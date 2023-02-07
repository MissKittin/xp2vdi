#!/bin/sh

# Wipe free space and dump disk to image
# Supported output image formats:
#  raw image
#  QEMU qcow2
#  QEMU compressed qcow2 with snapshot
#  VirtualBox vdi
#  VirtualPC vhd

find_partitions()
{
	local device="${1##*/}"
	local dev_path="${1%/*}"

	local i
	for i in /sys/block/${device}/${device}*; do
		[ "${i}" = "/sys/block/${device}/${device}*" ] && break
		[ -b "${dev_path}/${i##*/}" ] && echo -n "${dev_path}/${i##*/} "
	done
}
get_dev_vendor_model_type()
{
	local device="${1##*/}"

	case "${device}" in
		sd*)
			if [ -e '/dev/disk/by-id' ]; then
				local i
				local i_bus
				local i_device

				for i in /dev/disk/by-id/*; do
					if [ "${i}" = '/dev/disk/by-id/*' ]; then
						echo -n ' ATA/(e)SATA/SCSI/USB'
						break
					else
						i_device="$(readlink ${i})"
						i_device="${i_device##*/}"

						if [ "${i_device}" = "${device}" ]; then
							i_bus="${i##*/}"

							case "${i_bus%%-*}" in
								'ata')
									echo -n ' ATA/(e)SATA'
								;;
								'scsi')
									echo -n ' SCSI'
								;;
								'usb')
									echo -n ' USB'
								;;
								*)
									echo -n ' ATA/(e)SATA/SCSI/USB'
								;;
							esac

							break
						fi
					fi
				done
			else
				echo -n ' ATA/(e)SATA/SCSI/USB'
			fi
		;;
		mmcblk*)
			echo -n ' (e)MMC/SD'
		;;
		nvme*)
			echo -n ' NVME'
		;;
		xvd*)
			echo -n ' XEN'
		;;
		vd*)
			echo -n ' VirtIO'
		;;
		loop*)
			echo -n ' Loopback'
		;;
	esac

	#[ -e "/sys/block/${device}/device/vendor" ] && \
	#	echo -n " $(cat /sys/block/${device}/device/vendor 2>/dev/null | xargs)"

	[ -e "/sys/block/${device}/device/model" ] && \
		echo -n " $(cat /sys/block/${device}/device/model 2>/dev/null | xargs)"
}
get_disk_capacity()
{
	local device="${1##*/}"

	[ ! -e "/sys/class/block/${device}/size" ] && return 1
	[ ! -e "/sys/class/block/${device}/queue/logical_block_size" ] && return 1

	local blocks=$(cat "/sys/class/block/${device}/size")
	local block_size=$(cat "/sys/class/block/${device}/queue/logical_block_size")
	local size="$((${blocks}*${block_size}))"

	if [ "${size}" -ge '1000000000000000' ]; then
		echo " $((${size}/1000000000000000))PB"
	elif [ "${size}" -ge '1000000000000' ]; then
		echo " $((${size}/1000000000000))TB"
	elif [ "${size}" -ge '1000000000' ]; then
		echo " $((${size}/1000000000))GB"
	elif [ "${size}" -ge '1000000' ]; then
		echo " $((${size}/1000000))MB"
	elif [ "${size}" -ge '1000' ]; then
		echo " $((${size}/1000))kB"
	else
		echo " ${size}B"
	fi
}

[ ! "${1}" = '--check-tools' ] && if [ "${3}" = '' ] || [ "${1}" = '-h' ] || [ "${1}" = '--help' ]; then
	echo 'Wipe free space and dump disk to image'
	echo ''
	echo 'Usage:'
	echo " ${0##*/} /dev/disk /path/to/image.img disk-image-format"
	echo 'eg.'
	echo " ${0##*/} /dev/sda /home/username/disk.qcow2 qcow2"
	echo 'Tool checking:'
	echo " ${0##*/} --check-tools"
	echo ''
	echo 'Supported disk image formats:'
	echo ' raw'
	echo '  uses dd to create image'
	echo ' qcow2'
	echo ' qcow2-compressed'
	echo '  this option creates two files:'
	echo '  disk-name.src - compressed disk image'
	echo '  disk-name - snapshot - use this in vm'
	echo ' vdi'
	echo ' vhd'
	echo ''
	echo 'Required tools:'
	echo ' bash or ash or dash'
	echo ' cat'
	echo ' xargs'
	echo ' mktemp'
	echo ' mount'
	echo ' dd'
	echo ' sync'
	echo ' rm'
	echo ' umount'
	echo ' rmdir'
	echo ' readlink'
	echo ' qemu-img (except raw image format)'
	echo ''
	echo 'Optional tools:'
	echo ' ntfs-3g'
	echo ''
	echo 'Note:'
	echo ' if you do not want to clear'
	echo ' the free space on the real disk,'
	echo ' create a disk image with dd'
	echo ' and mount the image with'
	echo ' losetup with the -P option'
	exit 1
fi

# Phase 0: check environment
tools_not_found='false'
required_tools='cat xargs mktemp mount dd sync rm umount rmdir readlink'
[ ! "${3}" = 'raw' ] && required_tools="${required_tools} qemu-img"
for i in ${required_tools}; do
	echo -n "Checking for ${i}"
	if command -v "${i}" > /dev/null 2>&1; then
		echo ' [ OK ]'
	else
		echo ' [FAIL]'
		tools_not_found='true'
	fi
done
if "${tools_not_found}"; then
	echo 'One or more tools not found'
	exit 1
