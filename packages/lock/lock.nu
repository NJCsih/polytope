#!/usr/bin/env nu

#let path = '$#{wallpaperPath}';

#let choice = ls $path | shuffle | get 0.name;
let choice = ls /run/current-system/sw/share/wallpapers/system-wallpapers | shuffle | get 0.name;
#${pkgs.swaylock}/bin/swaylock -fFi $choice;
swaylock -fFi $choice;
systemctl suspend;
