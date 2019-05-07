# chitin_builder
Chitin builder plugin for VMD

# Installation

1. Download the code from the Download button in Github or by git clone

2. In VMD, open the menu Extensions/VMD Preferences. In the CUSTOM tab add NEW by clicking the button on the left.

__In Description add:__

Chitin_builder

__In Code add:__
```
lappend auto_path /path_to/your_downloaded_code

menu main on

package require chitin
```
3. Press the UPDATE button and also the WRITE SETTINGS TO VMDRC button, press yes if ask to overwrite.

4. Close VMD and reopen it.

Now you should have the Chitin_Builder menu installed under Extensions/Modeling/Chitin Builder/
