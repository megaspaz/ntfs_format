#!/usr/bin/env bash

function list_disk_if_exists {
  retval=$(diskutil list "${1}" 2>&1)
  if [[ "${retval}" = "Could not find disk for ${1}" ]]
  then
    printf "%s. You can do a 'NTFS_format.sh -l' beforehand to verify.\n" "${retval}"
    exit 1
  fi
  func_return="${retval}"
}

function get_disk_from_du_list_output {
  retval=$(printf "%s" "${1}" | cut -d'/' -f3 | cut -d' ' -f1)
  func_return="${retval}"
}

function print_usage {
  printf "
./NTSF_format.sh -l
    runs diskutil list

./NTSF_format.sh -[h | help]
    prints this usage.

./NTSF_format.sh -[n | name] \"Thumb Drive Name\"
    format drive or disk with the display name of \"Thumb Drive Name\". Enclose in quotes names with spaces.

./NTSF_format.sh -[n | name] disk4
    format drive or disk with the identifier disk4. /dev/disk4 is also acceptable. Do not use IDs like disk4s1.\n\n"
}

user_input=""
func_return=""
if [ "${1}" == "-l" ]
then
  diskutil list
  exit 0
elif [[ "${1}" == "-h" || "${1}" == "-help" ]]
then
  print_usage
  exit 0
elif [[ "${1}" == "-n" || "${1}" == "-name" ]]
then
  if [ -z "${2}" ]
  then
    printf "Input required for name value. Exiting...\n"
    print_usage
    exit 0
  fi
  list_disk_if_exists "${2}"
  get_disk_from_du_list_output "${func_return}"
  user_input="${func_return}"
else
  printf "Invalid option or expected option not given. Exiting...\n"
  print_usage
  exit 0
fi

disk="/dev/${user_input}"
container="${disk}s1"

# unmount the container/partition.
diskutil unmount "${container}"

sleep 2

# Erase the disk partition information from the drive.
printf "Erase the disk partition information from the drive. Press Initialize button on upcoming alert.\n"
sudo dd if=/dev/zero of="${disk}" bs=512 count=1

# Look at current structure
diskutil list "${disk}"

# fdisk functions.

(
  echo y # Do you wish to write new MBR and partition table? [n]
) | sudo fdisk -i -a dos "${disk}"

sleep 5

(
  echo print    # fdisk: 1>
  echo "edit 1" # fdisk: 1>
  echo 07       # Partition id ('0' to disable)  [0 - FF]: [C] (? for help)
  echo          # Do you wish to edit in CHS mode? [n]
  echo          # Partition offset [0 - 240254976]: [63]
  echo          # Partition size [1 - 240254913]: [240254913]
  echo print    # fdisk: 1>
  echo write    # fdisk: 1>
  echo exit     # fdisk: 1>
) | sudo fdisk -e "${disk}"

sleep 5

# unmount the container/partition.
diskutil unmount "${container}"

sleep 2

# format the container/partition.
sudo mkntfs -FQ "${container}"

sleep 2

# mount the container/partition.
diskutil mount "${container}"

exit 0
