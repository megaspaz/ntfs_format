# NTFS_format

- **./NTSF_format.sh -l**
    &NewLine;
    &NewLine;
    runs diskutil list
    &NewLine;
    &NewLine;
    &NewLine;
- **./NTSF_format.sh -[h | help]**
    &NewLine;
    &NewLine;
    prints this usage.
    &NewLine;
    &NewLine;
    &NewLine;
- **./NTSF_format.sh -[n | name] \"Thumb Drive Name\"**
    &NewLine;
    &NewLine;
    format drive or disk with the display name of \"Thumb Drive Name\". Enclose in quotes names with spaces.
    &NewLine;
    &NewLine;
    &NewLine;
- **./NTSF_format.sh -[n | name] disk4**
    &NewLine;
    &NewLine;
    format drive or disk with the identifier disk4. /dev/disk4 is also acceptable. Do not use IDs like disk4s1.
    &NewLine;
    &NewLine;
    &NewLine;

- Prerequisite instructions found [here.](https://github.com/osxfuse/osxfuse/wiki/NTFS-3G)
- This only works on disks formatted in a simple MBR type format.
