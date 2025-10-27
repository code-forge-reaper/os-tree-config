eval "$(zoxide init --cmd cd bash)"


# pnpm
export BUN_INSTALL=$HOME/.bun
PATH=$BUN_INSTALL/bin:$PATH

export PNPM_HOME="/home/cross/.local/share/pnpm"
#if not string match -q -- $PNPM_HOME $PATH
#  set -gx PATH "$PNPM_HOME" $PATH
#end
if [[ "$PATH" != *"$PNPM_HOME"* ]]; then
  PATH="$PNPM_HOME:$PATH"
fi
