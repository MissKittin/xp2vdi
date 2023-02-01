#!/bin/sh

# disk2img.sh and mergeide.sh automation
# dumps image to vdi

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
find_windows()
{
	local l_dir_windows='not-found'

	local i
	for i in 'Winnt' 'winnt' 'WINNT'; do
		[ -d "${1}/${i}" ] && l_dir_windows="${1}/${i}"
	done
	for i in 'Windows' 'windows' 'WINDOWS'; do
		[ -d "${1}/${i}" ] && l_dir_windows="${1}/${i}"
	done

	[ "${l_dir_windows}" = 'not-found' ] && return 1

	dir_windows="${l_dir_windows}"
	return 0
}
find_windows_directories_and_flies()
{
	local i
	local do_exit='false'

	local dir_system32='not-found'
	for i in 'System32' 'system32' 'SYSTEM32'; do
		[ -d "${1}/${i}" ] && dir_system32="${1}/${i}"
	done
	if [ "${dir_system32}" = 'not-found' ]; then
		echo " Directory ${1}/System32 not found"
		do_exit='true'
	fi

	# for remove_flies_for_mergeide()
	dir_system32_drivers='not-found'
	for i in 'Drivers' 'drivers' 'DRIVERS'; do
		[ -d "${dir_system32}/${i}" ] && dir_system32_drivers="${dir_system32}/${i}"
	done
	if [ "${dir_system32_drivers}" = 'not-found' ]; then
		echo " Directory ${1}/System32/Drivers not found"
		do_exit='true'
	fi

	# for find_windows_nt_edition()
	file_system32_ntoskrnl='not-found'
	for i in 'Ntoskrnl.exe' 'ntoskrnl.exe' 'NTOSKRNL.EXE'; do
		[ -f "${dir_system32}/${i}" ] && file_system32_ntoskrnl="${dir_system32}/${i}"
	done
	if [ "${file_system32_ntoskrnl}" = 'not-found' ]; then
		echo " File ${1}/System32/Ntoskrnl.exe not found"
		do_exit='true'
	fi

	"${do_exit}" && return 1

	if [ -f "/tmp/.${0##*/}.debug" ]; then
		echo "Debug: file /tmp/.${0##*/}.debug exists"
		echo 'Debug: find_windows_directories():'
		echo "Debug:  local dir_system32: ${dir_system32}"
		echo "Debug:        dir_system32_drivers: ${dir_system32_drivers}"
		echo "Debug:        file_system32_ntoskrnl: ${file_system32_ntoskrnl}"
		echo ''
	fi

	return 0
}
find_windows_nt_edition()
{
	#if grep 'Windows NT ' "${1}" > /dev/null 2>&1; then
	if grep 'Microsoft (R) Windows NT (TM) ' "${1}" > /dev/null 2>&1; then
		echo 'NT 4'
		return 0
	fi

	if grep ' Windows 2000 ' "${1}" > /dev/null 2>&1; then
		echo '2000'
		return 0
	fi

	if grep -E '[0-9][0-9][0-9][0-9]\.srv03.*rtm|gdr|qfe\.' "${1}" > /dev/null 2>&1; then
		echo '2003'
		return 0
	fi

	if grep -E '[0-9][0-9][0-9][0-9]\.xp.*rtm|gdr|qfe\.' "${1}" > /dev/null 2>&1; then
		echo 'XP'
		return 0
	fi

	# strings "./windows/system32/ntoskrnl.exe" | grep -E '^2600\.xp.*\.'
	if grep '2600\.xp.*\.' "${1}" > /dev/null 2>&1; then
		echo 'XP'
		return 0
	fi

	if grep -E '[0-9][0-9][0-9][0-9]\.vista.*rtm|gdr\.' "${1}" > /dev/null 2>&1; then
		echo 'Vista/2008'
		return 0
	fi

	if grep -E '[0-9][0-9][0-9][0-9]\.lh.*rtm|gdr\.' "${1}" > /dev/null 2>&1; then
		echo 'Vista/2008'
		return 0
	fi

	if grep -E '[0-9][0-9][0-9][0-9]\.win7.*rtm|gdr\.' "${1}" > /dev/null 2>&1; then
		echo '7/2008 R2'
		return 0
	fi

	if grep -E '[0-9][0-9][0-9][0-9]\.win8.*rtm|gdr\.' "${1}" > /dev/null 2>&1; then
		echo '8/2012'
		return 0
	fi

	if grep '[0-9][0-9][0-9][0-9].winblue.*\.' "${1}" > /dev/null 2>&1; then
		echo '8.1/2012 R2'
		return 0
	fi

	if grep 'http://www.microsoft.com/windows0' "${1}" > /dev/null 2>&1; then
		echo '10/11/2016/2019/2022'
		return 0
	fi

	if grep 'Windows' "${1}" > /dev/null 2>&1; then
		echo 'Unknown'
		return 0
	fi

	echo 'No Windows found'
	return 1
}
remove_flies_for_mergeide()
{
	local i
	local do_exit='false'

	for i in 'Atapi.sys' 'atapi.sys' 'ATAPI.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo " Removing ${dir_system32_drivers}/${i}"
			if rm "${dir_system32_drivers}/${i}" > /dev/null 2>&1; then
				break
			else
				echo "  Failed removing $(realpath ${dir_system32_drivers}/${i})"
				do_exit='true'
				break
			fi
		fi
	done
	for i in 'Intelide.sys' 'intelide.sys' 'INTELIDE.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo " Removing $(realpath ${dir_system32_drivers}/${i})"
			if rm "${dir_system32_drivers}/${i}" > /dev/null 2>&1; then
				break
			else
				echo "  Failed removing $(realpath ${dir_system32_drivers}/${i})"
				do_exit='true'
				break
			fi
		fi
	done
	for i in 'Pciide.sys' 'pciide.sys' 'PCIIDE.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo " Removing $(realpath ${dir_system32_drivers}/${i})"
			if rm "${dir_system32_drivers}/${i}" > /dev/null 2>&1; then
				break
			else
				echo "  Failed removing $(realpath ${dir_system32_drivers}/${i})"
				do_exit='true'
				break
			fi
		fi
	done
	for i in 'Pciidex.sys' 'pciidex.sys' 'PCIIDEX.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo " Removing $(realpath ${dir_system32_drivers}/${i})"
			if rm "${dir_system32_drivers}/${i}" > /dev/null 2>&1; then
				break
			else
				echo "  Failed removing $(realpath ${dir_system32_drivers}/${i})"
				do_exit='true'
				break
			fi
		fi
	done

	if [ -e "${1}/../system.bak" ]; then
		echo " Removing $(realpath ${1}/../system.bak)"
		if ! rm "${1}/../system.bak" > /dev/null 2>&1; then
			echo "  Failed removing $(realpath ${1}/../system.bak)"
			do_exit='true'
		fi
	fi

	"${do_exit}" && return 1
	return 0
}

