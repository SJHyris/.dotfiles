#!/bin/sh

# Simple setup script 
# Written by me
#
# TO DO:
#		Read packages from file
#		Symlink dotfiles
#		Log choices made so the config is repeatable.


###############################################
###				VARIABLES					###
###############################################

countmenu=0
countitem=0

while read -r line; do
	if [[ $line == @@@* ]]; then
		#Add to the MENU array
		mainmenu[${countmenu}]=${line:3}		
		menu=${mainmenu[${countmenu}]}
		((countmenu+=1))
		countitem=0
		
	else
		item="${menu}[${countitem}]"
		declare "${item}"=$line

		((countitem+=1))
	fi

done < ~/.dotfiles/installed.txt


###############################################
###				FUNCTIONS					###
###############################################

#Ask the user basic yes/no input
#Print custom message if it was  passed to the function

function userYN {
	if [[ $# == 1 ]]; then
		echo "$1 (y/n)"
	else 
		echo "Input y/n to choose: "
	fi

	read option
	case $option in

		y) return;;
		n) false;;
		*) echo " \"$option\" Is Not A Valid Option"; false;;
	esac
}

function print_menu {
	menu="${1}[@]"
	i=1
	for item in ${!menu}; do
		echo "	${i}) $item"
		((i+=1))
	done
}



function symlink_setup {
	$BACKUP_DOTFILES="~/.olddotfiles"
	while IFS= read -r dotfile; do
		cd ~
		dotfile=$dotfile
		if [ -L $dotfile ]; then 
			echo "	[x] Symlink for $dotfile already setup."

		elif [ -f "$dotfile" ]; then
			# "MAKE DIR if doesn-t exist" function?
			echo "	[x] Moving old $dotfile to $BACKUP_DOTFILES"
			mv "$dotfile" "$BACKUP_DOTFILES"
			# and symlink
		else
			# just symlink
			echo "	[x] Symlinking $dotfile"
		fi
	done < ~/.dotfiles/locations.txt
}

#preliminary system cleanup with bleachbit

function bleachsys {
	echo "	[x] Installing bleachbit"
	sudo pacman -S bleachbit
	sudo bleachbit -c system.*
	echo "	[x] Removing bleachbit"
	sudo pacman -R bleachbit
}

pcalc ()	{
	cd ~/.dotfiles
	echo "	[x] Cloning files from repo"
	git clone https://github.com/vapier/pcalc.git
	cd ./pcalc
	sudo make install
	cd ~/.dotfiles
	echo "	[x] Removing installation files"
	rm -rf ./pcalc	
}

##############################################################


echo "		ARCH-MANJARO SETUP SCRIPT"

#Preliminary system-wide update
if userYN "[x] Run system-wide update?"; then
	sudo pacman -Syu
	echo 
fi

#Preliminary cleanup using bleachbit
if userYN "[x] Run a preliminary system cleanup?"; then
	bleachsys	
	echo 
fi

#Setup Dotfiles
if userYN "[x] Setup dotfiles?"; then
	symlink_setup
	echo 
fi

echo "[x] What do you wish to install?"
echo ''
print_menu "mainmenu"
echo "	------------"
echo "	q) exit"

read option

if [ $option -ge 1 ] && [ $option -le ${#mainmenu[@]} ]; then

	print_menu "${mainmenu[(($option - 1))]}"

elif [ $option -eq "q" ]; then 
	return
else
	echo "[x] \"$option\" Is Not A Valid Option"
fi


