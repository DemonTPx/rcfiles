#!/usr/bin/env bash

ME=$(whoami)
UBUNTU_LSB=jammy
PHP_VERSION=8.1
NODE_VERSION=16
JETBRAINS_TOOLBOX_VERSION=1.25.12627

set -xe

# Apt and common tools
if [ $(( $(date +%s) - $(stat -c %Y /var/cache/apt/pkgcache.bin) )) -gt 3600 ]
then
  sudo apt update -y
fi

sudo apt install -y \
    vim \
    git \
    build-essential \
    zsh \
    tmux \
    htop \
    colordiff \
    curl \
    wget \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    fonts-symbola \
    fonts-hack \
    ansible

mkdir -p ~/workspace ~/Applications

# Google Chrome
if [ ! -f /usr/bin/google-chrome ]
then
  curl -fsSL "https://dl-ssl.google.com/linux/linux_signing_key.pub" | sudo gpg --dearmor -o /usr/share/keyrings/google-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-archive-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
  sudo apt update -y
fi
sudo apt install -y google-chrome-stable

# rcfiles?
if [ ! -e ~/workspace/rcfiles ]
then
  git clone https://github.com/DemonTPx/rcfiles ~/workspace/rcfiles
fi

cp -t ~/ \
    ~/workspace/rcfiles/.tmux.conf \
    ~/workspace/rcfiles/.gitconfig \
    ~/workspace/rcfiles/.vimrc

# Cinnamon config
dconf load /org/cinnamon/ < ~/workspace/rcfiles/dconf/cinnamon.dconf
dconf load /org/gnome/libgnomekbd/keyboard/ < ~/workspace/rcfiles/dconf/keyboard.dconf

# Oh my zsh
if [ ! -e ~/.oh-my-zsh ]
then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

  cp ~/.zshrc ~/.zshrc.dist
  cp ~/workspace/rcfiles/.zshrc ~/.zshrc
fi

# Docker
if [ ! -e /usr/bin/docker ]
then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu ${UBUNTU_LSB} stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt update -y
fi
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo adduser "${ME}" docker

# Traefik
if [ ! -e ~/workspace/traefik ]
then
  git clone https://github.com/DemonTPx/traefik-docker ~/workspace/traefik
  docker-compose -f ~/workspace/traefik/docker-compose.yml up -d || true
fi

# PHP
if [ ! -f "/etc/apt/sources.list.d/ondrej-php-${UBUNTU_LSB}.list" ]
then
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x14aa40ec0831756756d7f66c4f4ea0aae5267a6c" | sudo gpg --dearmor -o /usr/share/keyrings/ondrej-php-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/ondrej-php-archive-keyring.gpg] http://ppa.launchpad.net/ondrej/php/ubuntu ${UBUNTU_LSB} main" | sudo tee /etc/apt/sources.list.d/ondrej-php-${UBUNTU_LSB}.list
  sudo apt update -y
fi
sudo apt install -y php${PHP_VERSION}-{cli,bcmath,curl,gd,intl,mbstring,mysql,opcache,sqlite3,xml} php-{apcu,xdebug,igbinary,pcov}

# Composer
if [ ! -f /usr/local/bin/composer ]
then
  EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
      >&2 echo 'ERROR: Invalid installer checksum'
      rm composer-setup.php
      exit 1
  fi

  php composer-setup.php
  rm composer-setup.php

  sudo mv composer.phar /usr/local/bin/composer
fi

# Node
if [ ! -f /usr/bin/node ]
then
  curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_${NODE_VERSION}.x ${UBUNTU_LSB} main" | sudo tee /etc/apt/sources.list.d/node.list
  sudo apt update -y
fi
sudo apt install -y nodejs

# Yarn
if [ ! -f /usr/bin/yarn ]
then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/yarn-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/yarn-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update -y
fi
sudo apt install -y yarn

# Jetbrains toolbox
if [ ! -f ~/Applications/jetbrains-toolbox ]
then
  curl -fsSL "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}.tar.gz" -o ~/Applications/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}.tar.gz
  tar xvzf ~/Applications/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}.tar.gz -C ~/Applications/
  mv ~/Applications/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}/jetbrains-toolbox ~/Applications/jetbrains-toolbox
  rm -rf ~/Applications/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION} ~/Applications/jetbrains-toolbox-${JETBRAINS_TOOLBOX_VERSION}.tar.gz
fi

if [ ! -f /etc/sysctl.d/60-intellij.conf ]
then
  echo "fs.inotify.max_user_watches = 524288" | sudo tee /etc/sysctl.d/60-intellij.conf
  sudo sysctl -p --system
fi

# DBeaver
if [ ! -f /usr/bin/dbeaver ]
then
  curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x30ece32520d438c21e16bf884a71b51882788fd2" | sudo gpg --dearmor -o /usr/share/keyrings/serge-rider-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/serge-rider-archive-keyring.gpg] http://ppa.launchpad.net/serge-rider/dbeaver-ce/ubuntu ${UBUNTU_LSB} main" | sudo tee /etc/apt/sources.list.d/serge-rider-dbeaver-ce-${UBUNTU_LSB}.list
  sudo apt update -y
fi
sudo apt install -y dbeaver-ce
