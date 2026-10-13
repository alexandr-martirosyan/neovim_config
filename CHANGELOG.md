# Configuration changelog

## 2026-10-11 — configuration repair and plugin upgrades

### 1. Preserve the starting configuration

- Work is isolated on `codex/nvim-plugin-upgrade`.
- The original configuration, uncommitted edits, lockfile, and installed plugins were backed up before editing.
- Existing plugin folders and separate spec/configuration files are retained. Unused plugins will be disabled, with their declarations and configurations kept.

See [MIGRATION_NOTES.md](MIGRATION_NOTES.md) for implementation decisions, compatibility details, exact plugin revisions, checks, and rollback instructions.

### 2. Make startup and shortcuts predictable

- Editor options, leaders, provider settings, diagnostics, and core mappings initialize before plugins. Lazy's update checker and fallback colorscheme now use the correct options.
- Plugin shortcuts moved into the plugins' existing configuration modules, so first use loads the correct plugin and disabled plugins no longer expose broken shortcuts.
- Relative line numbers now toggle with `<leader>lr`; `<leader>rn` remains LSP rename. `<leader>pt` selects a ToggleTerm terminal. Copilot Chat reset loads its plugin correctly.
- Duplicate editor autocmds/filetype registrations were consolidated; custom highlights survive colorscheme changes.

### 3. Clarify language tooling

- An explicit LSP allowlist controls activation, including servers installed during a session. Opening a new file now loads LSP and lint support.
- Lua library discovery uses lazydev; Deno uses upstream root detection with a guard against overlapping a nested Node project. Circom's root callback is repaired but remains opt-in.
- Mason installation commands inspect the current installed packages; reinstall now actually forces installation.
- Diagnostic display has one configuration owner. Manual formatting is preserved, with Prettier added for JSX/TSX. Linting skips special buffers and avoids redundant window-entry runs.

### 4. Keep completion and optional plugins coherent

- Completion and autopairs load on entering Insert mode without a dependency cycle. Copilot completion loads with completion rather than forcing it at startup.
- Tab still confirms completion; outside the completion menu it expands/jumps through snippets. Shift-Tab jumps backward. Leaving Insert mode no longer cancels the active snippet.
- Unused cmp sources, extra Neogit pickers, legacy popup/debugger dependencies, Copilot NES, and LuaFileSystem remain declared but disabled.
- Scope now initializes tab-local buffer tracking. LazyGit loads on demand. Floating terminals adapt to current dimensions and support headless operation.
- The local Barbar checkout is preserved, with a remote fork fallback for machines without it. The lockfile is now eligible for Git tracking.

### 5. Migrate current plugin APIs

- Updated 38 of the 72 installed plugin repositories; the remaining 34 already matched their selected stable release/branch. Retained disabled plugins were updated too.
- Treesitter now uses `main` and Neovim's highlighting API, installing every available parser (as before) with dedicated HTTP parser ownership. Installed the required Tree-sitter CLI.
- Telescope moves from 0.1.8 to 0.2.2, retaining the flex layout and fzf/frecency/media/UI-select/Trouble integrations.
- Colorful Winsep moves from the deleted alpha branch to main, retaining bold separators with animation and extra two-window indicators disabled.
- CodeCompanion and Avante use the installed Codex agent's correct `chat-gpt` authentication ID. Avante's ACP-mode shortcut uses its current command; history and explicit tool permissions are preserved. Avante's new Cargo libraries were built.
- AI frontends and Harpoon load through their own commands/keys. Lualine no longer forces Noice/Trouble to initialize; symbols appear when LSP attaches, and the Kulala winbar workaround is retained.
- Copilot moves to v3's native backend; existing credentials are preserved. Kulala moves to 6.33.1 at your request, and its backend is now activated with your license token (see section 8).


### 6. Verify and document the final behavior

