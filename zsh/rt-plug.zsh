# rt-plug.zsh
# Custom Zsh plugin manager
## @maintainer: cross-sniper|code-forge-reaper

# --- Configuration ---
# Base directory for all rt-plug related files (plugins, completions, database)
: "${RT_HOME:=$HOME/.config/zsh/rt-plug}"
: "${PLUGIN_HOME:=$RT_HOME/plugins}"
: "${COMPLETIONS_DIR:=$RT_HOME/completions}"
: "${PLUGINS_DB:=$RT_HOME/plugins.db}"

# --- Helper Functions ---

# Function to initialize the database and ensure necessary directories exist
_rt_init_db() {
    mkdir -p "$PLUGIN_HOME" "$COMPLETIONS_DIR"

    # Create the plugins table if it doesn't exist
    # Columns: name (unique), url, type (plugin/completion), path
    sqlite3 "$PLUGINS_DB" "CREATE TABLE IF NOT EXISTS plugins (
        name TEXT PRIMARY KEY,
        url TEXT NOT NULL,
        type TEXT NOT NULL,
        path TEXT NOT NULL
    );" || {
        echo "Error: Could not initialize SQLite database at $PLUGINS_DB." >&2
        return 1
    }
    return 0
}

# Function to extract the plugin name from a URL or full path
_rt_get_plugin_name() {
    local full_path="$1"
    local plugin_name

    # Extract the plugin name from the URL or path
    plugin_name=$(basename "$full_path" .git)

    echo "$plugin_name"
}

# Function to resolve the full Git URL
_rt_resolve_url() {
    local _name="$1"
    local url

    # Check if _name starts with a URL
    if [[ ! $_name =~ ^https?:// ]]; then
        # Assume it's a GitHub repository and prepend the base URL
        url="https://github.com/$_name.git"
    else
        url="$_name"
    fi
    echo "$url"
}

# --- Core Plugin Management Functions ---

# Function to add a plugin
# Usage: add_plugin <name_or_url> [type]
# type can be 'plugin' or 'completion'. Defaults to 'plugin'.
_rt_add() {
    local _name="$1"
    local item_type="${2:-plugin}" # Default to 'plugin'
    local url
    local plugin_name
    local target_dir # This variable holds the path for the item being added
    local db_type

    if ! _rt_init_db; then
        return 1
    fi

    url=$(_rt_resolve_url "$_name")
    plugin_name=$(_rt_get_plugin_name "$url")

    case "$item_type" in
        plugin)
            target_dir="$PLUGIN_HOME/$plugin_name"
            db_type="plugin"
            ;;
        completion)
            target_dir="$COMPLETIONS_DIR/$plugin_name"
            db_type="completion"
            ;;
        *)
            echo "Error: Invalid type '$item_type'. Must be 'plugin' or 'completion'." >&2
            return 1
            ;;
    esac

    # Check if already installed
    local existing_entry
    existing_entry=$(sqlite3 "$PLUGINS_DB" "SELECT name FROM plugins WHERE name = '$plugin_name' AND type = '$db_type';")
    if [ -n "$existing_entry" ]; then
        # don't output anything,
        # When using Powerlevel10k with instant prompt, console output during zsh
        # initialization may indicate issues.
        return 0
    fi

    # Clone the repository if the directory doesn't exist or is empty
    if [ ! -d "$target_dir" ] || [ -z "$(ls -A "$target_dir" 2>/dev/null)" ]; then
        echo "Cloning $item_type $plugin_name from $url to $target_dir..."
        if git clone --depth 1 "$url" "$target_dir"; then
            echo "Successfully cloned $plugin_name."
        else
            echo "Error: Failed to clone $item_type $plugin_name from $url." >&2
            # Clean up potentially created empty directory
            rmdir "$target_dir" 2>/dev/null
            return 1
        fi
    else
        echo "Directory $target_dir already exists and is not empty. Skipping clone."
        echo "If you want to update, use 'rt sync'."
    fi

    # Insert into database
    if sqlite3 "$PLUGINS_DB" "INSERT INTO plugins (name, url, type, path) VALUES ('$plugin_name', '$url', '$db_type', '$target_dir');"; then
        echo "Added $item_type '$plugin_name' to database."
    else
        echo "Error: Failed to add $item_type '$plugin_name' to database. It might already exist." >&2
        return 1
    fi

    # Source or add to fpath based on type
    if [ "$item_type" = "plugin" ]; then
        # Source the plugin files if they exist
        if [ -f "$target_dir/$plugin_name.plugin.zsh" ]; then
            source "$target_dir/$plugin_name.plugin.zsh"
            echo "Sourced $target_dir/$plugin_name.plugin.zsh"
        elif [ -f "$target_dir/$plugin_name.zsh" ]; then
            source "$target_dir/$plugin_name.zsh"
            echo "Sourced $target_dir/$plugin_name.zsh"
        else
            echo "Warning: No standard Zsh plugin file found in $target_dir (expected *.plugin.zsh or *.zsh)."
        fi
    elif [ "$item_type" = "completion" ]; then
        # Check if fpath contains plugin_dir, if not, add it
        if [[ ":$fpath:" != *":$target_dir:"* ]]; then
            fpath+="$target_dir"
            echo "Added $target_dir to fpath."
        else
            echo "$target_dir is already in fpath."
        fi
        # Ensure compinit is run after adding to fpath if completions are needed immediately
        # This is typically done once in .zshrc, but for immediate effect, could re-run.
        # However, re-running compinit can be slow and is usually not desired mid-session.
        # User should restart shell or run `compinit` manually.
        echo "Note: For completions to take full effect, you might need to restart your shell or run 'compinit'."
    fi
}

