#!/bin/bash
#
# INSTALLATION SCRIPT FOR CHITIN BUILDER
#
# Directory where VMD startup script is installed, should be in users' paths.
# We use here the default employed by VMD
# Change here if you changed it when installing VMD 
install_library_dir="/usr/local/lib"

echo "Chitin Builder installation script"
echo "VMD assumed to be in the following folder: "

ls $install_library_dir

# Folder for chitin
echo "Creating Cellulose Builder folder"
#mkdir $chitinfolder
mkdir $install_library_dir/vmd/plugins/noarch/tcl/chitin1.0

#IMPORTANT: The user doing the install must be in the sudoers list

echo "Copying Chitin Builder"
sudo cp -r * $install_library_dir/vmd/plugins/noarch/tcl/chitin1.0/
echo "Done!"
