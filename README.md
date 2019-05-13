# chitin_builder
Chitin builder plugin for VMD.

Developed by D. C. Malaspina and J. Faraudo.
Institut de Ciencia de Materials de Barcelona (ICMAB-CSIC)

please cite:
D.C. Malaspina and J. Faraudo Comp. Phys. Comm. , submitted (2019)

# Installation

Please download and unzip the code from the Download button in this GitBucket or clone by git clone.To 
To add the builder to the standard VMD extensions-modelling menu, please select the appropiate instructons depending on your OS:

-----------------------------------------
Linux (automatic)

Make the file install.sh executable 
From a terminal execute ./install.sh

Note: The installation script assumes that VMD is localted in the default folder /usr/local/lib. You can modify this setting by editing the install.sh file with any editor of your choice.

-------------------------------------------
Linux (Manual installation)

1) Locate the vmd folder in which the program VMD is installed. By default is /usr/local/lib/vmd  
Inside the vmd folder, locate the folder vmd/plugins/noarch/tcl/ that contains many plugins written in tcl language.
Inside this tcl folder, create a new folder with the name chitin1.0

2) Copy or move the chitin builder that you have downloaded to this new folder. You need superuser privileges.
For example, in ubuntu you can open a terminal in the folder  

the VMD tcl/plugin folder (example:your_path/vmd/plugins/noarch/tcl/chitin_builder) *Check your user privileges to copy the files in this directory

3) Open VMD. Now you should have the Chitin_Builder menu installed under Extensions/Modeling/Chitin Builder/
