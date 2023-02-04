import distro
import os
import shutil
import subprocess

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
# from libqtile.log_utils import logger

# Custom modules
from theme import Nord


home = os.path.expanduser("~")
config = f"{home}/.config"
wallpapers = f"{home}/.local/share/backgrounds/wallpapers"

mod = "mod4"
terminal = "kitty"
browser = "firefox"  # qutebrowser?
theme = Nord(f"{wallpapers}/nord")

# TODO
# 0) Notification server
# 1) Keybinding
#    - Screen lock
# 4) bar layout and widgets
#   - Go through list of supported widgets
#   - uniform spacing
#   - Logout/shutdown widget? Or dmenu script?
# 6) Some apps should not be tiled, eg. VirtualBox, ++
# 8) Theme
#    - put colorscheme and stuff here
#    - rounded corners (need qtile-extras for that)
#    - layout
#    - font
# 9) Widgets
#    - Storage (show used storage in percent)


# Used by CheckUpdates widget
def get_distro():
    name = distro.name()
    if name == "Arch Linux":
        return "Arch_checkupdates"
    return name


# A list of available commands that can be bound to keys can be found
# at https://docs.qtile.org/en/latest/manual/config/lazy.html
keys = [
    # Essentials
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "d", lazy.spawn(
        f'rofi -no-lazy-grab -show drun -display-drun "" -font "{theme.font} {theme.fontsize}" -theme {config}/qtile/assets/nord.rasi'),
        desc="Run application launcher"
        ),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload configuration"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # Applications
    Key([mod], "b", lazy.spawn(browser), desc="Launch browser"),

    # Window management
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen mode for focused window"),
    # TODO: Screen/monitor management
    # - Move focused window to other screen and focus that window
    # - Move focus to other screen
    # - Minimize/hide focused window (and reset)

    # Layout management
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    # multiple stack panes ... what's this?
    Key([mod, "shift"], "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
        ),

    # Misc
    Key([], "XF86AudioRaiseVolume", lazy.spawncmd("amixer -D pulse sset Master 5 %+"), desc="Increase volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawncmd("amixer -D pulse sset Master 5 %-"), desc="Decrease volume"),
    Key([], "XF86AudioMute", lazy.spawncmd("amixer -D pulse sset Master toggle"), desc="Toggle volume"),
    Key([mod], "XF86AudioRaiseVolume", lazy.spawncmd("amixer -D pulse sset Capture %+"), desc="Increase mic volume"),
    Key([mod], "XF86AudioLowerVolume", lazy.spawncmd("amixer -D pulse sset Capture 5 %-"), desc="Decrease mic volume"),
    Key([], "XF86AudioMicMute", lazy.spawncmd("amixer -D pulse sset Capture toggle"), desc="Toggle mic"),
    Key([], "XF86MonBrightnessDown", lazy.spawncmd("brightnessctl set 5%-"), desc="Decrease brightness"),
    Key([], "XF86MonBrightnessUp", lazy.spawncmd("brightnessctl set +5%"), desc="Increase brightness"),
]

groups = [
    Group("", layout="monadtall"),
    Group("", layout="max", matches=[Match(wm_class=["firefox", "chromium", "brave"])]),
    Group("", layout="monadtall", matches=[Match(wm_class=["emacs", "code"])]),
    Group("", layout="monadtall", matches=[Match(wm_class=["qpdfview", "thunar", "pcmanfm", "nautilus"])]),
    Group("", layout="max"),
    Group("", layout="max", matches=[Match(wm_class=["spotify"])]),
    Group("", layout="max"),  # virtualbox?
]

for i, g in zip(["1", "2", "3", "4", "5", "6", "7"], groups):
    keys.append(Key([mod], i, lazy.group[g.name].toscreen(), desc=f"Switch to group {g.name}"))
    keys.append(Key([mod, "shift"], i, lazy.window.togroup(g.name, switch_group=True), desc=f"Switch to & move focused window to group {g.name}"))


check_updates_distro = get_distro()

