# NTFS_format

- **./NTSF_format.sh -l**
    <br />
    runs diskutil list
    <br /><br />
- **./NTSF_format.sh -[h | help]**
    <br />
    prints this usage.
    <br /><br />
- **./NTSF_format.sh -[n | name] \"Thumb Drive Name\"**
    <br />
    format drive or disk with the display name of \"Thumb Drive Name\". Enclose in quotes names with spaces.
    <br /><br />
- **./NTSF_format.sh -[n | name] disk4**
    <br />
    format drive or disk with the identifier disk4. /dev/disk4 is also acceptable Do not use IDs like disk4s1.
    <br /><br />
    
- Prerequisite instructions found [here.](https://github.com/osxfuse/osxfuse/wiki/NTFS-3G)
- This only works on disks formatted in a simple MBR type format.
