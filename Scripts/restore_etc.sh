#!/bin/bash
#|---/ /+-------------------------+---/ /|#
#|--/ /-| Script to configure etc |--/ /-|#
#|-/ /--| T-Crypt         |-/ /--|#
#|/ /---+-------------------------+/ /---|#

source global_fn.sh
if [ $? -ne 0 ] ; then
    echo "Error: unable to source global_fn.sh, please execute from $(dirname $(realpath $0))..."
    exit 1
fi


if pkg_installed sddm 
     then
        
        read -p "Do you want to use the Hack the Box SDDM theme? (y/n): " use_htb_theme
        if [[ $use_htb_theme == "y" || $use_htb_theme == "Y" ]]; then
            theme_tar="Sddm_HTB.tar.gz"
            theme_name="Sweet-HTB"
        else
            theme_tar="Sddm_Corners.tar.gz"
            theme_name="corners"
        fi

        echo "Configuring SDDM..."
        sudo tar -xzf ${CloneDir}/Source/arcs/${theme_tar} -C /usr/share/sddm/themes/
        sudo cp /usr/share/sddm/themes/${theme_name}/kde_settings.conf /etc/sddm.conf.d/
        setfacl -m u:sddm:x /home/${USER}

        if [ -f ${CloneDir}/Source/misc/${USER}.face.icon ]; then
            sudo cp ${CloneDir}/Source/misc/${USER}.face.icon /usr/share/sddm/faces/
            echo "Avatar set for ${USER}..."
        fi
    else
        echo "WARNING: SDDM is not installed..."
    fi
}


# grub
if pkg_installed grub
    then

    if [ ! -f /etc/default/grub.t2.bkp ] && [ ! -f /boot/grub/grub.t2.bkp ]
        then
        echo "configuring grub..."
        sudo cp /etc/default/grub /etc/default/grub.t2.bkp
        sudo tar -xzf ${CloneDir}/Source/arcs/Grub_Pochita.tar.gz -C /usr/share/grub/themes/

        if nvidia_detect
            then
            sudo sed -i "/^GRUB_CMDLINE_LINUX_DEFAULT=/c\GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet splash nvidia_drm.modeset=1\"" /etc/default/grub
        fi

        sudo sed -i "/^GRUB_DEFAULT=/c\GRUB_DEFAULT=saved
        /^GRUB_GFXMODE=/c\GRUB_GFXMODE=1280x1024x32,auto
        /^#GRUB_THEME=/c\GRUB_THEME=\"/usr/share/grub/themes/pochita/theme.txt\"
        /^#GRUB_SAVEDEFAULT=true/c\GRUB_SAVEDEFAULT=true" /etc/default/grub

        sudo cp /boot/grub/grub.cfg /boot/grub/grub.t2.bkp
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi

else
    echo "WARNING: grub is not installed..."
fi


# pacman
if [ -f /etc/pacman.conf ] && [ ! -f /etc/pacman.conf.t2.bkp ]
    then

    echo "adding extra spice to pacman..."
    sudo cp /etc/pacman.conf /etc/pacman.conf.t2.bkp
    sudo sed -i "/^#Color/c\Color\nILoveCandy
    /^#VerbosePkgLists/c\VerbosePkgLists
    /^#ParallelDownloads/c\ParallelDownloads = 5" /etc/pacman.conf
fi


# dolphin
if pkg_installed dolphin && pkg_installed xdg-utils
    then

    xdg-mime default org.kde.dolphin.desktop inode/directory
    echo "setting" `xdg-mime query default "inode/directory"` "as default file explorer..."

else
    echo "WARNING: dolphin is not installed..."
fi


# zsh
if pkg_installed zsh
    then

    if [ "$SHELL" != "/usr/bin/zsh" ] ; then
        echo "changing shell to zsh..."
        chsh -s $(which zsh)
    fi

else
    echo "WARNING: zsh is not installed..."
fi

