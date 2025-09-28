notify_script="now-playing.sh" # is in path

# Function to send notification
send_notification() {
    bash "$notify_script"
}

# Initial metadata to compare against
previous_artist=""
previous_title=""

# Monitor changes in the metadata
playerctl -p spotify metadata --follow | while read -r line; do
    # Get the current artist and title
    artist=$(playerctl -p spotify metadata artist)
    title=$(playerctl -p spotify metadata title)

    # Check if the song has changed
    if [[ "$artist" != "$previous_artist" ]] || [[ "$title" != "$previous_title" ]]; then
        # Update previous values
        previous_artist="$artist"
        previous_title="$title"
        
        # Send notification
        send_notification
    fi
done
