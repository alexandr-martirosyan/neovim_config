# tmux config

The tmux setup that goes with this Neovim config (details: `../TMUX_PLAN.md` § Final state).
The files live here; the paths tmux uses are links to them, so edits are saved in this repo.

| File | Linked from | Purpose |
|---|---|---|
| `tmux.conf` | `~/.tmux.conf` | the whole tmux configuration |
| `scripts/tmux-project.sh` | `~/.tmux/scripts/tmux-project.sh` | project switcher (`prefix f`) |

## Set up on a new Mac

```bash
brew install tmux lazygit fzf zoxide fd
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
mkdir -p ~/.tmux/scripts
ln -s ~/.config/nvim/tmux/tmux.conf ~/.tmux.conf
ln -s ~/.config/nvim/tmux/scripts/tmux-project.sh ~/.tmux/scripts/tmux-project.sh
```

Then start `tmux` and press `prefix I` (capital i; prefix is Ctrl+\) to install the plugins
(catppuccin theme, tmux-resurrect, tmux-which-key). zoxide needs `eval "$(zoxide init zsh)"` in `~/.zshrc`
for the project list to learn folders.

To stop using the links, replace each link with a copy, e.g.
`rm ~/.tmux.conf && cp ~/.config/nvim/tmux/tmux.conf ~/.tmux.conf` (same for the script).