- Added Avante's newly required command-parser/logging dependencies; repaired the nested Node-in-Deno overlap found during acceptance.
- Built Kulala's current HTTP grammar, corrected the demo's parsed-response assertions, and verified the demo with mocked responses.
- Startup/lazy loading, real existing/new-file Lua LSP attachment, root selection, AI links, snippets, search, folds, terminals, icons, file explorers, and retained Git/database setup passed focused checks.
- Added consistent formatting settings and documented prerequisites, recovery, all selected plugin revisions, token setup, and intentionally deferred alternatives.
- Real AI authentication and terminal image rendering remain manual acceptance checks.

### 7. Follow-up review corrections

- Treesitter installs every available parser again, restoring the old "all" behavior; the 24-language list had dropped languages such as SQL (Dbee) and diff/gitcommit (Neogit). On the next interactive start, Neovim builds the missing parsers once in the background (no command needed).

### 8. Post-review fixes

- `<leader>fm` (manual format) and `<leader>ll` (lint now) work again. They had been moved into the Conform/nvim-lint modules but were never attached to those plugins, so Conform never loaded and formatting did nothing. `:ConformInfo` also loads Conform now.
- The `nvim` on your PATH (managed by bob) now runs Neovim 0.12.6, the latest stable. It was still 0.11.7, which the upgraded Avante and Treesitter do not support; the earlier testing used Homebrew's separate 0.12.6. 0.11.7 stays installed for rollback (`bob use 0.11.7`).
- Every available Treesitter parser is now installed, not only the 24 that were built before.
- Kulala is activated: the license token is saved globally (one time, used by every `.http` file) and backend 1.3.1 is installed. Sending a request shows the response normally.
- `<leader>fm` formats `.http` files again with kulala-fmt. The earlier migration assumed Kulala's language server formats HTTP files, but it does not, so formatting `.http` files silently did nothing. kulala-fmt is back in the `:MasonInstallAll` list.
- On machines without your local Barbar checkout, the config now installs your fork's `filename_depth` branch. It was pinned to the fork's master, which is plain upstream and lacks your tab-label fix.
- Tab (buffer) icons come from mini.icons again, as before the migration; the migration had switched them to nvim-web-devicons. Any plugin that asks for nvim-web-devicons gets mini's stand-in.
- Comment.nvim is enabled again. Disabling it had removed `gbc`/`gb` (block comments) and `gco`/`gcO`/`gcA`; ts-comments stays enabled alongside it, as before.
- Your comments and commented-out code that the migration deleted are restored: the section headers and spare mappings in `mappings.lua`, the Barbar command notes (now next to Barbar's shortcuts), the Bufferline test mappings (now in the Bufferline config), the old nvim-cmp config block, the LSP handlers snippet, and the lualine highlight notes.
- Your local Barbar fork is up to date with upstream (3 fixes merged, including Neovim 0.13 compatibility). The merge is local only and not pushed.
- Barbar's slanted tab edges look right again. The Catppuccin update started applying its own colours to every plugin it detects, which painted Barbar's tab edges solid blue and changed other plugins' colours you never chose (for example a red Colorful Winsep separator). Catppuccin now uses the same set of plugin colours it had before the update.

### 9. Completion: nvim-cmp → blink.cmp

- Completion now runs on blink.cmp 1.10.2 with its fast (Rust) matcher. nvim-cmp, its sources (LSP, buffer, path, LuaSnip) and copilot-cmp are disabled, not removed; their configuration is untouched, so switching back is a matter of flipping `cond`.
- Same shortcuts: `<Tab>` accepts the selected/first item or expands/jumps a snippet, `<S-Tab>` jumps back (both also work while a snippet placeholder is selected), `<C-n>`/`<C-p>` select, `<C-Space>` opens, `<C-e>` closes, `<C-f>`/`<C-d>` scroll the docs. No new blink default keys were added.
- Same sources and look: Copilot (now via blink-copilot), LSP, LuaSnip snippets (friendly-snippets included), buffer words shown together with LSP items, paths, and lazydev in Lua files. Same rounded menu with lspkind icons on the left and the source icons on the right, same docs window, ghost text on, no command-line completion.
- Avante's `@` mentions, `/` commands and `#` shortcuts keep working through blink.compat. CodeCompanion switches to its blink integration automatically.
- Brackets after accepting a function now come from blink itself instead of nvim-autopairs' cmp hook; autopairs still pairs brackets while you type.
- Language servers get their completion capabilities from blink.

### 10. Copilot and plugin cleanup

- Copilot next edit suggestions (NES) are on, via copilot-lsp. After you change text, Copilot may preview the edit you are likely to make next, anywhere in the file. In Normal mode, `<Tab>` jumps to it and applies it, `<Esc>` dismisses it; with no suggestion both keys do what they did before (`<Esc>` still clears search highlighting). Inline completions still come through the blink menu.
- CopilotChat is removed (config, `<leader>ip…` shortcuts, installed files).
- popup.nvim is removed: nothing uses it any more.
- Bufferline is removed (config folder, including its spare test mappings); it was never installed.
- fzf-lua, mcphub and nvim-dap are enabled but not configured yet. Each has a `TODO:` note next to it, so they show up in `<leader>ft` (TODO search). Nothing else changes: pickers still use Telescope.
- luafilesystem is removed (config folder, installed copy, its compiled rock, lockfile entry). Nothing used it; Neovim's built-in `vim.fs`/`vim.uv` cover the same needs.
- mini.pick is removed (it was only one of Neogit's optional pickers; you use Telescope).
- Copilot next edit suggestions are off again and copilot-lsp is removed (no code changes since Dec 2025, feature still experimental). Normal-mode `<Tab>` and `<Esc>` are back to their usual behavior only. Copilot completions in the blink menu are unchanged. If you want next edit suggestions later, sidekick.nvim (with Copilot as a native language server) is the suggested route.

### 11. Plugin version rule

- New rule, written in `configs/lazy.lua`: every plugin follows its main branch (newest code) unless it actively publishes releases; those use `version = "*"`, the newest stable release, **including new major versions** (no more `^6.33.1`-style ceilings).
- "Actively publishes releases" means the newest release is under a year old and close to the main branch. On releases: LuaSnip, blink.cmp, catppuccin, CodeCompanion, copilot.lua, image.nvim, indent-blankline, Kulala, lazydev, mason, mason-lspconfig, mini.icons, neo-tree, nvim-lspconfig, oil, render-markdown, Telescope, todo-comments.
- Plugins whose releases are old and far behind (fzf-lua, Neogit, nvim-web-devicons, conform, Dbee, nvim-dap, gitsigns, Comment.nvim, plenary, focus, toggleterm, telescope-frecency, Noice, which-key, Trouble, and others) follow main, so none of them was downgraded to an old release.
- Exceptions: Treesitter stays on `branch = "main"` (its only release is the old pre-rewrite version), Avante stays on main (its README says never to use `"*"`), Harpoon and Colorful Winsep keep their branches (no releases).
- What changed on disk: 11 plugins moved to match the rule. catppuccin went to its v2.0.0 release and neo-tree to 3.42.0 (both slightly older than the main-branch code they were on); toggleterm, telescope-frecency and blink.compat moved forward to their main branch. telescope-frecency converted its ranking database to a new format on first use (rankings may shift slightly; the old file is kept).
- Because new major versions now install automatically, `:Lazy update` can bring breaking changes. Read the update summary, and if something breaks, roll that plugin back from `:Lazy` (or with the lockfile).

### 12. Shortcut cleanup

- Visual `J`/`K` are back to Neovim's built-ins (join selected lines / look up the selected word). Moving a selection still works with `<A-j>`/`<A-k>`.
- The Insert-mode `<C-h>`/`<C-j>`/`<C-k>`/`<C-l>` cursor keys are disabled (kept commented in `mappings.lua`), which restores the built-ins: `<C-h>` deletes the previous character, `<C-j>` starts a new line, `<C-k>` types special characters (e.g. `<C-k> e :` gives `ë`).
- Visual `p` is back to the built-in (paste, and the replaced text becomes the register). Use Visual `P` to paste without overwriting the register; the old `"_dP` mapping is kept commented in `mappings.lua`. This also stops `p` from pasting when typed inside a snippet placeholder.
- Avante: `<leader>ian` is now consistently **new ask** (a fresh question about the current file/selection; works in Normal and Visual mode) and **new chat** moved to `<leader>iaN`. Before, two settings fought over `<leader>ian` and new chat had no working key. `<leader>ian` also loads Avante now, so it works as the first Avante key you press.
- LSP shortcuts now use Neovim's built-ins: `grr` references, `grn` rename, `gra` code action, `gri` implementation, `grt` type definition (your `gr`, `gi`, `<leader>rn`, `<leader>ca`, `<leader>D` are commented out). `gr…` keys no longer wait 400 ms, and built-in `gi` (continue typing where you last stopped) works again. `gd`, `gD`, `gh`, `<leader>sh` and the workspace keys are unchanged.
- Avante zen mode moved from `<leader>az` to `<leader>iaz`, so `<leader>a` (Harpoon add) runs instantly instead of waiting 400 ms.
- Visual-mode shortcuts no longer fire while you type into a snippet placeholder (Select mode). Your window keys, `<`/`>`, `<A-j>/<A-k>`, and the Visual keys of Avante, CodeCompanion, Gitsigns and Kulala are now Visual-only. They work exactly as before in Visual mode; typing `<`, `>`, Space and so on into a placeholder now just types.
- Avante's own automatic shortcuts are off (they always included Select mode). Every Avante key is defined in your Avante config instead, including the four it used to add by itself: `<leader>iad` debug, `<leader>iaC` toggle selection, `<leader>iaS` toggle suggestion, `<leader>iaB` add all open buffers.
- Code lens is on: in files whose language server supports it (e.g. Rust), small labels like `▶ Run Test | ⚙ Debug` appear above code. `grx` runs the one on the current line, `<leader>lc` toggles them for the current file.
- Barbar "pin buffer" moved from `<A-p>` to `<leader>bp`. `<A-n>`/`<A-p>` are now vim-illuminate's next/previous occurrence of the word under the cursor (defined explicitly, so plugin load order no longer matters).
- Harpoon moved to its own `<leader>j` group: `<leader>ja` add file, `<leader>jj` menu (was `<leader>a` and `<leader>hi`). `<leader>fp` (Telescope list) and Ctrl+Shift+P/N (previous/next) are unchanged. `<leader>a` is now free.

### 13. Plugin review follow-ups

- `<leader>fr`: recent files ranked by how often and how recently you open them (telescope-frecency, previously loaded but unused). `<leader>fo` (plain recent files) is unchanged.
- Git hunk keys moved from `<leader>h…` to `<leader>g…`, next to `<leader>gt` (git status): `gs` stage hunk, `gr` reset hunk (both also in Visual mode), `gS` stage buffer, `gu` undo stage, `gR` reset buffer, `gp` preview, `gb` blame line, `gd` diff, `gD` diff against last commit. `]c`/`[c`, `ih`, `<leader>tb`, `<leader>td` are unchanged.
- image.nvim now picks its image method from the terminal: Sixel in iTerm2 and Windows Terminal (including WSL), kitty's method in kitty, Ghostty and WezTerm, and stays off (installed, not loaded) in other terminals. It uses the ImageMagick command instead of a compiled Lua library. Not yet confirmed visually in iTerm2.
- New: nvim-surround. `ysiw"` surrounds a word with quotes, `cs"'` changes `"` to `'`, `ds"` deletes them, `S"` in Visual mode surrounds the selection.
- Toggling neo-tree no longer breaks your window layout. Opening the tree shrinks every window by the same factor (a 50/50 or 70/30 split keeps its ratio); closing it puts back the exact widths you had. If you resize windows while the tree is open, closing scales your new proportions up instead. Fixed-width panels keep their width, heights are never touched, and closing the tree with `:q` is handled too.
- New split keys: `<leader>sD` opens a full-width window at the bottom (spanning all columns, `:botright split`), `<leader>sS` a full-height window on the far right (`:botright vsplit`). `<leader>sd`/`<leader>ss` still split only the current window.
- Window separators are now thick lines (`┃` `━` with matching corners) in a visible grey (`#6e738d`) between **all** windows, so two unfocused windows side by side no longer blend together. Colorful Winsep still colours the focused window's borders. The old colour `#313244` was almost the same as the background.
- The line between neo-tree and your code now uses the same thick grey separator. Catppuccin's neo-tree colours had made it invisible (drawn in the background colour).
- `nvim .` no longer leaves an extra empty `[No Name]` buffer focused after you open your first file. When Neovim starts on a folder, neo-tree now loads during startup, so the file tree opens immediately (no `<C-n>` needed), and the empty placeholder buffer is removed once you open a real file. Other starts (`nvim file`, plain `nvim`) are unchanged.
- Oil (`-`) now opens as a clearly framed popup: rounded border, the current folder as its title, and 80% of the screen. Before, it had no border and filled the whole editor, so it looked like you were still inside the file (whose title bar and tab stayed visible).
- Go to definition works again inside your own config modules (e.g. `gd` on `toggleterm.keys` or on a `require("alexander....")` path). The version-rule change had moved lazydev back to its last release (v1.10.0, Oct 2025), which cannot resolve modules in your own `lua/` folder; lazydev follows its main branch again, where this is fixed.

### 14. Plugin versions follow each plugin's own docs

- Replaces the version rule from section 11, which had moved several plugins back to older releases (lazydev, neo-tree, image.nvim, nvim-lspconfig, mason-lspconfig, catppuccin, oil, render-markdown).
- New rule: each plugin uses what its own install docs recommend. Where the docs give no version, it uses your original setting, and otherwise its default branch (newest code).
- Back to your original/docs settings: neo-tree `branch = "v3.x"`, LuaSnip `"v2.*"`, window-picker `"2.*"`, toggleterm `"*"`, telescope-frecency `"*"`, CodeCompanion `"^19.0.0"`.
- Per the docs: blink.cmp `"1.*"` (its README warns v2 has breaking changes; `"*"` would have installed v2 as soon as it is released), blink.compat `"2.*"`, nvim-surround `"^4.0.0"`.
- Default branch again (no version given by the docs or by you): catppuccin, image.nvim, nvim-lspconfig, mason, mason-lspconfig, oil, render-markdown, copilot.lua, Kulala, indent-blankline, todo-comments.
- Unchanged and already matching their docs: Telescope `"*"`, mini.icons `"*"`, Avante (main), Harpoon (`harpoon2`), Treesitter (`main`), lazydev (main).
- Result: no plugin is older than before section 11. Re-checked LSP, Treesitter, completion and snippets, formatting, Kulala, the neo-tree layout, tab colours, and go-to-definition in your config.- Refinement: a README can say "use releases" while the maintainers have quietly moved to the main branch. Where the last release is old but main is still actively fixed, the plugin follows main. Applied to Telescope (last release Feb 2026, 29 fixes on main since, incl. a Neovim 0.12 deprecation fix) and telescope-frecency (last release Sep 2025, Neovim 0.12 fix on main). LuaSnip, neo-tree, CodeCompanion, nvim-surround and mini.icons release regularly and stay on releases; toggleterm, blink.compat and window-picker have no newer work on main either. blink.cmp stays on 1.x on purpose (main is the breaking v2). Re-tested all Telescope pickers.

### 15. Queued plugin changes

- **Start screen (Alpha)** rebuilt with your real tools: press `e` new file, `f` find file, `r`/`o` recent files (frequent first / latest first), `g` find text, `s` restore session, `t` file tree, `n` Neogit, `l` LazyGit, `c` Neovim config, `L` Lazy, `m` Mason, `h` check health, `q` quit. The old buttons pointed at someone else's keys.
- **Big-file protection:** files over 1.5 MB or with very long lines (minified JSON/JS) open with Treesitter, language servers, linters, folds, word highlighting and indent guides off for that file (simple syntax colours stay). A short notice says so.
- **Code structure text objects** (nvim-treesitter-textobjects): `af`/`if` function, `ac`/`ic` class, `aa`/`ia` argument, `al`/`il` loop, e.g. `vaf`, `dif`, `cia`, `yac`. `]f`/`[f` jump to the next/previous function start, `]F`/`[F` to its end.
- **Project-wide find & replace** (grug-far): `<leader>fs` (word under cursor, or the Visual selection), `<leader>fS` (current file only). In the panel: type the replacement, review the preview, `\r` replaces all, `g?` shows all keys. `/` and `:s` are unchanged.
- **Pinned context** (treesitter-context): the function/class you are in stays visible at the top while scrolling, at most 3 lines (innermost kept). `<leader>tc` changes the limit while you work (`0` = no limit).
- **Sessions** (auto-session): open files and window layout are saved per folder on quit and restored on start (`nvim .` or plain `nvim` in that folder). File tree, terminals and AI panels are not saved, so they never come back broken. Home, Downloads and `/` are excluded. `:AutoSession restore / delete / search` for manual control.
- **Database UI: Dbee → vim-dadbod-ui.** `<leader>db` opens the database drawer. Your two connections and your saved query were moved over (Dbee's own files are untouched). SQL completion (tables, columns) now shows in the blink menu in `.sql` files. Dbee is disabled, not removed.
- telescope-media-files removed (config, installed copy, lockfile entry).
- fzf-lua stays enabled but unconfigured; Noice, indent-blankline, mcphub unchanged; winshift stays disabled; flash not added.
- A temporary `picture.png` in the config folder is there to test image display (`:e picture.png`); delete it afterwards.
- Verified by you: image.nvim shows images in iTerm2 (Sixel); the test picture was deleted. Dimming of inactive windows stays on for now; colorful-winsep stays installed but disabled.
- `AGENTS.md` (and `CLAUDE.md`, which loads it) records where things stand, your rules for changes, and what is still open, for any AI assistant working on this config.

### 16. Fixes after the handoff

- Starting Neovim in the config folder no longer shows "Error restoring session, disabling auto save" and no longer reopens the deleted `picture.png`. The saved session had frozen the image viewer's settings; restoring them failed, and because a failed restore turns auto-save off, the broken session was never replaced. The broken session was deleted, and sessions no longer store per-window settings (file type and bars are set normally when a file opens). A session that mentions a file you deleted now just restores the rest.

### 17. Review fixes (Codex review of `main`)

- `<leader>fS` (find & replace in the current file) now really stays in that file: file names with spaces work, and in a buffer that isn't a saved file (e.g. an empty new buffer) it shows a warning instead of searching the whole project.
- Neo-tree's proportional layout also works when you add a full-width split (`<leader>sD`) while the tree is open: closing the tree now gives its space back only to the windows next to it, so their proportions are kept (before: 120/79 became 95/104).
- The empty-buffer cleanup after `nvim .` now runs only once, for the startup placeholder. Empty buffers you create yourself later are no longer deleted.
- README updated (vim-dadbod-ui instead of Dbee, Bufferline removed, all Treesitter parsers, `.http` formatting via kulala-fmt, Comment.nvim keys); the migration notes are marked as a historical record.

### 18. Config guide and lost icons

- New `CONFIG_GUIDE.md`: a full description of the config — folder structure, startup order, every option, every plugin (enabled, disabled, removed) and what it does here, every shortcut with its mode and the file that defines it (including LSP, Kulala, database and plugin-panel keys and the Neovim built-ins you rely on), how each feature works, and where data lives outside the repo. Its top says which commit it matches and how to check whether it is still current. `AGENTS.md` now requires updating it with every change.
- Completion menu: the Copilot and LSP source icons (and the Copilot kind icon) are back; they had become empty during the blink migration.
- Start screen: 9 of the 14 buttons had lost their icons (new file, recent, session, Neogit, LazyGit, config, Mason, health, quit); they have icons again.
