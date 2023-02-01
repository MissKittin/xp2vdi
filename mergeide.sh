#!/bin/sh

# MergeIDE for Linux
# Patch Windows on existing disk image
# Supports 2000, 2003 and XP

print_mergeide_reg()
{
# source: https://www.virtualbox.org/wiki/Migrate_Windows
# note: reged does not allow comments and line breaks

cat << EOF
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\primary_ide_channel]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="atapi"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\secondary_ide_channel]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="atapi"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\*pnp0600]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="atapi"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\*azt0502]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="atapi"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\gendisk]
"ClassGUID"="{4D36E967-E325-11CE-BFC1-08002BE10318}"
"Service"="disk"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#cc_0101]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_0e11&dev_ae33]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1039&dev_0601]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1039&dev_5513]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1042&dev_1000]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_105a&dev_4d33]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1095&dev_0640]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1095&dev_0646]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1095&dev_0646&REV_05]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1095&dev_0646&REV_07]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1095&dev_0648]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1095&dev_0649]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1097&dev_0038]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_10ad&dev_0001]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_10ad&dev_0150]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_10b9&dev_5215]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_10b9&dev_5219]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_10b9&dev_5229]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="pciide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_1106&dev_0571]
"Service"="pciide"
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_1222]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_1230]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_2411]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_2421]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_7010]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_7111]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\CriticalDeviceDatabase\pci#ven_8086&dev_7199]
"ClassGUID"="{4D36E96A-E325-11CE-BFC1-08002BE10318}"
"Service"="intelide"

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\atapi]
"ErrorControl"=dword:00000001
"Group"="SCSI miniport"
"Start"=dword:00000000
"Tag"=dword:00000019
"Type"=dword:00000001
"DisplayName"="Standard IDE/ESDI Hard Disk Controller"
"ImagePath"=hex(2):53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,44,00,52,00,49,00,56,00,45,00,52,00,53,00,5c,00,61,00,74,00,61,00,70,00,69,00,2e,00,73,00,79,00,73,00,00,00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\IntelIde]
"ErrorControl"=dword:00000001
"Group"="System Bus Extender"
"Start"=dword:00000000
"Tag"=dword:00000004
"Type"=dword:00000001
"ImagePath"=hex(2):53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,44,00,52,00,49,00,56,00,45,00,52,00,53,00,5c,00,69,00,6e,00,74,00,65,00,6c,00,69,00,64,00,65,00,2e,00,73,00,79,00,73,00,00,00

[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PCIIde]
"ErrorControl"=dword:00000001
"Group"="System Bus Extender"
"Start"=dword:00000000
"Tag"=dword:00000003
"Type"=dword:00000001
"ImagePath"=hex(2):53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,44,00,52,00,49,00,56,00,45,00,52,00,53,00,5c,00,70,00,63,00,69,00,69,00,64,00,65,00,2e,00,73,00,79,00,73,00,00,00
EOF
}

