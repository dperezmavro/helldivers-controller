# About
This is a board I made to learn KiCAD and also because I wanted for a while to delve deeper into Arduinos and electronics. 

# Purpose
This is a very basic board that is effectively a macro-pad. It is based around an Arduino Pro Micro and uses 4 toggle switches and 4 push-buttons to provide 4 dual-mode macro-programmable buttons (i.e. each button has an A/B mode). The intention is to use this to call stratagems faster.

Given than you can re-program the ProMicro, this can be changed to your liking.

# Current design
I made the design choice to have the Pro Micro attach to the board using pin headers. This is because I had an arduino die on me whilst prototyping on a perfboard, and I had to restart the whole thing. The pin-header design allows you to swap out the board very easily.


## Schematic
![image](graphics/schematic.PNG)

Each channel has one mode toggle (SW1, SW3, SW5, SW7) and one macro button (SW2, SW4, SW6, SW8). The nets are labelled `MODEn` and `BTNn`; the design notes on the sheet explain the wiring and the pin map. The Pro Micro symbol and the custom footprints (Pro Micro, AEDIKO SPDT toggle, logo) are project-local libraries in `controller/lib`, registered in `controller/sym-lib-table` and `controller/fp-lib-table`, so the project opens without any extra library setup.

## 3d render
This is what the current board render looks like when 3D

![image](graphics/sm_blue_top.png)

## Assembled
And this is what it looks like after assembled IRL.

![image](graphics/assembled_1.jpg)
![image](graphics/assembled_2.jpg)
![image](graphics/assembled_3.jpg)
![image](graphics/assembled_4.jpg)
![image](graphics/assembled_5.jpg)

# Future work
Since this is the first PCB that I have designed and fabricated, I have found some bugs in the physical layout of the board. 

## The spacing of they keyboard buttons is too tight to allow for keycaps. 

Keycaps are a 1u width (roughly 17mm) and the current spacing is too tight as I only meassured the keyboard button and did not account for the width of the keycap that would sit on top whilst designing. This means that most keycaps are rubbing both on the keycaps next to them, as well as they toggle switches above them.

## The pinout for the 4th button and switch is reversed. 

This is not so much a bug, as much as a very likely gotcha (and it did get me!). Due to board layout and via routing, I found it easier to switch the pin order for the 4th button and toggle switch combination. The board still works as intended, but this is something to keep in mind when programming. In the schematic this shows as `BTN4` on D8 and `MODE4` on D9, whereas the other channels have the toggle on the lower pin number. 

The 3rd and 4th button vias are also very close to each other, and this might make manufacturing hard/impossible for some providers. 

## Board shape and standoff screws

The current screws are M2, I would change them to M3. I would also round the corners of the board.

## Make this wireless
I would need to work out how to make this a bluetooth-enabled keyboard, and also figure out the power situation.


## Make this wearable

It would be cool to make this wearable, like the pad in the game! This would make most sence if the board is wireless. 

# Lisence

Feel free to replicate this project for your own personal use. No commercial use is allowed (i.e. uses including, but not limited to, commercial manufacturing, resale, reuse, incorporation or integration of parts or the whole of this project).