local nvim_color = os.getenv("NVIM_COLOR") or "nvcode"

require("themes." .. nvim_color)
