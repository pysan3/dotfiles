import os
import subprocess
from libqtile import hook
from libqtile import qtile
from typing import List
from libqtile.config import Click, Drag, Group, Key, Match, Screen, ScratchPad, DropDown
from libqtile.lazy import lazy
from libqtile.bar import Bar
from libqtile import widget
from libqtile.layout import *  # type: ignore # noqa
from libqtile.dgroups import simple_key_binder

import colorConfig

color = colorConfig.xterm

modKey = "mod4"
mod = [modKey]
shift = ["shift"]
control = ["control"]

# My Default Programs
# myBrowser = 'firefox'
# myTerminal = 'alacritty'
# myTextEditor = 'vim'
# myPrimaryFileManager = 'dolphin'
# mySecondaryFileManager = 'st vifm'
# myRecorder = 'obs'
# myDrawingApp = 'mypaint'
# myVideoEditor = 'kdenlive'
# myAudioEditor = 'audacity'
# myPhotoEditor = 'gimp'
# myVirtualbox = 'virtualbox'
# myVideoPlayer = 'vlc'
# myPrimaryMenu = 'dmenu_run'
# myEmailCliant = 'thunderbird'

defaultBrowser = 'firefox'
defaultTerminal = 'alacritty'
defaultEditor = os.environ.get('EDITOR', 'nvim')
defaultFileManagerGUI = 'dolphin'
defaultFileManagerTUI = 'alacritty -e vifm'
defaultRecorder = 'obs'
defaultPaint = 'krita'
defaultVideoEditor = 'kdenlive'
defaultAudioEditor = 'audacity'
defaultPhotoEditor = 'gimp'
defaultVirtualbox = 'virtualbox'
defaultVideoPlayer = 'vlc'
defaultPrimaryMenu = 'dmenu_run'
defaultEmailCliant = 'thunderbird'


