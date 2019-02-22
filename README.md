# Dotfiles repo
A simple repository with my dotfiles and a basic setup script to get them symlinked, do a bit of post-installation cleaning and installing basic applications. 

The dotfiles list is contained in the file locations.txt, while the file installed.txt is used to dynamically generate the application menus. Any line beginning with  @@@ defines a category, under which the various apps are listed.

If no custom function is defined, the script issues a "sudo pacman -S <list_item>" when any item is selected. To define a custom function for the installation of the program it must be named exactly <list_item> and added to the array "specific" inside the "install" function.

Written for Manjaro i3.
