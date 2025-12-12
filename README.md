# My rcfiles

My collection of rcfiles... for my own convenience!

## Fedora stuff

    dnf install -y \
        fish \
        ansible \
        nodejs \
        php83 \
        php83-syspaths \
        php83-php-intl \
        php83-php-gd \
        php83-php-ldap \
        php83-php-process \
        php83-php-pecl-imagick-im7 \
        php83-php-pecl-rdkafka6 \
        php83-php-pecl-pcov \
        php83-php-pecl-xdebug3

## Useful gnome extensions

- https://extensions.gnome.org/extension/615/appindicator-support/
- https://extensions.gnome.org/extension/1160/dash-to-panel/
- https://extensions.gnome.org/extension/28/gtile/
- https://extensions.gnome.org/extension/4105/notification-banner-position/
- https://extensions.gnome.org/extension/1714/ssh-search-provider-reborn/

## Other useful commands

Bind scroll lock to mic mute

    dconf write /org/gnome/settings-daemon/plugins/media-keys/mic-mute "['Scroll_Lock']"

Control Spotify

    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous
    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next

Disable unused keybinds which conflict with IntelliJ keybinds

    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-up "[]"
    gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "[]"
