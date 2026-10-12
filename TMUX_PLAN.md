# tmux integration — research and plan (prepared 2026-10-12, not started)

The user asked for this research and will do the setup on another day. Nothing below is applied yet.
Ask before installing anything (`brew install tmux`, TPM clone) and before creating `~/.tmux.conf`.

## 1. Current state (checked)

| Item | State |
|---|---|
| tmux | **not installed**. Homebrew has **3.8**, built with `--enable-sixel` and `--enable-utf8proc` |
| `~/.tmux.conf`, `~/.config/tmux/` | don't exist |
| kitty | not installed (alternative from AGENTS.md, not chosen) |
| Terminal | iTerm2 (`TERM_PROGRAM=iTerm.app`), Option key sends Esc+ (so `<A-…>` keys work) |
| Neovim | 0.12.6 via bob; `termguicolors = true`; `clipboard = "unnamedplus"` (pbcopy, works inside tmux on macOS without extras) |

### Neovim keys that tmux setup touches

| Key | Where | Now |
|---|---|---|
| `<C-h/j/k/l>` (n, x) | `configs/mappings.lua:13-16` | move between Neovim windows |
| `<C-S-h/j/k/l>` (n) | `configs/mappings.lua:37-40` | resize window by 1 |
| `<A-j>/<A-k>` (n, x) | `configs/mappings.lua:43-44, 63-64` | move lines |
| `<A-v> <A-h> <A-i> <A-t> <A-1…>` (n, t) | `plugins/toggleterm/toggleterm.lua:68+` | toggleterm terminals |
| `<C-S-P>/<C-S-N>` | `plugins/harpoon/harpoon.lua:43-46` | Harpoon prev/next |
| `<C-Space>` (insert) | `plugins/blink-cmp/blink-cmp.lua:49` | open completion menu |

## 2. Findings

1. **Seamless `<C-hjkl>` between Neovim windows and tmux panes: smart-splits.nvim v3** (moved to the
   `smart-splits-nvim` GitHub org). v3 has no built-in tmux support any more; it needs the separate
   backend plugin `smart-splits-nvim/backend-tmux`.
   - Docs: `version = "^3.0.0"`, backend as a dependency with `main = "smart-splits-backend-tmux"`,
     `opts = { mux = { backend = "smart-splits-backend-tmux" } }`. Requires Neovim ≥ 0.11.
   - **Must not be lazy-loaded** (`lazy = false`): the backend sets the tmux pane option `@pane-is-vim`;
     without it tmux swallows `<C-hjkl>` and Neovim never sees them.
   - tmux side uses `if -F '#{@pane-is-vim}' { send-keys C-h } { select-pane -L }` (no process-name
     sniffing, so bob's shim doesn't matter). It can be installed through TPM with options
     `@smart-splits_at_edge`, `@smart-splits_move_*_key`, `@smart-splits_resize_*_key`,
     `@smart-splits_resize_step_size`, or written by hand.
   - `move.at_edge`: `"wrap"` (default), `"stop"`, `"split"`. Keep tmux `@smart-splits_at_edge` in sync.
   - Backend option `disable_nav_when_zoomed = true` (default).
   - Defaults: `ignored_buftypes = { "nofile", "quickfix", "prompt" }` (neo-tree is `nofile`, so it's
     skipped for resize geometry), `resize.amount = 3`.
   - Alternative: christoomey/vim-tmux-navigator (older, process-name detection, navigation only).
     smart-splits is preferred: also does resize + swap and uses the pane flag.
2. **Resize keys conflict.** smart-splits' docs put resize on `<A-hjkl>`, but the user has `<A-h>`
   (toggleterm horizontal) and `<A-j>/<A-k>` (move lines). Options:
   - (a) keep the user's `<C-S-hjkl>` for resize (needs extended keys, see 3) — recommended, no conflicts;
   - (b) use `<A-H/J/K/L>` (Alt+Shift) as an extra fallback.
   Decide with the user. Also map smart-splits `swap_buf_*` (docs use `<leader><leader>h…`; check which-key
   conflicts first).
3. **Ctrl+Shift keys inside tmux.** tmux ≥ 3.5 rewrote extended keys: `set -g extended-keys on` +
   `set -g extended-keys-format csi-u` (3.5+), and add `extkeys` for the outer terminal
   (`set -as terminal-features 'xterm*:extkeys'`). iTerm2 must report the keys (Profiles → Keys →
   "Report keys using CSI u", or its kitty-keyboard support). Must be **tested by key**: `<C-S-h/j/k/l>`,
   `<C-S-P>/<C-S-N>`. Fallback if it fails: option (b) above. Note: plain shells may misread some
   Ctrl keys in csi-u mode; this mostly matters for programs other than Neovim.
