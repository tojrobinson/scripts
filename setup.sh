#!/bin/bash

apt update && apt upgrade -y

apt install -y unattended-upgrades
dpkg-reconfigure --priority=low unattended-upgrades -f noninteractive

# Dev env
apt install -y vim
curl -sL https://deb.nodesource.com/setup_lts.x | bash -
apt install -y nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
apt install -y python3 python3-pip
update-alternatives --install /usr/bin/python python /usr/bin/python3 1
apt install -y postgresql postgresql-contrib

# Setup .bashrc
echo "PS1='\[\e[34m\](\W)>\[\e[0m\] '" >> ~/.bashrc
echo "export EDITOR=vim" >> ~/.bashrc
echo "export TERM=xterm-256color" >> ~/.bashrc

# tumux
apt install -y tmux

echo "
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
" >> ~/.bash_profile

echo "Security setup"

apt install ufw -y
apt install fail2ban

read -p "Enter the SSH port #: " ssh_port

if [[ ! "$ssh_port" =~ ^[0-9]+$ ]]; then
  echo "Invalid port number. Exiting."
  exit 1
fi

ufw enable
ufw allow $ssh_port/tcp
ufw default deny incoming
ufw default allow outgoing
sed -i "s/#Port 22/Port $ssh_port/g" /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

systemctl restart sshd
ufw reload

echo "[sshd]
enabled = true
port = $ssh_port
action = ufw
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600" | tee -a /etc/fail2ban/jail.local

systemctl enable fail2ban
systemctl start fail2ban
systemctl reload fail2ban

echo "Environment setup complete... remember to source ~/.bashrc"