# Function to remove a plugin or completion
_rt_remove() {
    local plugin_name="$1"
    local entry_type="$2" # Optional: 'plugin' or 'completion'
    local query_where="name = '$plugin_name'"

    if ! _rt_init_db; then
        return 1
    fi

    if [ -n "$entry_type" ]; then
        query_where+=" AND type = '$entry_type'"
    fi

    local entry_data
    entry_data=$(sqlite3 "$PLUGINS_DB" "SELECT name, type, path FROM plugins WHERE $query_where;")

    if [ -z "$entry_data" ]; then
        echo "Error: $plugin_name not found in rt-plug database." >&2
        if [ -n "$entry_type" ]; then
            echo "Searched for type: $entry_type"
        fi
        return 1
    fi

    local name type item_path # 'item_path' temporarily holds the path from DB
    IFS='|' read -r name type item_path <<< "$entry_data"

    local target_path # This will be either pluginPath or compPath
    if [ "$type" = "plugin" ]; then
        local pluginPath="$item_path" # Declared and assigned specific variable
        target_path="$pluginPath"
    elif [ "$type" = "completion" ]; then
        local compPath="$item_path" # Declared and assigned specific variable
        target_path="$compPath"
    else
        echo "Error: Unknown item type '$type' for $name." >&2
        return 1
    fi

    echo "Removing $type '$name' from $target_path..."

    # Remove directory
    if [ -d "$target_path" ]; then
        if rm -rf "$target_path"; then
            echo "Successfully removed directory: $target_path"
        else
            echo "Error: Failed to remove directory $target_path. Please remove manually." >&2
            return 1
        fi
    else
        echo "Warning: Directory $target_path not found. Removing database entry only."
    fi

    # Remove from database
    if sqlite3 "$PLUGINS_DB" "DELETE FROM plugins WHERE name = '$name' AND type = '$type';"; then
        echo "Removed $type '$name' from database."
    else
        echo "Error: Failed to remove $type '$name' from database." >&2
        return 1
    fi

    echo "Note: For changes to take full effect (e.g., unsourcing plugins, removing completions from fpath), you might need to restart your shell."
}

# Function to list installed plugins and completions
_rt_list() {
    if ! _rt_init_db; then
        return 1
    fi

    local plugins_count
    plugins_count=$(sqlite3 "$PLUGINS_DB" "SELECT COUNT(*) FROM plugins WHERE type = 'plugin';")
    local completions_count
    completions_count=$(sqlite3 "$PLUGINS_DB" "SELECT COUNT(*) FROM plugins WHERE type = 'completion';")

    echo "--- rt-plug Managed Items ---"
    echo "Plugins ($plugins_count):"
    if [ "$plugins_count" -gt 0 ]; then
        sqlite3 "$PLUGINS_DB" "SELECT name, url FROM plugins WHERE type = 'plugin' ORDER BY name;" | while IFS='|' read -r name url; do
            echo "  - $name ($url)"
        done
    else
        echo "  No plugins installed."
    fi

    echo ""
    echo "Completions ($completions_count):"
    if [ "$completions_count" -gt 0 ]; then
        sqlite3 "$PLUGINS_DB" "SELECT name, url FROM plugins WHERE type = 'completion' ORDER BY name;" | while IFS='|' read -r name url; do
            echo "  - $name ($url)"
        done
    else
        echo "  No completions installed."
    fi
    echo "-----------------------------"
}

# Function to sync/update all installed plugins and completions
_rt_sync() {
    if ! _rt_init_db; then
        return 1
    fi

    echo "Starting rt-plug sync:"

    # Query all managed paths and types
    sqlite3 "$PLUGINS_DB" "SELECT name, type, path, url FROM plugins;" | \
    while IFS='|' read -r name type item_path url; do # 'item_path' temporarily holds the path from DB
        local current_sync_path # This will be either pluginPath or compPath for the current iteration

        if [ "$type" = "plugin" ]; then
            local pluginPath="$item_path" # Declared and assigned specific variable
            current_sync_path="$pluginPath"
        elif [ "$type" = "completion" ]; then
            local compPath="$item_path" # Declared and assigned specific variable
            current_sync_path="$compPath"
        else
            printf " › [%s] %s: Unknown type '%s', skipping\n" "$type" "$name" "$type" >&2
            continue
        fi

        if [ -d "$current_sync_path/.git" ]; then
            printf " › [%s] %s… " "$type" "$name"
            pushd "$current_sync_path" >/dev/null 2>&1
            # Try fast-forward only pull
            if git pull --ff-only --quiet; then
                echo "ok"
            else
                echo "failed"
            fi
            popd >/dev/null 2>&1
        else
            printf " › [%s] %s: not a git repo or directory not found, skipping\n" "$type" "$name"
        fi
    done

    echo "rt-plug sync complete."
}

