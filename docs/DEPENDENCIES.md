# System Dependencies

This document lists the system dependencies required for the full dotfiles setup, particularly for the Neovim configuration.

## Core Requirements

### Essential
- **Neovim** >= 0.10.0
- **Git** - for plugin management and version control
- **curl** or **wget** - for downloading plugins and tools

### For LSP & Mason Tools

#### Python-based tools (basedpyright, pylint)
```bash
# Ubuntu/Debian
sudo apt install python3-pip python3-venv
```

#### C/C++ development (clangd)
```bash
# Ubuntu/Debian
sudo apt install clangd
```

#### LaTeX (texlab) - skipped in devcontainers
```bash
# Ubuntu/Debian
sudo apt install texlive texlive-latex-extra
```

### Optional
- **ripgrep** (`rg`) - for faster grep operations
- **fd** - for faster file finding
- **lazygit** - for Git TUI integration
- **zathura** - PDF viewer for vimtex

```bash
# Ubuntu/Debian
sudo apt install ripgrep fd-find lazygit zathura
```

## Quick Start for Fresh Systems

### Minimal Setup (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install -y git python3-pip python3-venv ripgrep
```

## Environment-Specific Notes

### Termux (Android)
- `clangd` is excluded from automatic installation
- Mason PATH is set to "append" instead of "prepend"

### Devcontainers
- `texlab` and `vimtex` are disabled
- Detection: checks for `/.banner` file or `REMOTE_CONTAINERS`/`DEVCONTAINER` env vars
