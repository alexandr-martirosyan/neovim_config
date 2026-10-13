# Neovim migration notes

> **Historical record.** Sections are kept in the order the work happened; later sections override
> earlier ones (e.g. section 8j replaces the version policy of 8d, removed plugins mentioned early on are
> gone). The current state and rules are in `AGENTS.md`.

This document is a technical handoff for future maintainers and AI assistants. `CHANGELOG.md` explains changes in terms of editor behavior. Entries below are maintained as each conceptual change is implemented, including corrections made during validation.

## Scope and invariants

- Preserve the current folder layout and the existing separate `init.lua` spec and configuration modules. Plugin keys may move into their own existing modules.
- Do not delete unused plugin declarations, dependency declarations, or configuration files. Disable unused components using `cond = false`; retain shared dependency configuration in its own folder.
- Keep nvim-cmp, Telescope, Oil, Neo-tree, the local Barbar fork, UFO, Noice, Dbee, all existing AI frontends, Catppuccin Macchiato, manual formatting, Black/Flake8, Rust Clippy, and current Codex/Ollama provider choices.
- Optional Snacks, Ruff, and AI consolidation proposals are outside this implementation (Blink was later migrated at the user's request; see 8b).
- Preserve the user's changes that existed before this task. No commit or push is requested. Do not modify the separate local Barbar repository.
- Use a bounded validation pass, followed only by checks needed to repair actual failures.

## 1. Baseline and recovery

Original branch: `codex/codecompanion-codex-cli`. Working branch: `codex/nvim-plugin-upgrade`.

Backup directory:

`/Users/alexandrmartirosyan/.codex/visualizations/2026/10/11/01a12a68-a4dd-7351-ba8e-1b162d49e23e/nvim-backup-2026-10-11`

- `config-before.tar.gz`: complete configuration directory, including Git metadata, ignored files, the old lockfile, and uncommitted/untracked files.
- `plugins-before.tar.gz`: complete installed Lazy plugins and lazy-rocks directories, including Git repositories and native build artifacts.
- `original-status.txt`, `original-branch.txt`, `original-diff.patch`: original working state.
- `installed-plugins.json`: original plugin paths, HEADs, remotes, and local status.

Rollback must restore both configuration and installed plugin/parser versions; switching branches alone does not restore installed binaries or uncommitted files. Stop Neovim, move the current configuration and plugin directories aside, inspect archive paths with `tar -tzf`, and extract the archives into their recorded parent directories. Do not extract over live plugin directories, since new-version files would remain. Restoring the configuration archive also restores its original Git state. Any parser/state changes made during this migration are documented in later sections.

The prior all-code review and implementation prompt remain in the chat's artifact directory (`nvim-review.md` and `gpt-6-sol-implementation-prompt.md`). Their folder-merging and deletion recommendations are explicitly overridden by the constraints above.

## 2. Startup, autocmds, and mapping ownership

The original `lazy.setup(spec, opts)` call embedded `checker` and `install` inside the spec argument, where they were not manager options. These options now live in the second argument. Options/provider flags and leaders run first in `alexander/init.lua`, followed by named autocmds, diagnostics, core mappings, then Lazy.

101 plugin mappings were moved into `M.keys` tables in 20 existing modules and consumed by their existing specs. No plugin folders or configuration files were merged/moved. This makes key-triggered loading explicit, including CodeCompanion CLI callbacks and UFO fold actions that previously required a plugin during startup. The terminal escape key remains a core mapping. Disabled Winshift retains its key definitions without registering them. LazyDocker retains its disabled configuration/mapping; its broken global shortcut is no longer registered.

`<leader>lr` replaces the global relative-number `<leader>rn` collision. `<leader>rn` stays buffer-local LSP rename. `<leader>pt` now runs supported `TermSelect` rather than the nonexistent Telescope `terms` extension. `<leader>?` now honors the advertised buffer-local WhichKey view. Gitsigns next-hunk description is corrected. CopilotChatReset and MasonReinstallAll are explicit lazy commands.

The `AlexanderEditor` group replaces duplicated ungrouped formatoptions autocmds. `vim.filetype.add` is the only Circom/HTTP registration. ColorScheme restores WinSeparator and Copilot completion highlighting. Diagnostics settings were moved into the already-existing diagnostics command file rather than being reset by an LSP plugin later.

## 3. LSP and formatting ownership

Native `vim.lsp.config` is retained. Settings remain in their existing per-server files, as requested; no `after/lsp` restructuring was done. Mason URLs use `mason-org`. `settings.servers` is an explicit allowlist; `mason-lspconfig.setup` owns activation with `automatic_enable = enabled` and listens for successful installations. Package installation stays manual through MasonInstallAll. The custom Circom server remains behind `settings.enable_circom = false`.

Global completion capabilities come from cmp-nvim-lsp without loading the full completion UI. LspAttach handles user mappings and the existing preference to disable semantic tokens; upstream per-server on_attach/on_init hooks are preserved. Overrides are required only when a file exists, and errors in an existing module are surfaced rather than swallowed by pcall.

LuaLS's misplaced `settings.workspace` and excessive preload overrides are replaced by `settings.Lua.workspace.checkThirdParty = false`; lazydev provides relevant libraries. `denols.lua` wraps the native upstream root callback with a narrow guard for closer Node lockfiles; see the acceptance correction below. The custom Circom callback follows `(bufnr, on_dir)` and resolves package.json/.git or the file's directory.

Mason's custom ensure_installed list remains in settings but is no longer passed as an unsupported Mason option. MasonInstallAll queries the registry when invoked; MasonReinstallAll uses `--force`. Formatter/linter tools remain unchanged, including Black/Flake8 and rustfmt/Clippy. Formatting remains manual; JSX/TSX use the existing Prettier parser overrides. HTTP uses Conform's built-in `kulala-fmt` formatter (see 8a; an interim change wrongly relied on Kulala LSP formatting).

## 4. Completion, disabled components, icons, and terminals

nvim-cmp retains LuaSnip, Copilot, LSP, buffer, path, and lazydev sources. It depends on lspkind and copilot-cmp. Autopairs is a separate InsertEnter spec depending on cmp; the reverse edge is inactive, eliminating recursion while retaining autopairs' own declaration. LSP depends only on cmp-nvim-lsp. Copilot-cmp no longer forces startup loads. Tab preserves menu confirmation and otherwise uses LuaSnip's local expansion/jump predicate; Shift-Tab jumps back. Lazy loaders honor custom snippet paths without empty-path duplicate loads. InsertLeave no longer unlinks snippets.

Unused components use `cond = false`, preserving declarations/configuration and installed files: cmp-nvim-lua, cmp-cmdline, extra Neogit pickers, popup.nvim, nvim-dap, copilot-lsp/NES, and LuaFileSystem. Existing disabled Bufferline/Winshift stay disabled. Shared dependencies still have their own configuration ownership and are listed by consumers.

(Corrected in 8a: mini.icons with its nvim-web-devicons mock is the icon provider again; an interim change made real nvim-web-devicons the provider.) Mini URLs use their canonical nvim-mini organization. No independent local fork edits were made. Barbar's spec uses the local checkout when available and the user's remote fork otherwise.

Scope had an event trigger without setup; `opts = {}` enables its intended tab-local buffers. LazyGit's eager flag is removed, retaining its command and Telescope extension dependencies. Floating terminal height is evaluated at open time, and width calculation falls back to editor dimensions if no UI is attached. The existing terminal IDs and exclusive-tab toggle behavior are preserved.

The lockfile is no longer ignored; runtime logs are ignored instead. Exact plugin targets and build results will be recorded below after upgrades.

## 5. AI links and runtime ownership

The existing Avante file_reference module is now also used by CodeCompanion. Its location is unchanged; this avoids creating a util folder or merging plugin configuration files. References support Markdown links, quoted/backtick paths, proper file URI decoding, :line:column/#Lline targets, CWD/project/file-relative resolution, loaded unsaved files, and clamped cursor positions. Only regular nonfloating editing windows are reused; AI panes, explorers, HTTP result windows, terminals, and dashboards are excluded. If necessary it opens a split; it does not overwrite or discard an unsaved buffer.

CodeCompanion's duplicated window-selection functions were replaced by the shared callback while preserving Ollama, terminal Codex arguments, CLI commands, and all existing user options. The installed @agentclientprotocol/codex-acp source advertises `chat-gpt` (and `chat-gpt-device-code`), not `chatgpt`; both frontends' explicit auth IDs now match. No login or AI request was made. MCPHub remains declared but disabled because neither setup nor CodeCompanion extension wiring exists; native MCP remains an optional future choice.

Avante loads on command/key use rather than VeryLazy. Its canonical URL is avante-corp/avante.nvim. `Avante acp modes` replaces the deprecated ACPModes shortcut; the alias remains in command triggers for compatibility. Current upstream `make` uses Cargo and writes four native .so libraries under lua; the build completed. History storage is explicitly kept at the original data/avante location, avoiding an implicit move to state/avante and preserving existing conversations. The existing state directory is backed up as well.

Harpoon's five existing shortcuts now trigger loading, with Telescope declared as a real dependency; opening every file no longer initializes its Telescope picker. Lualine uses deferred Noice/Trouble access and a copied theme table. Trouble loads on LspAttach for statusline symbols. LualineMessagePill is defined/restored with Macchiato-compatible colors. The Kulala winbar guard checks both its URI and kulala_ui filetype; it remains until backend-enabled UI acceptance is possible.

## 6. Upgrades and breaking APIs

All 72 installed repositories were considered. 38 moved to reviewed targets; 34 remained current for their chosen track. Stable constraints remain for LuaSnip, ToggleTerm, window-picker, frecency, Mini icons, and CodeCompanion. Telescope's constraint deliberately moves to ^0.2.2. Neo-tree remains on v3.x and Harpoon on harpoon2. Disabled plugins were updated without removing their installed files. Generated doc/tags files were preserved when finishing three upgrades. No Lazy sync/clean was run.

### Treesitter

The current main branch is an incompatible rewrite requiring Neovim 0.12+ and tree-sitter-cli >=0.26.1. This machine runs Neovim 0.12.6; Homebrew tree-sitter-cli 0.27.1 was installed (the existing tree-sitter package was only the C library). The spec is eager as required by upstream. `nvim-treesitter.configs`, ensure_installed=all, and removed module commands are replaced by the new setup/install/update API and a named FileType callback for Neovim highlighting/indentation. The existing module installs `"all"` (follow-up correction: the user asked to restore the old install-everything behavior; an interim 24-language list dropped SQL for Dbee and diff/gitcommit for Neogit). Upstream `"all"` expands to every available parser except tier-4 unsupported ones; there is no ignore option, so the old `ignore_install = { "ipkg" }` has no equivalent and a failing parser only logs an error. The build hook allows 30 minutes and `update()` without arguments refreshes all installed parsers. Because the build hook only runs on plugin install/update, `config` also calls `install_missing_once()`: two seconds after an interactive (non-headless) start it runs `install("all")` asynchronously (already-built parsers are skipped) and, when the task finishes without being interrupted, writes `stdpath("state")/treesitter-install-all.done` so failed parsers are not retried every launch. Delete that file to rerun it. Avante, CodeCompanion, and Kulala result buffers map to Markdown. UFO remains the fold UI/provider owner. Kulala owns its separate kulala_http grammar.

Parser files, Avante history, and Kulala backend state were backed up in `parser-ai-http-state-before.tar.gz` with home-relative archive paths. Plugin-native files were already included in the plugin archive. Parser install/build results and verification are recorded below when complete.

### Telescope and Colorful Winsep

Telescope's old 0.1.x branch would never receive the current APIs. v0.2.2 retains your flex layouts and extensions; extension dependencies now explicitly include frecency and Trouble. Unsupported extensions_list is removed. Colorful Winsep's removed alpha track is replaced with main; no_exec_files becomes excluded_ft, the old symbol array becomes border="bold", animation is explicitly false, and the new two-window indicator is explicitly disabled. This preserves your existing quiet separator behavior.

### Copilot and Kulala

Copilot v3 defaults to a pinned, hash-verified native server download; old apps.json authentication is no longer supported. Suggestion/panel remain disabled in favor of copilot-cmp. Existing auth files are untouched. First-use backend/auth behavior requires a separate check; if needed run :Copilot auth locally. Node 22+ is only required for its optional nodejs backend.

Kulala uses its canonical dont-be-evil-company URL, ^6.33.1, and SessionLoadPost support. Its current backend requires Kulala Core 1.3.1; the installed older binary identifies as 0.7.0 in its version file and cannot be substituted safely. No token was found. The user explicitly chose to upgrade and requested token setup instructions. The plugin update is complete; HTTP execution/formatting acceptance is pending backend download with a valid token. Do not claim the HTTP workflow is already validated.

Official token configuration: open an .http file, enter the token at Kulala's hidden prompt; it is stored in `~/Library/Application Support/kulala-core/license-token` with owner-only permissions and reused across upgrades. Alternatively provide `KULALA_CORE_LICENSE_TOKEN` in the environment of the process launching Neovim. Do not put a real token in this repo, chat, or changelog. The official https://core.kulala.app page manages tokens using an existing API token; public docs did not establish a free/paid price or public signup path. Obtain licensing/access information from the maintainers; do not invent pricing or accept terms on the user's behalf.

Primary references: [Treesitter setup](https://github.com/nvim-treesitter/nvim-treesitter), [Telescope 0.2.2](https://github.com/nvim-telescope/telescope.nvim/releases/tag/v0.2.2), [Colorful Winsep](https://github.com/nvim-zh/colorful-winsep.nvim), [CodeCompanion Codex adapter](https://github.com/olimorris/codecompanion.nvim/blob/v19.27.0/lua/codecompanion/adapters/acp/codex.lua), [Avante](https://github.com/avante-corp/avante.nvim), [Copilot](https://github.com/zbirenbaum/copilot.lua), [Kulala configuration](https://github.com/dont-be-evil-company/kulala.nvim), [Kulala licenses](https://core.kulala.app/).

### Acceptance corrections and new dependency

The first runtime acceptance pass exposed a required upstream dependency absent from the old configuration: Avante's consolidated command now imports `mega.cmdparse`. Added ColinKennedy/mega.cmdparse and its required mega.logging dependency, installed both, and recorded them in the lockfile. They use upstream defaults and have no duplicate custom setup. This is a concrete breaking dependency, not an optional new feature.

Two initial failures came from the test harness rather than the configuration: Neovim `-l` runs before VimEnter/VeryLazy, and macOS resolves /tmp to /private/tmp. Canonical fixture paths fixed the /tmp assertion. Lazy waits for UIEnter in this startup path, so the final startup check uses a real terminal UI rather than trying to prove VeryLazy behavior from a headless harness. A sandbox-only vim.pack directory warning was avoided by running the authorized runtime checks with access to installed plugin paths. Passed cases were not rerun merely for reassurance.

The public HTTP demo uses current `client.assert` instead of undocumented assert helpers. JSONPlaceholder uses parsed `response.body` directly; httpbin retains its genuine response.body.json.data nesting. No public requests were sent.

## 7. Considered changes deliberately not implemented

- **Feature folders, merged plugin files, config→config singular rename, after/lsp layout, a new util folder:** the review proposed these for reducing navigation/boilerplate. The user prefers the existing layout and separate files, so all were declined. Ownership was improved through keys/options inside the existing modules instead.
- **Inlining shared dependency configuration into one consumer:** rejected because future consumers should not depend on that consumer. Existing shared plugins keep their own configuration; every consumer declares its real dependencies. Dependency declarations are not separate installations or repeated setup calls.
- **Deleting unused plugin/dependency declarations or installed directories:** explicitly prohibited. Unused components use cond=false; existing inactive alternatives remain available, and disabled installed repositories received updates.
- **Snacks:** a possible future consolidation of picker/dashboard/terminal/notifier/indent/image/Git helpers, but it changes workflows and requires selecting modules. The agreed baseline preserves current tools; adding overlapping replacements would not repair the identified bugs.
- **Blink:** optional completion migration with distinct source/snippet/Copilot/Avante integration requirements. nvim-cmp remains functional after repairing its graph and snippet behavior; no completion backend replacement was necessary.
- **Ruff:** optional Black/Flake8 replacement with project-rule/output implications. The current formatting/lint policy is preserved until that migration is deliberately chosen.
- **AI frontend consolidation or enabling MCPHub/native MCP tools:** the user has distinct Avante/CodeCompanion/Copilot Chat configuration. No preferred frontend/tool permissions were selected. All frontends remain; unused MCPHub is disabled, not removed.
- **Neogit/LazyGit or Oil/Neo-tree consolidation; replacing UFO with native folds:** these can coexist with distinct workflows. Their presence alone was not evidence that one should be replaced.
- **Updating or replacing the local Barbar development checkout:** the prior implementation scope explicitly preserves this separate repository. It remains at a49658503cceab4c45ac9f37c695de0554df4162. The portable fork fallback is pinned to a49658503cceab4c45ac9f37c695de0554df4162 (origin/configurable-filename-depth, same as the local checkout). Correction: it was first pinned to 539d73d, which is the fork's master and plain upstream (the merge base), so other machines would have lost `filename_depth` and the project-relative label cap. No fast-forward, reset, or local source edits were made.
- **Switching ts_ls to TypeScript 7's tsc server:** project toolchains have not been migrated to TypeScript 7. Keep ts_ls for the current configured toolchain rather than guessing project requirements.
- **Enabling Circom, debugger adapters, Copilot NES, or new mini.ai/mini.surround operations:** these are feature decisions without a demonstrated configured need. Their existing declarations/configurations remain where present.
- **Removing the Kulala/lualine patch:** a real winbar ownership fix. It passes a local guard check; removing it needs backend-enabled UI evidence, which is pending licensing.
- **Automatic format-on-save and automatic Mason package upgrades:** not requested and would alter established editing/project behavior. Plugin updates do not silently change every language tool binary.

The implemented conceptual changes were not limited to tiny edits: Treesitter, Colorful Winsep, AI command dependencies, LSP activation, mapping ownership, and Kulala's backend interface were deliberately migrated. The exclusions above follow the user's constraints or the agreed optional scope, rather than a blanket preference to avoid substantial work.

### Node/Deno regression correction

The selected upstream denols callback searches Deno markers but does not compare Node lockfiles. In a Deno project containing a deeper Node package, ts_ls correctly selects the deeper Node package while denols also selects its parent Deno project. The acceptance fixture reproduced this overlap. The existing denols override now captures the native callback and filters its result when a nearer package-lock.json/yarn.lock/pnpm-lock.yaml/bun.lockb/bun.lock exists. Equal-depth Deno markers still win; standalone Deno/Node and both nesting directions pass. This is a native `(bufnr, on_dir)` wrapper, not the old filename-returning root_pattern function.

### Build and acceptance results

- Lua syntax: all 101 Lua files compile; final syntax/whitespace checks performed after repairs and formatting.
- Existing and newly created Lua files: real LuaLS attachment, completion/snippet capability, and buffer rename shortcut passed. Upstream Deno/TypeScript attachment hooks are preserved. Circom remains disabled.
- Root fixtures: Node-only, Deno-only, Deno within Node, and Node within Deno passed after the narrow guard above.
- AI file references: encoded URI with spaces/#, extreme cursor positions, project-relative links, unsaved buffer reuse, and a split when only a sidebar exists passed. Sidebar contents were retained.
- Treesitter: selected parsers built/updated; Lua, Rust, TS/TSX, Python, TOML, and Markdown queries parse correctly. Dependencies also install ecma/jsx/html_tags. UFO fold actions passed.
- Telescope: fzf-native, frecency, media_files, and ui-select loaded; file picker and Trouble integration passed. Existing fzf-native build remained compatible with unchanged extension revision.
- Completion: cmp/autopairs initialized, LuaSnip jumps forward/back, and InsertLeave preserves snippet state. Remote AI/completion requests were not made; the test prevents Copilot attaching to fixture buffers.
- Avante: Cargo built all four current libraries; native modules require successfully, command registration and explicit approval/history settings passed. CodeCompanion CLI and CopilotChatReset commands register. Copilot Chat's optional tiktoken build was already current.
- Terminals: dynamic size calculations work without an attached UI; a floating terminal opened and closed.
- Terminal UI: actual UIEnter/VeryLazy startup ownership passed; Scope initialized, and unused alternatives remained inactive. Oil/Neo-tree first use passed. Harpoon, Neogit/Telescope integration, and Dbee setup passed.
- Icons and Kulala winbar: real devicons, Barbar commands, and preserving the HTTP result winbar passed. New Kulala HTTP grammar was fetched/built and parsed a local request without invoking its backend/license flow.
- HTTP demo: four post-request scripts pass against mocked responses using Node's VM. No real HTTP requests were issued.
- ImageMagick is installed. Inline image rendering still needs a compatible real user terminal; redirected test output produced a terminal-size warning, not a production configuration repair requirement.

Meaningful checks were run once per group; retries addressed actual dependency/root failures and test-harness assumptions. A duplicated habamax fallback in Lazy's merged options made an overly strict test assertion fail; the final test checks fallback availability, which is the intended behavior. No repeated benchmarking or broad test campaign was performed.

Manual acceptance remaining: authenticate/use the user's AI services (Codex ACP/CLI, Ollama, Copilot/Copilot Chat) with their own credentials; activate Kulala Core with a valid license token and check local HTTP execution/formatting/response tabs; evaluate images in the actual terminal. Credentials were not rotated, tokens were not created, and licensing/purchases were not accepted. Kulala's old binary/history is backed up and retained, but its incompatible old binary is not forced into the new release.

A repository .stylua.toml gives future edits the same tab indentation/double-quote style. Only edited Lua files were formatted. No original Lua file was removed or relocated. Runtime logs were kept outside the repository during testing.

## 8. Installed revision record

The table covers every originally installed repository, plus Avante's two new required dependencies. Full target SHAs are recorded in lazy-lock.json and the saved upgrade-results.json artifact. Local Barbar and its separate portable fallback are described above and are not counted as a managed plugin upgrade.

| Plugin | Selected track | Before | After | Result |
| --- | --- | --- | --- | --- |
| Comment.nvim | master | e30b7f20 | e30b7f20 | current |
| CopilotChat.nvim | main | 2db7b404 | 004ced05 | updated |
| LuaSnip | v2.5.0 | 642b0c59 | 642b0c59 | current |
| alpha-nvim | main | 6c6a89d5 | 4ba26e41 | updated |
| avante.nvim | main | 98547000 | 4f496566 | updated |
| catppuccin | main | 8edd468a | edefef77 | updated |
| cmp-buffer | main | b74fab36 | b74fab36 | current |
| cmp-cmdline | main | d126061b | d126061b | current |
| cmp-nvim-lsp | main | cbc7b02b | cbc7b02b | current |
| cmp-nvim-lua | main | e3a22cb0 | e3a22cb0 | current |
| cmp-path | main | c6424870 | c6424870 | current |
| cmp_luasnip | master | 98d9cb5c | 98d9cb5c | current |
| codecompanion.nvim | v19.27.0 | 60d03186 | 6794c8bc | updated |
| colorful-winsep.nvim | main | 7bbe4e13 | 6134b5cd | updated |
| conform.nvim | master | 619363c3 | 016802de | updated |
| copilot-cmp | master | 15fc12af | 15fc12af | current |
| copilot-lsp | main | 1b6d8273 | 1b6d8273 | current |
| copilot.lua | master | 7b89909d | b4bf055b | updated |
| diffview.nvim | main | 4516612f | 4516612f | current |
| focus.nvim | master | 36ebedee | 36ebedee | current |
| friendly-snippets | main | 6cd7280a | b4d01b0f | updated |
| fzf-lua | main | fea9eedc | 48d7c3db | updated |
| gitsigns.nvim | main | dd3f588b | 851a051e | updated |
| harpoon | harpoon2 | 87b1a350 | 87b1a350 | current |
| hererocks | master | 3db37265 | 5d77b0ba | updated |
| image.nvim | master | 44e07129 | 365e2ace | updated |
| img-clip.nvim | main | b6ddfb97 | 99848daf | updated |
| indent-blankline.nvim | master | d28a3f70 | f1e186e4 | updated |
| kulala.nvim | main | b92e6e96 | 1517fd87 | updated |
| lazy.nvim | main | 306a0552 | 306a0552 | current |
| lazydev.nvim | main | ff2cbcba | ff2cbcba | current |
| lazygit.nvim | main | a04ad0db | 9ffc6103 | updated |
| lspkind.nvim | master | c7274c48 | c7274c48 | current |
| luafilesystem | master | a186cca5 | 146ab458 | updated |
| lualine.nvim | master | 131a558e | 221ce6b2 | updated |
| mason-lspconfig.nvim | main | 7b01e297 | e17625cd | updated |
| mason.nvim | main | bb639d4b | 2a6940af | updated |
| mcphub.nvim | main | 7cd5db33 | 7cd5db33 | current |
| mini.icons | v0.18.0 | ff2e4f1d | e56797f9 | updated |
| mini.pick | main | 4522d9ab | 8dbbb2c5 | updated |
| neo-tree.nvim | v3.x | ebd66767 | 1a140830 | updated |
| neogit | master | 99326a13 | 70708be9 | updated |
| noice.nvim | main | 7bfd9424 | 7bfd9424 | current |
| nui.nvim | main | de740991 | 10fc3618 | updated |
| nvim-autopairs | master | 7b9923ab | 3172f40c | updated |
| nvim-cmp | main | a1d50489 | 2ffe79f1 | updated |
| nvim-dap | master | 53177153 | cfa2d58f | updated |
| nvim-dbee | master | dda51769 | dda51769 | current |
| nvim-lint | master | d48f3a76 | f6230a5c | updated |
| nvim-lspconfig | master | a4ed4e76 | c59fc922 | updated |
| nvim-notify | master | 8701bece | 8701bece | current |
| nvim-treesitter | main | cf12346a | 1a4f47b0 | updated |
| nvim-ufo | main | ab3eb124 | ab3eb124 | current |
| nvim-web-devicons | master | 0d7d35fa | 58447c1f | updated |
| oil.nvim | master | b91ee5a7 | b73018b7 | updated |
| plenary.nvim | master | 74b06c6c | 74b06c6c | current |
| popup.nvim | master | b7404d35 | b7404d35 | current |
| promise-async | main | 119e8961 | 119e8961 | current |
| render-markdown.nvim | main | 5adf0895 | 8e879536 | updated |
| scope.nvim | main | 228aabdb | 228aabdb | current |
| telescope-frecency.nvim | 1.2.2 | d4f1bb2a | d4f1bb2a | current |
| telescope-fzf-native.nvim | main | b25b749b | b25b749b | current |
| telescope-media-files.nvim | master | 0826c7a7 | 0826c7a7 | current |
| telescope-ui-select.nvim | master | 6e51d7da | 6e51d7da | current |
| telescope.nvim | v0.2.2 | a0bbec21 | 5255aa27 | updated |
| todo-comments.nvim | main | 31e3c38c | 31e3c38c | current |
| toggleterm.nvim | v2.13.1 | 50ea089f | 50ea089f | current |
| trouble.nvim | main | bd67efe4 | bd67efe4 | current |
| ts-comments.nvim | main | 123a9fb1 | a59d6092 | updated |
| vim-illuminate | master | 0d1e9368 | 1cc33d34 | updated |
| which-key.nvim | main | 3aab2147 | 3aab2147 | current |
| window-picker | v2.4.0 | 6382540b | 6382540b | current |
| mega.cmdparse | required new dependency | new | 47ea5b1b | installed |
| mega.logging | required new dependency | new | 194ad8c3 | installed |

## 8a. Post-review corrections

- **Conform/nvim-lint keys were never wired.** `conform.keys` and `nvim_lint.keys` existed but `plugins/diagnostics/init.lua` did not pass them to the specs. Conform had no other trigger (no event/cmd, `defaults.lazy = true`), so it never loaded and `<leader>fm` was unmapped; `<leader>ll` was unmapped too. Both specs now set `keys = ...`; Conform also gets `cmd = { "ConformInfo" }`. Verified: `<leader>fm` loads Conform and lists stylua for Lua.
- **Runtime Neovim version.** The earlier acceptance ran `/opt/homebrew/bin/nvim` (0.12.6), but the user's PATH puts bob's `~/.local/share/bob/nvim-bin` first, and bob was on 0.11.7. Under 0.11.7, Avante aborts startup ("Avante requires at least nvim-0.12") and Treesitter `main` is unsupported. bob 4.2.0 defaults to `~/Library/Application Support/bob` on macOS, while the user's PATH and `~/.local/share/bob/env/env.sh` use `~/.local/share/bob`. `~/Library/Application Support/bob/config.json` now sets `downloads_location`/`installation_location` to the `~/.local/share/bob` paths, and `bob use 0.12.6` (latest stable) was run. 0.11.7 remains installed for rollback. Homebrew's neovim 0.12.6 is still installed but shadowed on PATH.
- **Treesitter parsers.** `M.parsers = "all"` was already restored, but only 24 parsers had been built and the background `install_missing_once()` only runs in an interactive UI. `install("all")` was run headlessly to build all of them: 297/297 languages installed with Neovim 0.12.6 and tree-sitter-cli 0.27.1. The `treesitter-install-all.done` stamp was written so the interactive background pass does not rerun.

- **Kulala activation and HTTP formatting.** The user entered the license token through Kulala's prompt: `~/Library/Application Support/kulala-core/license-token` exists with 0600 permissions, and `stdpath("data")/kulala.nvim/bin/kulala-core` is 1.3.1 (`version.txt`), matching `Globals.BACKEND_VERSION`. A request against a local `python3 -m http.server` returned 200 and rendered in the `kulala_ui` buffer. However, `kulala-core-lsp` does not advertise `textDocument/formatting`, so the earlier `http = { lsp_format = "prefer" }` did nothing (`[LSP] Format request failed, no matching language servers`). Kulala's README still points to the separate kulala-fmt. `http` now uses Conform's built-in `kulala-fmt` (same command/args as the original custom formatter), and `kulala-fmt` is back in `mason/settings.lua` `ensure_installed`. Verified: `<leader>fm` normalizes a messy request (separator spacing, header casing, JSON body).

- **Icon provider reverted to mini.icons.** The migration disabled mini.icons and made real nvim-web-devicons the provider, claiming the Barbar fork needs the "full API". Barbar only calls `get_icon(name, ext, { default = true })`; across lualine, neo-tree, telescope, alpha, avante, oil and trouble only `get_icon`, `get_icon_by_filetype`, `setup` and `has_loaded` are used, all covered by `MiniIcons.mock_nvim_web_devicons()`. The user reported misplaced/overlapping tab icons on both 0.11.7 and 0.12.6 (so not the Neovim update). Barbar's computed layout widths were identical across versions. mini.icons is enabled again (`cond = false` removed); `mini-icons.lua` gains an `init` that sets `package.preload["nvim-web-devicons"]` to install the mock on first require, so the mock wins regardless of load order. The `nvim-web-devicons` dependency Codex added to Barbar was removed (not in the original spec); alpha's and other consumers' declarations are unchanged. The user still needs to confirm the visual result in iTerm2 (FiraCode Nerd Font, non-Mono).
- **Comment.nvim re-enabled.** It was active before the migration (default `setup()`), so disabling it removed `gb`/`gbc`/`gco`/`gcO`/`gcA`, which native `gc` lacks. Restored as before: Comment.nvim plus ts-comments.
- **Deleted comments restored.** The migration removed ~200 comment lines, including commented-out code the user kept. Restored: section headers for mappings still in `configs/mappings.lua` and the commented `<C-b>`/`<C-e>`/`nomap` lines; Barbar's commented `BufferGoto 2-9` lines and command notes beside `barbar.lua` `M.keys`; the commented Bufferline test mappings at the end of `bufferline/bufferline.lua`; the commented old nvim-cmp config after `return M` in `nvim-cmp.lua` (verbatim); the commented `M.handlers` block in `lspconfig/init.lua`; the lualine `hl_group` notes. Comments describing code that was replaced (old winsep options, the old mason-lspconfig loop, leader setup moved to options.lua) were not restored. The terminal escape description is back to its original text.
- **Barbar fork synced (separate repo, user-requested).** `~/projects/lua/barbar.nvim`: added an `upstream` remote (romgrk/barbar.nvim), fast-forwarded local `master` to upstream 337ecfa (tracking origin/master), and merged upstream into `configurable-filename-depth` with a merge commit (3aa77e1, no conflicts; no rebase, so PR #661's history is intact). Nothing pushed. The config's fallback `commit` still pins a496585 (the pushed branch head); update it to the merge commit only after pushing.

- **Catppuccin integrations pinned to the pre-update set.** catppuccin 8edd468a → edefef77 includes 058e83d `fix!: remove default_integrations`, which also makes `auto_integrations = true` the default. Detection (lazy plugin names → integration mappings) enabled the barbar integration, which sets `Buffer{Current,Visible,Inactive}Sign` to `fg = blue` on the tab background. That suits Barbar's default `▎` sign but breaks the `slanted` preset, whose U+E0BC/U+E0BE separators need `fg = fill bg` and `bg = tab bg` (Barbar's own BufferDefault*Sign groups). Previously barbar was not in catppuccin's default set, so Barbar computed its own colours. The colorscheme spec now passes `opts` with `auto_integrations = false` and the exact old default `integrations` table copied from 8edd468a, then calls `setup(opts)` before `colorscheme catppuccin-macchiato`. Verified: barbar integration nil; BufferCurrentSign fg #1e2030 on bg #24273a; colorful_winsep integration disabled. When nvim-cmp → blink.cmp happens, `blink_cmp` is already in this list.

## 8b. nvim-cmp → blink.cmp migration

Inventory: every installed plugin was scanned for `require("cmp")`, `cmp_nvim_lsp`, nvim-cmp references and blink integrations. Consumers and what each now uses:

| Consumer | Before | Now |
| --- | --- | --- |
| Completion engine (`plugins/nvim-cmp`) | nvim-cmp, InsertEnter | `plugins/blink-cmp/` (new folder, same init.lua + module pattern): `saghen/blink.cmp` `version = "1.*"` (release tags give prebuilt fuzzy binaries; 1.10.2 / 78336bc), InsertEnter, deps LuaSnip, lspkind, blink.compat. nvim-cmp spec `cond = false`, opts kept. |
| cmp sources | cmp_luasnip, cmp-nvim-lsp, cmp-buffer, cmp-path (+ already-disabled cmp-nvim-lua/cmp-cmdline) | `cond = false` on each dependency entry. blink built-ins lsp/buffer/path, `snippets.preset = "luasnip"`. |
| Copilot | copilot-cmp | copilot-cmp `cond = false`; new `fang2hou/blink-copilot` spec in `plugins/copilot/` (`blink-copilot.lua` module, depends on copilot.lua, lazy). Not a blink dependency on purpose: blink loads at the first LSP capabilities request (BufReadPre), and making blink-copilot a dependency would start Copilot then instead of InsertEnter. blink's `module = "blink-copilot"` triggers Lazy's module autoload on first use. `async = true`, no score_offset (copilot-cmp had no priority either). |
| lazydev | `{ name = "lazydev", group_index = 0 }` | `per_filetype.lua = { inherit_defaults = true, "lazydev" }`, provider `lazydev.integrations.blink`, `score_offset = 100` (lazydev README). lazydev's own cmp auto-registration with the blink.compat shim is harmless. |
| LSP capabilities (`lspconfig/init.lua`, `diagnostics/init.lua`) | `require("cmp_nvim_lsp").default_capabilities()`, dep cmp-nvim-lsp | `require("blink.cmp").get_lsp_capabilities()` (+ existing utf-16 positionEncodings), dep `saghen/blink.cmp`, cmp-nvim-lsp `cond = false`. Explicit rather than relying on blink's plugin-file `vim.lsp.config("*")` merge, since servers start before InsertEnter. Verified snippetSupport/labelDetailsSupport on lua_ls and typos_lsp. |
| nvim-autopairs | dep nvim-cmp + `cmp.event:on("confirm_done", …)` | dep `{ "hrsh7th/nvim-cmp", cond = false }`; hook kept but guarded by `lazy.core.config.plugins["nvim-cmp"]._.loaded`. A `pcall(require, "cmp")` guard would be wrong: blink.compat ships a `cmp` shim (with `cmp.event`). Brackets on accept: blink `completion.accept.auto_brackets`. |
| lspkind | cmp formatter | Still enabled; `kind_icon` component uses `lspkind.symbol_map[ctx.kind]` (Copilot `` via `lspkind.init`). |
| Avante | dep nvim-cmp; `avante/init.lua` registers avante_commands/mentions/prompt_mentions/shortcuts via `require("cmp")` and calls `cmp.setup.filetype` | deps `{ "hrsh7th/nvim-cmp", cond = false }`, blink.cmp, `saghen/blink.compat` (2.*; its `cmp.setup.filetype` is a no-op). Providers `module = "blink.compat.source"` with avante README's score offsets; `per_filetype.AvanteInput = { avante_commands, avante_mentions, avante_shortcuts }`, `AvantePromptInput = { avante_prompt_mentions }`, matching Avante's old `cmp.setup.filetype` (its `avante_files` entry is never registered by current Avante, so omitted). Verified all four registered. Kaiser-Yang/blink-cmp-avante was not used (separate reimplementation, last updated 2025-07). |
| CodeCompanion | auto-detects; cmp provider when cmp present and blink absent | Auto-selects `blink` (verified) and self-registers its provider and codecompanion filetype sources. No config change. |
| Noice | `lsp.override["cmp.entry.get_documentation"] = true` | `false` with note (override is attached only if `cmp.entry` loads; blink highlights docs with Treesitter). |
| Highlights (`configs/autocmds.lua`) | CmpItemKindCopilot | Kept, plus BlinkCmpKindCopilot (same `#6CC644`). Catppuccin already pins `cmp` and `blink_cmp = { style = "bordered" }` integrations. |
| CopilotChat, Kulala, render-markdown, Dbee, fzf-lua (disabled), mcphub (disabled) | — | No change: CopilotChat uses its own omnifunc; Kulala completes through its LSP (and has a blink workaround); render-markdown completions were and stay off; Dbee has no completion integration. |

Behavior mapping: keymap `preset = "none"` with the old keys only. `<Tab>`: `select_and_accept` when the menu is visible, else `luasnip.expand_or_locally_jumpable()` → `expand_or_jump` (scheduled, since blink keymaps are `expr`), then `snippet_forward`, then fallback. `snippet_forward`/`snippet_backward` are listed because blink only installs select-mode mappings for keys that contain a snippet command; without them Tab/S-Tab would not jump from a selected LuaSnip placeholder (verified: expand → `<Tab>` selects 2nd placeholder → `<S-Tab>` back to 1st, mode `s`). Sorting: `{ "exact", "score", cmp_kind, "sort_text", cmp_length }` where `cmp_kind`/`cmp_length` reproduce nvim-cmp's comparators (Snippet first, Text last); recently_used/locality map to blink's frecency/proximity inside `score`; offset/order have no blink equivalent. Selection: preselect + auto_insert (nvim-cmp `select_next_item` default Insert behaviour, `completeopt = menu,menuone`). `lsp.fallbacks = {}` keeps buffer items alongside LSP as in nvim-cmp's single group. Menu: rounded border, old Pmenu winhighlight, no scrollbar, padding 0, label max 50, source-icon column (unmapped sources show their name, as before). Docs: auto-show with 0 ms delay, old (undefined) CmpDoc winhighlight kept for identical look. `cmdline.enabled = false`, `signature.enabled = false`, ghost text on.

## 8c. Copilot NES, CopilotChat removal, enabled-for-later plugins

- **NES.** `copilotlsp-nvim/copilot-lsp` enabled as copilot.lua's dependency with `init = copilot_lsp.init` (sets `vim.g.copilot_nes_debounce = 500`, moved from the top of `copilot.lua`; copilot.lua's README says copilot-lsp settings belong in its `init`). copilot.lua `nes = { enabled = true, keymap = { accept_and_goto = "<Tab>", accept = false, dismiss = "<Esc>" } }`; `auto_trigger` left at its default (copilot-lsp requests on debounced TextChanged/TextChangedI regardless, and copilot.lua's `nes_set_auto_trigger` path looks broken upstream). copilot.lua registers these buffer-local Normal-mode maps with passthrough: it saves the existing map (your global `<Esc>` → `:noh` callback) and calls it when there is no suggestion; `<Tab>` with no previous map returns itself (native `<Tab>`/`<C-i>`). Verified: nes initialized with the `copilot` client attached, both maps present, `<Esc>` still clears `v:hlsearch`. Whether suggestions actually appear depends on the user's Copilot plan. copilot.lua v3 already runs GitHub's official Copilot language server binary (`server.type = "binary"`), so copilot.vim or a bare `copilot_ls` setup was not adopted; folke/sidekick.nvim is an active NES alternative but would mean a separate Copilot LSP setup.
- **CopilotChat removed (user request).** Spec deleted from `plugins/copilot/init.lua`, `copilot-chat.lua` deleted, installed `CopilotChat.nvim` (with its tiktoken build) deleted, lockfile entry removed. Earlier notes mentioning CopilotChat (CopilotChatReset lazy command, tiktoken) are historical.
- **popup.nvim deleted (user request).** No installed plugin requires `popup`; Telescope 0.2 does not use it. Dependency line, installed directory and lockfile entry removed.
- **Bufferline removed (user request).** `plugins/bufferline/` deleted (spec, opts, and the commented Bufferline test mappings restored in 8a). It was never installed and had no lockfile entry.
- **Enabled for later configuration (user request):** fzf-lua (Neogit optional dep; Neogit keeps `integrations.fzf_lua = false`; CodeCompanion's picker detection tries Telescope first and Avante pins Telescope, so no picker changes), nvim-dap (Telescope dep), mcphub (CodeCompanion dep; its plugin file only defines `:MCPHub` and highlights unless `vim.g.mcphub` is set; the `mcp-hub` binary is not installed). Each has a `TODO:` comment for todo-comments. mini.pick stays disabled (not requested).
- **luafilesystem removed (user request).** `plugins/luafilesystem/` deleted, plus `lazy/luafilesystem`, `lazy-rocks/luafilesystem` and its lockfile entry. No code required `lfs` (conform already used `nvim_get_runtime_file`). Startup verified clean.
- **mini.pick removed (user request).** It was one of Neogit README's "only one of these is needed" pickers; dependency line, installed directory and lockfile entry removed. Neogit's `integrations.mini_pick = false` is kept (it only disables the integration).
- Still disabled: the nvim-cmp family (kept until the user is comfortable with blink), winshift (kept by request; never installed).

- **copilot-lsp removed afterwards (user request).** Last code commit 2025-12-30, 17 open issues, NES marked experimental by both copilot-lsp and copilot.lua. Dependency and `copilot-lsp.lua` deleted, installed directory and lockfile entry removed; the `nes` block in `copilot.lua` is back to the user's original commented form, and the debounce global is commented out. Future NES option: folke/sidekick.nvim, which needs Copilot as a native `vim.lsp.enable("copilot")` server (Mason `copilot-language-server`, `:LspCopilotSignIn`) and therefore replacing copilot.lua; blink-copilot supports that server.

## 8d. Version policy (user request)

Policy: `defaults.version = false` in `configs/lazy.lua` (follow the default branch head). Plugins that actively publish releases set `version = "*"`, which has no major-version ceiling. lazy.nvim's `get_target` applies `defaults.version` only when a spec has neither `version` nor `branch`, and falls back to the branch head when no semver tag exists.

Classification was measured from the installed repositories (latest semver tag via `lazy.manage.git.get_versions`, commits from that tag to `origin/HEAD`, tag date). "Actively releasing" = newest release within about 12 months **and** within about 30 commits of the default branch. Stale-release projects follow main, because applying `"*"` to them would have downgraded working code by up to 889 commits (fzf-lua 0.7), 498 (nvim-treesitter v0.10.0, pre-rewrite master API), 233 (neogit v3.0.0) or 123 (nvim-web-devicons v0.100), and their post-release commits include Neovim 0.11/0.12 fixes.

- `version = "*"`: LuaSnip, blink.cmp (240 commits after v1.10.2, but releases are required for prebuilt fuzzy binaries), catppuccin (v2.0.0 predates 058e83d; the pinned `auto_integrations = false` + explicit list works on both, verified Barbar sign highlights), codecompanion, copilot.lua, image.nvim, indent-blankline, kulala, mason, mason-lspconfig, mini.icons, neo-tree (was `branch = "v3.x"`), nvim-lspconfig, oil, render-markdown, telescope (29 after v0.2.2), todo-comments, window-picker.
- Moved from `"*"` to `version = false` with a dated comment: toggleterm (v2.13.1, Dec 2024), telescope-frecency (1.2.2, Sep 2025; converted `file_frecency.bin` to `file_frecency_v2.bin`, v1 kept), blink.compat (v2.5.0, Mar 2025).
- Branches kept: nvim-treesitter `main` (required), harpoon `harpoon2`, colorful-winsep `main` (no tags). Avante `version = false` (upstream: never `"*"`). Barbar: local dir; the fallback `commit` pin is unchanged.
- Everything else (including dependency-only plugins such as plenary, nui, promise-async, mega.*, hererocks) inherits the default and follows its branch. lazy.nvim itself is unchanged.
- Applied with a full `require("lazy").update()`: 11 lockfile changes (blink.compat, catppuccin, image.nvim, lazydev, mason-lspconfig, neo-tree, nvim-lspconfig, oil, render-markdown, telescope-frecency, toggleterm), no errors. Re-verified: Treesitter + LSP on Lua/TS/Python/Markdown, Barbar slanted sign highlights, kulala-fmt formatting, a local Kulala request (200), blink sources (lsp/buffer/copilot) and all completion keys including select-mode snippet jumps.
- An earlier targeted `lazy.update({ plugins = ... })` silently applied nothing because one name was wrong (`nvim-window-picker`; the plugin name is `window-picker`).

## 8e. Shortcut conflict fixes (user-approved)

- Avante: `<leader>ian` = new ask (function `require("avante.api").ask({ new_chat = true })`, n+x, also loads Avante), `<leader>iaN` = `AvanteChatNew`, zen mode `mappings.zen_mode = "<leader>iaz"` (default `<leader>az` made `<leader>a`, Harpoon add, wait `timeoutlen`). `behaviour.auto_set_keymaps = false`, because Avante's `safe_keymap_set` only skips a key when a lazy key handler has the same lhs in the same mode, and its ask/new_ask/zen/edit use mode `"v"` (x+s). The four keys it added that the config lacked are now lazy keys with `remap = true` to Avante's `<Plug>` maps: iad (ToggleDebug), iaC (ToggleSelection), iaS (ToggleSuggestion), iaB (AddAllBuffers).
- LSP: user maps `gi`, `gr`, `<leader>rn`, `<leader>ca`, `<leader>D` commented out in favour of Neovim 0.11+ defaults `gri`, `grr`, `grn`, `gra`, `grt`. This removes the `gr` prefix wait and restores built-in `gi`. `gd`, `gD`, `gh`, `<leader>sh`, workspace maps kept.
- Select-mode leakage: every user/plugin mapping that used `"v"` now uses `"x"`: `mappings.lua` window keys and `<`/`>`; the duplicate `"v"` `<A-j>/<A-k>` are commented out (the `"x"` versions already existed); gitsigns `<leader>hs/hr`; CodeCompanion; Avante `iaa`/`iae`. Kulala's defaults "Send request", "Send request <cr>" (ft http/rest) and "Send all requests" use `{ "n", "v" }`; `global_keymaps` is now a table overriding just those three by name with `{ "n", "x" }` (Kulala applies `global_keymaps_prefix` only to its defaults, so the overrides carry full lhs). Verified: the only remaining select-mode maps are Neovim's own `<Tab>`/`<S-Tab>` (vim.snippet) and `<C-S>` (plus blink's buffer-local snippet keys on InsertEnter).
- Insert `<C-h/j/k/l>`, Visual `J`/`K` and Visual `p` (`"_dP`) commented out at the user's request (built-ins restored; Visual `P` replaces the `p` trick).

- Code lens: `M.on_attach` (lspconfig/init.lua) now receives the client and, when it supports `textDocument/codeLens`, calls `vim.lsp.codelens.enable(true, { bufnr })` (Neovim 0.12 API) and maps buffer-local `<leader>lc` to toggle via `is_enabled({ bufnr = 0 })`. Verified with rust-analyzer on a cargo test crate: 5 lenses (Run Tests/Debug, Run Test/Debug, one lazily resolved), toggle off/on works.
- Barbar pin `<A-p>` → `<leader>bp`. vim-illuminate only creates `<a-n>`/`<a-p>` in its plugin file when `has_keymap` is false, so `<A-n>`/`<A-p>` are now explicit lazy keys in `illuminate/vim-illuminate.lua` (`M.keys`, wired in its spec).
- Harpoon: `<leader>a` → `<leader>ja`, `<leader>hi` → `<leader>jj` in both the config maps and the lazy key stubs; no other `<leader>j` keys exist. `<leader>1`–`4` jumps intentionally not added (user will add if needed).

## 8f. Plugin review follow-ups

- telescope-frecency mapped at `<leader>fr` (`Telescope frecency`); it was loaded via `load_extension` but had no key.
- gitsigns lazy keys renamed `<leader>h{s,r,S,u,R,p,b,d,D}` → `<leader>g…` (11 entries incl. the two Visual `x` ones). Only other `<leader>g` key: `<leader>gt` (Telescope git_status).
- image.nvim (`plugins/image/init.lua`): `cond` from terminal detection (`KITTY_WINDOW_ID`, `TERM` xterm-kitty/xterm-ghostty, `TERM_PROGRAM` ghostty/WezTerm → `kitty`; `TERM_PROGRAM == "iTerm.app"` or `WT_SESSION` → `sixel`; otherwise disabled). `processor = "magick_cli"` (README default in this version; needs the `magick` CLI, present via Homebrew). Verified: neo-tree loads with image.nvim enabled and disabled; headless runs no longer emit image.nvim terminal-size noise when TERM_PROGRAM is unset. Inside tmux TERM_PROGRAM becomes `tmux`, so image.nvim stays off there until tmux passthrough is configured. Visual rendering in iTerm2 with Sixel is unverified (user to check).
- nvim-surround added (`plugins/nvim-surround/`, `version = "*"` → v4.0.5, VeryLazy, default keymaps). Verified ysiw", cs"', ds'.
- Decisions recorded: keep focus.nvim (user enables it per project), scope.nvim, Comment.nvim (better per-language results than built-in gc), both Neogit and LazyGit, both Avante and CodeCompanion, Dbee.

## 8g. Neo-tree proportional layout

`plugins/neo-tree/keep-layout.lua`, wired through neo-tree `event_handlers` (`neo_tree_window_before_open`, `after_open`, `before_close`, `after_close`) plus a `WinClosed` autocmd for closing the tree with `:q`, which skips neo-tree's close events. Sidebar positions only (left/right); float/current are ignored. `equalalways` stays false (true would equalize every window).

- before_open: store widths of scalable windows (non-float, not neo-tree, not `winfixwidth`) and the free width = `columns` minus top-level-row fixed leaves (tree / winfixwidth) incl. separators.
- after_open: `vim.schedule` (after neo-tree sizes its own window), scale stored widths by `free_now / free`, apply left-to-right by window column in two passes (Vim gives each difference to the next window), store the resulting widths.
- before_close / WinClosed: capture widths while the tree is still in the layout. Measuring after close is wrong because Vim has already given the tree's columns to a neighbour; that produced 92/8/98 instead of 40/60/98 in testing.
- restore (after_close / scheduled WinClosed): if the captured widths equal the post-open widths, apply the original widths exactly; otherwise scale the captured widths by `free_now / free_closing`.
- Verified headless at 200 columns: 50/50, 70/30, three columns, stacked left + right, a fixed 30-column right panel, resizing while open, and `:q`. All restore exactly except "resize while open", which keeps the new ratio. Open widths can differ by one column from the exact ratio because of rounding and separators.

## 8h. `nvim .` stray empty buffer

Reproduced in a real pseudo-terminal (VeryLazy needs a UI; the sandbox blocks `--listen` sockets, so the probe script ran inside Neovim and wrote its state to a file). With netrw disabled and neo-tree on VeryLazy, the folder buffer stayed until the user opened a file from the tree. neo-tree's `setup/netrw.lua` hijack is debounced: it fired from the BufEnter of the folder buffer when the tree moved into the main window to open the file, and its callback then replaced `dir_window`'s buffer with a new `nvim_create_buf(true, false)` without checking that the window already showed the file. Traced `BufNew` tracebacks to `netrw.lua:67`.

Fix: (1) neo-tree spec `init` requires `neo-tree` when `argc(-1) == 1` and `argv(0)` is a directory, so lazy.nvim loads it during startup and the hijack (open_default) runs before any interaction (the tree now opens automatically for `nvim <folder>`). (2) `configs/autocmds.lua` BufEnter (named, normal buffers) schedules deletion of listed buffers that are unnamed, `buftype == ""`, unmodified, a single empty line and in no window (the hijack placeholder Vim does not reuse). Verified: `nvim .` → Enter on a file leaves only that file listed and focused; `nvim file` and `nvim` unaffected.

Correction: an earlier note claimed plain `nvim` shows no Alpha dashboard. That was a test artifact: alpha's `should_skip_alpha()` skips when `v:argv` contains `-c`, which the probe used. A probe without `-c` (reading the rendered screen) shows the dashboard.

## 8i. Go-to-definition regression (lazydev) and `<C-]>` timeout

- Symptom: in `~/.config/nvim/lua/**`, `gd`/`<C-]>` on fields of the user's own modules (`toggleterm.keys`) found nothing; plugin modules (`require("lazy")`) and locals worked. lua_ls was attached (root `~/.config/nvim`).
- Cause: 8d moved lazydev from main (ff2cbcb) to `version = "*"` (v1.10.0 / 01bc2aa). In its `lua_root` mode lazydev sends `runtime.pathStrict = true`, `runtime.path = {"?.lua","?/init.lua"}`, `workspace.ignoreDir = {"/lua"}` and the config `lua/` as a library; with v1.10.0 own-module definitions return nothing. Isolated by forcing `require("lazydev.config").lua_root = false` (fixed) and by checking out origin/main temporarily (fixed with `lua_root` on). Resolution: lazydev back to `version = false` (main, ff2cbcb, as before 8d). The 8d rule ("release < 12 months and <= 30 commits behind") missed this; releases can lag real fixes.
- `<C-]>`: Neovim 0.12's `vim.lsp.tagfunc` calls `buf_request_sync(..., 'textDocument/definition', ...)` with the default 1000 ms timeout; the first library lookup in a session took ~1070 ms, so the tagfunc returned NIL and Vim fell back to tags files (E433). A buffer-local `<C-]>` → `vim.lsp.buf.definition` mapping was tried and verified (async, pushes the tagstack), then reverted at the user's request; it stays commented out in `M.on_attach`. Built-in `<C-]>` can still hit the 1 s limit on the first lookup of a session.

## 8j. Version policy replaced: follow each plugin's docs

8d's "release < 12 months and close to main" rule caused real downgrades (installed commits vs the pre-8d lockfile): neo-tree -44 (branch v3.x → tag), image.nvim -22, nvim-lspconfig -20, mason-lspconfig -20, catppuccin -16, oil -8, render-markdown -2, lazydev -7 (see 8i). It also left blink.cmp on `"*"`, whose README warns v2 is breaking (stay on `version = "1.*"` / `branch = 'v1'`), so v2 would have been installed on release.

Method: (A) version fields of every spec in the pre-Codex backup, (B) each repo's current GitHub README (install snippets), (C) current specs; plus installed commits (pre-Codex `installed-plugins.json`, pre-8d lockfile, current). Policy: docs recommendation > user's original setting > default branch (`defaults.version = false`).
- Docs/original restored: neo-tree `branch = "v3.x"`, LuaSnip `"v2.*"`, window-picker `"2.*"`, toggleterm `"*"`, telescope-frecency `"*"` (user's comment restored; the pre-migration `file_frecency.bin` is still read by the release), CodeCompanion `"^19.0.0"` (user's original; README gives none).
- Docs: blink.cmp `"1.*"`, blink.compat `"2.*"`, nvim-surround `"^4.0.0"`. mega.cmdparse/mega.logging README suggests `"v1.*"`, but they are Avante dependencies and stay on their default branch like Avante.
- Default branch (no docs version, none originally): catppuccin, image.nvim, nvim-lspconfig, mason, mason-lspconfig, oil, render-markdown, copilot.lua, kulala, indent-blankline, todo-comments.
- Kept: telescope `"*"` (README `version = '*'`; the original `branch = "0.1.x"` is a legacy branch), mini.icons `"*"` (README stable option), Avante `version = false` (README), harpoon `harpoon2`, treesitter `main`, colorful-winsep `main` (default branch).
- Note: image.nvim is `cond`-gated on the terminal, so `lazy.update()` from a headless run without `TERM_PROGRAM` skips it; it was updated with `TERM_PROGRAM=iTerm.app`.
- Verified after the full update: no installed plugin is behind the pre-8d lockfile; files/LSP/Treesitter, blink (sources, keys, snippet select-mode jumps, Avante compat sources, CodeCompanion provider), kulala-fmt, a local Kulala request, the neo-tree layout scenarios, the Barbar sign highlights, and own-module `gd` all pass.

- Stale-release override (user's heuristic): for every plugin pinned to a release or release branch, compared release date, commits on the default branch since that release, the last default-branch commit, and the release cadence. Moved to `version = false`: telescope.nvim (v0.2.2 2026-02-16; +29 on master through 2026-08-17 incl. `fix: vim.deprecation of vim.F`; master requires Nvim 0.11+) and telescope-frecency (1.2.2 2025-09-24; +6 incl. `fix: add shim for deprecated vim.F.npcall`, v2 database). Kept on releases: LuaSnip (releases every 4-6 months), neo-tree v3.x (releases every 1-3 months), CodeCompanion, nvim-surround, mini.icons (recent releases), toggleterm/blink.compat/window-picker (default branch also inactive), blink.cmp `1.*` (origin/v1 has nothing after v1.10.2; main is v2). Verified find_files, live_grep, frecency, the lazygit extension and ui-select; `checkhealth vim.deprecated` reports nothing for Telescope.

## 8k. Queued plugin changes

- **Alpha:** `startup/alpha.lua` sets `dashboard.section.buttons.val` to single-letter buttons for real commands (Telescope find_files/frecency/oldfiles/live_grep, AutoSession restore, Neotree focus, Neogit, LazyGit, Telescope find_files in stdpath("config"), Lazy, Mason, checkhealth, qa) and a footer with Neovim version + plugin count. Verified in a pseudo-terminal: the buttons render and `f` opens Telescope.
- **Big file:** `configs/autocmds.lua` adds `vim.filetype.add({ pattern = { [".*"] = { fn, { priority = math.huge } } } })`, returning `bigfile` when size > 1.5 MB or (size - lines) / lines > 1000 (the function returns nil once the filetype is already `bigfile`, so `vim.filetype.match({ buf })` inside the FileType handler still finds the real type). The FileType `bigfile` handler notifies, sets manual folds and conceallevel 0, detaches UFO (`provider_selector` also returns `""` for bigfile), disables ibl via `setup_buffer`, pauses illuminate, and sets `syntax` to the real filetype. An LspAttach handler detaches any client from bigfile buffers (typos_lsp attaches to every filetype). Verified: 2.4 MB JSON and 600 KB minified JSON → bigfile, no Treesitter/LSP; small JSON unchanged.
- **nvim-treesitter-textobjects** (`plugins/nvim-treesitter-textobjects/`, `branch = "main"` per README, lazy via keys, `select.lookahead`, linewise function/class, `move.set_jumps`): `af/if ac/ic aa/ia al/il` (x, o), `]f [f ]F [F` (n, x, o). It avoids `]]`/`[[`/`]m`, so `vim.g.no_plugin_maps` is not needed. Verified dif/daf/cia/]f/[f.
- **grug-far** (`plugins/grug-far/`, default branch; no releases): `<leader>fs` (n: prefill `<cword>`; x: `with_visual_selection`), `<leader>fS` (prefill `paths = expand("%")`), `cmd` GrugFar/GrugFarWithin; in-panel keys use `<localleader>` (`\`). Verified an end-to-end two-file rename via `inst:replace()`.
- **nvim-treesitter-context** (`plugins/nvim-treesitter-context/`, default branch; only release v1.0.0 2025-05, main active): `max_lines = 3`, `trim_scope = "outer"`; `<leader>tc` sets `require("treesitter-context.config").max_lines` through `vim.ui.input` (read on every update in `context.calc_max_lines`), then fires CursorMoved. No enable/disable key, as requested. Context is capped by the rows between the window top and the cursor (mode = cursor). Verified 3 → 1 lines.
- **auto-session** (`plugins/auto-session/`, `lazy = false` per README, default branch): `sessionoptions = "buffers,curdir,help,tabpages,winsize,winpos,localoptions"` (README recommendation minus blank/terminal/folds), `suppressed_dirs = { "~/", "~/Downloads", "/" }`, `bypass_save_filetypes = { "alpha" }`, `close_unsupported_windows = true`, `continue_restore_on_error = true`. Verified in a pty: `nvim .` → open 2 files + tree + terminal → quit → `nvim .` restores both files (tree re-opens through the neo-tree hijack, terminal not restored, no errors, no stray buffer) → plain `nvim` restores. The test session file was deleted.
- **Dbee → vim-dadbod-ui** (`plugins/vim-dadbod-ui/`; deps vim-dadbod and vim-dadbod-completion per README): `db_ui_save_location = stdpath("data") .. "/db_ui"`, `<leader>db` → DBUIToggle. nvim-dbee `cond = false`. Migrated the 2 connections from `~/.local/state/nvim/dbee/persistence.json` into `db_ui/connections.json` (file-to-file, mode 0600, URLs never printed) and copied `notes/<id>/ex.sql` to `db_ui/stack-overflow-db/ex.sql` (originals untouched). blink: `per_filetype.sql/mysql/plsql = { "snippets", "dadbod", "buffer" }`, provider `dadbod = { module = "vim_dadbod_completion.blink" }`. lualine winbar disabled for `dbui`/`dbout`. Verified: the drawer lists both connections and "Saved queries (1)"; the connection showed ✕ because the database server was not running.
- telescope-media-files removed (dependency, `load_extension`, installed directory, lockfile entry). `picture.png` (480×270, ImageMagick) added to the config root for image testing (not gitignored; delete after testing).

## 8l. auto-session restore error loop

- Symptom: `Error restoring session, disabling auto save.` on every start in `~/.config/nvim`; `picture.png` reopened after it was deleted.
- Cause: `sessionoptions` contained `localoptions`, so the session stored `setlocal filetype=image_nvim`, `nomodifiable`, `buftype=nowrite` and rendered lualine `statusline`/`winbar` strings (one embedded an image.nvim traceback with a literal tab). `default_restore_error_handler` returns false on any non-fold/help error, which disables auto-save, so the bad session file was never overwritten.
- Fix: `localoptions` removed from `sessionoptions` (`auto-session/auto-session.lua` `M.init`); stale `~/.local/share/nvim/sessions/%2FUsers%2F...%2Fnvim.vim` deleted.
- Test (pty): session saved with `a.lua` + `pic.png` split, image deleted, restart → no restore error, `a.lua` restored, session re-saved on quit.

## 8m. Review fixes (Codex review of 137031f)

- `grug-far.lua` `<leader>fS`: refuses buffers with `buftype ~= ""`, no name, or no file on disk (an empty `paths` prefill searched the whole cwd). Escapes only spaces (`\ `): `utils.splitPaths` unescapes only `\ `, so `fnameescape` would break names with `[ ] # %` (e.g. `[id].tsx`). Path is `:.`-relative.
- `neo-tree/keep-layout.lua`: closing used the top-level row only (`fixed_columns` returned 0 when the top level was a `col`, e.g. after `botright split`), so free width was wrong and `apply` gave the remainder to the last window. `capture` now finds the tree's parent row in `winlayout()` (`parent_row`), scales only that row's scalable leaves, and stores `free_after = row width - fixed + tree width + 1`; `restore` uses it. Open path unchanged (neo-tree opens as a top-level sidebar). pty test, 200 cols: 120/79 → tree 95/63 → `botright split` → close → 120/79 (old code: 95/104); plain open/close still exact.
- `autocmds.lua` placeholder cleanup: only when started with one directory argument, waits past the directory buffer itself, and removes its autocmd after the first real file (`return true`). pty test: `nvim .` placeholder reused/removed, a later `nvim_create_buf(true, false)` buffer survives.
- README: Dbee → dadbod requirements, Bufferline removed, all parsers, kulala-fmt, Comment.nvim keys, link to AGENTS.md. MIGRATION_NOTES header marks the file as historical.

## 8n. CONFIG_GUIDE.md and lost private-use icons

- `CONFIG_GUIDE.md` written from a full read of every file plus a pty session dump (`nvim_get_keymap` per mode with callback `debug.getinfo` sources, buffer-local maps on Lua/HTTP/SQL buffers, loaded plugins after VeryLazy, user commands, config augroups) and lazy's plugin table (80 plugins: 68 on, 11 off, image.nvim conditional). AGENTS.md: keep it current before each commit.
- Found while verifying: BMP private-use glyphs (U+E000–U+F8FF) were dropped when files were written by the assistant. `blink-cmp.lua` had `copilot = ""`, `lsp = ""`, lspkind `Copilot = ""` (nvim-cmp.lua still had U+F113 / U+EB50). `alpha.lua` had 9 empty button icons. Restored by code point: blink copilot/Copilot U+F113, lsp U+EB50; alpha e U+F15B, r U+F06D, s U+F0E2, n U+E702, l U+F126, c U+F013, m U+F0AD, h U+F21E, q U+F011 (4-byte U+F0000+ icons were intact). Per-file non-ASCII byte counts vs e70dfa0 checked: other differences are moves (diagnostic signs → diagnostics-commands.lua) or API migrations (winsep `symbols` → `border = "bold"`), not losses.

## 8o. Treesitter start requires highlight queries

- Symptom: `~/.tmux.conf` had no colours. `lazy/nvim-treesitter/parser/` (untracked, 249 MB) holds 320 parsers built by the old master branch; nvim-treesitter main installs to `site/parser`, which comes first on the runtimepath, so most languages use the new parsers. Only-old parsers: blueprint, fusion, hlsplaylist, ipkg, jsonc, kulala_http, muttrc, norg, problog, prolog, robots, tmux, verilog, zathurarc. main dropped hlsplaylist/muttrc/tmux/zathurarc in 78bebef1 (2026-07-18, upstream removed generated files). For those, `language.add` succeeded and `vim.treesitter.start` disabled regex syntax although no `highlights` query exists.
- Fix (`nvim-treesitter/nvim-treesitter.lua`): skip `vim.treesitter.start` when `#vim.treesitter.query.get_files(lang, "highlights") == 0`, so `syntax/<ft>.vim` stays active. Not affected: jsonc (`get_lang("jsonc") == "json"` via nvim-treesitter), verilog (→ systemverilog), kulala_http (Kulala installs its queries into `site/queries`).
- The old parser folder is kept: Kulala's `kulala_http.so` exists only there.
- Test: `.tmux.conf` → treesitter off, `b:current_syntax = tmux`; `.jsonc`, `.lua`, `.http` → treesitter on.

## 8p. Lazy checker without notifications

- `configs/lazy.lua`: `checker = { enabled = true, notify = false }` (was `{ enabled = true }` since the first commit). Since the version rule moved most plugins to their default branch (sections 8d/8j), the hourly check (`frequency = 3600`) found updates on nearly every start and notified. Verified: `require("lazy.core.config").options.checker` → enabled true, notify false.

## 8q. smart-splits.nvim v3 + backend-tmux

- New `plugins/smart-splits/{init,smart-splits}.lua`: `smart-splits-nvim/smart-splits.nvim` `version = "^3.0.0"` (docs), `lazy = false` (docs: the tmux backend sets the pane option `@pane-is-vim` on load; lazy-loading leaves tmux owning `<C-hjkl>`), dependency `{ "smart-splits-nvim/backend-tmux", main = "smart-splits-backend-tmux" }` (default branch, no releases). opts: `mux = { backend = "smart-splits-backend-tmux", warn_if_unusable = false }` (outside tmux it otherwise notifies "none of the configured backends detected" on every start), `resize = { amount = 1 }` (previous step), `move.at_edge` default `wrap`.
- Keys in `M.keys`: `<C-h/j/k/l>` (n, x) → `move_cursor_*`; `<C-S-h/j/k/l>` (n) → `resize_*` (directional: moves the border towards the key, previously `:vertical resize ±1` / `:resize ±1`). `configs/mappings.lua` lines commented with a note.
- tmux side (in `~/.tmux.conf`, outside the repo): `bind -n C-h if -F '#{@pane-is-vim}' { send-keys C-h } { select-pane -L }` etc.; resize bound as `C-S-H/J/K/L` because iTerm2 with extended keys sends Ctrl+Shift+h as `ESC[27;6;72~` (tmux name `C-S-H`).
- Tested in a pty tmux with the user's config and iTerm2's codes (`ESC[27;5;108~` = Ctrl+l, `ESC[27;6;76~` = Ctrl+Shift+l): split→split inside Neovim, Neovim edge→tmux pane, tmux pane→Neovim, resize inside Neovim, resize of tmux panes from a shell pane. Outside tmux: headless moves/resizes, no warning.

## 8r. image.nvim inside tmux

- `plugins/image/init.lua` `image_backend()`: sixel also when `vim.env.LC_TERMINAL == "iTerm2"` (inside tmux `TERM_PROGRAM=tmux`; the user's tmux global environment has `LC_TERMINAL=iTerm2`). image.nvim's sixel backend wraps output in tmux passthrough (`utils/tmux.lua`, needs `allow-passthrough on`, set in `~/.tmux.conf`).
- Headless check: plain iTerm2 → enabled/sixel; `TERM_PROGRAM=tmux LC_TERMINAL=iTerm2` → enabled/sixel; tmux without LC_TERMINAL → disabled. Visual check in a real tmux pane by the user.
- Found while testing: image.nvim had no load trigger (only as a neo-tree dependency on VeryLazy), so a picture given on the command line was read before the plugin's `BufWinEnter` hijack existed (raw bytes; `:e` later worked). Added `event = { "BufReadPre *.png", … "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }` (image.nvim's default `hijack_file_patterns`). pty tests: `nvim test.png` → `ft=image_nvim` in plain iTerm2 and inside tmux (server environment with `LC_TERMINAL=iTerm2`).
- Inside tmux the picture was still not shown: the sixel backend wraps the DCS in tmux passthrough (`utils.tmux.escape`, `backends/sixel.lua:132`) but sends the cursor save/move (`ESC[s`, `ESC[y;xH`) unwrapped, so tmux applies them pane-relative while iTerm2 draws at its own cursor; tmux then repaints over it. User test: `magick test.png sixel:-` in a tmux shell pane shows the picture (tmux native sixel; client features include `sixel`). Fix in `image/init.lua` `config`: after setup, when `backend == "sixel"` and `$TMUX`, replace `require("image/utils/tmux").escape` with identity, so tmux receives raw sixel and draws it in the pane (sixel positioning uses no pane offsets). The module must be required with slashes (`image/utils/tmux`): the dotted name is a separate `package.loaded` entry. kitty backend untouched (it also uses `escape`).
- Second tmux issue (left unfixed, user's choice): a float over the picture rows (nvim-notify E21 after `i` in an image buffer) makes the picture disappear. Tried: augroup on `WinClosed` → `nvim_exec_autocmds("WinResized", { group = "image.nvim" })`; in pty traces image.nvim re-sent the sixel after the popup closed, but in the user's real iTerm2 the picture then vanished immediately on `i` and never returned, so it was reverted. The pty harness cannot verify sixel display (its terminal does not advertise sixel, so tmux never forwards images); only the user's iTerm2 can. Note: nvim-notify opens its window without WinNew; the sixel backend flush does `noautocmd mode` (full redraw) before painting.
- Root cause, measured with a pty "terminal" that answers tmux's queries like iTerm2 3.6.10 (DA1 `ESC[?64;1;2;4;6;17;18;21;22;52c`, DA2 `ESC[>64;2500;0c`, XTVERSION `ESCP>|iTerm2 3.6.10ESC\\`) and reports pixel sizes, so tmux enables `sixel` for it and forwards images; "tmux still holds the image" checked via `refresh-client` (tmux re-sends held images): tmux drops a sixel image as soon as Neovim rewrites any cell in its area (popup close, buffer switch, opening the image after another file), while image.nvim keeps `is_rendered = true`, so it never re-sends (`:e!` sends nothing). Options offered: open images in macOS Quick Look inside tmux, keep as is, patch image.nvim's passthrough positioning (fragile), report upstream. User chose to keep it as is (current state: unwrapped sixel inside tmux).

## 8s. tmux files in the repo (reverted)

- New folder `tmux/` (user approved): `tmux/tmux.conf` (moved from `~/.tmux.conf`), `tmux/scripts/tmux-project.sh` (moved from `~/.tmux/scripts/`), `tmux/README.md` (setup on a new Mac). Symlinks: `~/.tmux.conf` → `~/.config/nvim/tmux/tmux.conf`, `~/.tmux/scripts/tmux-project.sh` → repo script. tmux config contains no secrets (checked). Verified: config loads through the link on a private server; `sh -n` on the script. The `FZF_TEST_PICK` test hook was removed from the script. Plugins (`~/.tmux/plugins`) are not in the repo; TPM installs them.
- **Reverted the same day (user):** tmux is a separate app, its config must not live in or link to the Neovim folder. Links replaced by real files again (`cmp`-verified identical), `tmux/` removed with `git rm` (still in history at 7d6085b; no secrets).

## 8t. Claude via claude-agent-acp in Avante and CodeCompanion

- Installed `npm i -g @agentclientprotocol/claude-agent-acp` 0.89.1 (the renamed `@zed-industries/claude-code-acp` / `claude-agent-acp`; both old names are deprecated). Codex was already set up (`codex-acp` 1.13.1, `codex login status` = ChatGPT).
- Auth: claude-agent-acp only advertises terminal login methods to clients that support terminal auth; Avante and CodeCompanion get `authMethods: []` (verified with an ACP `initialize` handshake in a clean env), so CodeCompanion's `_authenticate` falls through and the agent uses the `claude` CLI credentials (Claude Pro after `claude auth login --claudeai`). Its `authenticate` throws for non-gateway methods, so no method is sent. CodeCompanion's `claude_code` adapter would also take `CLAUDE_CODE_OAUTH_TOKEN` (from `claude setup-token`) — not used.
- Avante `acp_providers["claude-code"] = { command = "claude-agent-acp", env = { NODE_NO_WARNINGS = "1" } }` (merged with Avante's defaults; its `ACP_PERMISSION_MODE`/`ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE` env are not read by 0.89.1, so permissions go through ACP requests; `auto_approve_tool_permissions = false`). Default provider unchanged (`codex`).
- CodeCompanion: `adapters.acp.claude_code = extend("claude_code", {})`, `interactions.chat.adapter = "claude_code"` (was `deepseek_ollama`, kept commented); inline/cmd/background stay `deepseek_ollama` (docs: ACP adapters work in the chat buffer only); CLI agents gain `claude_code` (`claude`), default agent stays `codex`.
- Note for assistants: inside the Claude desktop app's shell, `ANTHROPIC_BASE_URL` and many `CLAUDE_CODE_*` variables are set by the app itself; the user's shell files and `~/.claude/settings.json` set none of them. Do not mistake them for the user's environment (`claude auth status` in that shell is not representative either).
- Headless check: both plugins load; `resolve("claude_code")` → acp `claude-agent-acp`; Avante acp providers include `claude-code`.

## 8u. Local AI removed, templates added

- User: no Ollama/Qwen/any local AI configured; they run local models with oMLX, llama.cpp or LM Studio (all serve OpenAI `/v1/chat/completions` and Anthropic `/v1/messages`) and will ask when they want one.
- CodeCompanion: removed `adapters.http.deepseek_ollama` and the commented qwen adapters; `interactions.inline/cmd/background` adapter lines removed → plugin default `copilot` (config.lua). Commented templates `local_openai` (`extend("openai_compatible", { env = { url, api_key = "local" } })`) and `local_anthropic` (`extend("anthropic", { url = ".../v1/messages", env = { api_key = "local" } })`).
- Avante: removed the commented `providers.ollama` block; commented templates `local-openai` (`__inherited_from = "openai"`, endpoint `…/v1`) and `local-anthropic` (`__inherited_from = "claude"`, endpoint = host; Avante appends `/v1/messages`), `api_key_name = "cmd:echo local"` (an empty key name makes Avante prompt for a key).
- Ports: oMLX 8000 (secondary sources), llama.cpp server 8080, LM Studio 1234.

## 9. Prompt for the next AI

> Read AGENTS.md first: it has the current state, the user's rules, and what is pending. The prompt below is from the original migration and is partly outdated.

> Continue from this completed migration in /Users/alexandrmartirosyan/.config/nvim. Read CHANGELOG.md, MIGRATION_NOTES.md, and git status first. Preserve pre-existing/uncommitted edits and the branch codex/nvim-plugin-upgrade. Do not merge files, rearrange folders, remove plugin/dependency declarations or the user's comments/commented-out code, modify the separate local Barbar repo without being asked, or run Lazy clean. Disabled plugins stay declared. Do not redo all 72 plugin checks or rerun passed tests without a relevant change. The installed plugin upgrades and API repairs are complete, Neovim runs 0.12.6 through bob, and all Treesitter parsers are installed; Kulala Core 1.3.1 is activated, local HTTP requests and kulala-fmt formatting are verified. Never write tokens into the repository/chat. Remaining: visually confirm Kulala/lualine response tabs in a real UI; repair only a demonstrated failure and update both documents immediately. AI auth/real terminal image checks are manual acceptance items. Snacks, Ruff, AI consolidation, TypeScript 7, or structural redesigns require a separate user selection. Report behavioral changes and limitations, not a line-by-line edit diary.
