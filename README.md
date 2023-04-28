# My Dotfiles

![image](https://user-images.githubusercontent.com/41065736/235205820-c04ef6c1-6f13-4f85-aebb-c007bb5354ed.png)

## Warnings

This installation might cause serious changes to your workflow.
(It won't overwrite any files though.)

## Included Config Files

- zsh
  - [./.zshenv](./.zshenv)
  - [./config/zsh/.zshrc](./config/zsh/.zshrc)
- neovim
  - [./nvim](./nvim)
- alacritty
  - [./config/alacritty/alacritty.yml](./config/alacritty/alacritty.yml)
- git
  - [./config/git/config](./config/git/config)
- latexmk
  - [./config/latexmk/latexmkrc](./config/latexmk/latexmkrc)
- npm
  - [./config/npm/npmrc](./config/npm/npmrc)
- tmux
  - [./config/tmux/tmux.conf](./config/tmux/tmux.conf)
- vifm
  - [./config/vifm/vifmrc](./config/vifm/vifmrc)
- wezterm
  - [./config/wezterm/wezterm.lua](./config/wezterm/wezterm.lua)
- wget
  - [./config/wgetrc](./config/wgetrc)

## Installation

```zsh
# Install git, zsh
sudo apt install -y zsh git
sudo pacman -S zsh git

# My config files only run on zsh shell
# Change default shell to zsh
chsh -s $(which zsh)  # This may break many things!!! Know what you are doing.

cd "$HOME"
git clone https://github.com/pysan3/dotfiles.git
cd dotfiles

# Create Symlink for all Config Files
# Already existing files will NOT be overwritten, and will not apply any changes
~/dotfiles/install_all.zsh

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
