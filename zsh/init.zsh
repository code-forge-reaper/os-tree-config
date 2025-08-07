# Function to get the current Git status
_git_status() {
    local git_status

    # Check if we are in a Git repository
    if git rev-parse --is-inside-work-tree &>/dev/null; then
        # Get the Git branch name
        local branch
        branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        
        # Get the number of changes not staged for commit
        local unstaged
        unstaged=$(git diff --name-only --no-ext-diff | wc -l)
        
        # Get the number of changes staged for commit
        local staged
        staged=$(git diff --cached --name-only --no-ext-diff | wc -l)
        
        # Get the number of untracked files
        local untracked
        untracked=$(git status --porcelain | grep '??' | wc -l)

        # Format the Git status output
        git_status="%F{yellow}${branch}%f"
        [ "$staged" -gt 0 ] && git_status+=" %F{green}+${staged}%f"
        [ "$unstaged" -gt 0 ] && git_status+=" %F{red}!${unstaged}%f"
        [ "$untracked" -gt 0 ] && git_status+=" %F{blue}?${untracked}%f"
        
        echo "$git_status"
    fi
}


# Function to get the current Git branch
_git_branch() {
    local branch
    branch=$(git branch --show-current 2>/dev/null)
    echo "$branch"
}


get_error(){
	if [ $status -ne 0 ]; then
		echo "[error $status]"
	fi
}


# Function to update the prompt
update_prompt() {
    PS1="[%F{blue}$(whoami)@$HOST%f] %F{cyan}%~%f %F{yellow}$(_git_status)%f
%F{red}$(get_error)%f%F{green}❯%f "
    RPS1="%F{magenta}[%*]%f"
}

# Call update_prompt before every command
precmd_functions+=(update_prompt)


# Initialize the prompt
update_prompt

source $HOME/.config/zsh/enviormentVars.zsh
source $HOME/.config/zsh/dynamic_init.zsh
source $HOME/.config/zsh/aliases.zsh
source $HOME/.config/zsh/rt-plug.zsh
source $HOME/.config/zsh/plugins.zsh
source $HOME/.config/zsh/usr-script.zsh
autoload -Uz compinit && compinit