# case sensitive :(
find_windows_directories_and_flies()
{
	local i
	local do_exit='false'

	local dir_driver_cache='not-found'
	for i in 'Driver Cache' 'Driver cache' 'driver Cache''driver cache' 'DRIVER CACHE'; do
		[ -d "./${i}" ] && dir_driver_cache="./${i}"
	done
	if [ "${dir_driver_cache}" = 'not-found' ]; then
		echo "Directory ${1}/Driver Cache not found"
		do_exit='true'
	fi

	# for ${file_driver_cache_i386_cab}
	local dir_driver_cache_i386='not-found'
	for i in 'i386' 'I386'; do
		[ -d "${dir_driver_cache}/${i}" ] && dir_driver_cache_i386="${dir_driver_cache}/${i}"
	done
	if [ "${dir_driver_cache_i386}" = 'not-found' ]; then
		echo "Directory ${1}/Driver Cache/i386 not found"
		do_exit='true'
	fi

	local dir_system32='not-found'
	for i in 'System32' 'system32' 'SYSTEM32'; do
		[ -d "./${i}" ] && dir_system32="./${i}"
	done
	if [ "${dir_system32}" = 'not-found' ]; then
		echo "Directory ${1}/System32 not found"
		do_exit='true'
	fi

	# for find_windows_drivers_flies() and cabextract
	dir_system32_drivers='not-found'
	for i in 'Drivers' 'drivers' 'DRIVERS'; do
		[ -d "${dir_system32}/${i}" ] && dir_system32_drivers="${dir_system32}/${i}"
	done
	if [ "${dir_system32_drivers}" = 'not-found' ]; then
		echo "Directory ${1}/System32/Drivers not found"
		do_exit='true'
	fi

	local dir_system32_config='not-found'
	for i in 'Config' 'config' 'CONFIG'; do
		[ -d "${dir_system32}/${i}" ] && dir_system32_config="${dir_system32}/${i}"
	done
	if [ "${dir_system32_config}" = 'not-found' ]; then
		echo "Directory ${1}/System32/Config not found"
		do_exit='true'
	fi

	# for registry backup and reged
	file_system32_config_system='not-found'
	for i in 'System' 'system' 'SYSTEM'; do
		[ -f "${dir_system32_config}/${i}" ] && file_system32_config_system="${dir_system32_config}/${i}"
	done
	if [ "${file_system32_config_system}" = 'not-found' ]; then
		echo "File ${1}/System32/Config/System not found"
		do_exit='true'
	fi

	# for cabextract
	file_driver_cache_i386_cab='not-found'
	for i in 'Driver.cab' 'driver.cab' 'DRIVER.CAB'; do
		[ -f "${dir_driver_cache_i386}/${i}" ] && file_driver_cache_i386_cab="${dir_driver_cache_i386}/${i}"
	done
	for i in 'Sp2.cab' 'sp2.cab' 'SP2.CAB'; do
		[ -f "${dir_driver_cache_i386}/${i}" ] && file_driver_cache_i386_cab="${dir_driver_cache_i386}/${i}"
	done
	for i in 'Sp3.cab' 'sp3.cab' 'SP3.CAB'; do
		[ -f "${dir_driver_cache_i386}/${i}" ] && file_driver_cache_i386_cab="${dir_driver_cache_i386}/${i}"
	done
	for i in 'Sp4.cab' 'sp4.cab' 'SP4.CAB'; do
		[ -f "${dir_driver_cache_i386}/${i}" ] && file_driver_cache_i386_cab="${dir_driver_cache_i386}/${i}"
	done
	if [ "${file_driver_cache_i386_cab}" = 'not-found' ]; then
		echo "driver.cab nor sp2.cab nor sp3.cab nor sp4.cab found in ${1}/System32/Driver Cache/i386"
		do_exit='true'
	fi

	"${do_exit}" && exit 1

	if [ -f "/tmp/.${0##*/}.debug" ]; then
		echo "Debug: file /tmp/.${0##*/}.debug exists"
		echo 'Debug: find_windows_directories_and_flies():'
		echo "Debug:  local dir_driver_cache: ${dir_driver_cache}"
		echo "Debug:  local dir_driver_cache_i386: ${dir_driver_cache_i386}"
		echo "Debug:  local dir_system32: ${dir_system32}"
		echo "Debug:        dir_system32_drivers: ${dir_system32_drivers}"
		echo "Debug:  local dir_system32_config: ${dir_system32_config}"
		echo "Debug:        file_system32_config_system: ${file_system32_config_system}"
		echo "Debug:        file_driver_cache_i386_cab: ${file_driver_cache_i386_cab}"
		echo ''
	fi
}
find_windows_drivers_flies()
{
	local i
	local do_exit='false'

	for i in 'Atapi.sys' 'atapi.sys' 'ATAPI.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo "$(realpath ${1}/${dir_system32_drivers}/${i}) exists"
			do_exit='true'
		fi
	done
	for i in 'Intelide.sys' 'intelide.sys' 'INTELIDE.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo "$(realpath ${1}/${dir_system32_drivers}/${i}) exists"
			do_exit='true'
		fi
	done
	for i in 'Pciide.sys' 'pciide.sys' 'PCIIDE.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo "$(realpath ${1}/${dir_system32_drivers}/${i}) exists"
			do_exit='true'
		fi
	done
	for i in 'Pciidex.sys' 'pciidex.sys' 'PCIIDEX.SYS'; do
		if [ -e "${dir_system32_drivers}/${i}" ]; then
			echo "$(realpath ${1}/${dir_system32_drivers}/${i}) exists"
			do_exit='true'
		fi
	done

	if "${do_exit}"; then
		echo 'rename or remove it'
		exit 1
	fi
}