# --- Main rt Command Dispatcher ---

# Main rt function
rt() {
    local subcommand="$1"
    shift # Remove the subcommand from the arguments

    case "$subcommand" in
        add)
            if [ -z "$1" ]; then
                echo "Usage: rt add <plugin_name_or_url> [plugin|completion]" >&2
                echo "Example: rt add zsh-users/zsh-autosuggestions" >&2
                echo "Example: rt add zsh-users/zsh-completions completion" >&2
                return 1
            fi
            _rt_add "$@"
            ;;
        remove)
            if [ -z "$1" ]; then
                echo "Usage: rt remove <plugin_name> [plugin|completion]" >&2
                echo "Example: rt remove zsh-autosuggestions" >&2
                echo "Example: rt remove zsh-completions completion" >&2
                return 1
            fi
            _rt_remove "$@"
            ;;
        list)
            _rt_list
            ;;
        initDb)
        	_rt_init_db
        	;;
        sync)
            _rt_sync
            ;;
        help | -h | --help)
            echo "rt-plug: A custom Zsh plugin manager."
            echo ""
            echo "Usage: rt <command> [arguments]"
            echo ""
            echo "Commands:"
            echo "  add <name_or_url> [type]   Add a new plugin or completion script."
            echo "                             <name_or_url>: GitHub repo (e.g., user/repo) or full Git URL."
            echo "                             [type]: 'plugin' (default) or 'completion'."
            echo "  remove <name> [type]       Remove an installed plugin or completion."
            echo "                             <name>: The name of the plugin/completion (e.g., zsh-autosuggestions)."
            echo "                             [type]: 'plugin' (default) or 'completion'. Useful if names conflict."
            echo "  list                       List all installed plugins and completions."
            echo "  sync                       Update all installed plugins and completions using 'git pull --ff-only'."
            echo "  help                       Show this help message."
            echo "  initDb                     initialize the database and folders manualy(good when you rm -rf the directories and .db file)."
            echo ""
            echo "Configuration:"
            echo "  RT_HOME: Base directory for rt-plug data (default: ~/.config/zsh/rt-plug)"
            echo "  PLUGIN_HOME: Directory for plugins (default: \$RT_HOME/plugins)"
            echo "  COMPLETIONS_DIR: Directory for completions (default: \$RT_HOME/completions)"
            echo "  PLUGINS_DB: Path to the SQLite database (default: \$RT_HOME/plugins.db)"
            echo ""
            echo "Note: After adding/removing/syncing, you might need to restart your shell"
            echo "      or run 'compinit' for changes to take full effect."
            ;;
        *)
            echo "Error: Unknown command '$subcommand'." >&2
            echo "Use 'rt help' for usage." >&2
            return 1
            ;;
    esac
}

# --- Initial Setup (optional, for .zshrc) ---
# To make 'rt' available as a command and source all plugins on shell startup,
# add the following to your ~/.zshrc:
#
# source /path/to/rt-plug.zsh
#
# # Ensure rt-plug's directories are created and database is initialized
_rt_init_db

# Source all managed plugins and add completions to fpath on Zsh startup
if [ -f "$PLUGINS_DB" ]; then
    # Source plugins
    sqlite3 "$PLUGINS_DB" "SELECT path, name FROM plugins WHERE type = 'plugin';" | while IFS='|' read -r plugin_path plugin_name; do
        local pluginPath="$plugin_path" # Declared and assigned specific variable
        if [ -d "$pluginPath" ]; then
            if [ -f "$pluginPath/$plugin_name.plugin.zsh" ]; then
                source "$pluginPath/$plugin_name.plugin.zsh"
            elif [ -f "$pluginPath/$plugin_name.zsh" ]; then
                source "$pluginPath/$plugin_name.zsh"
            fi
        fi
    done

    # Add completion paths to fpath
    sqlite3 "$PLUGINS_DB" "SELECT path FROM plugins WHERE type = 'completion';" | while IFS='|' read -r completion_path; do
        local compPath="$completion_path" # Declared and assigned specific variable
        if [ -d "$compPath" ] && [[ ":$fpath:" != *":$compPath:"* ]]; then
            fpath+="$compPath"
        fi
    done
fi
#
# # Ensure compinit is run after fpath is populated
# # You might already have this in your .zshrc
# # autoload -Uz compinit
# # compinit
