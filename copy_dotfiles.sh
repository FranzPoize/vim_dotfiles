#!/bin/sh

[ -d "./Wallpapers" ] && rm -rf Wallpapers
cp -R ~/Wallpapers/ .
[ ! -d "./nvim/" ] && rm -rf nvim
cp -R ~/.config/nvim/ .
[ ! -d "./i3/" ] && mkdir i3
cp ~/.config/i3/config i3/
[ ! -d "./fish/" ] && rm -rf fish
cp -R ~/.config/fish/ .
[ -d "./polybar/" ] && rm -rf polybar
cp -R ~/.config/polybar/ .

