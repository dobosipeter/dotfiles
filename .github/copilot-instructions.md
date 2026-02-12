# Copilot / AI Agent Instructions

Purpose: quick, actionable guidance for AI coding agents working on this repository (Neovim + zsh dotfiles).

Big picture
- This repo is a personal dotfiles collection focused on Neovim config under `nvim/` and shell bits under `zsh/`.
- Neovim config is modular Lua: `nvim/init.lua` loads `nvim/lua/core/*` (options, keymaps, autocmds) and `nvim/lua/plugins/*`.
- Plugin management uses `lazy.nvim` (see [nvim/lua/plugins/init.lua](nvim/lua/plugins/init.lua)); `lazy-lock.json` is committed.

Key files & locations (start here)
- [nvim/init.lua](nvim/init.lua): top-level loader — requires `core` and `plugins` modules.
- [nvim/lua/core/options.lua](nvim/lua/core/options.lua): vim options and diagnostic config (folding, clipboard, ripgrep integration).
- [nvim/lua/core/keymaps.lua](nvim/lua/core/keymaps.lua) and [nvim/lua/core/autocmds.lua](nvim/lua/core/autocmds.lua): keybindings and small UI behaviors.
- [nvim/lua/plugins/init.lua](nvim/lua/plugins/init.lua): bootstraps `lazy.nvim` and lists plugin specs.
- [nvim/lua/plugins/*.lua](nvim/lua/plugins): per-plugin configuration (examples: `lsp.lua`, `colorscheme.lua`, `completion.lua`).
- [nvim/README.md](nvim/README.md): human documentation of structure, keymaps, and workflows.

Project-specific patterns & conventions
- Lua modules use the `require('<module>')` pattern with root set to `nvim/lua`. E.g. `require('core.options')` loads `nvim/lua/core/options.lua`.
- Plugins are declared as Lua tables and returned from `nvim/lua/plugins/*.lua` files; these are consumed by `require('lazy').setup()`.
- Environment flags are encapsulated in `utils` (e.g. `is_termux`, `is_devcontainer`) and used to conditionally enable plugins or LSP servers.
- Leader key is `\` (backslash) per README; common mappings: `\-e` filetree, `\-c` Copilot Chat, `K` hover, `gl` diagnostics.

Integration points (externals to be aware of)
- lazy.nvim — plugin manager bootstrapped in `nvim/lua/plugins/init.lua` (cloned to `stdpath('data')/lazy/lazy.nvim`).
- Mason, mason-lspconfig, mason-tool-installer, none-ls: used for LSP/formatters/linters in `nvim/lua/plugins/lsp.lua`.
- LSP servers referenced: `basedpyright`, `lua_ls`, `clangd`, `texlab` (conditional on environment).

Developer workflows & quick commands
- To run Neovim with this config from the repo root (for testing):

  `nvim -u nvim/init.lua`

- Validate setup inside Neovim: `:checkhealth` and use `:Lazy` commands once `lazy.nvim` is installed.
- Plugin changes: edit files under `nvim/lua/plugins/` and keep `lazy-lock.json` in sync. The config bootstraps lazy automatically.
- LSP/tooling changes: update `nvim/lua/plugins/lsp.lua` and the mason lists there; watch for `utils.is_termux` and `utils.is_devcontainer` branching.

Examples (copyable snippets)
- Load core options from `nvim/init.lua`:

  `require('core.options')`

- Add a plugin module skeleton in `nvim/lua/plugins/newplugin.lua`:

  ```lua
  return {
    'owner/plugin',
    config = function()
      -- plugin setup
    end,
  }
  ```

What *not* to assume
- There is no build/test harness in this repo. Changes are validated interactively by opening Neovim with the repo config.
- Do not add global stateful services or CI steps unless the user asks — this repo is primarily local configuration.

If you change anything non-trivial
- Update the appropriate `nvim/lua/*` module and mention the affected file in your PR/commit message.
- If you modify plugin lists, verify `nvim -u nvim/init.lua` loads and run `:checkhealth`.

Questions / Ambiguities to flag to the user
- Clarify whether changes should apply to upstream config (home folder) or remain only in repo for experimentation.
- Ask whether they want automated plugin install or a manual bootstrap step documented.

---
LaTeX / devcontainer notes
- LaTeX support is provided by two places:
  - `texlab` is configured in [nvim/lua/plugins/lsp.lua](nvim/lua/plugins/lsp.lua) and is added to Mason's `ensure_installed` lists. It is skipped when `utils.is_devcontainer` is true.
  - `vimtex` (plugin `lervag/vimtex`) is declared in [nvim/lua/plugins/tools.lua](nvim/lua/plugins/tools.lua) and its `enabled` function returns `not utils.is_devcontainer`. It sets `vim.g.vimtex_view_method = 'zathura'`.
- Environment detection logic lives in [nvim/lua/utils.lua](nvim/lua/utils.lua):
  - `is_termux` is true if `vim.fn.has("android") == 1` or `$PREFIX` contains `com.termux`.
  - `is_devcontainer` is true if `/.banner` exists or environment variables `REMOTE_CONTAINERS` or `DEVCONTAINER` equal `true`.
- Practical implication: to enable LaTeX tooling in a container, set `REMOTE_CONTAINERS=true` or `DEVCONTAINER=true` (or remove `/.banner`).

If you'd like, I can iterate on this and include exact `utils` behavior examples (from `nvim/lua/utils.lua`) or add a short checklist for making plugin changes. What should I expand? 
