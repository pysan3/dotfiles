from dataclasses import dataclass
import yaml

Color = tuple[str, str]


@dataclass
class ColorScheme:
    colors: tuple[Color, Color, Color, Color, Color, Color, Color, Color]

    background: str
    foreground: str
    workspace: str
    foreground2: str

    is_bright: bool = False

    @classmethod
    def load_yaml(cls, y: str):
        d: dict[str, dict[str, str]] = yaml.safe_load(y)['colors']
        return cls(
            (
                cls._load_colors(d, 'black'),
                cls._load_colors(d, 'red'),
                cls._load_colors(d, 'green'),
                cls._load_colors(d, 'yellow'),
                cls._load_colors(d, 'blue'),
                cls._load_colors(d, 'magenta'),
                cls._load_colors(d, 'cyan'),
                cls._load_colors(d, 'white'),
            ),
            d['primary']['background'],
            d['primary']['foreground'],
            '#51afef',
            d['cursor']['cursor'],
        )

    @staticmethod
    def _load_colors(data: dict[str, dict[str, str]], key: str):
        return (data['normal'][key], data['bright'][key])

    @property
    def bright(self):
        return self.__class__(self.colors, self.background, self.foreground,
                              self.workspace, self.foreground2, is_bright=True)

    @property
    def black(self):
        return self.colors[0][self.is_bright]

    @property
    def red(self):
        return self.colors[1][self.is_bright]

    @property
    def green(self):
        return self.colors[2][self.is_bright]

    @property
    def yellow(self):
        return self.colors[3][self.is_bright]

    @property
    def blue(self):
        return self.colors[4][self.is_bright]

    @property
    def purple(self):
        return self.colors[5][self.is_bright]

    @property
    def cyan(self):
        return self.colors[6][self.is_bright]

    @property
    def white(self):
        return self.colors[7][self.is_bright]


dracula = ColorScheme((
    ("#282a36", "#282a36"),  # background (dark grey) [0]
    ('#ff5555', '#ff5555'),  # red [9]
    ("#50fa7b", "#50fa7b"),  # green [5]
    ("#f1fa8c", "#f1fa8c"),  # yellow [10]
    ("#6272a4", "#6272a4"),  # blue/grey) [3]
    ("#bd93f9", "#bd93f9"),  # purple [8]
    ("#8be9fd", "#8be9fd"),  # cyan [4]
    ("#f8f8f2", "#f8f8f2"),  # forground (white) [2]
),
    "#282a36",
    "#f8f8f2",
    "#bd93f9",
    "#44475a",
)

xterm = ColorScheme((
    ("#000000", "#7f7f7f"),
    ("#cd0000", "#ff0000"),
    ("#00cd00", "#00ff00"),
    ("#cdcd00", "#ffff00"),
    ("#0000ee", "#5c5cff"),
    ("#9c3885", "#e628ba"),
    ("#00cdcd", "#00ffff"),
    ("#e5e5e5", "#ffffff"),
),
    "#000000",
    "#ffffff",
    "#3a5e87",
    "#373737"
)


paperdark = ColorScheme.load_yaml("""
# Colors (PaperColor - Dark)
colors:
  # Default colors
  primary:
    background: "#1c1c1c"
    foreground: "#d0d0d0"
  cursor:
    text: "#1c1c1c"
    cursor: "#2c2b32"
  # Normal colors
  normal:
    black: "#1c1c1c"
    red: "#af005f"
    green: "#5faf00"
    yellow: "#d7af5f"
    blue: "#5fafd7"
    magenta: "#af87d7"
    cyan: "#20a5ba"
    white: "#d0d0d0"
  # Bright colors
  bright:
    black: "#585858"
    red: "#5faf5f"
    green: "#afd700"
    yellow: "#af87d7"
    blue: "#ffaf00"
    magenta: "#ffaf00"
    cyan: "#4fb8cc"
    white: "#5f8787"
""")
