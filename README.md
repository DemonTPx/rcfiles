# My rcfiles

My collection of rcfiles... for my own convenience!


#### Resizing and moving windows

Left small

    xdotool getactivewindow windowsize 1174 100% windowmove 0 0

Right large

    xdotool getactivewindow windowsize 1386 100% windowmove 1174 0

Focus on google chrome or start it

    sh -c "xdotool search --onlyvisible --desktop 0 --class "google-chrome" windowactivate || xdotool search --onlyvisible --class "google-chrome" windowactivate || google-chrome"

#### Other useful command

Toggle mute input

    xdotool getactivewindow key XF86AudioMicMute

Map Scroll Lock to toggle mute input

    xmodmap -e "keycode 78 = XF86AudioMicMute"

Play/pause spotify

    dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause
