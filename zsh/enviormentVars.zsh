# Editor configuration
export BROWSER=brave

export EDITOR="nvim"
export MANPAGER="nvim +Man!"

# Odin programming language root directory
export ODIN_ROOT="$HOME/Downloads/Odin-master/"

# Paths
export PATH="$HOME/.rbenv/shims:$PATH"
export PATH="$HOME/bin:$HOME/.config/emacs/bin:$HOME/.local/share/gem/ruby/3.0.0/bin:$PATH"
export PATH="/opt/brew/opt/pod2man/bin:$PATH"
export PATH="/opt/brew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="/opt/android-sdk/platform-tools:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# hist
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history

# Avoid storing duplicate commands
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# Store only unique commands (no duplicates in history)
setopt HIST_REDUCE_BLANKS
# Keep history for the current session
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY
# Append to the history file, rather than overwriting
setopt APPEND_HISTORY
