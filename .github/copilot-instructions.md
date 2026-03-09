# Copilot Instructions

This is a personal dotfiles repository. Its primary operation is `install.sh`, which symlinks (or copies) all configs into the home directory.

## Installation

```bash
./install.sh          # symlink mode (default)
./install.sh --copy   # copy mode (falls back automatically on Windows/MINGW)
```

`install.sh` also creates `~/code/nartex/` and `~/code/personal/` directories, and handles `${HOME}` variable interpolation in `gitconfig` during install. Existing files are backed up as `.bak` before overwriting.

## Architecture

### Shell (bashrc + bashrc.d/)
`bashrc` is a thin loader — it only sources `~/.bashrc.d/*.sh` in order and loads `~/.bashrc.local` for machine-specific overrides. All real logic lives in `bashrc.d/`.

Scripts in `bashrc.d/` use numeric prefixes to enforce load order:
- `00–09`: Core env and PATH
- `10–19`: Aliases and modern tool integrations (exa, bat, fzf, git, ripgrep, fd, delta, docker)
- `20–29`: Multiplexer (tmux)
- `30–49`: Language runtimes (Java, Node, Python, Rust, Go)
- `50–59`: Utility functions and dotfiles helpers
- `90–99`: Prompt and navigation tools (gitid, starship, zoxide)

Use gaps in numbering (e.g., 10, 11, 12...) so new scripts can be inserted without renaming.

### Git identity switching
`gitconfig` uses `[includeIf]` to load context-specific identities:
- `~/code/nartex/` → `git/gitconfig-nartex` (work identity)
- `~/code/personal/` → `git/gitconfig-personal` (personal identity)

Always place work projects under `~/code/nartex/` and personal projects under `~/code/personal/` for the correct git identity to activate automatically.

### Vim vs Neovim
- `vimrc` — Vimscript config for Vim
- `config/nvim/init.lua` — Lua config for Neovim with equivalent functionality

Both configs are intentionally kept in sync. Changes to keymaps, themes, or behavior should be applied to both unless they are Neovim-specific.

## Key Conventions

- **Numeric prefix ordering**: New `bashrc.d/` scripts must have a numeric prefix. Group by function domain (env/path < tool aliases < language runtimes < prompt).
- **Modern tool replacements**: `exa`→`ls`, `bat`→`cat`, `ripgrep`→`grep`, `fd`→`find`, `delta`→`diff`, `zoxide`→`cd`. Aliases and functions wrap these; do not call the originals directly in scripts.
- **Machine-local overrides**: Never commit machine-specific settings. They belong in `~/.bashrc.local` (never tracked).
- **Git config values**: When editing `gitconfig`, keep `${HOME}` as a literal variable — `install.sh` interpolates it during copy. Do not hardcode paths.
- **Symlink-first**: `install.sh` prefers symlinks. Only use copy mode when the target system doesn't support symlinks (e.g., some Windows environments).
- **Backup before overwrite**: `install.sh` renames existing files to `.bak`. Do not remove that logic.
- **Comments use emoji section headers** throughout configs (e.g., `# 🎨 Theme`, `# ⌨️ Keybinds`) — follow this style when adding new sections.