if [ "${2}" = '' ] || [ "${1}" = '-h' ] || [ "${1}" = '--help' ]; then
	echo 'Wipe free space,'
	echo 'dump disk to VirtualBox image'
	echo 'and patch Windows 2000/2003/XP on existing disk image'
	echo ''
	echo 'Usage:'
	echo " ${0##*/} /dev/disk /path/to/image.vdi"
	echo 'eg.'
	echo " ${0##*/} /dev/sda /home/username/disk.vdi"
	echo 'Tool checking:'
	echo " ${0##*/} --check-tools"
	echo ''
	echo 'Required tools:'
	echo ' bash or ash or dash'
	echo ' grep'
	echo ' dirname'
	echo ' readlink'
	echo ' realpath'
	echo ' lsmod'
	echo ' modprobe'
	echo ' qemu-nbd'
	echo ' mktemp'
	echo ' mount'
	echo ' umount'
	echo ' rm'
	echo ' rmdir'
	echo ''
	echo 'Optional tools:'
	echo ' ntfs-3g'
	echo ''
	echo 'Required scripts in this directory:'
	echo ' disk2img.sh'
	echo ' mergeide.sh'
	exit 1
fi

# Phase 0: check environment, look for directories and files
tools_not_found='false'
scripts_not_found='false'
for i in 'grep' 'dirname' 'readlink' 'realpath' 'lsmod' 'modprobe' 'qemu-nbd' 'mktemp' 'mount' 'umount' 'rm' 'rmdir'; do
	echo -n "Checking for ${i}"
	if command -v "${i}" > /dev/null 2>&1; then
		echo ' [ OK ]'
	else
		echo ' [FAIL]'
		tools_not_found='true'
	fi
done
for i in 'disk2img.sh' 'mergeide.sh'; do
	echo -n "Checking for ${i}"
	if [ -e "$(dirname "$(readlink -f "${0}")")/${i}" ]; then
		echo -n ' [ OK ]'

		if [ -x "$(dirname "$(readlink -f "${0}")")/${i}" ]; then
			echo ' [ OK ]'
		else
			echo ' [FAIL]'
			tools_not_found='true'
			scripts_not_found='true'
		fi
	else
		echo ' [FAIL]'
		tools_not_found='true'
		scripts_not_found='true'
	fi
done
"${scripts_not_found}" || for i in 'disk2img.sh' 'mergeide.sh'; do
	"$(dirname "$(readlink -f "${0}")")/${i}" --check-tools || tools_not_found='true'