4. **Images (image.nvim) inside tmux — needs a config change.** Inside tmux `TERM_PROGRAM=tmux` and
   `TERM=tmux-256color`, so `plugins/image/init.lua` `image_backend()` returns nil and image.nvim is
   **disabled** in tmux. Fix: also detect iTerm2 via `LC_TERMINAL == "iTerm2"` (set by iTerm2, inherited by
   the tmux server's environment) and/or `TERM_PROGRAM == "tmux"` + `tmux show-environment`/
   `#{client_termname}`. image.nvim docs for tmux: tmux ≥ 3.3, `set -gq allow-passthrough on`,
   `set -g visual-activity off`, `set -g focus-events on`; option `tmux_show_only_in_active_window`.
   Sixel under tmux goes through tmux's **native** sixel (Homebrew 3.8 has it; 3.6/3.7 fixed several sixel
   bugs) — tell tmux the outer terminal can do it: `set -as terminal-features 'xterm*:sixel'`. Passthrough
   is for the kitty protocol (not iTerm2). Test with a png; if slow, `only_render_image_at_cursor = true`.
5. **Neovim `:checkhealth` tmux section** expects: `escape-time` ≤ 300 (recommend `set -sg escape-time 10`;
   10 is tmux's default since 3.5), `focus-events on`, `default-terminal` = `tmux-256color`
   (or screen-256color), and RGB: `set -as terminal-features 'xterm-256color:RGB'` (iTerm2's `$TERM`).
6. **Sessions.** tmux-resurrect (+ tmux-continuum for auto save/restore) re-runs `nvim` in each pane's
   folder; auto-session then restores the Neovim session by folder (it restores when started with no
   args). So no extra Neovim session strategy is needed. Check: with bob the saved command may be the
   versioned path (`…/bob/v0.12.6/bin/nvim`); if so, set `@resurrect-processes` / a post-save hook.
   Optional — ask the user.
7. **Prefix key.** Default `C-b`. Don't use `C-Space` (blink completion). `C-a` hides Vim's increment.
   Recommend keeping `C-b` (or `C-s` — unused in Neovim; zsh has flow control off by default — confirm).
8. **tmux 3.8 notes for a fresh config:** mouse defaults to on; new built-in light/dark theme (`theme`
   option; status colours could be matched to catppuccin-macchiato — catppuccin/tmux plugin exists,
   check its docs); `refresh-from-pane` renamed; synchronized output (3.7) reduces flicker; `get-clipboard`
   (3.7, off by default). `set -g set-clipboard on` for OSC52 copy from remote/SSH.
9. **iTerm2 tmux integration (`tmux -CC`)** turns tmux windows into native iTerm2 tabs, but keys/images
   behave differently; recommend plain tmux.
10. Other Neovim bits: lualine/barbar unaffected; lazygit/lazydocker could later also run as tmux popups
    (`display-popup -E lazygit`), optional.

## 3. Plan for the setup day (each step: explain, ask, then do)

1. Ask: install tmux (`brew install tmux`) and TPM (git clone to `~/.tmux/plugins/tpm`) or a hand-written
   config without plugins? Ask: prefix key, resize keys (2a/2b), resurrect/continuum yes/no, theme.
2. Write `~/.tmux.conf` (outside the repo; offer to keep a copy in this repo only if the user wants):
   true colour + `default-terminal`, `escape-time`, `focus-events`, extended keys, passthrough/sixel,
   `visual-activity off`, `set-clipboard`, mouse, vi copy-mode, base-index 1, splits keeping cwd,
   smart-splits bindings (incl. copy-mode-vi), optional TPM plugins.
3. Neovim: new `lua/alexander/plugins/smart-splits/{init,smart-splits}.lua` (folder pattern, `lazy = false`,
   `version = "^3.0.0"`, backend dependency). Move `<C-hjkl>`/resize to smart-splits; comment out the old
   lines in `mappings.lua` with a note (keep them). Works outside tmux too (falls back to Neovim windows).
4. Neovim: fix `image/init.lua` detection for tmux (finding 4).
5. Test: `:checkhealth` (tmux section, smart-splits, smart-splits-backend-tmux), `<C-hjkl>` across panes both
   ways, resize keys, `<C-S-P/N>`, `<A-…>` toggleterm keys, an image, colours, clipboard yank → paste in
   macOS, `nvim` restore inside tmux.
6. Update CHANGELOG.md, MIGRATION_NOTES.md, AGENTS.md; commit only when the user asks.

## Sources

- smart-splits.nvim README: https://github.com/smart-splits-nvim/smart-splits.nvim
- backend-tmux README: https://github.com/smart-splits-nvim/backend-tmux
- image.nvim README (tmux section): https://github.com/3rd/image.nvim
- tmux CHANGES: https://github.com/tmux/tmux/blob/master/CHANGES
- Homebrew tmux formula: https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/t/tmux.rb
- extended-keys-format csi-u guide: https://pi.dev/docs/latest/tmux
- iTerm2 CSI u: https://iterm2.com/documentation-csiu.html
- Neovim TUI keys: https://neovim.io/doc/user/tui/
- tmux-resurrect: https://github.com/tmux-plugins/tmux-resurrect
- Neovim health check source: `$VIMRUNTIME/lua/vim/health/health.lua` (`check_tmux`)
