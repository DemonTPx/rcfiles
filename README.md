# My rcfiles

My collection of rcfiles... for my own convenience!

## Fedora stuff

    dnf install -y \
        fish \
        xdotool \
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

Focus on google chrome or start it using xdotool

    sh -c "xdotool search --onlyvisible --desktop 0 --class "google-chrome" windowactivate || xdotool search --onlyvisible --class "google-chrome" windowactivate || google-chrome"

Bind scroll lock to mic mute

    dconf write /org/gnome/settings-daemon/plugins/media-keys/mic-mute "['Scroll_Lock']"

Play/pause spotify

    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
