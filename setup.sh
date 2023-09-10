#!/bin/bash

# Update package lists and upgrade existing packages
apt update && apt upgrade -y

# Install Node.js LTS and NVM
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash

# Install Python3 and set it as the default for the `python` command
apt install -y python3 python3-pip
update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Install tmux
apt install -y tmux

# Setup .bashrc
echo "PS1='\[\e[34m\](\W)>\[\e[0m\] '" >> ~/.bashrc
echo "export EDITOR=vim" >> ~/.bashrc
echo "export TERM=xterm-256color" >> ~/.bashrc
echo "
# tumux
SESSION_NAME='tboi'

if command -v tmux &> /dev/null; then
  if [[ -z \"\$TMUX\" ]]; then
    tmux has-session -t \"\$SESSION_NAME\" &> /dev/null
    if [ \$? != 0 ]; then
      tmux new-session -d -s \"\$SESSION_NAME\"
      tmux send-keys -t \"\$SESSION_NAME\" \"LOLOLOL HAHAHHA\" C-m
    fi
    tmux attach-session -t \"\$SESSION_NAME\"
  fi
fi

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi" >> ~/.bash_profile

# Install vim
apt install -y vim

# Install PostgreSQL LTS (12 as of Ubuntu 20.04 LTS)
apt install -y postgresql postgresql-contrib

# Change SSH port to 777 and disable port 22
sed -i 's/#Port 22/Port 777/' /etc/ssh/sshd_config
systemctl restart sshd

# Reload bash settings
source ~/.bashrc

echo "Environment setup complete."
