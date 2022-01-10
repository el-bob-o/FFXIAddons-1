# HasteTracker
1.0.4
- Don't do anything if cancelhaste set to 0

1.0.3
- Fixed hastega and hastega II from Garuda (Doesn't seem to work if it's not your own Garuda)

1.0.2
- Fixed the check to see if any spells were still being cast. Can't use # operator for non-contiguous tables! 

1.0.1
- Will only cancel if everyone finished casting to minimize chances of cancelling a haste buff that user actually wants
- Keep track of Ygnas' Phototropic Wrath also
- Added in debug logging

1.0
- Initial commit

# Features

- Determine which haste has been casted (Haste I or Haste II) and automatically cancel if the cancel_haste level has been set. E.g. If you are a RNG and wants to cancel all haste so that Koru-Moru can cast Flurry II on you then you can either put cancel_haste = 2 somewhere in your gearswap lua or //gs cancelhaste 2. 

# How to Use

- Put the following code somewhere near the top of your gearswap lua:
> include("HasteTracker/HasteTracker.lua")

# Commands:

## //gs cancelhaste (num 0-2)

Set to automatically cancel haste spells cast on you.

> //gs cancelhaste 2

Automatically cancels all haste spells so that Flurry II can be cast by Koru-Moru.

> //gs cancelhaste 1

Automatically cancels all Haste I cast on you so that Haste II can be cast by Koru-Moru or King of Hearts.

> //gs cancelhaste 0

Don't cancel any haste spells.


