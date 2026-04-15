---
description: Shared agent instructions for this dotfiles repo
alwaysApply: true
---

# AI Agent Instructions

Purpose: quick, actionable guidance for AI coding agents working on this repository (Neovim + zsh dotfiles).

## Cross-platform instruction files

This repo may contain instruction files for multiple AI agent platforms.
Before starting work, check for and read any that exist:

- `.github/copilot-instructions.md` — GitHub Copilot
- `.cursor/rules/*.mdc` — Cursor
- `CLAUDE.md` — Claude Code (repo root or parent dirs)
- `.windsurfrules` — Windsurf / Codeium
- `.clinerules` — Cline
- `AGENTS.md` or `codex.md` — OpenAI Codex
- `.aider.conf.yml`, `CONVENTIONS.md` — Aider

Some of these may be symlinks to a shared canonical file. Follow all
applicable instructions regardless of which platform you are running on.

Big picture
- This repo is a personal dotfiles collection: Neovim config under `nvim/`, Kitty terminal config under `kitty/`, zsh/Oh-My-Zsh under `zsh/`, and system dependency docs under `docs/`.
- Neovim config is modular Lua: `nvim/init.lua` loads `nvim/lua/core/*` (options, keymaps, autocmds) and `nvim/lua/plugins/*`.
- Plugin management uses `lazy.nvim` (see [nvim/lua/plugins/init.lua](nvim/lua/plugins/init.lua)); `lazy-lock.json` is gitignored and not committed.

Key files & locations (start here)
- [nvim/init.lua](nvim/init.lua): top-level loader — requires `core` and `plugins` modules.
- [nvim/lua/core/options.lua](nvim/lua/core/options.lua): vim options and diagnostic config (folding, clipboard, ripgrep integration).
- [nvim/lua/core/keymaps.lua](nvim/lua/core/keymaps.lua) and [nvim/lua/core/autocmds.lua](nvim/lua/core/autocmds.lua): keybindings and small UI behaviors (LSP highlight, navic, spell for prose filetypes).
- [nvim/lua/plugins/init.lua](nvim/lua/plugins/init.lua): bootstraps `lazy.nvim` and lists plugin specs.
- [nvim/lua/plugins/*.lua](nvim/lua/plugins): per-plugin configuration — `lsp.lua`, `colorscheme.lua`, `completion.lua`, `tools.lua`, `ui.lua`.
- [nvim/lua/utils.lua](nvim/lua/utils.lua): environment flags (`is_termux`, `is_devcontainer`) and helpers (`has_pip()`).
- [nvim/rice/](nvim/rice): ASCII headers and quotes used by the alpha-nvim dashboard.
- [kitty/kitty.conf](kitty/kitty.conf): Kitty terminal settings (font, opacity, colors).
- [zsh/.zshrc_bp_c_0098y](zsh/.zshrc_bp_c_0098y): Oh My Zsh config (theme, plugins, git aliases, PATH).
- [docs/DEPENDENCIES.md](docs/DEPENDENCIES.md): system dependency reference.
- [nvim/README.md](nvim/README.md): detailed Neovim docs (keymaps, plugin list, workflows).

Project-specific patterns & conventions
- Lua modules use the `require('<module>')` pattern with root set to `nvim/lua`. E.g. `require('core.options')` loads `nvim/lua/core/options.lua`.
- Plugins are declared as Lua tables and returned from `nvim/lua/plugins/*.lua` files; these are consumed by `require('lazy').setup()`.
- Environment flags in `utils.lua` (`is_termux`, `is_devcontainer`, `has_pip()`) conditionally enable plugins, LSP servers, and Mason behavior.
- Leader key is `\` (backslash, Neovim default — not explicitly set). Key mappings:
  - `<leader>e` nvim-tree toggle, `<leader>c` CopilotChat toggle
  - `<leader>r` rename, `<leader>a` code action (LSP on_attach)
  - `gd` go to definition, `gr` references, `K` hover, `gl` diagnostic float

Integration points (externals to be aware of)
- lazy.nvim — plugin manager bootstrapped in `nvim/lua/plugins/init.lua` (cloned to `stdpath('data')/lazy/lazy.nvim`).
- Mason, mason-lspconfig, mason-tool-installer, none-ls: used for LSP/formatters/linters in `nvim/lua/plugins/lsp.lua`.
- LSP servers: `basedpyright`, `lua_ls`, `clangd`, `texlab`, `typos_lsp` (conditional on environment).
- Treesitter (`nvim-treesitter`), nvim-cmp + LuaSnip (completion), nvim-autopairs.
- UI: alpha-nvim (dashboard), nvim-tree (file explorer), lualine (statusline), satellite (scrollbar), blink.indent, render-markdown, nvim-navic (breadcrumbs).
- Git: gitsigns.nvim. Spell: spellwarn.nvim.
- CopilotChat (model: claude-sonnet-4.5) for AI chat inside Neovim.
- Colorscheme: kanagawa-dragon (`rebelot/kanagawa.nvim`).
- Kitty terminal: 0xProto Nerd Font Mono, 0.67 opacity, custom ANSI palette, hidden decorations.

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

If in doubt about `utils` behavior, read `nvim/lua/utils.lua` directly.
