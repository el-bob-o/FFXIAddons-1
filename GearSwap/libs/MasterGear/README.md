# MasterGear

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

## //gs mastergear removeset (set_name)

Remove specified set.

> //gs mastergear removeset IdleRefresh

Removes IdleRefresh from all slots and equipment

## //gs mastergear update (gear_1_name,gear_2_name)

Updates name of gear from gear_1_name to gear_2_name.

> //gs mastergear update Meg. Gloves +1, Meg. Gloves +2

Changes the name of gear in sets named Meg. Gloves +1 to Meg. Gloves +2

## //gs mastergear removename (slot)

Removes from gear list item with the same name as the gear that is equipped in specified slot.

> //gs mastergear removename back

Removes from sets any gear with the same name as the gear equipped in the back slot. E.g if Ankou's Mantle is equipped in back slot then all Ankou's Mantle will be removed, even ones with different augments. If you want to update just the augments on 1 piece, can just edit the json by yourself.

# Limitations
- Doesn't care about inventory. If you want to care about gear in inventory, uncomment the "--0" in equipable_bags