# =============== Keybinds ===============
keys = [
    # =============== Window Movements ===============
    # Move Focus
    Key(mod, "h", lazy.layout.left(), desc="Move focus to left"),
    Key(mod, "l", lazy.layout.right(), desc="Move focus to right"),
    Key(mod, "j", lazy.layout.down(), desc="Move focus down"),
    Key(mod, "k", lazy.layout.up(), desc="Move focus up"),
    Key(mod, "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move Window
    Key(mod + shift, "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key(mod + shift, "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key(mod + shift, "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key(mod + shift, "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Resize Window
    Key(mod + control, "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(mod + control, "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key(mod + control, "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key(mod + control, "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key(mod + control, "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # =============== Layouts ===============
    # Toggle between split and unsplit sides of stack (Zoom)
    Key(mod + shift, "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
    # Change Layout
    Key(mod, "Tab", lazy.next_layout(), desc="Toggle between layouts"),

    # =============== Manage Qtile ===============
    Key(mod + shift, "q", lazy.window.kill(), desc="Kill focused window"),

    Key(mod + control, "r", lazy.restart(), desc="Restart Qtile"),
    Key(mod + control, "q", lazy.shutdown(), desc="Shutdown Qtile"),

    Key(mod, "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    # =============== Launch Applications ===============
    Key(mod, "Return", lazy.spawn(defaultTerminal), desc="Launch terminal"),
    Key(mod, "space", lazy.spawn(defaultPrimaryMenu), desc="Launch dmenu"),
    Key(mod, "t", lazy.spawn(defaultTerminal), desc="Launch terminal"),
    Key(mod, "b", lazy.spawn(defaultBrowser), desc="Launch browser"),
    Key(mod, "e", lazy.spawn(defaultEmailCliant), desc="Launch thunderbird"),
    Key(mod, "f", lazy.spawn(defaultFileManagerGUI), desc="Lauch primary file manager"),
]

# =============== Groups ===============
groups = [
    Group(" "),
    Group(" "),
    Group(" "),
    Group(" "),
    Group(" ", matches=[Match(wm_class=defaultRecorder)]),
    Group(" ", matches=[Match(wm_class=defaultPaint)]),
    Group(" ", matches=[
        Match(wm_class=defaultVideoEditor),
        Match(wm_class=defaultAudioEditor),
        Match(wm_class=defaultPhotoEditor),
    ]),
    Group(" ", matches=[Match(wm_class=defaultVideoPlayer)]),
    Group(" ", matches=[Match(wm_class=defaultVirtualbox)]),
    Group(" ")
]
dgroups_key_binder = simple_key_binder(modKey)

# =============== ScratchPad ===============
groups.append(ScratchPad('scratchpad', [
    DropDown('terminal', defaultTerminal, width=0.4, height=0.5, x=0.3, y=0.2, opacity=1),  # type: ignore
    DropDown('FileManagerTUI', defaultFileManagerTUI, width=0.4, height=0.5, x=0.3, y=0.2, opacity=1),  # type: ignore
]))
keys.extend([
    Key(control, "1", lazy.group['scratchpad'].dropdown_toggle('terminal')),
    Key(control, "2", lazy.group['scratchpad'].dropdown_toggle('FileManagerTUI')),
])

# =============== Layout ===============
layouts = [
    MonadTall(border_focus=color.workspace),
    Max(border_focus=color.workspace),
    Floating(border_focus='bd93f9', margin=4),
]

# =============== TagBar ===============
widget_defaults = dict(
    font='PlemolJP Console NF',
    fontsize=12,
    padding=2,
    background=color.background,
)
extension_defaults = widget_defaults.copy()


def getSeparator(background: str = color.background, foreground: str = color.foreground):
    return widget.textbox.TextBox(
        text='\u25e2',
        padding=-2,
        fontsize=30,
        background=background,
        foreground=foreground
    )


screens = [
    Screen(top=Bar([
        widget.Image(
            filename='~/.config/qtile/icons/python.png',
            scale=True,
            margin_x=5,
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(defaultPrimaryMenu)}
        ),
        widget.GroupBox(
            margin_x=5,
            active=color.bright.white,
            inactive=color.white,
            highlight_color=[color.background, color.workspace],
            block_highlight_text_color=color.workspace,
            highlight_method='text',
        ),
        widget.Prompt(),
        getSeparator(foreground=color.workspace),
        widget.CurrentLayout(background=color.workspace),
        getSeparator(background=color.workspace, foreground=color.background),
        widget.WindowName(foreground=color.green),
        widget.Chord(
            chords_colors={'launch': (color.foreground, color.foreground)},
            name_transform=lambda name: name.upper(),
        ),
        widget.Systray(),
        getSeparator(foreground=color.foreground2),
        widget.Net(
            interface="wlp4s0",
            format='  {down} ↓↑ {up}',
            padding=2,
            background=color.foreground2,
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(defaultTerminal + ' -e nmtui')},
            foreground=color.blue,
        ),
        getSeparator(background=color.foreground2, foreground=color.foreground2),
        widget.CPU(
            format=' {freq_current:>4}GHz {load_percent:>4}% ',
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(defaultTerminal + ' -e htop')},
            background=color.foreground2,
            foreground=color.yellow,
        ),
        widget.Memory(
            background=color.foreground2,
            foreground=color.yellow,
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(defaultTerminal + ' -e htop')},
            fmt=' {:>14}',
        ),
        getSeparator(background=color.foreground2, foreground=color.foreground2),
        widget.ThermalSensor(
            background=color.foreground2,
            foreground=color.red,
            threshold=70,
            fmt='  {}',
        ),
        getSeparator(background=color.foreground2, foreground=color.foreground2),
        widget.Volume(
            fmt='  {}',
            background=color.foreground2,
            foreground=color.purple,
        ),
        getSeparator(background=color.foreground2, foreground=color.foreground2),
        widget.Battery(
            charge_char='',
            discharge_char='',
            format='  {percent:2.0%} {char}',
            background=color.foreground2,
            foreground=color.green,
        ),
        getSeparator(background=color.foreground2, foreground=color.foreground2),
        widget.Clock(
            format='  %a, %b %d %Y, %H:%M:%S',
            background=color.foreground2,
            foreground=color.white,
        ),
        getSeparator(background=color.foreground2, foreground=color.background),
        widget.QuickExit(
            fmt=' ',
            foreground=color.red,
        ),
    ], 20))
]

# Drag floating layouts.
mouse = [
    Drag(mod, "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag(mod, "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click(mod, "Button2", lazy.window.bring_to_front())
]

# dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = Floating(border_focus=color.purple, float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *Floating.default_float_rules,
    Match(wm_class='kdenlive'),  # gitk
    Match(wm_class='gimp'),  # gitk
    Match(wm_class='mypaint'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# Programms to start on log in


@ hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.call([home])


# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
