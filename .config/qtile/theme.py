import os
import random


class Nord:
    def __init__(self, wallpaper_path):
        if os.path.isdir(wallpaper_path):
            self.wallpaper = (
                f"{wallpaper_path}/{random.choice(os.listdir(wallpaper_path))}"
            )
        else:
            self.wallpaper = wallpaper_path

        # TODO: Make these configurable
        self.font = "UbuntuMono Nerd Font"
        self.fontsize = 11

        self.nord0 = "#2e3440"
        self.nord1 = "#3b4252"
        self.nord2 = "#434c5e"
        self.nord3 = "#4c566a"
        self.nord4 = "#d8dee9"
        self.nord5 = "#e5e9f0"
        self.nord6 = "#eceff4"
        self.nord7 = "#8fbcbb"
        self.nord8 = "#88c0d0"
        self.nord9 = "#81a1c1"
        self.nord10 = "#5e81ac"
        self.nord11 = "#bf616a"
        self.nord12 = "#d08770"
        self.nord13 = "#ebcb8b"
        self.nord14 = "#a3be8c"
        self.nord15 = "#b48ead"

        self.colors = [
            [self.nord0, self.nord0],
            [self.nord0, self.nord0],
            [self.nord1, self.nord1],
            [self.nord2, self.nord2],
            [self.nord3, self.nord3],
            [self.nord4, self.nord4],
            [self.nord5, self.nord5],
            [self.nord6, self.nord6],
            [self.nord7, self.nord7],
            [self.nord8, self.nord8],
            [self.nord9, self.nord9],
            [self.nord10, self.nord10],
            [self.nord11, self.nord11],
            [self.nord12, self.nord12],
            [self.nord13, self.nord13],
            [self.nord14, self.nord14],
            [self.nord15, self.nord15],
        ]

        self.black = self.nord0
        self.white = self.nord6
        self.teal = self.nord7
        self.cyan = self.nord8
        self.blue = self.nord9
        self.red = self.nord11
        self.orange = self.nord12
        self.yellow = self.nord13
        self.green = self.nord14
        self.magenta = self.nord15

        self.fg_normal = self.nord6
        self.fg_focus = self.nord8
        self.fg_urgent = self.nord12
        self.fg_critical = self.nord11

        self.bg_normal = self.nord0
        self.bg_focus = self.nord1
        self.bg_urgent = self.nord1
        self.bg_critical = self.nord1

        self.border_normal = self.nord1
        self.border_focus = self.nord8
        self.border_urgent = self.nord12
        self.border_critical = self.nord11
        self.border_width = 1

        self.padding = 5
        self.useless_gap = 8
        self.widget_spacing = 8

        self.layout = {
            "margin": self.useless_gap,
            "border_width": self.border_width,
            "border_focus": self.border_focus,
            "border_normal": self.border_normal,
        }
