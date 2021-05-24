# Dynamis D Shard Helper

This is for groups doing Dynamis D that wants some help with lotting (e.g people choosing 2 jobs and only lotting the shards for those 2 jobs).

Party members can use party chat or tell to register which job shards they want to lot for by prefixing a '{' character and then the job three-letter abbreviations (e.g "/p {rdm geo"). When a shard for those classes drops, this will automatically output to chat the players who registered interest (e.g "/p Voidshard: RDM, Dabidobido, Dabidabida")

# Notes

- Lot list is saved in a csv file so that it is saved if player with this addon crashes or disconnects in Dynamis D. For this reason, please use *ddsh clear* to reset the lot list before asking party members to register interest before a Dynamis D run.

- Currently, Windower will sometimes pass chat strings that are not terminated properly with the 'chat message' event. This means that parsing chat messages will lead to crashes. For this reason, I have used matching instead of parsing to determine player interest. If not for this, I would have made this for more general usage. However, a possible workaround for other drops is to manually add drops and players using *ddsh addDebug*.

# Commands

use //ddsh to send commands

## ddsh list "dropNames - optional"

> ddsh list

Prints in either windower chat mode, party chat or say chat the jobs and players who registered interest. 

> ddsh list RUN,WHM

Only list players who registered for RUN and WHM.

## ddsh printMode "number"

Sets which channel to print stuff.
 
- -1 = Windower Chat
- 0 = Say
- 4 = Party Chat
	
## ddsh testDrop "itemIds"

Simulates stuff dropping into treasure pool. Pass in itemIds. For more than one, use comma to seperate different ids.

>ddsh testDrop 9609,9609

9609 is Torsoshard: RUN so will print list of people for registered for RUN.

## ddsh add "chatMessage" "senderName"

Manually add players to the lot list. Chat message has to have the '{' prefix.

> ddsh add "{ rdm" Dabidobido

Add Dabidobido to the RDM list

## ddsh clearLots

This will clear the lot list

## ddsh addDrop "itemName"

This will add a drop to the drop list.

## ddsh removeDrop "itemName"

This removes a drop from the drop list.

## ddsh reload

Reloads drops from setting file and lots from lots file.

# Version History
1.0.9:
- Fix typo

1.0.8:
- Check for item validity before adding it to treasure list since that 0D2 packet is received 8x upon zoning and possibly other times as well

1.0.7:
- fixed lots not appearing if another treasure dropped before lots were printed
- changed testDrop function
- added optional argument to list function

1.0.6:
- fixed lots not appearing
- fixed treasure pool not clearing

1.0.5:
- fixed only first chat appearing when there are multiple watched drops
- fixed adding to wrong lots when names match with multiple watchlist items (e.g "/p { sch" will add player to "sch" and "eschalixir" lots if both are in the watchlist). However, "/p { geo" will add to both "geo" and "geode" as I'm matching if it starts the same due to the windower chat issue
- changed watchlist to txt file instead of config because config can't add or remove from a list easily
- more feedback to know when things are working or not
- automatically remove player from lots if player sends a chat message again. Doesn't care if new message has valid lots or not.

1.0.4:
- attempt to fix only first chat appearing when there are multiple watched drops

1.0.3:
- fix chat not appearing for party and say modes

1.0.2:
- added ChatDelay command to configure delay
- use multiple lines in one chat message

1.0.1:
- Fix printing to chat. Need to schedule it otherwise there will be an error or it will crash.
- Moved the drop names to a settings file. Added addDrop and removeDrop command.
- Changed clear command to clearLots so that it is clear it doesn't clear the settings, only the lots.
- Added reload command to reload settings and lots from file. This is to let people edit the file and reload it if needed.
- Removed addDebug command.

1.0.0: 
- First version with basic functionality
