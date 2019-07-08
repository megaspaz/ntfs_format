#!/usr/bin/env bash

if [ -z "${1}" ]
then
  echo "Input required. Exiting..."
  exit 0
fi

if [ "${1}" == "-l" ]
then
  diskutil list
  exit 0
elif [ "${1}" == "-u" ]
then
  printf "
./NTSF_format.sh -l
    runs diskutil list

./NTSF_format.sh -u
    prints this usage.

./NTSF_format.sh disk4
    format drive or disk with the identifier disk4. Do not use IDs like disk4s1.\n\n"

  exit 0
fi

disk="/dev/${1}"
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
