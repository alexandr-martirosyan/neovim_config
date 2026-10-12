# Notes for AI assistants working on this Neovim config

Read this first. Then `CHANGELOG.md` (user-facing, sections 1–17) and `MIGRATION_NOTES.md`
(technical details, sections 1–8m) for anything specific.

## Where things stand (2026-10-12)

- Config: `~/.config/nvim`, branch `main` (the only branch). All work up to CHANGELOG section 17 (and `TMUX_PLAN.md`) was
  committed and fast-forwarded into `main`; the `codex/*` branches were deleted. `lazy-lock.json` is tracked.
- Neovim **0.12.6** via bob. bob 4.2 on macOS defaults to `~/Library/Application Support/bob`;
  `~/Library/Application Support/bob/config.json` points it at `~/.local/share/bob` (that's what PATH uses).
  0.11.7 stays installed for rollback.
- Completion: **blink.cmp** (`1.*`, v2 is unreleased/breaking). nvim-cmp family is `cond = false` and kept
  until the user says he is comfortable with blink, then he will ask to remove it.
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
- **Next planned task: tmux.** The user chose tmux; research and a step-by-step plan are in
  `TMUX_PLAN.md` (read it first when the user says to start). Nothing installed or configured yet.
- Font: Fira Code 6.2 is current, but its Nerd Fonts patch is 3.2.1; latest is 3.5.1
  (`brew install --cask font-fira-code-nerd-font`). Alternatives discussed: Maple Mono, Monaspace.
- blink.cmp v2 migration once 2.0.0 is released (needs blink.lib, local Rust build).
- Copilot next-edit suggestions later via folke/sidekick.nvim (would replace copilot.lua with the native
  Copilot language server).
- fzf-lua, mcphub, nvim-dap are enabled with `TODO:` notes (configure later).
- Built-in `<C-]>` can hit a 1 s LSP timeout on the first lookup of a session; the user chose to keep the
  built-in (an alternative mapping is commented out in `lspconfig/init.lua`).

## Testing tips

- Headless: `nvim --headless -c "luafile probe.lua"` with deferred functions writing results to a file.
- VeryLazy and UIEnter only fire with a UI: run Neovim in a Python `pty` and read the screen or a results file.
  `--listen` sockets are blocked by the sandbox (and macOS limits socket paths to ~104 chars).
- Alpha skips the dashboard when `v:argv` contains `-c`; read the rendered screen to test it.
- image.nvim has `cond` based on the terminal: run `lazy.update()` with `TERM_PROGRAM=iTerm.app`.
- lazy plugin names differ from repo names (e.g. `window-picker`, `catppuccin`); a wrong name in
  `lazy.update({ plugins = … })` silently updates nothing.
