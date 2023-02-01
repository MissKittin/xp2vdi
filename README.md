# XP2VDI
Easily convert an existing Windows installation to a virtual machine image.

### Warning
This tool will wipe free disk space!

### Usage
The main program is `xp2vdi.sh`:
```
xp2vdi.sh /dev/disk /path/to/image.vdi
```

Just wipe free space and create a disk image:
```
disk2img.sh /dev/disk /path/to/image.img raw|qcow2|qcow2-compressed|vdi|vhd
```

Patch the windows installation for use in the virtual machine:
```
mergeide.sh /media/sda1/WINDOWS
```
where `/media/sda1` is a mountpoint.

### How it works
Running older Windows installations in a VM without prior preparation will result in a bluescreen.  
To resolve this issue, install the disk drivers.  
This is easy if you can run Windows on the original computer, but it is not always possible.  
The `mergeide.sh` script makes it easier to solve this problem - it allows you to install  
the required ATA drivers from the Linux level.  
Formats like vdi or qcow do not preserve zeros - they save disk space.  
But operating systems do not zero out the free space automatically.  
Free space must therefore be overwritten manually on each partition.  
This operation is facilitated by the `disk2img.sh` script - it overwrites  
free space on the disk with zeros and creates a disk image.  
`xp2vdi.sh` combines `disk2img.sh` and `mergeide.sh` into one program, automating the entire process:  
* cleans the free space
* creates a vdi disk image
* searches for Windows 2000/2003/XP installation on it
* and installs the necessary drivers

### Sources
c't MergeIDE: https://www.virtualbox.org/wiki/Migrate_Windows
