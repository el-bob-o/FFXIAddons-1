# MasterGear
1.4.6
MasterGeaLua
- Use TH gear is no set defined for spells in midcast and if treasure hunter mode set to fulltime

1.4.5
MasterGearLua
- Add WeatherObi set to midcast

1.4.4
MasterGearFunctions
- Enabled wardrobe 4 by default

1.4.3
MasterGearFunctions
- Print out slip number that needs to be in inventory when not in mog garden

1.4.2
MasterGeaLua
- Added Killer effect function

MasterGearFunctions
- Update augments and HP when updating gear by name

1.4.1
MasterGearLua
- Added Throwing set and command to MasterGearLua
- Added Mode prefix to sets
- Added custom_aftercast, custom_zone_change and custom_status_change functions

MasterGearFunctions
- Ignore inventory when printing extra gear

1.4.0
- Added MasterGearLua library that has basic gearswap functionality

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

# How to Use MasterGearLua

- Put the following code somewhere near the top of your gearswap lua:
> include("MasterGear/MasterGearLua.lua")

- Do not define get_sets(), precast(), midcast(), aftercast(), status_change(), self_command() in your lua.

- That's it! That can be the only line in your lua and you can start using it immediately. Requires THHelper and HasteTracker libraries. This uses MasterGearFunctions so you can start by defining some sets.

## MasterGearLua Sets

"Mode_(num)(name)" e.g "Mode_1HybridTP". Naming your sets this way will automatically populate the modes available, which you can change using "//gs c mode (num)" or cycle through with "//gs c mode". Only 9 modes available at the moment. Modes are equipped on engage, on aftercast, and even on idle if combat mode ("//gs c combat" to toggle) is on.

"IdleRegen" and "Movement". These are equipped when Idle.

"Fastcast". Equipped in precast whenever a magic spell is cast.

"Adoulin". Equipped in Adoulin.

"TPBonus". Any TPBonus gear like Moonshade earring. These will be equipped when a table named 'ws' exists. If it does, the weaponskill's english name is checked (e.g ws\["Raging Fist"]). It will then equip the set defined and equip TPBonus set if tp_bonus is true and tp is less than 3000. 

> ws = {}
> ws\["Raging Fist"] = { set = sets\["Raging Fist"], tp_bonus = true }

"WeatherObi". This is for elemental weaponskills. If the day matches the element, this set will be equipped.

"Precast_<name>". E.g "Precast_Repair" will equip this set for "Repair" ability in Precast.

"Midcast_<name>". E.g "Midcast_Diaga" will equip this set for "Diaga" spell in Midcast.

"CP". This set will be equipped when CP mode is on, toggled by "//gs c cp"

You can also do "Precast_(mode_name)(name)" or "Midcast_(mode_name)(name)". E.g If you have a mode called "Mode_2HighAcc" then you can do "Precast_HighAccRaging Fists" and it will equip "Precast_HighAccRaging Fists" only when you are using "Mode_2HighAcc".

## MasterGearLua Custom functions

- custom_get_set. If defined, will be called after get_sets() is done.
- custom_precast(spell). If defined, will be called right at the start of precast(). If the function returns true, will stop processing anything else.
- custom_midcast(spell). If defined, will be called right at the start of midcast(). If the function returns true, will stop processing anything else.
- custom_command(args). If defined, will be called at the end of self_command(). Args parameter is a list of strings, so you can do "if args\[1] == 'blabla' then do_something()".
- custom_aftercast(spell). If defined, will be called right at the start of aftercast(). If the function returns true, will stop processing anything else.
- custom_status_change(new, old). If defined, will be called at the start of status_change(). If the function returns true, will stop processing anything else.
- custom_zone_change(). If defined, will be called at the start of zone_change(). If the function returns true, will stop processing anything else.

# How to Use MasterGearFunctions

- Put the following code somewhere near the top of your gearswap lua:
> include("MasterGear/MasterGearFunctions.lua")

# MasterGearFunction Features

- Auto priority based on +HP on the gear
- Since all gear for all jobs is now centralised, can determine which gear in wardrobes is not used by any jobs

# MasterGearFunction Commands

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