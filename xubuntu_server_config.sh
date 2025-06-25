#!/usr/bin/env bash

echo ""
echo "-----------------------------------------"
echo "  Xubuntu Server  (minimal install)      " 
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
#sudo add-apt-repository -y ppa:kisak/kisak-mesa
sudo add-apt-repository -y ppa:graphics-drivers/ppa
sudo add-apt-repository -y ppa:savoury1/pipewire
sudo add-apt-repository -y ppa:xtradeb/apps
sudo add-apt-repository -y ppa:ubuntuhandbook1/handbrake
sudo add-apt-repository -y ppa:heyarje/makemkv-beta
sudo apt update 
clear


# remove snap
sudo apt purge -y snapd 
rm -vrf ~/snap 
sudo rm -vrf /snap /var/snap /var/lib/snapd /var/cache/snapd /usr/lib/snapd 
sudo apt-mark hold snapd  


# Install flatpak 
sudo apt install -y flatpak 
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 


sudo apt install -y synaptic mousepad gsmartcontrol build-essential fakeroot dkms ufw samba libnss-winbind winbind linux-headers-$(uname -r) openssh-server
sudo apt install -y wget curl apt-transport-https software-properties-common perl gnome-disk-utility gnome-firmware gnome-system-monitor pavucontrol
sudo apt install -y mtools f2fs-tools xfsdump gvfs-backends thunarx-python
#sudo apt install -y xorgxrdp xrdp


wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list
sudo apt update  
sudo apt install -y linux-xanmod-x64v3
sudo update-initramfs -u -k all
sudo update-grub


sudo apt install -y gstreamer1.0-fdkaac gstreamer1.0-plugins-bad gstreamer1.0-plugins-rtp gir1.2-gst-plugins-bad-1.0 gstreamer1.0-espeak 
sudo apt install -y gstreamer1.0-vaapi gstreamer1.0-pipewire gstreamer1.0-gtk3 rtkit
sudo apt install -y ffmpeg libavdevice60 libavcodec-extra aac-enc lame libmad0 flac twolame libaacs0 x265 sox libsox-fmt-mp3 libsox-fmt-ao 
sudo apt install -y celluloid handbrake soundconverter yt-dlp 

# NoMachine RDP
# sometimes you need to update the download link and file name
wget https://download.nomachine.com/download/9.0/Linux/nomachine_9.0.188_11_amd64.deb
sudo apt install /home/lxadmin/nomachine_9.0.188_11_amd64.deb


# Install makemkv (allow dvd and blueray copy)
sudo apt install -y makemkv-oss makemkv-bin default-jre

# Install brasero
sudo apt install -y brasero brasero-cdrkit gir1.2-brasero-3.1


# Virt-Manager
sudo apt install -y virt-manager virtinst libvirt-clients bridge-utils qemu-kvm qemu-utils \
libvirt-daemon-system dnsmasq-utils spice-client-gtk swtpm

# Guestfs support for Virt-Manager
sudo apt install -y guestfs-tools guestfsd libguestfs-gfs2 libguestfs-rsync python3-guestfs libguestfs-ocaml oz



# Install webmin interface
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sudo sh webmin-setup-repo.sh
sudo apt-get install --install-recommends webmin 

sudo systemctl enable webmin
sudo systemctl start webmin


# Install nvidia driver
sudo apt install -y nvidia-dkms-570 nvidia-utils-570  libnvidia-gl-570 libnvidia-gl-570:i386 nvidia-compute-utils-570 libxnvctrl0 nvidia-settings
sudo apt install -y vulkan-validationlayers libvulkan1 vulkan-tools libosmesa6 mesa-opencl-icd
sudo update-initramfs -u -k all


# Enable unattended upgrades for security updates
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades


# Add your user to the libvirt and kvm groups
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)

# Start and enable libvirt service
sudo systemctl start libvirtd
sudo systemctl enable libvirtd


# Some needed programs via flatpak
flatpak install -y flathub com.github.tchx84.Flatseal
flatpak install -y flathub org.mozilla.firefox
flatpak install -y flathub org.strawberrymusicplayer.strawberry
flatpak install -y flathub com.warlordsoftwares.formatlab
flatpak install -y flathub fr.handbrake.ghb
flatpak install -y org.freedesktop.Platform.ffmpeg-full 


# Install and enable ssh
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Setup UFW firewall if available
if command -v ufw >/dev/null 2>&1; then
  echo "Configuring UFW firewall..."
  sudo ufw default deny incoming
  sudo ufw default allow outgoing
  sudo ufw allow OpenSSH
  sudo ufw allow samba
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  #sudo ufw allow 3389/tcp
  sudo ufw allow 10000
  sudo ufw allow 4000/tcp
  sudo ufw allow 4000/udp
  sudo ufw --force enable
else
  echo "UFW not installed, skipping firewall configuration"
fi


# Remove old kernels
sudo apt autoremove --purge -y

sudo apt autoremove -y
sudo apt autoclean -y
sudo apt clean
sudo update-grub

sudo systemctl enable fstrim.timer  
sudo fstrim -av

clear
echo ""
echo "Xubuntu server configuration completed successfully."
echo "You can access Webmin at https://your-server-ip:10000"
echo ""
sleep 2
read -p "Press any key to reboot the server.."
sudo reboot

