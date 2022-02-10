# [takuto](https://www.pysan3.server-on.net/)'s dotfiles

## Warnings

This installation might cause serious changes to your workflow.
(It won't overwrite any files though.)

## Included Config Files

- zsh
  - [./.zshenv](./.zshenv)
  - [./config/zsh/.zshrc](./config/zsh/.zshrc)
  - [./config/zsh/.zsh_aliases](./config/zsh/.zsh_aliases)
  - [./config/zsh/.zsh_rust](./config/zsh/.zsh_rust) (Add various programs to `$PATH`)
- neovim
  - [./nvim](./nvim)
  - [nvim/lua (./nlua)](./nlua)
- alacritty
  - [./config/alacritty/alacritty.yml](./config/alacritty/alacritty.yml)
- git
  - [./config/git/config](./config/git/config)
- latexmk
  - [./config/latexmk/latexmkrc](./config/latexmk/latexmkrc)
- npm
  - [./config/npm/npmrc](./config/npm/npmrc)
- peco
  - [./config/peco/config.json](./config/peco/config.json)
- tmux
  - [./config/tmux/tmux.conf](./config/tmux/tmux.conf)
- vifm
  - [./config/vifm/vifmrc](./config/vifm/vifmrc)
- wget
  - [./config/wgetrc](./config/wgetrc)

## Installation

```zsh
# My config files only run on zsh shell
# Change default shell to zsh
chsh -s $(which zsh)  # This may break many things!!! Know what you are doing.

cd "$HOME"
git clone https://git.esslab.jp/takuto/dotfiles.git
cd dotfiles

# Create Symlink for all Config Files
# Already existing files will NOT be overwritten, and will not apply any changes
~/dotfiles/install_dotfiles.sh

# Install Package Requirements
# Watch the installation, it needs some inputs from the user along the way
~/dotfiles/install_base.zsh

```

## Requirements

- Use zsh shell
- This repository must be downloaded to `$HOME/dotfiles`
- `git`
- `npm`
- `nvim`
