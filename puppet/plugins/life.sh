original(){
	if [ $# -eq 0 ]; then
        echo "original:"
        echo "runs the original command, be it in /usr/bin /bin or in some other folder,"
        echo "Usage: original <command> [arguments]"
        return 1
	fi
	local cmd=$1
	shift
	/usr/bin/$cmd $@
}

whoowns(){
    if [ $# -eq 0 ]; then
        echo whoowns
        echo " shows you who is the owner of a file or folder"
        echo " e.g: ~/ owner's would be you, $(whoami)"
        echo "whoowns <file or folder>"
        return 1
    fi
    stat -c '%U' $1
}

yt() {
    if [ $# -eq 0 ]; then
        echo "Usage: yt <url(s)>"
        return 1
    fi

    for url in "$@"; do
        if [[ "$url" == *"playlist?list="* ]]; then
            yt-dlp -o "$HOME/Music/%(uploader)s/%(playlist_title)s/%(title)s [%(id)s].%(ext)s" "$url"
        else
            yt-dlp -o "$HOME/Music/%(uploader)s/%(title)s [%(id)s].%(ext)s" "$url"
        fi
    done

    if command -v mpc >/dev/null 2>&1; then
        mpc rescan
    fi
}

kill() {
    # If no arguments, just show usage
    if [ $# -eq 0 ]; then
        echo "Usage: kill <pid|process_name> [...]"
        return 1
    fi

    local args=()
    local signals=()

    for arg in "$@"; do
        case "$arg" in
            -*) 
                # treat as signal flag (like -9)
                signals+=("$arg")
                ;;
            *)
                # non-flag argument — could be PID or process name
                if [[ "$arg" =~ ^[0-9]+$ ]]; then
                    # numeric → assume it's a PID
                    args+=("$arg")
                else
                    # not numeric → assume process name
                    # get all PIDs matching the process name
                    pids=$(pgrep -x "$arg" 2>/dev/null)
                    if [ -z "$pids" ]; then
                        echo "kill: no process found for '$arg'"
                    else
                        args+=($pids)
                    fi
                fi
                ;;
        esac
    done

    # if nothing was found, bail
    if [ ${#args[@]} -eq 0 ]; then
        return 1
    fi

    # run original kill with all resolved pids
    original kill "${signals[@]}" "${args[@]}"
}
