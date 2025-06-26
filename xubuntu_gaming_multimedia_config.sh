#!/usr/bin/env bash

echo ""
echo "-----------------------------------------"
echo "  Xubuntu Gaming  (minimal install)      " 
echo "-----------------------------------------"
sleep 3

set -e

sudo apt autoremove -y apport apport-gtk
sudo dpkg --add-architecture i386 
sudo apt update
sudo apt dist-upgrade -y
sudo apt install --fix-missings
sudo apt install --fix-broken
clear

# Add various PPAs
sudo add-apt-repository -y ppa:kisak/kisak-mesa
sudo add-apt-repository -y ppa:savoury1/pipewire
sudo add-apt-repository -y ppa:xtradeb/apps
#sudo add-apt-repository -y ppa:ubuntuhandbook1/handbrake
sudo add-apt-repository -y ppa:mozillateam/ppa
sudo apt update 
clear


# remove snap
sudo apt purge -y snapd 
rm -vrf ~/snap 
sudo rm -vrf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd 
sudo apt-mark hold snapd  

sudo apt install -y synaptic gdebi mousepad gsmartcontrol build-essential dkms ufw samba winbind linux-headers-$(uname -r) 
sudo apt install -y wget curl apt-transport-https software-properties-common gnome-disk-utility gnome-firmware gnome-system-monitor firefox
sudo apt install -y mtools f2fs-tools xfsdump gvfs-backends


# Install flatpak 
sudo apt install -y flatpak 
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 

wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list
sudo apt update  
sudo apt install --install-recommends -y linux-xanmod-x64v3
sudo update-initramfs -u -k all
sudo update-grub

sudo apt install --install-recommends -y vulkan-validationlayers libvulkan1 vulkan-tools libosmesa6 mesa-opencl-icd


# Multimedia support
sudo apt install -y gstreamer1.0-fdkaac gstreamer1.0-plugins-bad gstreamer1.0-plugins-rtp gir1.2-gst-plugins-bad-1.0 gstreamer1.0-espeak 
sudo apt install -y gstreamer1.0-vaapi gstreamer1.0-pipewire gstreamer1.0-gtk3 rtkit pavucontrol
sudo apt install -y ffmpeg libavdevice60 libavcodec-extra aac-enc lame libmad0 flac twolame libaacs0 x265 sox libsox-fmt-mp3 libsox-fmt-ao 
sudo apt install -y celluloid handbrake soundconverter yt-dlp

# Gaming
sudo apt install --install-recommends -y steam gamemode libgdiplus libfaudio0 libopenal1 libvkd3d1 libvkd3d-headers protontricks

flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub net.davidotek.pupgui2
flatpak install -y flathub com.usebottles.bottles

#flatpak install -y flathub com.valvesoftware.Steam
#flatpak install flathub org.strawberrymusicplayer.strawberry

#flatpak install flathub com.warlordsoftwares.formatlab
#flatpak install flathub fr.handbrake.ghb
#flatpak install org.freedesktop.Platform.ffmpeg-full 


# Download and install strawberry player
wget https://github.com/strawberrymusicplayer/strawberry/releases/download/1.2.11/strawberry_1.2.11-noble_amd64.deb
sudo gdebi /home/lxadmin/strawberry_1.2.11-noble_amd64.deb




echo "
CPU_LIMIT=0
GPU_USE_SYNC_OBJECTS=1
PYTHONOPTIMIZE=1
__GL_SYNC_TO_VBLANK=1
__GLX_VENDOR_LIBRARY_NAME=mesa
MESA_BACK_BUFFER=ximage
MESA_NO_DITHER=0
MESA_SHADER_CACHE_DISABLE=false
mesa_glthread=true
MESA_DEBUG=0
PROTON_USE_WINED3D=0
PROTON_USE_FSYNC=1
GAMEMODE=1
DXVK_ASYNC=1
WINE_FSR_OVERRIDE=1
WINE_FULLSCREEN_FSR=1
WINE_VK_USE_FSR=1
 " | sudo tee -a /etc/environment


# Remove old kernels
sudo apt autoremove --purge -y

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean
rm -f "$deb_file"
sudo update-grub

sudo systemctl enable fstrim.timer  
sudo fstrim -av

clear
echo ""
echo "Xubuntu configuration completed successfully."
echo ""
sleep 2
read -p "Press any key to reboot the server.."
sudo reboot
