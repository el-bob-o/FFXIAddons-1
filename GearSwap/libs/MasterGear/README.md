# MasterGear
1.3.4
- Fix logic problem that prevented getting all the gear with slipget and made it necessary to run the command multiple times

1.3.3
- Updated the porterpacker integration to produce error if slips are not in inventory and user not in mog garden
- Changed moveslipgear to slipmove to make it easier to up arrow and change the command. Slipmove can only be used in mog garden.

1.3.2
- Delay moving by 1 sec since 0.5 sec seems to have some repeats
- Delay sending command to porterpacker for getting slip items by 2sec, to have time to move slips into inventory 

1.3.1
- Fix some chat spam issues
- Added moveslipgear command to move slips to storage bags and slip gear to wardrobes

1.3.0
- Added PorterPacker support: slipstore and slipget commands to store and get gear from storage slips.

1.2.0
- Changed removeset function to take slots
- Removed the removebyname function since removeset with new slot functionality is better.

1.1
- Fix exportsets function

1.0
- Initial commit

# How to Use

- Put the following code somewhere near the top of your gearswap lua:
> include("MasterGear/MasterGearFunctions.lua")

- In your get_set function or equivalent:
> get_set_for_job_from_json()

# Features

- Auto priority based on +HP on the gear
- Since all gear for all jobs is now centralised, can determine which gear in wardrobes is not used by any jobs

# Commands

## //gs mastergear countgear (filter:optional) (jobs:csv)

Count number of gear for jobs specified in third argument if filter keyword is specified. Otherwise count all gear

> //gs mastergear countgear filter rng

Count the total number of gear used by ranger job

## //gs mastergear extragear (jobs:csv)

List gear that is in wardrobes but not in the MasterGearList for jobs specified in second argument

> //gs mastergear extragear run,sam

Lists all the extra gear that is in wardrobes that is not part of any set for runefencer and samurai jobs

## //gs mastergear missinggear (jobs:csv)

List gear that is in MasterGearList for jobs specified in second argument but not in wardrobes

> //gs mastergear missinggear run,sam

List all the gear that was defined in sets for runefencer and samurai but not in wardrobes

## //gs mastergear exportsets

Export all sets to a txt file.

## //gs mastergear saveeq (set_name)

Saved equipped gear to a set. Won't save main, sub, ranged.

> //gs mastergear saveeq Idle.Regen

Saves all equipment except main,sub,ranged to a set called Idle.Regen. This can be accessed in gearswap with equip(sets.Idle.Regen) or equip(sets\["Idle]\["Regen"])

## //gs mastergear saveslots (slots:csv) (set_name)

Saved gear in specified slots to a set.

> //gs mastergear saveslots head,feet,ring1,ring2 IdleRefresh

Saves equipment in head, feet, ring1, ring2 slots to a set called IdleRefresh.

## //gs mastergear removeset (slot, set_name)

Remove specified set from slot. Use 'all' for all slots.

> //gs mastergear removeset IdleRefresh

Removes IdleRefresh from all slots and equipment

## //gs mastergear update (gear_1_name,gear_2_name)

Updates name of gear from gear_1_name to gear_2_name.

> //gs mastergear update Meg. Gloves +1, Meg. Gloves +2

Changes the name of gear in sets named Meg. Gloves +1 to Meg. Gloves +2

## //gs mastergear slipstore (jobs:csv)

Stores all gear that can be stored on slips except for gear for jobs specified. If no jobs specified, will use current job. Requires PorterPacker to be loaded.

## //gs mastergear slipget (jobs:csv)

Gets all gear that is stored on slips for jobs specified. If no jobs specified, will use current job. Requires PorterPacker to be loaded.

## //gs mastergear moveslipgear

Moves slips to storage bags and slip gear to wardrobes.

# Limitations
- No support for items with the same name (e.g 2x Varar Ring +1). Need to edit the json and add in the bag info yourself.
> "name": "Varar Ring +1",
> "bag": "wardrobe",