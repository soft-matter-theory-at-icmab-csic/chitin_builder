# chitin_builder
Chitin builder plugin for VMD

# Installation
In VMD, open the menu Extensions/VMD Preferences. In the CUSTOM tab add NEW by clicking the button on the left.

__In Description add:__

Chitin_builder

__In Code add:__
```
lappend auto_path /path_to/your_downloaded_code

menu main on

package require chitin
```
Press the UPDATE button and also the WRITE SETTINGS TO VMDRC button, press yes if ask to overwrite.
Close VMD and reopen it.
Now you should have the Chitin_Builder menu installed under Extensions/Modeling/Chitin Builder/