layouts = [
    # layout.Columns(**theme.layout),
    layout.Max(**theme.layout),
    # layout.Stack(num_stacks=2, **layout_theme),
    layout.Bsp(**theme.layout),
    layout.Matrix(**theme.layout),
    layout.MonadTall(**theme.layout),
    layout.MonadWide(**theme.layout),
    layout.RatioTile(**theme.layout),
    layout.Tile(**theme.layout),
    # layout.TreeTab(
    #    sections=['FIRST', 'SECOND'],
    #    bg_color='#3b4252',
    #    active_bg='#bf616a',
    #    inactive_bg='#a3be8c',
    #    padding_y=5,
    #    section_top=10,
    #    panel_width=280
    # ),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font=theme.font,
    fontsize=theme.fontsize,
    #  padding=theme.padding,
    background=theme.bg_normal,
    foreground=theme.fg_focus
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        wallpaper=theme.wallpaper,
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.GroupBox(
                    active=theme.fg_normal,
                    inactive=theme.bg_focus,
                    block_highlight_text_color=theme.fg_focus,
                    this_current_screen_border=theme.fg_focus,
                    highlight_color=[theme.bg_normal, theme.bg_focus],  # when using "line" method
                    highlight_method="line",
                    urgent_border=theme.border_urgent,
                    urgent_text=theme.fg_urgent,
                    urgent_alert_method="line",
                    margin_x=0,
                    margin_y=3,
                    padding_x=5,
                    padding_y=8,
                    rounded=False,
                    borderwidth=2,
                    disable_drag=True,
                ),
                widget.Prompt(),  # What's this for?
                widget.Spacer(),
                widget.TextBox(
                    text="◢",
                    padding=0,
                    fontsize=50,
                    foreground=theme.bg_focus,
                ),
                widget.CPU(
                    format=" {load_percent}%",
                    update_interval=2,
                    background=theme.bg_focus,
                ),
                widget.ThermalSensor(
                    fmt=" {}",
                    update_interval=5,
                    background=theme.bg_focus,
                ),
                widget.Memory(
                    format=" {MemPercent}%",
                    update_interval=2,
                    background=theme.bg_focus,
                ),
                # Mic?
                widget.Volume(
                    fmt=' {}',
                    background=theme.bg_focus,
                ),
                widget.Battery(
                    charge_char="",
                    discharge_char="",
                    full_char="",
                    empty_char="",
                    # unknown_char="", ???
                    low_foreground=theme.fg_urgent,
                    # notify_below=, ???
                    format="{char} {percent:2.0%}",
                    background=theme.bg_focus,
                ),
                widget.Net(
                    format=" {down} ↓↑{up}",
                    interface="all",
                    background=theme.bg_focus,
                    prefix="M"
                ),
                widget.TextBox(
                    text="◢",
                    padding=0,
                    fontsize=50,
                    background=theme.bg_focus,
                    foreground=theme.bg_normal,
                ),
                widget.Clock(
                    format="%a %b %d, %H:%M",
                ),
                widget.TextBox(
                    text="◢",
                    padding=0,
                    fontsize=50,
                    foreground=theme.bg_focus,
                ),
                widget.CheckUpdates(
                    colour_have_updates=theme.fg_focus,
                    colour_no_updates=theme.bg_focus,
                    update_interval=1800,
                    distro=check_updates_distro,
                    display_format=" {updates}",
                    background=theme.bg_focus,
                ),
                widget.Sep(
                    foreground=theme.bg_focus,
                    background=theme.bg_focus,
                    linewidth=5,
                ),
            ],
            22,
            margin=[theme.useless_gap, theme.useless_gap, 0, theme.useless_gap],
            opacity=0.9,
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True


@hook.subscribe.restart
def cleanup():
    shutil.rmtree(os.path.expanduser("~/.config/qtile/__pycache__"))


@hook.subscribe.shutdown
def killall():
    shutil.rmtree(os.path.expanduser("~/.config/qtile/__pycache__"))
    # TODO -- Popen shutdown processes


# @hook.subscribe.startup_once
# def start_once():
#     home = os.path.expanduser('~')
#     subprocess.call([home + '/.config/qtile/autostart.sh'])


@hook.subscribe.startup
def start_always():
    subprocess.Popen(["/usr/bin/xset", "r", "rate", "200", "40"])


# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
