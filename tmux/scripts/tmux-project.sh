#!/bin/sh
# Pick a project folder and jump to its tmux session (created on first use).
# List: folders zoxide knows (most visited first), then everything two levels under ~/projects.
dir=$(
	{
		zoxide query -l 2>/dev/null
		fd -t d -d 2 . "$HOME/projects" 2>/dev/null | sed 's:/$::'
	} | awk '!seen[$0]++' | fzf --prompt='project> ' --reverse
)
[ -n "$dir" ] || exit 0
# session name = folder name (tmux does not allow "." or ":" in names)
name=$(basename "$dir" | tr '.:' '__')
tmux has-session -t "=$name" 2>/dev/null || tmux new-session -d -s "$name" -c "$dir"
tmux switch-client -t "=$name"
