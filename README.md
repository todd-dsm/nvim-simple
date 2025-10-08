# nvim-simple

That same simplicity with a new sheen.

A modern Neovim configuration written entirely in Lua, optimized for Bash scripting with full LSP support and designed for future expansion to additional languages (Docker, Python, etc.).

This configuration is a companion project to [vim-simple](https://github.com/todd-dsm/vim-simple), completely rewritten using Neovim-native features and modern best practices.

## Features

- **Pure Lua**: Zero VimScript, all configuration in Lua
- **LSP-first**: Native LSP with bash-language-server for intelligent code navigation
- **Auto-formatting**: Automatic code formatting with shfmt on save
- **Linting**: Shellcheck integration via none-ls
- **Smart completion**: nvim-cmp with LSP, buffer, path, and snippet sources
- **Custom snippets**: Bash snippets with modern `[[ ]]` syntax
- **Git integration**: vim-fugitive + gitsigns for comprehensive git workflow
- **Fuzzy finding**: Telescope for fast file/buffer navigation
- **Auto-bootstrap**: Automatically installs lazy.nvim and all plugins on first launch
- **Muscle memory preserved**: Same keybindings as vim-simple (`,` leader)

## Prerequisites

### macOS (Homebrew)

Install these packages before using nvim-simple:

```bash
# Core requirements
brew install neovim          # Neovim 0.9.0+
brew install git             # Version control
brew install ripgrep         # Fast grep (for telescope)
brew install fd              # Fast find (for telescope)
brew install node            # Required for some LSP features

# Bash/Shell development tools
brew install shellcheck      # Shell script linter
brew install shfmt           # Shell script formatter
brew install bash-language-server  # LSP for bash
```

## Installation

### Option 1: Clone and Symlink (Recommended)

```bash
# Clone to ~/code/nvim-simple
git clone https://github.com/todd-dsm/nvim-simple.git ~/code/nvim-simple

# Backup existing Neovim config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Symlink to Neovim config directory
ln -s ~/code/nvim-simple ~/.config/nvim
```

### Option 2: Direct Clone

```bash
# Backup existing Neovim config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Clone directly to ~/.config/nvim
git clone https://github.com/todd-dsm/nvim-simple.git ~/.config/nvim
```

### First Launch

On first launch, nvim-simple will automatically:
1. Download and install lazy.nvim (plugin manager)
2. Install all configured plugins
3. Install Treesitter parsers for bash, lua, vim, etc.

Simply run:

```bash
nvim
```

Wait for all plugins to install, then restart Neovim.

## Oh My Zsh Integration (macOS)

The `~/.oh-my-zsh/custom` directory is designed for your personal configurations that won't be overwritten when Oh My Zsh updates.

### Create a Custom Configuration File

Create a custom configuration file for nvim-simple:

```bash
# Create nvim-simple custom config
cat << 'EOF' > ~/.oh-my-zsh/custom/nvim-simple.zsh
# nvim-simple configuration

# Set Neovim as default editor
export EDITOR='nvim'
export VISUAL='nvim'

# Aliases for Neovim
alias vim='nvim'
alias vi='nvim'
alias v='nvim'

# Optional: Quick edit common configs
alias zshconfig='nvim ~/.zshrc'
alias nvimconfig='nvim ~/.config/nvim/init.lua'
EOF
```

### Enable Vi Mode (Optional)

If you want vi keybindings in your shell, edit `~/.zshrc` and add `vi-mode` to your plugins:

```bash
plugins=(git vi-mode)
```

### Apply Changes

```bash
source ~/.zshrc
```

### Verify Installation

```bash
echo $EDITOR   # Should output: nvim
which nvim     # Should show the path to neovim
vim --version  # Should launch nvim
```

**Benefits of this approach:**
- Custom configurations are preserved during Oh My Zsh updates
- Easy to manage and version control your custom settings
- Can be easily disabled by removing/renaming the `.zsh` file

## Keybindings

### Leader Key

The leader key is `,` (comma) - preserved from vim-simple for muscle memory.

### Editor Controls

| Key         | Action                          |
|-------------|---------------------------------|
| `,N`        | Toggle line numbers             |
| `,l`        | Toggle invisible characters     |
| `,.`        | Clear search highlighting       |
| `F2`        | Toggle paste mode               |

### Git Integration

| Key         | Action                          |
|-------------|---------------------------------|
| `,gs`       | Git status                      |
| `,gd`       | Git diff                        |
| `,gb`       | Git blame                       |
| `]c`        | Next git hunk                   |
| `[c`        | Previous git hunk               |
| `,hp`       | Preview git hunk                |

### LSP Navigation

| Key         | Action                          |
|-------------|---------------------------------|
| `gd`        | Goto definition                 |
| `gr`        | Goto references                 |
| `K`         | Hover documentation             |
| `,rn`       | Rename symbol                   |
| `,ca`       | Code actions                    |
| `]d`        | Next diagnostic                 |
| `[d`        | Previous diagnostic             |

### Fuzzy Finding (Telescope)

| Key         | Action                          |
|-------------|---------------------------------|
| `,ff`       | Find files                      |
| `,fg`       | Live grep                       |
| `,fb`       | Find buffers                    |
| `,fh`       | Help tags                       |

### Text Manipulation

| Key         | Action                          |
|-------------|---------------------------------|
| `gcc`       | Toggle comment (current line)   |
| `gc{motion}`| Comment motion (e.g., `gcap`)   |
| `cs"'`      | Change surrounding " to '       |
| `ds"`       | Delete surrounding "            |
| `ysiw"`     | Add " around inner word         |

### Completion & Snippets

| Key         | Action                          |
|-------------|---------------------------------|
| `Tab`       | Select next completion / expand snippet |
| `Shift-Tab` | Select previous completion      |
| `Ctrl-Space`| Trigger completion              |
| `Enter`     | Confirm completion              |

## Bash Snippets

Type the trigger and press `Tab` to expand:

| Trigger | Expands to                      |
|---------|----------------------------------|
| `if`    | `if [[ condition ]]; then ... fi` |
| `elif`  | `elif [[ condition ]]; then ...` |
| `for`   | `for i in words; do ... done`   |
| `while` | `while [[ condition ]]; do ... done` |
| `case`  | `case word in pattern) ... esac` |
| `func`  | `function_name() { ... }`       |

**Note**: All snippets use modern `[[ ]]` syntax (not `[ ]` or `test`).

## Configuration Structure

```
~/.config/nvim/
├── init.lua                    # Entry point
├── lua/
│   ├── core/
│   │   ├── options.lua         # Editor settings
│   │   ├── keymaps.lua         # Global keybindings
│   │   └── autocmds.lua        # Autocommands
│   ├── plugins/
│   │   ├── init.lua            # Plugin manager (lazy.nvim)
│   │   ├── lsp.lua             # LSP configuration
│   │   ├── completion.lua      # nvim-cmp
│   │   ├── snippets.lua        # LuaSnip
│   │   ├── ui.lua              # Status line (lualine)
│   │   ├── git.lua             # Git integration
│   │   ├── telescope.lua       # Fuzzy finder
│   │   └── treesitter.lua      # Syntax highlighting
│   └── snippets/
│       └── bash.lua            # Custom bash snippets
├── after/
│   └── ftplugin/
│       └── sh.lua              # Bash-specific settings
└── README.md
```

## Adding New Languages

To add support for a new language (e.g., Python):

1. **Install the language server**:
   ```bash
   brew install pyright
   ```

2. **Add LSP config** in `lua/plugins/lsp.lua`:
   ```lua
   lspconfig.pyright.setup({
       on_attach = on_attach,
       capabilities = capabilities,
   })
   ```

3. **Add snippets** in `lua/snippets/python.lua`

4. **Update Treesitter** in `lua/plugins/treesitter.lua`:
   ```lua
   ensure_installed = { "bash", "lua", "python", ... }
   ```

No changes to core configuration needed!

## Customization

### Change Colorscheme

Edit `lua/plugins/init.lua` and replace `maxmx03/solarized.nvim` with your preferred colorscheme.

### Modify Keybindings

Edit `lua/core/keymaps.lua` to customize keybindings.

### Add Plugins

Add new plugin specs in `lua/plugins/init.lua` following the lazy.nvim format.

## Troubleshooting

### Plugins not installing

```bash
# Open Neovim and run:
:Lazy sync
```

### LSP not working

1. Check LSP server is installed: `which bash-language-server`
2. Check LSP status: `:LspInfo`
3. Check logs: `:messages` or `~/.local/state/nvim/lsp.log`

### Shellcheck/shfmt not working

Verify they're installed:
```bash
which shellcheck
which shfmt
```

### Treesitter errors

Update parsers:
```bash
:TSUpdate
```

## Testing Checklist

After installation, verify:

- [ ] Auto-bootstrap works (fresh install)
- [ ] Leader key is `,` and keybindings work
- [ ] Shellcheck lints bash files on save
- [ ] Shfmt formats bash files on save
- [ ] Bash snippets work: `if<Tab>`, `for<Tab>`, etc.
- [ ] Snippets use `[[ ]]` syntax
- [ ] Auto-completion appears after 2-3 characters
- [ ] LSP goto definition works (`gd`)
- [ ] Status line shows buffer, filename, git branch, diagnostics
- [ ] Solarized colorscheme displays correctly
- [ ] Trailing whitespace auto-removed on save
- [ ] Git commands work: `,gs`, `,gd`, `,gb`
- [ ] Comment toggling works: `gcc`
- [ ] Surround commands work: `cs"'`, `ds"`, `ysiw"`

## Contributing

Contributions welcome! Please open an issue or pull request.

## License

MIT License - see LICENSE file for details.

## Credits

- Based on [vim-simple](https://github.com/todd-dsm/vim-simple)
- Built with [lazy.nvim](https://github.com/folke/lazy.nvim)
- Powered by Neovim's native LSP
