#!/usr/bin/env bash

ME=$(whoami)
UBUNTU_LSB=focal
PHP_VERSION=7.4
DOCKER_COMPOSE_VERSION=1.25.5
NODE_VERSION=14
JETBRAINS_TOOLBOX_VERSION=1.17.6856

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
    ttf-bitstream-vera \
    ansible

mkdir -p ~/workspace ~/Applications

# Google Chrome
if [ ! -f /usr/bin/google-chrome ]
then
  curl -fsSL "https://dl-ssl.google.com/linux/linux_signing_key.pub" | sudo apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
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

# Font config
mkdir -p ~/.config/fontconfig/conf.d/
cp -t ~/.config/fontconfig/conf.d/ \
    ~/workspace/rcfiles/fontconfig/69-emoji.conf \
    ~/workspace/rcfiles/fontconfig/70-no-dejavu.conf

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
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu ${UBUNTU_LSB} stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt update -y
fi
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo adduser "${ME}" docker

# Docker-compose
if [ ! -f /usr/local/bin/docker-compose ]
then
  sudo curl -fsSL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
fi

# Traefik
if [ ! -e ~/workspace/traefik ]
then
  git clone https://github.com/DemonTPx/traefik-docker ~/workspace/traefik
  docker-compose -f ~/workspace/traefik/docker-compose.yml up -d || true
fi

# PHP
if [ ! -f "/etc/apt/sources.list.d/ondrej-php-${UBUNTU_LSB}.list" ]
then
  sudo add-apt-repository -y ppa:ondrej/php
  sudo apt update -y
fi
sudo apt install -y php${PHP_VERSION}-{cli,bcmath,curl,gd,intl,json,mbstring,mysql,opcache,sqlite3,xml} php-{apcu,xdebug,igbinary,pcov}

# Composer
if [ ! -f /usr/local/bin/composer ]
then
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"

  sudo mv composer.phar /usr/local/bin/composer
fi

# Node
if [ ! -f /usr/bin/node ]
then
  curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource.gpg.key" | sudo apt-key add -
  echo "deb https://deb.nodesource.com/node_${NODE_VERSION}.x ${UBUNTU_LSB} main" | sudo tee /etc/apt/sources.list.d/node.list
  sudo apt update -y
fi
sudo apt install -y nodejs

# Yarn
if [ ! -f /usr/bin/yarn ]
then
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
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
  sudo add-apt-repository -y ppa:serge-rider/dbeaver-ce
  sudo apt update -y
fi
sudo apt install -y dbeaver-ce