done
if "${tools_not_found}"; then
	echo 'One or more tools not found'
	exit 1
fi
[ "${1}" = '--check-tools' ] && exit 0
unset 'tools_not_found'
unset 'scripts_not_found'
echo ''

if [ -e "${2}" ]; then
	echo "${2} exists"
	echo 'rename or remove it'
	exit 1
fi

# Phase 1: check and load modules
if lsmod | grep '^nbd' > /dev/null 2>&1; then
	echo 'nbd module already loaded'
	echo 'please remove it'
	exit 1
fi
echo -n 'Loading nbd module'
if modprobe nbd max_part=16; then
	echo ' [ OK ]'
else
	echo ' [FAIL]'
	exit 1
fi

# Phase 2: remove ntfs hiberfile
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
		mount_dir="$(mktemp -d)"

		echo -n "Removing hiberfile from ${current_partition}"
		if mount -t ntfs-3g -o remove_hiberfile "${current_partition}" "${mount_dir}" > /dev/null 2>&1; then
			echo -n ' [ OK ]'
			umount "${mount_dir}" > /dev/null 2>&1 && echo ' [ OK ]' || echo ' [FAIL]'
		else
			echo ' [FAIL]'
		fi

		rmdir "${mount_dir}" > /dev/null 2>&1
		unset 'mount_dir'
	done
	unset 'current_partition'
fi
unset 'found_partitions'

# Phase 3: dump disk to image
echo ''
echo 'Starting disk2img.sh'
echo ''
if "$(dirname "$(readlink -f "${0}")")/disk2img.sh" "${1}" "${2}" vdi; then
	echo ''
	echo 'disk2img.sh finished'
	echo 'Syncing filesystems'
	sync
else
	echo ''
	echo 'disk2img.sh failed'

	echo 'Removing nbd module'
	rmmod 'nbd' > /dev/null 2>&1

	exit 1
fi

# Phase 4: attach disk image
echo -n 'Setting up nbd device /dev/nbd0'
if qemu-nbd -c /dev/nbd0 "${2}" > /dev/null 2>&1; then
	echo ' [ OK ]'
	echo 'Waiting 5 seconds'
	sleep 5
else
	echo ' [FAIL]'

	echo 'Removing nbd module'
	rmmod 'nbd' > /dev/null 2>&1

	exit 1
fi

# Phase 5: run MergeIDE
echo ''
found_partitions=$(find_partitions '/dev/nbd0')
if [ "${found_partitions}" = '' ]; then
	echo 'No partitions found in /dev/nbd0'
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

		if find_windows "${mount_dir}"; then
			echo " Found Windows in ${current_partition} in ${dir_windows##*/}"

			if find_windows_directories_and_flies "${dir_windows}"; then
				echo -n ' Found Windows: '
				found_windows_version=$(find_windows_nt_edition "${file_system32_ntoskrnl}")
				echo "${found_windows_version}"

				if \
					[ "${found_windows_version}" = '2000' ] || \
					[ "${found_windows_version}" = '2003' ] || \
					[ "${found_windows_version}" = 'XP' ]
				then
					if remove_flies_for_mergeide "${dir_windows}"; then
						echo ' Starting MergeIDE'
						echo ''

						if "$(dirname "$(readlink -f "${0}")")/mergeide.sh" "${dir_windows}"; then
							echo ''
							echo ' MergeIDE finished'
						else
							echo ''
							echo ' MergeIDE failed'
						fi
					fi
				else
					echo ' Windows 2000 nor 2003 nor XP found - skipping MergeIDE'
				fi

				unset 'found_windows_version'
			fi

			unset 'dir_windows'
		fi

		echo " Unmounting ${current_partition}"
		if ! umount "${mount_dir}" > /dev/null 2>&1; then
			echo " Unmounting ${current_partition} failed"
			echo " Stale mount point: ${mount_dir}"
			unset 'mount_dir'
		fi

		rmdir "${mount_dir}" > /dev/null 2>&1
		unset 'mount_dir'
	done
	unset 'current_partition'
fi
unset 'found_partitions'

# Phase 6: clean
echo ''
echo 'Syncing filesystems'
sync

echo -n 'Removing nbd device /dev/nbd0'
if qemu-nbd -d /dev/nbd0 > /dev/null 2>&1; then
	echo ' [ OK ]'
else
	echo ' [FAIL]'
	exit 1
fi

sleep 1

echo -n 'Removing nbd module'
if rmmod 'nbd' > /dev/null 2>&1; then
	echo ' [ OK ]'
else
	echo ' [FAIL]'
	exit 1
fi

echo 'Done'
exit 0
