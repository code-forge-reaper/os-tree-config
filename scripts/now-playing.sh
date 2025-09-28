#!/bin/bash

# Get the current artist, title, and album art URL
artist=$(playerctl -p spotify metadata artist)
title=$(playerctl -p spotify metadata title)
icon=$(playerctl -p spotify metadata mpris:artUrl)

# If icon is empty or invalid, use a default icon
icon=${icon:-"terminal.png"}

# Convert 'file://' URL to a usable path
if [[ $icon =~ ^file:// ]]; then
    icon=${icon#file://}
fi

# Construct the notification message
message="Artist: $artist\nTitle: $title"

if [ -e "$icon" ] ; then
	# Send the notification
	dunstify \
	  --icon="$icon" \
	  "Now Playing" \
	  "$message"
else
	dunstify \
	  "Now Playing" \
	  "$message"
fi
