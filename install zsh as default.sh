#!/usr/bin/env bash

# Update package list and install zsh
sudo apt update && sudo apt install -y zsh

# Change the default shell to zsh
chsh -s $(which zsh)

# Append zsh configuration to .zshrc
{
    echo "# Set the prompt"
    echo "export PROMPT='%n@%m %1~ %# '"
    echo ""
    echo "# Enable command auto-correction"
    echo "setopt correct"
    echo ""
    echo "# Enable syntax highlighting (if you have the zsh-syntax-highlighting plugin)"
    echo "# source /path/to/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    echo ""
    echo "# Enable command history"
    echo "HISTSIZE=1000"
    echo "SAVEHIST=1000"
    echo "HISTFILE=~/.zsh_history"
} >> ~/.zshrc

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Clear the terminal
clear

# Inform the user about changing the shell in /etc/passwd
echo "Find the line: $username:x:1000:1000:,,,:/home/$username:/bin/bash and change to:"
echo "        $username:x:1000:1000:,,,:/home/$username:/bin/zsh"
echo ""

# Open /etc/passwd for editing
read -p "Press any key to continue to edit /etc/passwd"
sudo nano /etc/passwd

# Reboot the system
sudo reboot