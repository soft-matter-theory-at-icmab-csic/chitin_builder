# chitin_builder
Chitin builder plugin for VMD

# Installation
In VMD, open the menu Extensions/VMD Preferences. In the CUSTOM tab add NEW by clicking the button on the left.

In Descriptino add:

Chitin_builder

In Code add:

lappend auto_path /path_to_your_downloaded_code

menu main on

package require chitin

Press the UPDATE button and also the WRITE SETTINGS TO VMDRC button, press yes if ask to overwrite.
Close VMD and reopen it.
Now you should have the Chitin_Builder menu installed under Extensions/Modeling/Chitin Builder/
