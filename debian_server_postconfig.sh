#!/usr/bin/env bash

# Last Edit: 12.07.2025

echo ""
echo "Debian Server Postinstall Script"
echo ""
read -p "Press any key to continue.."
clear

sudo dpkg --add-architecture i386

sudo apt update
sudo apt dist-upgrade -y

sudo apt install --install-recommends dkms curl gvfs ufw software-properties-common apt-transport-https ca-certificates gsmartcontrol
sudo apt install -y synaptic flatpak xfsdump mtools f2fs-tools gnome-disk-utilitys rtkit pavucontrol ffmpeg flac lame x264 x265 handbrake
sudo apt install -y libglw1-mesa mesa-opencl-icd mesa-utils vulkan-tools vulkan-validationlayers
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

curl -fsSL https://repo.vivaldi.com/archive/linux_signing_key.pub | gpg --dearmor | sudo tee /usr/share/keyrings/vivaldi.gpg > /dev/null
echo deb [arch=amd64,armhf signed-by=/usr/share/keyrings/vivaldi.gpg] https://repo.vivaldi.com/archive/deb/ stable main | sudo tee /etc/apt/sources.list.d/vivaldi.list
sudo apt update
sudo apt install --install-recommends vivaldi-stable


# Install webmin interface
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sudo sh webmin-setup-repo.sh
sudo apt-get install --install-recommends webmin samba openssh-server fakeroot 


"Liquorix Kernel"
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash



# makemkv
sudo su
wget https://apt.benthetechguy.net/benthetechguy-archive-keyring.gpg -O /usr/share/keyrings/benthetechguy-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/benthetechguy-archive-keyring.gpg] https://apt.benthetechguy.net/debian bookworm non-free" > /etc/apt/sources.list.d/benthetechguy.list
apt update
sudo apt install -y makemkv libmakemkv1 libmmbd0
echo ""

# Virt-Manager
sudo apt install -y virt-manager virtinst libvirt-clients bridge-utils qemu-kvm qemu-utils \
libvirt-daemon-system dnsmasq-utils spice-client-gtk swtpm

# Guestfs support for Virt-Manager
sudo apt install -y guestfs-tools guestfsd libguestfs-gfs2 libguestfs-rsync python3-guestfs libguestfs-ocaml oz


# NoMachine RDP
# sometimes you need to update the download link and file name
wget https://download.nomachine.com/download/9.0/Linux/nomachine_9.0.188_11_amd64.deb
sudo apt install /home/lxadmin/nomachine_9.0.188_11_amd64.deb


sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 80/tcp  
sudo ufw allow 443/tcp 
sudo ufw allow OpenSSH
sudo ufw allow 445/tcp
sudo ufw allow 10000


sudo systemctl enable ssh
sudo systemctl start ssh

# Add your user to the libvirt and kvm groups
sudo usermod -aG libvirt $(whoami)
sudo usermod -aG kvm $(whoami)

# Start and enable libvirt service
sudo systemctl start libvirtd
sudo systemctl enable libvirtd


sudo systemctl enable webmin
sudo systemctl start webmin

sudo ufw enable


sudo systemctl enable fstrim.timer
sudo fstrim -av


sudo apt purge -y
sudo apt autoremove -y

# Remove old kernels
sudo apt autoremove --purge -y


echo ""
echo "Debian Server is now ready to use. Have fun!"
read -p "Press any key to reboot the server."
sudo reboot