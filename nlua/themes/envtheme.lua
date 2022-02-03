local nvim_color = os.getenv("NVIM_COLOR") or "codedark"

require("themes." .. nvim_color)
-- source $HOME/.config/nvim/themes/$NVIM_COLOR.vim
