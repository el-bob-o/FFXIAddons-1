# Mandragora Mania Bot

This is for automating the Mandragora Mania mini game. This only reads packets and does not inject them, and uses input commands to simulate the client actually playing the game normally. But still, use at your own risk!

# How to Use

1. Talk to Chacharoon in Bastok Markets (only tested on this npc, unknown if other npcs in other cities have same ids or not)
2. Make sure you go first in the settings (because I couldn't be bothered to find out how to figure this out from packets)
3. Go to the player selection sub menu (I couldn't find an incoming or outgoing packet when I went between the main menu and player selection sub menu)
4. //mmbot start <number>
5. Select player (Only tested logic against Green Thumb Moogle Pattern D. Quite possible there are infinite loop situations and/or bugs). You can select other players at first but the automation will always selected Green Thumb Moogle.

# Commands

use //mmbot to send commands

## mmbot start <number>

> mmbot start 20

Will automate through 20 games.

## mmbot stop

Will stop the automation.

## mmbot debug 

Toggles between printing debug messages to console or not. Default is off.

# Version History

1.0.0: 
- First version.
