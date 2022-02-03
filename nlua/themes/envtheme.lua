local nvim_color = os.getenv("NVIM_COLOR") or "codedark"

require("themes." .. nvim_color)

