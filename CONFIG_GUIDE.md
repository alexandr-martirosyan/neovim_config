# Neovim config guide

A complete description of this Neovim configuration: what it contains, how the code is organised,
every shortcut and where it is defined, every plugin and what it does here, and what lives outside
the repository. It is a reference for people and AI assistants working on this config.

> **Snapshot.** Fully checked against commit `3abb37c` (2026-10-12), then updated with every later
> change, up to and including CHANGELOG section 26 (2026-10-14). Verified by reading every file and by inspecting a running
> Neovim (loaded plugins, real key mappings, buffer-local LSP/Kulala mappings).
>
> **Freshness check.** Compare the last commit that changed this file with the last commit that
> changed the code, and look for uncommitted code changes:
>
> ```bash
> git log -1 --format='%h %cd' -- CONFIG_GUIDE.md
> git log -1 --format='%h %cd' -- init.lua lua
> git status --short -- init.lua lua
> ```
>
> If the code has newer commits or uncommitted changes, this guide may be partly outdated; recheck
> the affected parts in the code when it matters.

Related files: `AGENTS.md` (current state, the owner's rules for changes, open items),
`CHANGELOG.md` (history in plain language), `MIGRATION_NOTES.md` (technical history),
`TMUX_PLAN.md` (tmux setup, finished; § Final state), `README.md` (short overview).

---

## 1. Overview

| Item | Value |
|---|---|
| Owner / platform | Alexandr Martirosyan, macOS, iTerm2 (Option key sends `Esc+`), Fira Code Nerd Font |
| Repository | `github.com/alexandr-martirosyan/neovim_config`, single branch `main` |
| Neovim | 0.12.6 managed by **bob** (`~/.local/share/bob`); 0.11.7 kept for rollback (`bob use 0.11.7`) |
| Plugin manager | lazy.nvim; 82 plugins incl. lazy.nvim: 70 enabled, 11 disabled, 1 conditional (image.nvim, on in iTerm2) |
| Leader / local leader | `<Space>` / `\` |
| Colorscheme | catppuccin **macchiato** |
| Completion | blink.cmp 1.x (+ LuaSnip, Copilot, lazydev, dadbod, Avante sources) |
| Pickers | Telescope (fzf-native, frecency, ui-select) |
| Files | neo-tree (sidebar), Oil (floating, `-`), Harpoon |
| LSP | Neovim built-in `vim.lsp` + nvim-lspconfig configs + Mason / mason-lspconfig |
| Format / lint | Conform (manual only, `<leader>fm`), nvim-lint (automatic) |
| Syntax | nvim-treesitter **main** branch, every parser installed |
| Git | gitsigns, Neogit (+ diffview), LazyGit, Telescope git pickers |
| AI | Avante (Codex or Claude via ACP), CodeCompanion (chat: Claude/Codex via ACP; inline: Copilot fallback), Copilot completions; no local AI (templates only) |
| Other tools | Kulala (HTTP client), vim-dadbod-ui (databases), toggleterm, grug-far, auto-session, image.nvim |
| UI | lualine (global statusline + winbar), Barbar tabs (owner's fork), Noice, which-key, alpha start screen |

---

## 2. Repository layout

```
~/.config/nvim/
├── init.lua                      -- sets local user = "alexander"; require(user)
├── lua/
│   ├── alexander/
│   │   ├── init.lua              -- vim.loader.enable(); loads configs in order (section 3)
│   │   ├── configs/              -- core editor setup (no plugins)
│   │   │   ├── options.lua               options, leader keys, filetypes
│   │   │   ├── autocmds.lua              highlights, big-file protection, startup cleanup, cd
│   │   │   ├── diagnostics-commands.lua  vim.diagnostic.config + 2 commands
│   │   │   ├── mappings.lua              core key mappings
│   │   │   └── lazy.lua                  lazy.nvim bootstrap + settings
│   │   └── plugins/              -- one folder per plugin (or group), see below
│   └── other-user/.gitkeep       -- placeholder: another user folder can be selected in init.lua
├── lazy-lock.json                -- exact plugin commits (tracked)
├── kulala-demo.http              -- Kulala example requests (public httpbin/jsonplaceholder demos)
├── typos.toml                    -- typos-lsp: allows the word "noice"
├── .stylua.toml                  -- Lua formatting: tabs, width 2, 120 columns, double quotes, always parens
├── .gitignore                    -- build artefacts, .DS_Store, .nvimlog/nvim.log (lazy-lock.json is tracked)
├── AGENTS.md, CLAUDE.md          -- AI assistant notes (CLAUDE.md only imports AGENTS.md)
└── CONFIG_GUIDE.md, CHANGELOG.md, MIGRATION_NOTES.md, README.md, TMUX_PLAN.md
```

### Plugin folder pattern

- `lazy.lua` calls `require("lazy").setup({ { import = "alexander.plugins" } })`. lazy imports every
  `lua/alexander/plugins/<folder>/init.lua` (one level deep). Deeper files are plain modules required
  by those `init.lua` files.
- Usual pattern: `<folder>/init.lua` returns the lazy spec(s) (repo, version/branch, load trigger,
  dependencies); `<folder>/<plugin>.lua` returns a module `M` with `M.opts`, `M.config`, `M.keys`,
  `M.init`, `M.cmd` that the spec references.
- A shared dependency has its own folder with its own spec (e.g. `plenary/`, `nui/`,
  `nvim-web-devicons/`, `nvim-notify/`); every consumer lists it in `dependencies`.
- Folders that group several specs or differ from the pattern:

| Folder | Contents |
|---|---|
| `ai/` | `init.lua` = specs for avante.nvim, codecompanion.nvim, render-markdown.nvim, img-clip.nvim; `avante/avante.lua`, `avante/file_reference.lua` (shared helper), `codecompanion/codecompanion.lua` |
| `blink-cmp/` | blink.cmp + blink.compat specs; `blink-cmp.lua` = all completion options |
| `colorschemes/` | catppuccin spec with options inline (no separate module) |
| `comments/` | ts-comments.nvim + Comment.nvim specs; `ts-comments.lua`, `comment-nvim.lua` |
| `copilot/` | copilot.lua, copilot-cmp (disabled), blink-copilot specs + one module each |
| `diagnostics/` | `init.lua` = specs for nvim-lint, conform, mason, nvim-lspconfig, mason-lspconfig. Here `conform/init.lua` and `nvim-lint/init.lua` are **option modules** (not specs). `conform/formatters/*.lua` = per-formatter overrides (auto-loaded). `lsp/lspconfig/init.lua` = LspAttach mappings + capabilities; `lsp/lspconfig/<server>.lua` = per-server settings; `lsp/mason/init.lua` + `settings.lua` = Mason tools and approved server list; `lsp/mason-lspconfig/init.lua` = server activation |
| `lazytools/` | lazygit.nvim spec; `lazygit.lua`; `lazydocker.lua` (its spec is commented out) |
| `neo-tree/` | spec; `neo-tree.lua` (opts/keys/init); `keep-layout.lua` (window proportion keeper) |
| `nvim-cmp/` | lspkind.nvim, nvim-cmp (disabled), LuaSnip, nvim-autopairs specs; modules `nvim-cmp.lua`, `LuaSnip.lua`, `nvim-autopairs.lua` |
| `startup/` | alpha-nvim spec; `alpha.lua` |
| `telescope/` | telescope-fzf-native, telescope.nvim, telescope-frecency specs; `telescope.lua` |
| `vim-dadbod-ui/` | vim-dadbod-ui spec with vim-dadbod and vim-dadbod-completion as dependencies |
| `illuminate/` | spec table returned directly (not wrapped in a list) |

---

## 3. Startup sequence

1. `init.lua` → `require("alexander")`.
2. `lua/alexander/init.lua`: `vim.loader.enable()`, then in order `configs.options`, `configs.autocmds`,
   `configs.diagnostics-commands`, `configs.mappings`, `configs.lazy`.
3. lazy.nvim runs every spec's `init` immediately:
   - mini.icons: `package.preload["nvim-web-devicons"]` → any `require("nvim-web-devicons")` gets mini.icons' mock.
   - barbar: `vim.g.barbar_auto_setup = false`.
   - neo-tree: when started as `nvim <folder>` (exactly one argument that is a directory) it `require`s
     neo-tree at once so its folder takeover happens during startup.
   - avante: FileType `Avante` autocmd that maps `gR` (section 6.5).
   - vim-dadbod-ui: `db_ui_use_nerd_fonts = 1`, `db_ui_save_location = stdpath("data")/db_ui`.
   - auto-session: sets `sessionoptions` (section 7.17).
4. Start plugins (`lazy = false`): catppuccin (priority 1000, applies `catppuccin-macchiato`), lualine,
   barbar, nvim-treesitter, auto-session, smart-splits (+ backend-tmux).
5. `VimEnter`: alpha start screen (only when Neovim starts without file arguments; alpha also skips
   when `-c` is in `v:argv`), auto-session restore, and the config's `cd <folder>` for a folder argument.
6. `VeryLazy`: neo-tree, noice (+ nvim-notify), which-key, Comment.nvim, ts-comments, nvim-surround,
   scope.nvim, window-picker.
7. Events and triggers for the rest: see the "Load" column in section 5.

Observed in a real session started with plain `nvim` in a project (after `VeryLazy`), these plugins were
loaded: Comment.nvim, alpha-nvim, auto-session, barbar, catppuccin, gitsigns, image.nvim (iTerm2),
indent-blankline, lualine, mini.icons, neo-tree, noice, nui, nvim-dap, nvim-notify, nvim-surround,
nvim-treesitter, nvim-ufo, nvim-web-devicons, plenary, promise-async, scope, telescope (+ fzf-native,
ui-select, frecency), todo-comments, trouble, ts-comments, vim-illuminate, which-key, window-picker,
smart-splits (+ backend-tmux). image.nvim comes with neo-tree (a dependency); in a supported terminal it
loads on `VeryLazy`, or earlier when a picture file is opened (section 5).
Opening a Lua file additionally loads the LSP stack (lspconfig, mason, mason-lspconfig, nvim-lint,
lazydev, treesitter-context); entering Insert mode loads blink.cmp, LuaSnip, friendly-snippets,
lspkind, blink.compat, copilot.lua, nvim-autopairs.

---

## 4. Core settings (`lua/alexander/configs/`)

### 4.1 `options.lua`

| Setting | Value / effect |
|---|---|
| `mapleader` / `maplocalleader` | `" "` / `"\\"` (set before plugins load) |
| `termguicolors` | true |
| `laststatus` | 3 (one global statusline) |
| `showmode` | false (mode shown by lualine; Noice routes mode messages such as "recording @q" to notifications) |
| `clipboard` | `unnamedplus` (system clipboard) |
| `cursorline` / `cursorlineopt` | true / `number` (only the line number is highlighted) |
| Indent | `expandtab`, `shiftwidth=2`, `tabstop=2`, `softtabstop=2`, `smartindent` |
| `fillchars` | `eob=" "`; thick separators `vert=┃ horiz=━ horizup=┻ horizdown=┳ vertleft=┫ vertright=┣ verthoriz=╋` |
| Search | `ignorecase`, `smartcase` |
| `mouse` | `a` |
| Numbers | `number`, `relativenumber`, `numberwidth=2`, `ruler=false` |
| `shortmess` | `+sI` (no intro screen, no "search hit BOTTOM") |
| `signcolumn` | `yes` |
| Splits | `splitbelow`, `splitright`, `equalalways=false` (closing a window doesn't resize all others) |
| `timeoutlen` | 400 ms |
| `undofile` | true (persistent undo) |
| `updatetime` | 250 ms |
| `whichwrap` | `+<>[]hl` (h/l and arrows move across line ends) |
| `exrc` + `secure` | project-local config files allowed (Neovim asks to `:trust` them), unsafe commands blocked |
| Providers | node, python3, perl, ruby providers disabled |
| Filetypes | `*.circom` → `circom`, `*.http` → `http` |
| `wrap` | false |
| `pumheight` | 12 |
| `foldopen` | `hor` removed (moving left/right doesn't open folds) |
| Commented out | spelling (`spelllang`, `spell`), Mason bin PATH snippet (NvChad) |

Fold options are set by nvim-ufo's config (section 7.10): `foldcolumn=1`, `foldlevel=99`,
`foldlevelstart=99`, `foldenable`.

### 4.2 `lazy.lua`

- `defaults = { lazy = true, version = false }`: every plugin is lazy unless its spec says otherwise;
  plugins without a `version`/`branch` follow their default branch (latest commit).
- `checker = { enabled = true, notify = false }`: lazy checks for plugin updates in the background
  (hourly) without a notification; `:Lazy` shows available updates.
- `install.colorscheme = { "habamax" }` (only used while installing on a fresh machine).
- `rocks.hererocks = true` (lazy builds its own Lua 5.1 for luarocks plugins).
- `performance.rtp.disabled_plugins`: 2html_plugin, tohtml, getscript(+Plugin), gzip, logipat, netrw,
  netrwPlugin, netrwSettings, netrwFileHandlers, matchit, tar(+Plugin), rrhelper, spellfile_plugin,
  vimball(+Plugin), zip(+Plugin), tutor, rplugin, syntax, synmenu, optwin, compiler, bugreport, ftplugin.
  Observed effect: netrw and matchit are off; filetype detection/plugins/indent and `syntax on` still work.
- Bootstraps lazy.nvim from `stable` if missing.

### 4.3 `diagnostics-commands.lua`

- `vim.diagnostic.config`: `severity_sort`, virtual text with a Nerd Font prefix (U+F445), sign icons
  (Nerd Font: error U+F0159, warn U+F071, info U+F02FC, hint U+F0335), underline, float border `single`.
- Commands: `:DiagnosticsToggleVirtualText` (inline messages on/off), `:DiagnosticsToggle`
  (all diagnostics on/off).

### 4.4 `autocmds.lua` (augroup `AlexanderEditor`)

| Autocmd | What it does |
|---|---|
| `BufEnter` | removes `c`, `r`, `o` from `formatoptions` (comments don't continue on new lines) |
| `ColorScheme` (+ at load) | highlights: `WinSeparator` and `NeoTreeWinSeparator` fg `#6e738d` (visible grey); `LualineMessagePill`; `CmpItemKindCopilot` and `BlinkCmpKindCopilot` green `#6CC644` |
| `BufEnter` (only after `nvim <folder>`, runs once) | when the first real file is entered, deletes leftover hidden, unnamed, unmodified, empty, listed normal buffers (neo-tree's folder-takeover placeholder); waits past the folder's own buffer; removes itself afterwards |
| `vim.filetype.add` pattern `.*` (priority max) | **big-file protection**: a file over 1.5 MB, or with average line length over 1000 (minified), gets filetype `bigfile` |
| `FileType bigfile` | warning notification; `foldmethod=manual`, `conceallevel=0`; detaches nvim-ufo; disables indent-blankline for the buffer; sets `syntax` to the real filetype (plain Vim syntax colours only); pauses vim-illuminate. Treesitter, LSP and linters have nothing for `bigfile`, so they stay off |
| `LspAttach` | detaches any language server from `bigfile` buffers (servers that attach to all filetypes, e.g. typos_lsp) |
| `VimEnter` | if the first argument is a directory, `cd` into it |

### 4.5 `mappings.lua`

All mappings are listed in section 6. Commented-out mappings (kept intentionally) are listed in 6.8.

### 4.6 Autocmds defined elsewhere

| Group | Where | Purpose |
|---|---|---|
| `AlexanderLspAttach` | `diagnostics/lsp/lspconfig/init.lua` | per-buffer LSP mappings, code lens, semantic tokens off |
| `AlexanderTreesitter` | `nvim-treesitter/nvim-treesitter.lua` | starts Treesitter highlighting/indent per FileType |
| `AlexanderNeoTreeKeepLayout` | `neo-tree/keep-layout.lua` | `WinClosed`: handles closing the tree with `:q` |
| `AlexanderAvanteFileReference` | `ai/avante/avante.lua` | `gR` in Avante buffers |
| `FocusDisable` | `focus/focus.lua` (runs when the module is required at startup) | marks windows/buffers that focus.nvim must ignore |
| `lint` | `diagnostics/nvim-lint/init.lua` | runs linters on read/new/write/InsertLeave |

### 4.7 User commands defined by this config

`:DiagnosticsToggle`, `:DiagnosticsToggleVirtualText` (diagnostics-commands.lua),
`:MasonInstallAll` (install missing tools from the list), `:MasonReinstallAll` (force-reinstall the
list) (`diagnostics/lsp/mason/init.lua`). All other commands come from plugins.

---

## 5. Plugins

Version column: `branch=` / `version=` as set in the spec; "default" = default branch, latest commit
(lazy `defaults.version = false`). Rule: follow the plugin's own docs, else the owner's original
setting, else the default branch; exception: if docs say "use releases" but the last release is
stale while the main branch is actively fixed, follow main (applied to telescope,
telescope-frecency, lazydev). Exact installed commits: `lazy-lock.json`.

### 5.1 Enabled

| Plugin (repo) | Load | Version | Config | Role in this config |
|---|---|---|---|---|
| lazy.nvim (folke) | — | stable bootstrap | `configs/lazy.lua` | plugin manager |
| catppuccin (catppuccin/nvim) | start, priority 1000 | default | `colorschemes/init.lua` | macchiato theme, pinned integrations, dim inactive windows |
| lualine.nvim | start | default | `lualine/` | global statusline + per-window winbar |
| barbar.nvim (owner's fork) | start | local dir or `commit=a4965850…` | `barbar/` | buffer tabs (slanted), offset for neo-tree |
| nvim-treesitter | start | `branch=main` | `nvim-treesitter/` | parsers (all), highlighting, indent |
| auto-session | start | default | `auto-session/` | per-folder sessions |
| smart-splits.nvim (+ backend-tmux) | start (must not be lazy) | `^3.0.0` (backend: default) | `smart-splits/` | `Ctrl+h/j/k/l` / `Ctrl+Shift+h/j/k/l` across Neovim splits and tmux panes |
| alpha-nvim | VimEnter | default | `startup/` | start screen |
| mini.icons | dependency | `*` | `mini-icons/` | icon provider; mocks nvim-web-devicons |
| nvim-web-devicons | dependency | default | `nvim-web-devicons/` | declared dependency; replaced by mini.icons' mock |
| plenary.nvim | dependency | default | `plenary/` | Lua library for many plugins |
| nui.nvim | dependency | default | `nui/` | UI library (neo-tree, noice, avante) |
| nvim-notify | dependency of noice | default | `nvim-notify/` | notification popups |
| noice.nvim | VeryLazy | default | `noice/` | cmdline popup, messages, LSP docs rendering |
| which-key.nvim | VeryLazy + keys | default | `which-key/` | key hints |
| neo-tree.nvim | VeryLazy, `:Neotree`, keys (early for `nvim <dir>`) | `branch=v3.x` | `neo-tree/` | file tree sidebar |
| window-picker (s1n7ax/nvim-window-picker) | VeryLazy | `2.*` | `nvim-window-picker/` | pick a window (neo-tree `W`) |
| scope.nvim | VeryLazy | default | `scope/` | tab-local buffer lists |
| Comment.nvim | VeryLazy | default | `comments/` | `gcc`, `gbc`, `gco`/`gcO`/`gcA` |
| ts-comments.nvim | VeryLazy (Neovim ≥ 0.10) | default | `comments/` | correct comment strings per Treesitter language |
| nvim-surround | VeryLazy | `^4.0.0` | `nvim-surround/` | add/change/delete surrounding pairs |
| gitsigns.nvim | BufEnter + keys | default | `gitsigns/` | git signs, hunk actions, blame |
| nvim-ufo (+ promise-async) | BufEnter + keys | default | `nvim-ufo/` | folds from Treesitter/indent |
| vim-illuminate | BufEnter + keys | default | `illuminate/` | highlight/jump word references |
| indent-blankline.nvim (`main="ibl"`) | BufEnter | default | `indent-blankline/` | indent guides (defaults) |
| todo-comments.nvim | BufEnter + keys | default | `todo-comments/` | highlight/search TODO etc. |
| focus.nvim | WinEnter, `:FocusEnable/Toggle` | default | `focus/` | auto-resize; **globally disabled** (`vim.g.focus_disable = true`) |
| telescope.nvim | `:Telescope`, keys | `version=false` | `telescope/` | pickers |
| telescope-fzf-native.nvim | dependency (`build=make`) | default | `telescope/` | fast fuzzy sorter |
| telescope-ui-select.nvim | dependency | default | `telescope/` | `vim.ui.select` as Telescope dropdown |
| telescope-frecency.nvim | dependency | `version=false` | `telescope/` | `<leader>fr` frequency/recency file list |
| trouble.nvim | LspAttach, `:Trouble`, keys | default | `trouble/` | diagnostics/symbols/quickfix lists; statusline symbols |
| harpoon (`branch=harpoon2`) | keys | `harpoon2` | `harpoon/` | marked files list |
| oil.nvim | `:Oil`, `-` | default | `oil/` | edit directories as buffers (floating) |
| toggleterm.nvim | `:ToggleTerm`, `:TermSelect`, keys | `*` | `toggleterm/` | terminals |
| grug-far.nvim | `:GrugFar`, `:GrugFarWithin`, keys | default | `grug-far/` | project find & replace |
| nvim-treesitter-textobjects | keys | `branch=main` | `nvim-treesitter-textobjects/` | `af`/`if`… text objects, `]f`/`[f` |
| nvim-treesitter-context | BufReadPost/BufNewFile + key | default | `nvim-treesitter-context/` | pinned function/class header |
| blink.cmp | InsertEnter | `1.*` | `blink-cmp/` | completion engine |
| blink.compat | dependency | `2.*` | `blink-cmp/` | nvim-cmp source API for blink (Avante sources) |
| blink-copilot | used by blink's copilot source | default | `copilot/` | Copilot items in the blink menu |
| copilot.lua | InsertEnter, `:Copilot` | default | `copilot/` | Copilot client (its own suggestion/panel UIs off) |
| LuaSnip (+ friendly-snippets) | dependency of blink | `v2.*`, `build=make install_jsregexp` | `nvim-cmp/LuaSnip.lua` | snippets engine |
| lspkind.nvim | dependency of blink | default | `nvim-cmp/init.lua` | kind icons in the menu |
| nvim-autopairs | InsertEnter | default | `nvim-cmp/nvim-autopairs.lua` | auto-close brackets/quotes |
| lazydev.nvim | ft=lua | `version=false` | `lazydev/` | Neovim Lua API types + completion for config code |
| nvim-lspconfig | BufReadPre/BufNewFile | default | `diagnostics/lsp/lspconfig/` | server configs (`vim.lsp.config`) |
| mason.nvim | `:Mason*` commands | default | `diagnostics/lsp/mason/` | installs LSP servers/formatters/linters |
| mason-lspconfig.nvim | BufReadPre/BufNewFile | default | `diagnostics/lsp/mason-lspconfig/` | enables the approved installed servers |
| conform.nvim | `:ConformInfo`, `<leader>fm` | default | `diagnostics/conform/` | formatting (manual) |
| nvim-lint | BufReadPre/BufNewFile + key | default | `diagnostics/nvim-lint/` | linters |
| neogit (+ diffview.nvim) | `:Neogit`, key | default | `neogit/` | Magit-style git UI |
| lazygit.nvim | `:LazyGit*`, keys | default | `lazytools/` | LazyGit in a float; Telescope extension |
| kulala.nvim (dont-be-evil-company) | ft=http/rest, SessionLoadPost, keys | default | `kulala/` | HTTP client for `.http` files |
| vim-dadbod-ui (+ vim-dadbod, vim-dadbod-completion) | `:DBUI*`, key; completion on ft=sql/mysql/plsql | default | `vim-dadbod-ui/` | database UI + SQL completion |
| avante.nvim (+ mega.cmdparse, mega.logging) | commands, keys | `version=false`, `build=make` | `ai/avante/` | AI assistant sidebar |
| codecompanion.nvim | commands, keys | `^19.0.0` | `ai/codecompanion/` | AI chat/inline/CLI |
| render-markdown.nvim | ft=markdown/codecompanion/Avante | default | `ai/init.lua` | renders Markdown in those buffers |
| img-clip.nvim | dependency of avante | default | `ai/init.lua` | paste images into AI chats |
| image.nvim | conditional (terminal); BufReadPre of png/jpg/jpeg/gif/webp/avif; dependency of neo-tree | default | `image/init.lua` | images inside Neovim |
| fzf-lua | dependency of neogit only | default | (none, `TODO`) | installed, not configured, not used (Neogit uses Telescope) |
| mcphub.nvim | dependency of codecompanion | default | (none, `TODO`) | installed, not configured |
| nvim-dap | dependency of telescope | default | (none, `TODO`) | installed, no adapters/keys configured |

### 5.2 Disabled (kept configured)

| Plugin | How disabled | Why / replacement |
|---|---|---|
| nvim-cmp + cmp-buffer, cmp-cmdline, cmp-nvim-lsp, cmp-nvim-lua, cmp-path, cmp_luasnip | `cond = false` | replaced by blink.cmp; kept until the owner asks to remove them |
| copilot-cmp | `cond = false` | replaced by blink-copilot |
| nvim-dbee | `cond = false` | replaced by vim-dadbod-ui (its key `<leader>db` is now dadbod's) |
| colorful-winsep.nvim (`branch=main`) | `cond = false` | **TEMPORARY** dimming trial (catppuccin `dim_inactive` instead); do not remove |
| winshift.nvim | `cond = false` | unused; **not installed** (it was `enabled = false`; `cond = false` does not install a missing plugin either, it only keeps an installed one) |
| image.nvim | `cond = backend ~= nil` | only loads in a supported terminal (section 7.19) |

To re-enable a `cond = false` plugin, set `cond = true` (or remove the line).

### 5.3 Removed on the owner's request

CopilotChat.nvim, copilot-lsp, popup.nvim, bufferline.nvim, luafilesystem, mini.pick,
telescope-media-files. lazydocker.nvim was never active (its spec is commented out in
`lazytools/init.lua`).

---

## 6. Key mappings

Notation: `<leader>` = Space, `<localleader>` = `\`, `<A-x>`/`<M-x>` = Alt/Option+x, `<C-S-x>` =
Ctrl+Shift+x. Modes: n = Normal, x = Visual (all Visual modes, not Select), o = operator-pending,
i = Insert, s = Select (snippet placeholders), t = Terminal. Visual mappings deliberately use `x`, not
`v`, so they don't fire while typing in a snippet placeholder.

Built-in help for keys: `<leader>?` (buffer-local keys via which-key), `<leader>wK` (all keys),
`<leader>wk` (which-key for a typed prefix; Esc/empty does nothing). Keys marked "(lazy)" load their plugin on first press.

### 6.1 Leader mappings

**Buffers (Barbar)** — `barbar/barbar.lua`

| Key | Mode | Action |
|---|---|---|
| `<leader>x` | n | close current buffer (`BufferClose`) |
| `<leader>bp` | n | pin/unpin buffer |
| `<leader>ba` | n | close all buffers except current or pinned |
| `<leader>bv` | n | close all buffers except visible |
| `<leader>bb` / `bn` / `bd` / `bl` / `bw` | n | order buffers by number / name / directory / language / window number |

**Code / Trouble** — `trouble/trouble.lua`, `telescope/telescope.lua`

| Key | Mode | Action |
|---|---|---|
| `<leader>cs` | n | Trouble: document symbols (no focus) |
| `<leader>cl` | n | Trouble: LSP definitions/references… (right side) |
| `<leader>cm` | n | Telescope: git commits |
| `<leader>zx` | n | Trouble: all diagnostics |
| `<leader>zX` | n | Trouble: current buffer diagnostics |
| `<leader>zL` | n | Trouble: location list |
| `<leader>zQ` | n | Trouble: quickfix list |

**Diagnostics / database** — `configs/mappings.lua`, `vim-dadbod-ui/vim-dadbod-ui.lua`

| Key | Mode | Action |
|---|---|---|
| `<leader>dh` | n | diagnostic float for the current line |
| `<leader>ds` | n | diagnostics → location list |
| `<leader>dt` | n | toggle inline diagnostics (virtual text) |
| `<leader>db` | n | toggle database UI (`:DBUIToggle`) (lazy) |

**Files / search** — `telescope/telescope.lua` unless noted

| Key | Mode | Action |
|---|---|---|
| `<leader>ff` | n | find files |
| `<leader>fa` | n | find all files (hidden, ignored, follow symlinks) |
| `<leader>fw` | n | live grep |
| `<leader>fz` | n | fuzzy find in current buffer |
| `<leader>fb` | n | open buffers |
| `<leader>fo` | n | recent files (latest first) |
| `<leader>fr` | n | recent files by frecency (frequent + recent) |
| `<leader>fh` | n | help tags |
| `<leader>ma` | n | marks |
| `<leader>gt` | n | git status (changed files) |
| `<leader>ft` | n | TODO/FIX/… comments in project (`todo-comments/`) |
| `<leader>fp` | n | Harpoon files in Telescope (`harpoon/`) (lazy) |
| `<leader>fg` | n | Telescope LazyGit repos (`lazytools/lazygit.lua`) (lazy) |
| `<leader>fm` | n | format file with Conform (`diagnostics/conform/init.lua`) (lazy) |
| `<leader>fs` | n | grug-far: find & replace in project, prefilled with word under cursor (lazy) |
| `<leader>fs` | x | grug-far with the selection (lazy) |
| `<leader>fS` | n | grug-far limited to the current file; refuses non-file buffers; spaces in the path are escaped (lazy) |
| `<leader>e` | n | focus neo-tree (`neo-tree/neo-tree.lua`) |

**Git hunks (gitsigns)** — `gitsigns/gitsigns.lua`

| Key | Mode | Action |
|---|---|---|
| `<leader>gs` | n / x | stage hunk / stage selected lines |
| `<leader>gr` | n / x | reset hunk / reset selected lines |
| `<leader>gS` | n | stage buffer |
| `<leader>gu` | n | undo stage hunk |
| `<leader>gR` | n | reset buffer |
| `<leader>gp` | n | preview hunk |
| `<leader>gb` | n | blame line (full) |
| `<leader>gd` | n | diff against index |
| `<leader>gD` | n | diff against the commit before HEAD (`~`) |
| `<leader>tb` | n | toggle current-line blame |
| `<leader>td` | n | toggle showing deleted lines |
| `<leader>ng` | n | Neogit (`neogit/`) (lazy) |
| `<leader>lg` | n | LazyGit float (`lazytools/lazygit.lua`) (lazy) |

**AI: Avante (`<leader>ia…`)** — `ai/avante/avante.lua` (all lazy)

| Key | Mode | Action |
|---|---|---|
| `<leader>iaa` | n / x | ask / ask about selection |
| `<leader>iae` | x | edit selection |
| `<leader>iac` | n | chat |
| `<leader>ian` | n, x | new ask (fresh question, current file/selection) |
| `<leader>iaN` | n | new chat |
| `<leader>iat` | n | toggle sidebar |
| `<leader>iaf` | n | focus sidebar |
| `<leader>iar` | n | refresh |
| `<leader>ias` | n | stop request |
| `<leader>iah` | n | history |
| `<leader>iam` | n | models |
| `<leader>iaM` | n | ACP models |
| `<leader>iao` | n | ACP mode |
| `<leader>iap` | n | switch provider |
| `<leader>iaR` | n | repo map |
| `<leader>iaz` | n | zen mode |
| `<leader>iad` | n | toggle debug |
| `<leader>iaC` | n | toggle selection |
| `<leader>iaS` | n | toggle suggestion |
| `<leader>iaB` | n | add all open buffers |
| `<leader>iaF` | n | add the current buffer to the open Avante sidebar's files, or remove it if it is already there (Avante's toggle; warns when the sidebar is closed) |

**AI: CodeCompanion (`<leader>ic…`)** — `ai/codecompanion/codecompanion.lua` (all lazy)

| Key | Mode | Action |
|---|---|---|
| `<leader>ica` | n, x | actions palette |
| `<leader>icc` | n, x | toggle chat |
| `<leader>icg` | x | add selection to chat |
| `<leader>icx` | n, x | toggle CLI (Codex in a terminal) |
| `<leader>icp` | n, x | prompt the CLI |
| `<leader>ics` | n, x | send current context (`#{this}`) to the CLI |
| `<leader>icd` | n | send diagnostics to the CLI and submit "Can you fix these?" |

**Harpoon (`<leader>j…`)** — `harpoon/harpoon.lua` (lazy): `<leader>ja` add file, `<leader>jj` quick menu.

**Lines / numbers / LSP / lint** — `configs/mappings.lua` unless noted

| Key | Mode | Action |
|---|---|---|
| `<leader>ln` | n | toggle line numbers |
| `<leader>lr` | n | toggle relative numbers |
| `<leader>ll` | n | run linters now (`diagnostics/nvim-lint/init.lua`) |
| `<leader>lc` | n | toggle code lens (buffer-local, only when the server supports code lens) |
| `<leader>o` / `<leader>O` | n | new empty line below / above without entering Insert mode |

**Splits** — `configs/mappings.lua`

| Key | Mode | Action |
|---|---|---|
| `<leader>ss` | n | vertical split of the current window |
| `<leader>sd` | n | horizontal split of the current window |
| `<leader>sS` | n | full-height split on the far right (`botright vsplit`) |
| `<leader>sD` | n | full-width split at the bottom (`botright split`) |
| `<leader>sh` | n | LSP signature help (buffer-local, LSP buffers) |

**Toggles / terminals / which-key**

| Key | Mode | Action | Defined in |
|---|---|---|---|
| `<leader>tc` | n | set max lines of pinned context (prompt; 0 = no limit) | `nvim-treesitter-context/…lua` |
| `<leader>pt` | n | select a terminal (`:TermSelect`) (lazy) | `toggleterm/toggleterm.lua` |
| `<leader>wK` | n | which-key: all keymaps | `which-key/which-key.lua` |
| `<leader>wk` | n | which-key: prompt for a prefix (Esc or empty input: nothing) | `which-key/which-key.lua` |
| `<leader>?` | n | which-key: buffer-local keymaps | `which-key/which-key.lua` |
| `<leader>wa` / `wr` / `wl` | n | LSP workspace folder add / remove / list (buffer-local) | `lspconfig/init.lua` |

**HTTP (Kulala, `<leader>R…`)** — `kulala/kulala.lua` + Kulala defaults (prefix `<leader>R`)

| Key | Mode | Scope | Action |
|---|---|---|---|
| `<leader>Rs` | n, x | global (config) | send request under cursor |
| `<leader>Ra` | n, x | global (config) | send all requests |
| `<leader>Rb` | n | global (default) | open scratchpad |
| `<leader>Ro` | n | global (default) | open Kulala |
| `<leader>Rr` | n | global (default) | replay last request |
| `<leader>Rq` | n | http/rest buffers | close Kulala window |
| `<leader>Rc` / `RC` | n | http/rest | copy as cURL / paste from cURL |
| `<leader>Ri` | n | http/rest | inspect current request |
| `<leader>Rj` | n | http/rest | cookies jar |
| `<leader>Re` | n | http/rest | select environment |
| `<leader>Ru` | n | http/rest | manage auth config |
| `<leader>Rg` | n | http/rest | download GraphQL schema |
| `<leader>Rn` / `Rp` | n | http/rest | next / previous request |
| `<leader>Rf` | n | http/rest | find request |
| `<leader>Rt` | n | http/rest | toggle headers/body |
| `<leader>RS` | n | http/rest | show stats |
| `<leader>Rx` / `RX` | n | http/rest | clear globals / clear cached files |
| `<CR>` | n, x | http/rest | send request under cursor |

Before Kulala has loaded only `<leader>Rs`, `<leader>Ra`, `<leader>Rb` exist as loading stubs.

### 6.2 Non-leader mappings (normal / visual / terminal)

| Key | Mode | Action | Defined in |
|---|---|---|---|
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | n, x | move to the split left / down / up / right; at Neovim's edge continue into the tmux pane there (smart-splits; at the far edge wrap around) | `smart-splits/smart-splits.lua` |
| `<C-S-h>` `<C-S-j>` `<C-S-k>` `<C-S-l>` | n | move the split border left / down / up / right by 1 (count multiplies); resizes tmux panes too | `smart-splits/smart-splits.lua` |
| `<A-j>` / `<A-k>` | n, x | move line / selection down / up (re-indents) | `configs/mappings.lua` |
| `<` / `>` | x | indent left / right and keep the selection | `configs/mappings.lua` |
| `<Esc>` | n | clear search highlight | `configs/mappings.lua` |
| `<C-x>` | t | leave terminal mode | `configs/mappings.lua` |
| `H` / `L` | n | previous / next buffer tab (replaces built-in screen top/bottom) | `barbar/barbar.lua` |
| `<A-,>` / `<A-.>` | n | move buffer tab left / right | `barbar/barbar.lua` |
| `<A-0>` | n | go to last buffer tab | `barbar/barbar.lua` |
| `<A-S-p>` | n | buffer pick mode (press the letter shown on a tab) | `barbar/barbar.lua` |
| `<A-n>` / `<A-p>` | n | next / previous occurrence of the word under the cursor | `illuminate/vim-illuminate.lua` |
| `<A-i>` | x, o | (vim-illuminate default) select the highlighted reference as a text object | plugin default |
| `<C-S-P>` / `<C-S-N>` | n | Harpoon previous / next file (lazy) | `harpoon/harpoon.lua` |
| `<C-n>` | n | toggle neo-tree | `neo-tree/neo-tree.lua` |
| `-` | n | Oil in a float (parent directory) (lazy) | `oil/oil.lua` |
| `]c` / `[c` | n | next / previous git hunk (in diff mode: built-in `]c`/`[c`) | `gitsigns/gitsigns.lua` |
| `ih` | o, x | select git hunk | `gitsigns/gitsigns.lua` |
| `]t` / `[t` | n | next / previous TODO comment | `todo-comments/todo-comments.lua` |
| `]f` / `[f` | n, x, o | next / previous function start (adds to jumplist) | `nvim-treesitter-textobjects/…lua` |
| `]F` / `[F` | n, x, o | next / previous function end | same |
| `af` / `if` | x, o | a function (whole lines) / inside function | same |
| `ac` / `ic` | x, o | a class (whole lines) / inside class | same |
| `aa` / `ia` | x, o | an argument (with comma) / inside argument | same |
| `al` / `il` | x, o | a loop / inside loop | same |
| `zR` / `zM` | n | open / close all folds (ufo) | `nvim-ufo/nvim-ufo.lua` |
| `<A-v>` | n, t | terminal 1, vertical (41% width) | `toggleterm/toggleterm.lua` |
| `<A-h>` | n, t | terminal 1, horizontal (15 lines) | same |
| `<A-i>` | n, t | terminal 1, floating (curved border) | same |
| `<A-t>` | n, t | terminal 1, in a tab | same |
| `<A-1>` / `<A-2>` | n, t | terminal 2 / 3 in a tab, hiding other open terminals | same |

Text objects combine with operators: `vaf` select function, `dif` delete body, `cia` change argument,
`yac` copy class. Select uses lookahead (works when the cursor is before the object on the line).

### 6.3 LSP buffer-local mappings (set on `LspAttach`, `diagnostics/lsp/lspconfig/init.lua`)

| Key | Action |
|---|---|
| `gd` | go to definition |
| `gD` | go to declaration |
| `gh` | hover (rendered by Noice) |
| `<leader>sh` | signature help |
| `<leader>wa` / `<leader>wr` / `<leader>wl` | workspace folders add / remove / list |
| `<leader>lc` | toggle code lens (only if the server supports it; code lens is enabled automatically then) |

### 6.4 Neovim 0.12 built-ins this config relies on

| Key | Mode | Action |
|---|---|---|
| `grr` | n | references |
| `grn` | n | rename |
| `gra` | n, x | code action |
| `gri` | n | implementation |
| `grt` | n | type definition |
| `grx` | n | run code lens on the current line |
| `gO` | n | document symbols |
| `K` | n | hover (buffer-local when LSP attached) |
| `<C-]>` | n | definition via `tagfunc` (1 s timeout; first lookup in a session can fail with E433, retry works) |
| `<C-s>` | i, s | signature help |
| `]d` / `[d`, `]D` / `[D` | n | next / previous / last / first diagnostic |
| `<C-w>d` | n | diagnostic float |
| `gc` / `gcc` | n, x, o | comment toggle (also Comment.nvim) |
| `an` / `in`, `]n` / `[n`, `]N` / `[N` | x, o | Treesitter node selection: parent / child, next / previous node, sibling |
| `]q` `[q` `]b` `[b` `]l` `[l` `]a` `[a` `]t`… | n | quickfix / buffer / loclist / arglist navigation (`]t`/`[t` are overridden by todo-comments) |
| `[<Space>` / `]<Space>` | n | add empty line above / below |
| `gx` | n, x | open path/URL with the system handler |
| `<Tab>` / `<S-Tab>` | i, s | `vim.snippet` jump (blink/LuaSnip mappings take over in Insert mode once blink loads) |
| `Y` | n | `y$` |

Overridden built-ins: `H`/`L` (Barbar), `<C-n>` (neo-tree), `]t`/`[t` (todo-comments), `]c`/`[c`
(gitsigns outside diff mode), `-` (Oil), `zR`/`zM` (ufo versions), `<Esc>` in Normal (adds `:noh`).

### 6.5 Plugin default keys that are active

- **Completion (blink.cmp, Insert mode; preset `none`, only these):** `<Tab>` accept selected/first item
  when the menu is open, else expand/jump LuaSnip snippet, else normal Tab (also works in Select mode
  inside placeholders); `<S-Tab>` jump back in a snippet; `<C-n>`/`<C-p>` next/previous item;
  `<C-Space>` open menu; `<C-e>` close; `<C-f>`/`<C-d>` scroll documentation down/up.
- **nvim-surround:** `ys{motion}{char}` add (`ysiw"`), `yss` line, `yS`/`ySS` on new lines, `ds{char}`
  delete, `cs{old}{new}` change, `cS` change onto new lines, Visual `S{char}` / `gS`, Insert `<C-g>s` /
  `<C-g>S`.
- **Comment.nvim:** `gcc` line, `gc{motion}`, `gbc` block, `gb{motion}`, `gco` / `gcO` / `gcA` comment
  below / above / end of line; Visual `gc` / `gb`.
- **Telescope (inside pickers):** `<C-t>` send results to Trouble (Insert and Normal), `q` close
  (Normal); other Telescope defaults unchanged.
- **neo-tree window:** `w` and `l` disabled (noop), `W` open with window picker, `L` focus preview;
  other neo-tree defaults (`?` shows them).
- **Oil:** plugin defaults (`g?` help, `<CR>` open, `-` parent, `_` cwd, …).
- **grug-far panel (`<localleader>` = `\`):** `\r` replace, `\s` sync all edits back, `\l` sync line,
  `\q` results → quickfix, `\c` close, `\t` history, `\a` add to history, `\f` refresh, `\o` open
  location, `\i` preview, `\b` abort, `\w` show command, `\e` swap engine, `\x` swap replacement
  interpreter, `\j`/`\k` apply next/prev, `\n`/`\p` sync next/prev, `\v` sync file, `<Enter>` go to
  location, `<Up>`/`<Down>` open prev/next location, `<Tab>`/`<S-Tab>` next/prev input, `g?` help.
- **Kulala response window:** `<C-h>`/`<C-l>` previous/next tab (override window movement there),
  `H` headers, `B` body, `A` all, `V` verbose, `O` script output, `S` stats, `R` report, `F` filter,
  `]`/`[` next/previous response, `<CR>` jump to response, `X` clear history, `<S-CR>` send WebSocket
  message, `<C-c>` interrupt, `?` help, `g?` news, `|` toggle split/float, `q` close.
- **vim-dadbod-ui drawer:** `o`/`<CR>`/double-click open, `S` open in vertical split, `A` add
  connection, `d` delete, `r` rename, `R` redraw, `H` toggle details, `J`/`K` next/previous sibling,
  `<C-j>`/`<C-k>` last/first sibling, `<C-n>`/`<C-p>` child/parent node, `q` quit (these override
  window movement, neo-tree toggle and hover inside the drawer).
  **Query buffer:** `<leader>S` run query (Normal) or selection (Visual), `<leader>W` save query,
  `<leader>E` edit bind parameters. **Results buffer:** `<C-]>` jump to foreign key, `vic` yank cell,
  `yh` yank header, `<leader>R` toggle result layout.
- **SQL files (Vim's sql ftplugin):** `]]`/`[[`, `][`/`[]`, `]}`/`[{`, `]"`/`["` SQL block/comment
  motions; Insert `<C-c>{t,c,…}` omni-completion helpers, `<Left>`/`<Right>` drill out of / into tables
  in the omni menu.
- **Neogit:** popup key `l` disabled, `<leader>l` opens the log popup; other Neogit defaults.
- **Avante buffers:** `gR` opens the file reference under the cursor in a normal code window
  (`ai/avante/file_reference.lua`); other Avante sidebar keys are Avante defaults.
- **Start screen (alpha):** `e` new file, `f` find file, `r` recent (frecency), `o` recent (latest),
  `g` live grep, `s` restore session, `t` file tree, `n` Neogit, `l` LazyGit, `c` find in Neovim config,
  `L` Lazy, `m` Mason, `h` checkhealth, `q` quit.

### 6.6 Keys only defined for disabled plugins (inactive)

- nvim-dbee: `<leader>db` → `:Dbee` (`nvim-dbee/nvim-dbee.lua`).
- winshift: `<C-w><C-m>`, `<C-w>m` (WinShift), `<C-w>X` (swap) (`winshift/winshift.lua`).
- lazydocker: `<leader>ld` (`lazytools/lazydocker.lua`, spec commented out).
- nvim-cmp's own mapping table (same keys as blink) in `nvim-cmp/nvim-cmp.lua`.

### 6.7 Overlaps worth knowing

- `<A-i>`: Normal/Terminal = floating terminal; Visual/operator-pending = illuminate text object.
- `<C-h>`/`<C-l>` (Kulala UI), `<C-j>`/`<C-k>`/`<C-n>`/`<C-p>`/`K` (dadbod drawer) are buffer-local
  overrides of the global keys.
- `<leader>R` is Kulala's prefix globally; in dadbod results buffers `<leader>R` toggles the layout.
- `<A-p>` was Barbar pin; now illuminate's previous reference (pin is `<leader>bp`).
- `<CR>` in `.http` files sends the request.

### 6.8 Commented-out / disabled mappings (kept on purpose)

| Mapping | File | Reason |
|---|---|---|
| Insert `<C-b>`, `<C-e>` (line start/end) | `configs/mappings.lua` | commented out (no reason noted in the file) |
| Insert `<C-h/j/k/l>` cursor moves | same | restores built-in `<C-h>` backspace, `<C-j>` new line, `<C-k>` digraphs |
| Visual `<A-j>`/`<A-k>` with mode `v` | same | duplicates the `x` versions |
| Visual `p` → `"_dP` | same | built-in Visual `P` pastes without overwriting the register |
| Visual `J`/`K` move selection | same | restores built-in join lines / keyword lookup |
| `gi`, `gr`, `<leader>rn`, `<leader>ca`, `<leader>D` LSP keys | `lspconfig/init.lua` | replaced by built-ins `gri`, `grr`, `grn`, `gra`, `grt` (also restores built-in `gi`) |
| `<C-]>` → `vim.lsp.buf.definition` | `lspconfig/init.lua` | owner keeps the built-in `<C-]>` |
| Barbar `<A-2>`…`<A-9>` BufferGoto | `barbar/barbar.lua` | unused (`<A-1>`/`<A-2>` are terminals) |
| `<C-h/j/k/l>` → `<C-w>h/j/k/l`, `<C-S-h/j/k/l>` → `:vertical resize ±1` / `:resize ±1` | `configs/mappings.lua` | moved to smart-splits (same keys, also work with tmux panes) |

---

## 7. Features in detail

### 7.1 Completion (blink.cmp) — `blink-cmp/blink-cmp.lua`

- Sources (default): `copilot` (blink-copilot, async), `lsp`, `snippets` (LuaSnip), `buffer`, `path`.
  Per filetype: `lua` adds `lazydev` (score +100); `sql`/`mysql`/`plsql` use `snippets`, `dadbod`,
  `buffer`; `AvanteInput` uses `avante_commands`, `avante_mentions`, `avante_shortcuts`;
  `AvantePromptInput` uses `avante_prompt_mentions` (all through blink.compat).
- `lsp.fallbacks = {}`: buffer words show together with LSP items (like the old nvim-cmp).
- Sorting: exact, score, kind (snippets first, plain text last), sort_text, shorter label first.
  Fuzzy matcher: Rust (blink 1.x prebuilt binary).
- Menu: rounded border, columns kind icon (lspkind; Copilot kind = U+F113), label + description, source
  icon (copilot U+F113, lsp U+EB50, snippets U+F0A6B, buffer U+F0094, path U+F024B). No scrollbar.
- Documentation auto-shows immediately (rounded border); ghost text on; auto brackets after accepting
  functions; first item preselected and auto-inserted while selecting.
- Command-line completion and blink's signature help are off. `opts_extend = { "sources.default" }` lets
  other specs append default sources.
- LSP capabilities for every server come from `blink.cmp.get_lsp_capabilities()`.

### 7.2 Snippets — `nvim-cmp/LuaSnip.lua`

LuaSnip `v2.*` with jsregexp; `history = true` (snippets stay active after leaving Insert, Tab/S-Tab
resume), updates on TextChanged/TextChangedI. Loads VSCode (friendly-snippets), snipmate and Lua
snippets lazily, plus custom paths if `vim.g.vscode_snippets_path` / `snipmate_snippets_path` /
`lua_snippets_path` are set.

### 7.3 Copilot — `copilot/`

copilot.lua starts on InsertEnter; its own inline suggestion and panel are disabled; suggestions appear
only as blink menu items (blink-copilot). Login: `:Copilot auth`. Next-edit suggestions are not set up
(copilot-lsp removed; sidekick.nvim is the noted future option).

### 7.4 LSP — `diagnostics/lsp/`

- Activation: mason-lspconfig `automatic_enable` = the approved list in `mason/settings.lua`
  `M.servers`: `lua_ls`, `solidity_ls_nomicfoundation`, `rust_analyzer`, `pyright`, `denols`, `eslint`,
  `ts_ls`, `typos_lsp`, `dockerls`, `tombi`. Installing another server through Mason does not enable it;
  add it to `M.servers`. `M.disabled_servers` in `lspconfig/init.lua` can switch one off.
- Per-server overrides (`lsp/lspconfig/<server>.lua`, applied with `vim.lsp.config`):
  - `lua_ls`: global `vim`, `workspace.checkThirdParty = false` (lazydev provides libraries).
  - `rust_analyzer`: proc macros on, check command `clippy`.
  - `typos_lsp`: root markers `typos.toml`, `_typos.toml`, `.typos.toml`, `pyproject.toml`,
    `Cargo.toml`, `.git`.
  - `denols`: upstream root detection, but skipped when a deeper Node project (lockfile) owns the file,
    so Deno and Node projects don't both attach.
  - `circom-lsp`: custom server, opt-in via `M.enable_circom = false` in `mason/settings.lua`.
- On attach: semantic tokens disabled (Treesitter colours win), buffer mappings (6.3), code lens enabled
  when supported, capabilities with `positionEncodings = { "utf-16" }`.
- Mason tool list (`M.ensure_installed`, installed with `:MasonInstallAll`): stylua,
  lua-language-server, solhint, nomicfoundation-solidity-language-server, rust-analyzer, pyright,
  flake8, black, deno, prettier, eslint-lsp, typescript-language-server, kulala-fmt, typos-lsp,
  dockerfile-language-server, hadolint, circom-lsp, tombi. Mason UI: custom icons, 10 parallel installs.
- lazydev (Lua files): Neovim/plugin types, `vim.uv` types via luv, go-to-definition into the config's own
  modules (requires lazydev's main branch).
- Observed on a Lua file: clients `lua_ls` and `typos_lsp` attach.

### 7.5 Formatting — `diagnostics/conform/`

Manual only (`<leader>fm`; no format on save). `stop_after_first`, LSP fallback when no formatter.
By filetype: lua → stylua; css/html/javascript/typescript/javascriptreact/typescriptreact/json/jsonc →
prettier; python → black; rust → rustfmt; http → kulala-fmt; toml → tombi. `formatters/prettier.lua`
sets explicit Prettier parsers per filetype/extension. `:ConformInfo` shows status.

### 7.6 Linting — `diagnostics/nvim-lint/init.lua`

Runs on BufReadPost, BufNewFile, BufWritePost, InsertLeave (only normal, modifiable buffers):
solidity → solhint, dockerfile → hadolint, python → flake8 (eslint lines commented). `<leader>ll` runs
now. Rust linting comes from rust-analyzer's clippy check.

### 7.7 Diagnostics display

See 4.3. Toggles: `<leader>dt` (inline text), `:DiagnosticsToggle` (everything). Lists: `<leader>ds`
(loclist), Trouble `<leader>zx`/`zX`. Float: `<leader>dh` or `<C-w>d`.

### 7.8 Treesitter — `nvim-treesitter/`

Main branch (rewrite; no `ensure_installed`/module toggles). Build hook installs and updates **all**
parsers. On interactive starts it also builds any missing parsers in the background, until one run
succeeds; then a stamp file `stdpath("state")/treesitter-install-all.done` (delete it to retry). A FileType
autocmd starts Treesitter highlighting for normal buffers (and for `Avante`, `codecompanion`,
`kulala_ui`, which are registered as Markdown) **only when the language has a `highlights` query**;
otherwise Vim's regex syntax stays on (e.g. tmux, prolog, muttrc, zathurarc, robots, norg: support
dropped by nvim-treesitter main, but old parsers remain in `lazy/nvim-treesitter/parser/`). It sets the
Treesitter `indentexpr` when an indents query exists. `jsonc` uses the `json` parser (mapping provided
by nvim-treesitter). The old master-branch parser folder `lazy/nvim-treesitter/parser/` is kept because
Kulala's `kulala_http` parser lives only there. Parsers live in `stdpath("data")/site/parser` (321 installed on 2026-10-12).

### 7.9 Text objects and pinned context

- nvim-treesitter-textobjects (main branch): keys in 6.2; function/class selections are linewise;
  jumps are added to the jumplist (`<C-o>` returns).
- nvim-treesitter-context: max 3 lines, `trim_scope = "outer"` (keeps the innermost); `<leader>tc`
  changes the limit live.

### 7.10 Folding — `nvim-ufo/`

Provider Treesitter, then indent; none for `bigfile`. Fold column 1, everything open by default
(`foldlevel = 99`). `zR`/`zM` use ufo; other `z` fold keys are built-in.

### 7.11 Search and replace

- grug-far (ripgrep): `<leader>fs` / `<leader>fS` (6.1, panel keys 6.5). `/` and `:s` unchanged.
- Telescope live grep `<leader>fw`, buffer search `<leader>fz`.

### 7.12 Files and navigation

- **neo-tree** (`v3.x`): follows the current file (`follow_current_file`, folders collapse when
  leaving), libuv file watcher, `W` window picker, `L` preview. Opens immediately for `nvim <folder>`
  (takes over the folder buffer). Barbar offsets its tabs above the tree ("File Explorer").
- **keep-layout** (`neo-tree/keep-layout.lua`): when the left/right sidebar opens, all scalable windows
  shrink by the same factor; on close the exact previous widths come back, or, if windows were resized
  while the tree was open, the current proportions are scaled up. On close only the windows in the
  tree's own row get its space (a full-width split below is left alone). Floating windows,
  `winfixwidth` windows (e.g. AI sidebars) and neo-tree are not scaled; heights are never changed;
  closing with `:q` is handled via `WinClosed`.
- **Oil** (`-`): float with rounded border, padding 2, max 80% width/height, title = current directory;
  not the default file explorer.
- **Harpoon 2**: `<leader>ja` add, `<leader>jj` menu, `<leader>fp` Telescope list, `<C-S-P>`/`<C-S-N>`
  previous/next. Data in `stdpath("data")/harpoon`.
- **Telescope**: flex layout (horizontal when ≥ 160 columns, else vertical with preview below,
  mirrored), prompt on top, 87% × 80%; fzf sorter (smart case); frecency; ui-select dropdown is used
  for every `vim.ui.select` (Noice leaves it alone).
- **window-picker**: ignores neo-tree, notify, terminal and quickfix windows; auto-selects when only one
  candidate.

### 7.13 Buffers, tabs and windows

- **Barbar** (owner's fork with `filename_depth` option; `filename_depth = 1`): slanted preset,
  diagnostics icons for all severities, custom close-button icon (U+F467), `barbar_auto_setup = false`. Uses the local
  checkout `~/projects/lua/barbar.nvim` (branch `configurable-filename-depth`) when it exists;
  otherwise the GitHub fork at commit `a49658503cceab4c45ac9f37c695de0554df4162`.
- **scope.nvim**: each tab page has its own buffer list (Barbar shows the current tab's buffers).
- **Separators**: thick `┃━` lines in grey `#6e738d` between all windows, including next to neo-tree.
- **Dimming trial (TEMPORARY)**: catppuccin `dim_inactive = { enabled = true, shade = "dark",
  percentage = 0.10 }` while colorful-winsep is `cond = false`. The owner said: keep for now, do not
  remove winsep.
- **focus.nvim**: loaded but auto-resizing is globally disabled (`vim.g.focus_disable = true`);
  `:FocusToggle` / `:FocusEnable` turns it on. When on, it ignores neo-tree, toggleterm and
  nofile/prompt/popup/terminal buffers.
- Splits: `splitright`, `splitbelow`, `equalalways = false`; keys in 6.1/6.2.
- **smart-splits** (`smart-splits/`): moves/resizes across Neovim splits and tmux panes. Inside tmux the
  backend sets the tmux pane option `@pane-is-vim`; `~/.tmux.conf` passes `C-h/j/k/l` and `C-S-H/J/K/L` to
  Neovim when it is set, otherwise moves/resizes tmux panes. Resize step 1, `at_edge = "wrap"`, no warning
  outside tmux (`warn_if_unusable = false`). Must not be lazy-loaded.

### 7.14 Terminals — `toggleterm/`

Terminal 1 can be vertical (41% of columns), horizontal (15 lines), floating (curved border, 61% wide
or 81% on narrow screens, 61% tall) or a tab; terminals 2 and 3 open in tabs and hide other open
terminals (`toggle_exclusive`). `<C-x>` leaves terminal mode. `<leader>pt` picks a terminal. Line
numbers are shown in terminals (`hide_numbers = false`).

### 7.15 Git

gitsigns (signs, hunks, blame, `ih`), Neogit (Telescope + diffview integrations, fzf-lua/mini.pick
integrations off), diffview (via Neogit), LazyGit (`<leader>lg`, Telescope extension `<leader>fg`),
Telescope `<leader>gt` status / `<leader>cm` commits.

### 7.16 AI

- **Avante** (`version = false`, built with `make` — needs Rust/Cargo): provider `codex` through ACP
  (`codex-acp -c web_search="live"`, auth `chat-gpt`, `NODE_NO_WARNINGS=1`), agentic mode, sidebar on
  the right (width 35, wrap, ask window doesn't start in Insert), Telescope file selector and selector.
  Behaviour: automatic keymaps off (all keys defined in `avante.lua`), no auto suggestions, no auto-apply,
  minimal diffs, current file auto-added, tool permissions not auto-approved, inline confirmation buttons,
  follows agent locations. Second ACP provider `claude-code` (`claude-agent-acp`, Claude Pro via the `claude` CLI
  login; switch with `<leader>iap`). History in `stdpath("data")/avante`. Commented templates for local servers
  (`local-openai`, `local-anthropic`: oMLX :8000, llama.cpp :8080, LM Studio :1234) are in `avante.lua`. `gR` opens file references (shared helper `file_reference.lua`, also used by CodeCompanion's
  "go to file": finds the path in `[](…)`, `<…>`, backticks, quotes or words; resolves relative to cwd,
  project roots and open files; opens in an existing normal code window or a vertical split).
- **CodeCompanion** (`^19.0.0`): chat uses the ACP adapter `claude_code` (`claude-agent-acp`, Claude Pro via the
  `claude` CLI login; `ga` in a chat switches to `codex`); inline/cmd/background have no adapter set, so
  CodeCompanion falls back to its default GitHub Copilot (they need a plain HTTP API, which the subscriptions don't
  include; ACP agents only work in the chat); ACP adapter `codex` (`codex-acp`, chat-gpt auth); CLI agents `codex`
  (default, `codex --no-alt-screen --search`) and `claude_code` (`claude`; `:CodeCompanionCLI agent=claude_code`).
  Log level ERROR. Commented templates for local servers (`local_openai` via `openai_compatible`, `local_anthropic`
  via `anthropic`; oMLX :8000, llama.cpp :8080, LM Studio :1234) are in `codecompanion.lua`. mcphub is a dependency awaiting configuration (`TODO`).
- **render-markdown**: Markdown rendering in `markdown`, `codecompanion`, `Avante` buffers.
- **img-clip**: image paste into CodeCompanion (Markdown link, absolute path, no name prompt) and Avante
  (drag & drop in Insert mode, absolute path).

### 7.17 Sessions — `auto-session/`

`sessionoptions = buffers,curdir,help,tabpages,winsize,winpos` (no terminals, blank windows, folds or
per-window options). One session per working folder in `stdpath("data")/sessions`. Auto-save on quit,
auto-restore on start when Neovim is started without file arguments (`nvim` or `nvim <folder>`); with
file arguments nothing is restored or saved. Not used in `~`, `~/Downloads`, `/`. Not saved when only the
start screen (alpha) is open. Before saving, non-file windows (tree, terminals, AI panels) are closed.
If part of a restore fails, the rest continues; a real failure turns auto-save off for that run.
Commands: `:AutoSession save | restore | delete | search | disable`. Start screen `s` restores.

### 7.18 Database — `vim-dadbod-ui/`

`<leader>db` toggles the drawer; connections and saved queries in `stdpath("data")/db_ui`
(`connections.json` contains credentials; never print or commit it). Uses the database command-line
clients (`psql`, `mysql`, …). SQL completion (tables/columns) appears in the blink menu in
sql/mysql/plsql buffers. Keys in 6.5. nvim-dbee is disabled; its old data in `stdpath("data")/dbee` is
untouched.

### 7.19 Images — `image/init.lua`

Backend from the terminal: `kitty` protocol for kitty, Ghostty, WezTerm; `sixel` for iTerm2
(`TERM_PROGRAM=iTerm.app`, or `LC_TERMINAL=iTerm2` inside tmux) and Windows Terminal (`WT_SESSION`, incl. WSL); any other terminal → plugin
not loaded. Processor `magick_cli` (ImageMagick `magick` command). Loads when an image file is opened
(so `nvim picture.png` works) or with neo-tree. Used for opening image files and
neo-tree previews. Inside tmux (where `TERM_PROGRAM` is `tmux`) iTerm2 is recognised by `LC_TERMINAL`,
and Sixel images are sent to tmux unwrapped so **tmux draws them itself** (tmux 3.4+ built with Sixel; the
config replaces image.nvim's tmux passthrough wrapper `require("image/utils/tmux").escape` for the sixel
backend). `~/.tmux.conf` has `terminal-features …:sixel` and `allow-passthrough on`. Picture buffers
are read-only (`i` shows E21). Known limitation inside tmux (accepted by the owner): tmux drops a
picture when Neovim rewrites any cell in its area (popup closing, buffer switch, opening it after another
file) and image.nvim does not notice, so it stays gone until Neovim restarts. Yazi previews work in tmux.

### 7.20 HTTP client (Kulala) — `kulala/`

`.http`/`.rest` files (filetype `http`), also loads on SessionLoadPost. Send keys are Visual-only
(`x`), not Select. Backend Kulala Core (1.3.1 installed in `stdpath("data")/kulala.nvim/bin`) needs a
license token stored outside the repo in `~/Library/Application Support/kulala-core/license-token`
(never commit it). Formatting `.http` uses kulala-fmt (Kulala's language server doesn't format).
lualine keeps Kulala's own winbar in its UI buffer. `kulala-demo.http` holds example requests.

### 7.21 Start screen — `startup/alpha.lua`

alpha dashboard theme with the buttons in 6.5; footer `Neovim vX.Y.Z · N plugins`.

### 7.22 Statusline and winbar — `lualine/lualine.lua`

- Theme `auto` with dark backgrounds (`#11111b` active, `#181926` inactive section c); pill-shaped
  components (rounded separators).
- Global statusline: default lualine sections, except section c = Trouble document-symbol breadcrumb
  (current function/class path) and section x = Noice message pill.
- Winbar per window: left = file path relative to cwd (pill) + git branch (pill); right = filetype.
  Inactive windows use muted colours. No winbar for oil, neo-tree, NvimTree, startify, dashboard,
  kulala_ui/kulala, toggleterm, avante/Avante/AvanteInput/AvanteSelectedFiles, codecompanion, dbui,
  dbout. Kulala's UI buffer keeps its own winbar (wrapper in `M.config`).

### 7.23 Messages and UI helpers

- **Noice**: classic bottom search, command palette (cmdline + popup menu together), long messages to a
  split, mode messages as notifications, LSP hover/markdown rendering overridden; `vim.ui.select` left to
  telescope-ui-select. Commented view tweaks kept.
- **which-key**: defaults plus names for the `<leader>` groups in `opts.spec` (b Buffers, c Code/commits,
  d Diagnostics/database, f Find/format/replace, g Git, i AI, ia Avante, ic CodeCompanion, j Harpoon,
  l Lines/lint/LSP/LazyGit, m Marks, n Neogit, p Terminals, R HTTP (Kulala), s Splits, t Toggles,
  w Which-key, z Trouble lists). Labels only; the keys stay in each plugin's file.
- **indent-blankline**: defaults; off for big files.
- **vim-illuminate**: highlights other occurrences of the word under the cursor; paused for big files.
- **todo-comments**: `TODO` also matches lowercase `todo`; highlights anywhere, not only in comments.
- **mini.icons**: icon provider for everything (mocks nvim-web-devicons).

### 7.24 Big files and startup cleanup

See 4.4. Tested cases: a 2.4 MB file and a minified file are protected, also after `:e` / `:e!`
(the detector skips only while the handler looks up the real filetype); normal files unchanged.
After `nvim .` the leftover `[No Name]` is removed once a real file opens; empty buffers created later
are kept.

---

## 7.25 tmux companion setup (outside the repo)

The config is used inside tmux 3.8. tmux's own files are outside this repo (`~/.tmux.conf`,
`~/.tmux/scripts/tmux-project.sh`; all settings in `TMUX_PLAN.md` § Final state). What matters for Neovim:
- Prefix is **Ctrl+\\**, so Neovim's built-in `Ctrl+\\ Ctrl+n` (terminal escape) needs the prefix pressed twice;
  this config uses `Ctrl+x` for that anyway.
- tmux takes these keys without a prefix, everywhere: Alt+Shift+h/l (windows), Alt+Shift+j/k (sessions). In Neovim
  panes, `Ctrl+h/j/k/l` and `Ctrl+Shift+h/j/k/l` are passed to Neovim (smart-splits decides).
- image.nvim inside tmux: see 7.19 (pictures are dropped on redraw).

## 8. Outside the repository

| What | Where |
|---|---|
| Neovim binaries (bob) | `~/.local/share/bob` (`v0.12.6`, `v0.11.7`); bob config `~/Library/Application Support/bob/config.json` points there |
| Plugins | `~/.local/share/nvim/lazy/` (lazy-rocks for rocks) |
| Mason tools | `~/.local/share/nvim/mason/` |
| Treesitter parsers | `~/.local/share/nvim/site/parser/` |
| Sessions | `~/.local/share/nvim/sessions/` |
| Database connections / saved queries | `~/.local/share/nvim/db_ui/` (credentials; mode 0600) |
| Avante history | `~/.local/share/nvim/avante/` |
| Harpoon data | `~/.local/share/nvim/harpoon/` |
| Kulala backend | `~/.local/share/nvim/kulala.nvim/bin/` (kulala-core 1.3.1) |
| Kulala license token | `~/Library/Application Support/kulala-core/license-token` (secret) |
| Copilot login (secret) | `~/.config/github-copilot/` (created by `:Copilot auth`); plugin data in `~/.local/share/nvim/copilot.lua/` |
| Frecency database | `~/.local/state/nvim/file_frecency_v2.bin` |
| Logs | `~/.local/state/nvim/` (lsp.log, mason.log, conform.log, noice.log, …) |
| Treesitter install stamp | `~/.local/state/nvim/treesitter-install-all.done` |
| tmux config (separate app, not in this repo) | `~/.tmux.conf`, `~/.tmux/scripts/tmux-project.sh`; plugins in `~/.tmux/plugins` (TPM) |
| Barbar fork checkout | `~/projects/lua/barbar.nvim` (branch `configurable-filename-depth`, local merge 3aa77e1 not pushed) |

---

## 9. External requirements

Neovim ≥ 0.12; git, curl, C compiler, make; **tree-sitter-cli ≥ 0.26.1** (`brew install
tree-sitter-cli`); Rust/Cargo (Avante build, LuaSnip jsregexp); `rg`, `fd`; ImageMagick (`magick`);
a Nerd Font; `lazygit`; database clients for dadbod; `codex` and `codex-acp` on PATH (ChatGPT login); `claude` and
`claude-agent-acp` (`npm i -g @agentclientprotocol/claude-agent-acp`, Claude login `claude auth login --claudeai`); a GitHub
Copilot login (completions, CodeCompanion inline fallback); Node (Copilot, JS tools); Kulala Core license.

---

## 10. Working on this config

The owner's rules are in `AGENTS.md`. In short: never remove a plugin unless asked (disable with
`cond = false`); keep the folder structure and the owner's comments/commented-out code; follow the
version rule (section 5); Visual mappings use `x`; update `CHANGELOG.md`, `MIGRATION_NOTES.md` **and
this guide** with every change (at the latest before each commit), including the snapshot line at the
top; test changes in Neovim; ask before outward actions (push, installs, downloads).

Adding a plugin: create `lua/alexander/plugins/<name>/init.lua` (spec) and `<name>.lua` (opts/keys);
lazy picks it up automatically. Keys go in the module's `M.keys` (lazy key specs), so they appear in
which-key and load the plugin on first use.

---

## 11. Known quirks and open items

- `<C-]>` can time out on the first lookup of a session (1 s `tagfunc` limit); retry or use `gd`.
- `Ctrl+Shift` keys (`<C-S-h/j/k/l>`, `<C-S-P/N>`) depend on the terminal reporting them; inside tmux
  they need extended keys (see `TMUX_PLAN.md`).
- fzf-lua, mcphub, nvim-dap: installed, enabled, not configured (`TODO` comments).
- Dimming trial and colorful-winsep (7.13) are temporary.
- nvim-cmp family kept disabled until the owner is comfortable with blink.
- Open ideas (not decided): pushing the Barbar fork, Nerd Font
  update, blink.cmp v2 when released, Copilot next-edit suggestions via sidekick.nvim, per-window buffer
  tabs.