if [ "${1}" = '' ] || [ "${1}" = '-h' ] || [ "${1}" = '--help' ]; then
	echo 'MergeIDE for Linux'
	echo 'Patch Windows on existing disk image'
	echo 'Supports 2000, 2003 and XP'
	echo 'Note:'
	echo ' you need to mount the Windows partition first'
	echo ' via loop or qemu-nbd'
	echo ''
	echo 'Usage:'
	echo " ${0##*/} path/to/windir"
	echo 'eg.'
	echo " ${0##*/} /media/sda1/WINDOWS"
	echo " ${0##*/} /media/loop0p1/WINNT"
	echo 'Tool checking:'
	echo " ${0##*/} --check-tools"
	echo ''
	echo 'Required tools:'
	echo ' cat'
	echo ' cp'
	echo ' cabextract'
	echo ' reged (from chntpw, with -I option)'
	echo ' grep'
	echo ' tr'
	echo ' xargs'
	echo ' mktemp'
	echo ' sed'
	echo ' rm'
	echo ' realpath'

	exit 1
fi

# Phase 0: check environment
tools_not_found='false'
for i in 'cat' 'cp' 'cabextract' 'reged' 'grep' 'tr' 'xargs' 'mktemp' 'sed' 'rm' 'realpath'; do
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
unset 'tools_not_found'
echo ''

if ! reged -h | grep '\-I <' > /dev/null 2>&1; then
	echo 'reged is too old (does not have an -I switch)'
	exit 1
fi

if ! cd "${1}" > /dev/null 2>&1; then
	echo "Cannot change directory to ${1}"
	exit 1
fi

# Phase 1: look for directories and files
find_windows_directories_and_flies # :D :D :D
find_windows_drivers_flies "${1}" # from phase 2

if [ -e '../system.bak' ]; then
	echo "$(realpath ${1}/../system.bak) exists"
	echo 'rename or remove it'
	exit 1
fi

# Phase 2: extract drivers
echo 'Checking cabinet'
for i in 'Atapi.sys' 'Intelide.sys' 'Pciide.sys' 'Pciidex.sys'; do
	echo -n " Looking for file ${i}"
	if cabextract -F "${i}" -l "${file_driver_cache_i386_cab}" 2>/dev/null | grep -i "${i}" > /dev/null 2>&1; then
		echo ' [ OK ]'
	else
		echo ' [FAIL]'
		exit 1
	fi
done
echo 'Extracting cabinet'
for i in 'Atapi.sys' 'Intelide.sys' 'Pciide.sys' 'Pciidex.sys'; do
	echo -n " Extracting file ${i}"
	if cabextract -L -F "${i}" -d "${dir_system32_drivers}" "${file_driver_cache_i386_cab}" > /dev/null 2>&1; then
		echo ' [ OK ]'
	else
		echo ' [FAIL]'
		exit 1
	fi
done

# Phase 3: backup registry
echo "Backing up registry to $(realpath ${1}/../system.bak)"
if ! cp "${file_system32_config_system}" '../system.bak' > /dev/null 2>&1; then
	echo 'Backing up registry failed'
	exit 1
fi

# Phase 4: patch registry
registry_patch_failed='true'
for current_control_set in $(cat << EOF | reged -e "${file_system32_config_system}" | grep 'ControlSet' | tr -d '<' | tr -d '>' | xargs
ls
q
EOF
); do
	if ! echo -n "${current_control_set}" | grep '^ControlSet' > /dev/null 2>&1; then
		echo "Control set tree ${current_control_set} is invalid"
		continue
	fi

	echo "Patching MergeIDE.reg: ${current_control_set}"
	mergeide_temp="$(mktemp).reg"
	print_mergeide_reg | sed 's/HKEY_LOCAL_MACHINE\\SYSTEM\\CurrentControlSet\\/HKEY_LOCAL_MACHINE\\SYSTEM\\'"${current_control_set}"'\\/g' > "${mergeide_temp}"

	echo "Patching registry: ${current_control_set}"
	echo 'y' | reged -I "${file_system32_config_system}" 'HKEY_LOCAL_MACHINE\SYSTEM' "${mergeide_temp}" > /dev/null 2>&1
	if [ ! "${?}" = '2' ]; then
		echo "Patching registry failed: ${current_control_set}"
		rm "${mergeide_temp}"
		exit 1
	fi

	rm "${mergeide_temp}"

	registry_patch_failed='false'
done

if "${registry_patch_failed}"; then
	echo 'Registry patching failed'
else
	echo 'Done'
fi

exit 0
