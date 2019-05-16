#!/bin/bash
#
# INSTALLATION SCRIPT FOR CHITIN BUILDER
#

#-------------------------------------------------------
# SECTION THAT CAN BE MODIFIED
# Directory where VMD startup script is installed, should be in users' paths.
# We use here the default employed by VMD

# Change here if you changed it when installing VMD 
install_library_dir="/usr/local/lib/vmd"

#------------------------------------------------------
#
#Installation script please do not modify
#
echo "------------------------------------"
echo "Chitin Builder installation script"
echo "This script requires superuser permission."
echo "Using user:"
echo "$(whoami)"
#[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"

#Check location of VMD
if [ ! -d "$install_library_dir" ]; then
    echo "VMD folder not found, it should be installed in non standard place"
    echo "Please modify install_library_dir variable in this script. "
    exit 1
fi

echo "VMD found at $install_library_dir"

# Folder for chitin
if [ ! -d "$install_library_dir/plugins/noarch/tcl/chitin1.0" ]; then
    echo "Creating Chitin Builder folder"
    mkdir $install_library_dir/plugins/noarch/tcl/chitin1.0
fi

#IMPORTANT: The user doing the install must be in the sudoers list

echo "Copying Chitin Builder at vmd folder plugins/noarch/tcl/chitin1.0"
sudo cp -r * $install_library_dir/plugins/noarch/tcl/chitin1.0/
echo "Done!"
echo "Chitin Builder is ready to be used in VMD"
