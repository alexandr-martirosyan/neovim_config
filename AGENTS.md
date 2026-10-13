# Notes for AI assistants working on this Neovim config

Read this first. `CONFIG_GUIDE.md` describes the whole config as it is now (structure, every plugin, every
shortcut and where it is defined, features, files outside the repo); its top has a freshness check.
`CHANGELOG.md` (user-facing, sections 1–20) and `MIGRATION_NOTES.md` (technical details, sections 1–8p)
hold the history.

## Where things stand (2026-10-12)

- Config: `~/.config/nvim`, branch `main` (the only branch). All work up to CHANGELOG section 20 (incl. `TMUX_PLAN.md`, `CONFIG_GUIDE.md`) was
  committed and fast-forwarded into `main`; the `codex/*` branches were deleted. `lazy-lock.json` is tracked.
- Terminal: iTerm2 with **Cmd and Ctrl swapped** (physical Cmd sends Ctrl to programs). Keep writing keys as
  `Ctrl+…`/`<C-…>`; mention the physical key only when ergonomics or iTerm2/macOS shortcuts matter.
- Neovim **0.12.6** via bob. bob 4.2 on macOS defaults to `~/Library/Application Support/bob`;
  `~/Library/Application Support/bob/config.json` points it at `~/.local/share/bob` (that's what PATH uses).
  0.11.7 stays installed for rollback.
- Completion: **blink.cmp** (`1.*`, v2 is unreleased/breaking). nvim-cmp family is `cond = false` and kept
  until the user says they are comfortable with blink; then they will ask to remove it.
- Colorscheme: catppuccin-macchiato with `auto_integrations = false` and the pre-update integration list
  pinned (Barbar slanted separators). Thick grey window separators (`fillchars`, `WinSeparator` and
  `NeoTreeWinSeparator` = `#6e738d`).
- Database: **vim-dadbod-ui** (`<leader>db`), nvim-dbee `cond = false`. Connections live in
  `~/.local/share/nvim/db_ui/connections.json` (contains credentials, mode 0600 — never print URLs).

## The user's rules (important)

- **Never remove a plugin unless asked.** Unused → `cond = false` (keeps it installed). Removed only on
  explicit request so far: CopilotChat, copilot-lsp, popup.nvim, bufferline, luafilesystem, mini.pick,
  telescope-media-files.
- **Do not restructure folders or merge files.** Pattern: `lua/alexander/plugins/<plugin>/init.lua`
  (lazy spec) + `<plugin>.lua` (opts/config/keys as `M.keys`). Shared dependencies keep their own folder;
  each consumer lists them in `dependencies`.
- **Keep the user's comments and commented-out code.** When disabling a mapping, comment it out with a note.
- **Versions:** follow the plugin's own docs; else the user's original setting; else default branch
  (`defaults.version = false`). Exception: docs say "release" but the last release is stale while main is
  actively fixed → follow main (applied to telescope, telescope-frecency, lazydev). blink.cmp stays `1.*`.
- Visual mappings use mode `"x"` (not `"v"`), so they don't fire in snippet Select mode.
- Update `CHANGELOG.md` (plain-language behaviour) and `MIGRATION_NOTES.md` (technical) after each change.
- **Keep `CONFIG_GUIDE.md` up to date with every change** (plugins, keys, options, features, files),
  at the latest before each commit, and update its snapshot line (commit + CHANGELOG section).
- Test changes before reporting (headless Neovim; a pseudo-terminal harness for UI-only behaviour).
  Don't run huge repeated checks — the user is token-conscious.
- Explain in plain language, step by step; the user often replies inline to parts of a message.
- Ask before outward actions (pushing to GitHub, installing system software, downloading).

## Waiting on the user / not tested by the user yet

- **Dimming trial:** Catppuccin `dim_inactive` (10%) is on and colorful-winsep is `cond = false`
  (comments say "TEMPORARY"). User: keep it for now; do **not** remove winsep.
- Verified by the user: Oil float border, separators, neo-tree thick separator, Kulala (license token works),
  image.nvim (Sixel in iTerm2 — `picture.png` test passed and was deleted).
- Not yet tried by the user in real use (all tested headless/pty by the assistant): neo-tree proportional
  layout (`neo-tree/keep-layout.lua`), `nvim .` stray-buffer fix, new start screen (Alpha), big-file
  protection, treesitter-textobjects, grug-far, treesitter-context (`<leader>tc`), auto-session,
  vim-dadbod-ui, code lens (`<leader>lc`), `<leader>sD`/`<leader>sS`, Harpoon on `<leader>ja`/`jj`.
- Databases: Docker Desktop was started and container `stack-overflow-db` (port 55008) is running and
  reachable. Connection `live-bootcamp-docker-db` (localhost:5432) has no matching container (`ps-db` exists
  but publishes no port) — ask the user before touching it.

## Open ideas (offered, not decided — don't do without asking)

- Barbar fork `~/projects/lua/barbar.nvim`: upstream merged locally into `configurable-filename-depth`
  (merge commit 3aa77e1) and local master fast-forwarded; **not pushed**. The config's fallback `commit`
  pin is still a49658503… (update only after a push). Upstream PR romgrk/barbar.nvim#661 awaits review.
- Per-window buffer tabs (custom winbar feature) — user said not now.
- **In progress: tmux** (plan in `TMUX_PLAN.md`; the user types most config themselves to learn it,
  the assistant may edit `~/.tmux.conf` when asked). Done (2026-10-13): steps 1–5 — tmux 3.8 (brew),
  `~/.tmux.conf` (outside the repo): prefix **Ctrl+\\**, splits `prefix s/d/S/D`, panes `prefix h/j/k/l`,
  detach `prefix q`, reload `prefix R`, status toggle `prefix b`, prev/next window **Alt+Shift+h/l** (bound
  as M-S-H, M-H and M-S-h — iTerm2 with extended keys sends `ESC[27;4;72~` = M-S-H), TPM, catppuccin/tmux
  v2.3.1 macchiato (session pill left, rounded tabs with folder names), tmux-resurrect (manual). Next:
  step 6 smart-splits (bind resize keys as C-S-H etc. and test with the real codes), 7 Ctrl+Shift keys,
  8 images in tmux (`image/init.lua` must also accept `LC_TERMINAL == "iTerm2"`), 9 session test,
  10 extras (tmux-which-key: change its Ctrl+Space root key first; LazyGit popup). Key debugging:
  `tmux -vv -L keydebug new` in a non-tmux tab, then grep `extended key` in tmux-server-*.log.
- Font: Fira Code 6.2 is current, but its Nerd Fonts patch is 3.2.1; latest is 3.5.1
  (`brew install --cask font-fira-code-nerd-font`). Alternatives discussed: Maple Mono, Monaspace.
- blink.cmp v2 migration once 2.0.0 is released (needs blink.lib, local Rust build).
- Copilot next-edit suggestions later via folke/sidekick.nvim (would replace copilot.lua with the native
  Copilot language server).
- fzf-lua, mcphub, nvim-dap are enabled with `TODO:` notes (configure later).
- Built-in `<C-]>` can hit a 1 s LSP timeout on the first lookup of a session; the user chose to keep the
  built-in (an alternative mapping is commented out in `lspconfig/init.lua`).

## Testing tips

- Nerd Font icons in the Basic Multilingual Plane private-use range (U+E000–U+F8FF, 3 UTF-8 bytes) can be
  dropped when an assistant writes a file (this emptied icons in `blink-cmp.lua` and `alpha.lua` once).
  Write such icons by code point (e.g. Python `"\uf113"`) and check the bytes afterwards.

- Headless: `nvim --headless -c "luafile probe.lua"` with deferred functions writing results to a file.
- VeryLazy and UIEnter only fire with a UI: run Neovim in a Python `pty` and read the screen or a results file.
  `--listen` sockets are blocked by the sandbox (and macOS limits socket paths to ~104 chars).
- Alpha skips the dashboard when `v:argv` contains `-c`; read the rendered screen to test it.
- image.nvim has `cond` based on the terminal: run `lazy.update()` with `TERM_PROGRAM=iTerm.app`.
- lazy plugin names differ from repo names (e.g. `window-picker`, `catppuccin`); a wrong name in
  `lazy.update({ plugins = … })` silently updates nothing.
