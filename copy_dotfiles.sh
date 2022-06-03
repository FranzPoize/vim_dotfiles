#!/bin/sh

[ -d "./Wallpapers" ] && rm -rf Wallpapers
cp -R ~/Wallpapers/ .
[ ! -d "./nvim/" ] && mkdir nvim
cp ~/.config/nvim/init.vim nvim/
[ ! -d "./i3/" ] && mkdir i3
cp ~/.config/i3/config i3/
[ -d "./polybar/" ] && rm -rf polybar
cp -R ~/.config/polybar/ .

