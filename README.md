# My Neovim configuration

Neovim configuration with Catppuccin Macchiato, a local Barbar fork, Telescope,
Oil/Neo-tree, native LSP, blink.cmp/LuaSnip/Copilot completion, manual Conform
formatting, UFO folds, ToggleTerm, and two AI frontends (Avante, CodeCompanion) plus Copilot completion.

## Requirements

- Neovim 0.12 or newer. The migration was tested with 0.12.6.
- Git, curl, a C compiler, make, and **tree-sitter-cli >= 0.26.1**. On Homebrew,
  `brew install tree-sitter-cli`; the `tree-sitter` formula alone is only a library.
- Rust/Cargo for Avante's current native build and LuaSnip's optional build tools.
- `rg` and `fd` for search. ImageMagick (`magick`) and a compatible terminal for image.nvim.
- Language tools managed by Mason, plus the relevant project toolchains (for
  example Cargo/rustfmt and Node for JavaScript tooling).
- `lazygit` for the LazyGit UI; the database's command-line client (e.g. `psql`, `mysql`) for
  vim-dadbod-ui. Connections are stored outside the repo in `~/.local/share/nvim/db_ui/`.
- `codex` and `codex-acp` on PATH for the configured Codex integrations; `claude` and `claude-agent-acp`
  (`npm i -g @agentclientprotocol/claude-agent-acp`) for Claude, logged in with `claude auth login --claudeai`. No local AI is
  configured; commented templates for oMLX, llama.cpp and LM Studio are in the Avante and CodeCompanion configs.
- Kulala Core license access for the upgraded HTTP backend; see below.

## Layout and ownership

The existing folder layout is preserved:

- `init.lua` loads `lua/alexander/init.lua`.
- `lua/alexander/configs/` owns editor options, autocmds, core mappings, diagnostic
  display, and Lazy bootstrap.
- `lua/alexander/plugins/<plugin>/init.lua` declares load triggers/dependencies;
  each plugin's existing configuration module owns its options and shortcuts.
- `plugins/diagnostics/lsp/` retains Mason settings and per-server overrides.
- `plugins/ai/avante/file_reference.lua` is the shared file-opening helper used
  by Avante and CodeCompanion, without introducing another folder.

A shared dependency keeps one configuration owner. Each consumer lists it as a
Lazy dependency; consumers do not depend on another consumer merely to get it
configured. Repeated dependency declarations refer to the same Lazy plugin.
Unused components are retained with `cond = false` (currently nvim-cmp and its sources, Dbee,
Winshift and, during the dimming trial, Colorful Winsep); the commented LazyDocker alternative
remains available. Bufferline was removed on request.

## Useful behavior and shortcuts

- `<leader>fm`: format manually. No format-on-save was added. Black/Flake8 and
  Rust Clippy are retained; JSX/TSX use Prettier.
- LSP uses Neovim's built-ins: `grr` references, `grn` rename, `gra` code action, `gri` implementation,
  `grt` type definition; plus `gd`/`gD` definition/declaration and `gh`/`K` hover.
  `<leader>lr`: toggle relative line numbers.
- Completion is blink.cmp (nvim-cmp is kept but disabled). Tab confirms a visible
  completion menu; otherwise it expands or advances a snippet. Shift-Tab moves back.
  Snippets survive leaving Insert mode. `<C-Space>` opens the menu, `<C-e>` closes it,
  `<C-n>`/`<C-p>` select, `<C-f>`/`<C-d>` scroll the docs.
- `<leader>ff`, `fw`, `fb`: Telescope files, grep, buffers; `fp`: Harpoon picker.
- `<leader>fs` / `fS`: find & replace across the project / in the current file (grug-far).
- Text objects: `af`/`if` function, `ac`/`ic` class, `aa`/`ia` argument, `al`/`il` loop; `]f`/`[f` next/previous function.
- `<leader>tc`: change how many lines of pinned context (current function/class) are shown.
- `<leader>db`: database UI (vim-dadbod-ui). Sessions are saved and restored per folder (auto-session).
- `-`: floating Oil; `<C-n>`: Neo-tree toggle.
- `<leader>pt`: select a ToggleTerm terminal. Alt-v/h/i/t retains terminal 1's
  vertical/horizontal/floating/tab views; Alt-1/2 retains exclusive tab terminals.
- `<leader>?`: buffer-local WhichKey view; `<leader>wK`: all keymaps.
- `gc`: native commenting with ts-comments support; Comment.nvim adds `gb`/`gbc` block comments
  and `gco`/`gcO`/`gcA`.
- `<leader>ia…`, `ic…`: Avante, CodeCompanion. Avante buffer
  `gR` opens a file reference safely in a code window.

## Language tools

Use `:MasonInstallAll` for missing packages from
`plugins/diagnostics/lsp/mason/settings.lua`. `:MasonReinstallAll` intentionally
forces reinstallation of that list. Merely installing another LSP does not enable
it: edit `settings.servers` to opt it in. Approved servers installed during a
session activate automatically. Circom remains opt-in via `enable_circom`.
Lua libraries are supplied by lazydev. Native root detection separates Node and
Deno projects; overrides and any regression corrections are explained in the
migration notes.

## Kulala backend activation

Kulala.nvim follows its default branch and needs Kulala Core (1.3.1 installed and activated on
this machine; the old 0.7.0 backend is not used). The steps below are for a new machine.

1. Obtain a valid Kulala Core license token from the maintainers. The
   [official license site](https://core.kulala.app/) did not expose public pricing
   or self-service signup during this migration, so **free versus paid access
   could not be confirmed**.
2. Open an `.http` file and enter the token at the hidden `Kulala license token`
   prompt. Kulala downloads the required backend and manages its HTTP parser.
3. On macOS the token is saved with owner-only permissions in
   `~/Library/Application Support/kulala-core/license-token` and reused later.
   Alternatively pass `KULALA_CORE_LICENSE_TOKEN` through the environment of the
   process launching Neovim. Never commit a token in this configuration.
4. After activation, check a local request with `<leader>Rs` and the response window's
   tabs/winbar. `<leader>fm` formats `.http` files with `kulala-fmt` (installed by
   `:MasonInstallAll`); Kulala's language server does not format.

The public demo's response assertions were corrected without executing its
POST/PATCH/DELETE requests. A script-only mock check is documented in the notes.

## Plugin upgrades and recovery

`lazy-lock.json` records the selected revisions, including retained disabled
components. `:Lazy update` updates active plugin tracks and invokes their build
hooks. Avoid `:Lazy clean` if retaining installed disabled plugins is desired.
Treesitter (main branch) installs every available parser and updates them from its build hook;
its current API uses `:TSInstall`/`:TSUpdate`, rather than the removed module toggles.

Barbar uses `~/projects/lua/barbar.nvim` when present. That development checkout
is deliberately not updated by this migration or Lazy. Other machines use the
user's remote fork pinned in the spec. The fallback is not a claim that the local
fork has the same HEAD. Keep that distinction when updating.

See [CONFIG_GUIDE.md](CONFIG_GUIDE.md) for a full description of the config (every plugin,
shortcut and feature), [AGENTS.md](AGENTS.md) for the current state and open items,
[CHANGELOG.md](CHANGELOG.md) for conceptual changes and
[MIGRATION_NOTES.md](MIGRATION_NOTES.md) for exact revisions, compatibility,
validation, deferred suggestions, and the complete pre-migration backup path.
Switching a Git branch alone does not restore installed plugins/native binaries;
follow the backup recovery instructions there.