fi
[ "${1}" = '--check-tools' ] && exit 0
unset 'required_tools'
unset 'tools_not_found'
echo ''

case "${3}" in
	'raw') ;;
	'qcow2') ;;
	'qcow2-compressed') ;;
	'vdi') ;;
	'vhd') ;;
	*)
		echo 'Wrong image format'
		exit 1
	;;
esac

# Phase 1: look for directories and files
if [ ! -b "${1}" ]; then
	echo "${1} is not a block device"
	exit 1
fi
if [ -b "${2}" ]; then
	echo "${2} is a block device - cowardly refuse"
	exit 1
fi

if [ -e "${2}" ]; then
	echo "${2} exists"
	echo 'remove or rename it'
	exit 1
fi
if [ "${3}" = 'qcow2-compressed' ] && [ -e "${2}.src" ]; then
	echo "${2}.src exists"
	echo 'remove or rename it'
	exit 1
fi

echo "Selected disk: ${1}$(get_dev_vendor_model_type ${1})$(get_disk_capacity ${1})"
echo "Selected file: ${2}"
if [ "${3}" = 'qcow2-compressed' ]; then
	echo " Disk image: ${2}.src"
	echo " Disk snapshot: ${2}"
fi
echo "Selected format: ${3}"

# Phase 2: wipe free space
echo ''
found_partitions=$(find_partitions "${1}")
if [ "${found_partitions}" = '' ]; then
	echo "No partitions found in ${1}"
else
	echo 'Found partitions:'
	for current_partition in ${found_partitions}; do
		echo " ${current_partition}"
	done
	echo ''

	for current_partition in ${found_partitions}; do
		echo "Processing partition: ${current_partition}"

		mount_dir="$(mktemp -d)"

		echo -n " Mounting ntfs-3g ${current_partition} in read-write mode"
		if mount -t ntfs-3g -o rw "${current_partition}" "${mount_dir}" > /dev/null 2>&1; then
			echo ' [ OK ]'
		else
			echo ' [FAIL]'
			echo -n " Mounting ${current_partition} in read-write mode"
			if mount -o rw "${current_partition}" "${mount_dir}" > /dev/null 2>&1; then
				echo ' [ OK ]'
			else
				echo ' [FAIL]'
				rmdir "${mount_dir}" > /dev/null 2>&1
				unset 'mount_dir'
				continue
			fi
		fi

		echo -n " Wiping free space on ${current_partition} [1] "
		for i in 1 2 3 4 5 6 7 8 9; do
			echo -n '.'
			dd if='/dev/zero' of="${mount_dir}/wipefreespace.part${i}" > /dev/null 2>&1
		done
		echo ''

		echo ' Syncing filesystems [1]'
		sync

		echo -n " Wiping free space on ${current_partition} [2] "
		for i in 1 2 3 4 5 6 7 8 9; do
			echo -n '.'
			rm "${mount_dir}/wipefreespace.part${i}" > /dev/null 2>&1
		done
		echo ''

		echo ' Syncing filesystems [2]'
		sync

		echo " Unmounting ${current_partition}"
		umount "${mount_dir}" > /dev/null 2>&1 || \
			echo " Unmounting ${current_partition} failed"

		rmdir "${mount_dir}" > /dev/null 2>&1
	done
	unset 'current_partition'
fi
unset 'found_partitions'

# Phase 3: dump disk to image
echo ''
if [ "${3}" = 'qcow2-compressed' ]; then
	echo "Saving qcow2 disk image from ${1} to ${2}.src"
else
	echo "Saving ${3} disk image from ${1} to ${2}"
fi
case "${3}" in
	'raw')
		if ! dd if="${1}" of="${2}" bs='100M' status='progress'; then
			echo 'Trying dd without optimizations'
			rm "${2}" > /dev/null 2>&1
			if ! dd if="${1}" of="${2}"; then
				echo 'Saving disk image failed'
				rm "${2}" > /dev/null 2>&1
				exit 1
			fi
		fi
	;;
	'qcow2')
		if ! qemu-img convert -O qcow2 "${1}" "${2}"; then
			echo 'Saving disk image failed'
			rm "${2}" > /dev/null 2>&1
			exit 1
		fi
	;;
	'qcow2-compressed')
		if ! qemu-img convert -O qcow2 -c "${1}" "${2}.src"; then
			echo 'Saving disk image failed'
			rm "${2}.src" > /dev/null 2>&1
			exit 1
		fi

		echo "Creating qcow2 snapshot ${2}"
		if ! qemu-img snapshot -c "${2}" "./${2}.src"; then
			echo 'Creating qcow2 snapshot failed'
			echo "Saved compressed disk image as ${2}.src"
			rm "${2}" > /dev/null 2>&1
			exit 1
		fi

		echo "Saved compressed disk image as ${2}.src"
		echo "Saved disk snapshot as ${2}"
		echo 'Note: these two files are one piece'
	;;
	'vdi')
		#dd if="${1}" | VBoxManage convertfromraw stdin "${2}" "${size}"

		if ! qemu-img convert -O vdi "${1}" "${2}"; then
			echo 'Saving disk image failed'
			rm "${2}" > /dev/null 2>&1
			exit 1
		fi
	;;
	'vhd')
		if ! qemu-img convert -O vpc "${1}" "${2}"; then
			echo 'Saving disk image failed'
			rm "${2}" > /dev/null 2>&1
			exit 1
		fi
	;;
esac

echo 'Done'
exit 0
