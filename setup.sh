#!/bin/sh

# Simple setup script 
# Written by me
#
# TO DO:
#		Read packages from file
#		Read menu from file
#		Symlink dotfiles
#		Log choices made so the config is repeatable.

function symlink_setup {
	while IFS= read -r dotfile; do
		cd ~
		dotfile=$dotfile
		if [ -L $dotfile ]; then 
			echo "[x] Symlink for $dotfile already setup."

		elif [ -f "$dotfile" ]; then
			# "MAKE DIR if doesn-t exist" function?
			echo "[x] Moving old $dotfile to $BACKUP_DOTFILES"
			mv "$dotfile" "$BACKUP_DOTFILES"
			# and symlink
		else
			# just symlink
			echo "[x] Symlinking $dotfile"
		fi
	done < ~/.dotfiles/locations.txt
}

echo "		ARCH-MANJARO SETUP SCRIPT"

echo "[x] Run a preliminary system cleanup?"
echo "[x] Setup dotfiles?"
symlink_setup

echo "[x] What do you wish to install?"
echo "	1) Basics (vim, git, gcc, gdb, palemoon)"

read option
case $option in

	1) sudo pacman -S --needed vim git gcc gdb palemoon ;;
	*) echo " \"$option\" Is Not A Valid Option";;
esac

