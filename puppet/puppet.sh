#!/usr/bin/env sh
# puppet.sh
PUPPET_DIR="$(dirname $BASH_SOURCE)"
#echo "[puppet: loading from $PUPPET_DIR]"
PLUGIN_DIR="$PUPPET_DIR/plugins"

puppet_reload() {
    source "$BASH_SOURCE"
}

puppet_load_plugins() {
    if [ -d "$PLUGIN_DIR" ]; then
        for plugin in "$PLUGIN_DIR"/*.sh; do
            [ -r "$plugin" ] && . "$plugin"
        done
        echo "[puppet: plugins loaded from $PLUGIN_DIR]"
    else
        echo "[puppet: no plugin directory found at $PLUGIN_DIR]"
    fi
}

# existing code
red="\033[0;31m"
green="\033[0;32m"
reset="\033[0m"
usr="$red\u$reset"
mch="$green\h$reset"
dir="$green\w$reset"
PS1="$usr@$mch in $dir\n-> "

HISTCONTROL=ignoredups
puppet_load_plugins
eval "$(uni-path.py bash)"
echo "[puppet loaded]"
