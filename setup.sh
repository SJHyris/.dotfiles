#!/bin/sh

# Simple setup script 
# Written by me
#
# TO DO:
#		Do the "Install all" option for a module
#		Log choices made so the config is repeatable.
#		Low priority: make it usable on ubuntu?


###############################################
###				VARIABLES					###
###############################################

countmenu=0
countitem=0

# Read menu from the file
while read -r line; do

	# Main Menu options are prefixed by @@@
	if [[ $line == @@@* ]]; then

		#Add to the mainmenu array, stripping it of the @@@
		mainmenu[${countmenu}]=${line:3}		
		
		# Create an array of arrays named "menu"
		# And add an item by the name of the option it just read 
		menu=${mainmenu[${countmenu}]}

		# Increment and reset counters
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
	echo "	------------"
	echo "	q) exit"
	(( i-=1 ))
	return $i
	
	}


function submenu {

	echo "[x] Select the software you wish to install."
	echo "[x] Type "all" to install them all."
	echo
	print_menu "$1"
	len=$?


	read option

	if [ "$option" == "q" ]; then 
		return

	elif [ "$option" == "all" ]; then 
		return

	elif [ $option -ge 1 ] && [ $option -le $len ]; then
		
		item="${1}[$(($option - 1))]"
		declare item=${!item}
		install "$item"

	else
		echo "[x] \"$option\" Is Not A Valid Option"
	fi
}


function install {
	specific=("pcalc", "wireshark", "pip", "pwntools", "python_net")
	if [[ " ${specific[@]} " =~ " ${1} " ]]; then
		${1}
	else
		sudo pacman --needed -S $1
	fi
}

function symlink_setup {
	BACKUP_DOTFILES=".olddotfiles"
	while IFS= read -r dotfile; do
		cd ~
		dotfile=$dotfile
		if [ -L $dotfile ]; then 
			echo "	[x] Symlink for $dotfile already setup."

		elif [ -f "$dotfile" ]; then
			mkdir $BACKUP_DOTFILES
			echo "	[x] Moving old $dotfile to $BACKUP_DOTFILES"
			mv "$dotfile" "$BACKUP_DOTFILES"

			echo "	[x] Symlinking $dotfile"
					ln -s ~/.dotfiles/${dotfile} ~/${dotfile}
		else
			echo "	[x] Symlinking $dotfile"
			ln -s ~/.dotfiles/${dotfile} ~/${dotfile}
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
	make
	sudo make install
	cd ~/.dotfiles
	echo "	[x] Removing installation files"
	rm -rf ./pcalc	
}

function wireshark { echo "works"
	sudo pacman -S wireshark-qt
	sudo gpasswd -a $USER wireshark
}

function pip {
	sudo pacman -S --needed python-pip python2-pip
}

function pwntools {
	sudo pip2 install pwntools
}

python_net () {
	sudo pip install sockets
	sudo pip install matplotlib
	sudo pacman -S tk
	sudo pip install requests
	sudo pip install python-geoip
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

while :
do
	echo "[x] What do you wish to install?"
	echo ''
	print_menu "mainmenu"

	read option

	if [[ "$option" == "q" ]]; then 
		exit
	elif [ $option -ge 1 ] && [ $option -le ${#mainmenu[@]} ]; then
		
		submenu "${mainmenu[(($option - 1))]}"

	else
		echo "[x] \"$option\" Is Not A Valid Option"
	fi

done
