#!/usr/bin/env bash

trim_quotes() {
    trim_output="${1//\'}"
    trim_output="${trim_output//\"}"
    printf "%s" "$trim_output"
}

os-helpers::get_linux_distro() {
    if [[ -f /bedrock/etc/bedrock-release && $PATH == */bedrock/cross/* ]]; then
        distro=$(< /bedrock/etc/bedrock-release)

    elif [[ -f /etc/redstar-release ]]; then
        distro="Red Star OS $(awk -F'[^0-9*]' '$0=$2' /etc/redstar-release)"

    elif [[ -f /etc/armbian-release ]]; then
        . /etc/armbian-release
        distro="Armbian $DISTRIBUTION_CODENAME (${VERSION:-})"

    elif [[ -f /etc/siduction-version ]]; then
        distro="Siduction ($(lsb_release -sic))"

    elif [[ -f /etc/mcst_version ]]; then
        distro="OS Elbrus $(< /etc/mcst_version)"

    elif type -p pveversion >/dev/null; then
        distro=$(pveversion)
        distro=${distro#pve-manager/}
        distro="Proxmox VE ${distro%/*}"

    elif type -p lsb_release >/dev/null; then
        distro=$(lsb_release -sd)

    elif [[ -f /etc/GoboLinuxVersion ]]; then
        distro="GoboLinux $(< /etc/GoboLinuxVersion)"

    elif [[ -f /etc/SDE-VERSION ]]; then
        distro="$(< /etc/SDE-VERSION)"
        distro="${distro% *}"

    elif type -p crux >/dev/null; then
        distro=$(crux)

    elif type -p tazpkg >/dev/null; then
        distro="SliTaz $(< /etc/slitaz-release)"

    elif type -p kpt >/dev/null && \
            type -p kpm >/dev/null; then
        distro=KSLinux

    elif [[ -d /system/app/ && -d /system/priv-app ]]; then
        distro="Android $(getprop ro.build.version.release)"

    elif [[ -f /etc/lsb-release && $(< /etc/lsb-release) == *CHROMEOS* ]]; then
        distro='Chrome OS'

    elif type -p guix >/dev/null; then
        distro="Guix System $(guix -V | awk 'NR==1{printf $4}')"

    elif [[ $distro = "OpenBSD"* ]] ; then
        read -ra sys_info <<< "$(sysctl -n kern.version)"
        distro=${sys_info[*]:0:2}

    else
        for release_file in /etc/*-release; do
            distro+=$(< "$release_file")
        done

        if [[ -z $distro ]]; then
            distro=${distro/DragonFly/DragonFlyBSD}

            # Workarounds for some BSD based distros.
            [[ -f /etc/pcbsd-lang ]]       && distro=PCBSD
            [[ -f /etc/trueos-lang ]]      && distro=TrueOS
            [[ -f /etc/pacbsd-release ]]   && distro=PacBSD
            [[ -f /etc/hbsd-update.conf ]] && distro=HardenedBSD
        fi
    fi

    if [[ $(< /proc/version) == *Microsoft* ]]; then
        distro+=" on Windows 10"

    elif [[ $(< /proc/version) == *chrome-bot* || -f /dev/cros_ec ]]; then
        [[ $distro != *Chrome* ]] && distro+=" on Chrome OS"
    fi

    distro=$(trim_quotes "$distro")
    distro=${distro/NAME=}

    # Get Ubuntu flavor.
    if [[ $distro == "Ubuntu"* ]]; then
        case $XDG_CONFIG_DIRS in
            *"plasma"*)   distro=${distro/Ubuntu/Kubuntu} ;;
            *"mate"*)     distro=${distro/Ubuntu/Ubuntu MATE} ;;
            *"xubuntu"*)  distro=${distro/Ubuntu/Xubuntu} ;;
            *"Lubuntu"*)  distro=${distro/Ubuntu/Lubuntu} ;;
            *"budgie"*)   distro=${distro/Ubuntu/Ubuntu Budgie} ;;
            *"studio"*)   distro=${distro/Ubuntu/Ubuntu Studio} ;;
            *"cinnamon"*) distro=${distro/Ubuntu/Ubuntu Cinnamon} ;;
        esac
    fi
}

os-helpers::set_os_icon() {
    name=$(uname -s)
    case $name in
        Darwin)   
            os_icon='#[fg=black]'
        ;;

        Linux|GNU*)
        os-helpers::get_linux_distro

        case $distro in
            "Redhat"* | "Red Hat"* | "rhel"*)
                os_icon='#[fg=red]'
            ;;
            "Ubuntu"*)
                os_icon='#[fg=black]'
            ;;
            "Arch"*)
                os_icon='#[fg=blue]'
            ;;
            "CentOS"*)
                os_icon='#[fg=black]'
            ;;
            "Container Linux by CoreOS"* | "Container_Linux"*)
                os_icon='#[fg=black]'
            ;;
            "Debian"* | "debian"*)
                os_icon='#[fg=red]'
            ;;
            "Elementary"* | "elementary_small"*)
                os_icon='#[fg=black]'
            ;;
            "Fedora"* | "RFRemix"* | "fedora"*)
                os_icon='#[fg=black]'
            ;;
            "Gentoo"* | "gentoo"*)
                os_icon='#[fg=black]'
            ;;
            "Linux Mint Old"* | "linuxmind"* | "LinuxMintOld"* | "mint_old"*)
                os_icon='#[fg=black]'
            ;;
            "mageia"* | "Mageia"*)
                os_icon='#[fg=black]'
            ;;
            "Mandriva"* | "OpenMandriva"*)
                os_icon='#[fg=black]'
            ;;
            "Manjaro"* | "manjaro"*)
                os_icon='#[fg=black]'
            ;;
            "NixOS"* | "nixos"*)
                os_icon='#[fg=blue]'
            ;;
            "openSUSE"* | "open SUSE"* | "SUSE"* | "opensuse_small" | "suse_small"*)
                os_icon='#[fg=black]'
            ;;
            "Raspbian"*)
                os_icon='#[fg=red]'
            ;;
            "Sabayon"*)
                os_icon='#[fg=black]'
            ;;
            "Slackware"* | "slackware"*)
                os_icon='#[fg=black]'
            ;;
            "Alpine"* | "alpine"*)
                os_icon='#[fg=blue]'
            ;;
            "AOSC"*)
                os_icon='#[fg=black]'
            ;;
            *)
                os_icon='#[fg=black]'
            ;;
        esac
        ;;

        *BSD|DragonFly|Bitrig)
            os_icon='#[fg=red]'
        ;;

        CYGWIN*|MSYS*|MINGW*)
            os_icon='#[fg=blue]'
        ;;

        *)
            os_icon='#[fg=black]'
        ;;
    esac
}