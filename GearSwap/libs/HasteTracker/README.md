# HasteTracker

1.0
- Initial commit

# Features

- Determine which haste has been casted (Haste I or Haste II) and automatically cancel if the cancel_haste level has been set. E.g. If you are a RNG and wants to cancel all haste so that Koru-Moru can cast Flurry II on you then you can either put cancel_haste = 2 somewhere in your gearswap lua or //gs cancelhaste 2. 

# How to Use

- Put the following code somewhere near the top of your gearswap lua:
> include("HasteTracker/HasteTracker.lua")

# Commands:

- //gs cancelhaste (num 0-2)

Automatically cancels all haste I cast on you so that haste II can be cast by Koru-Moru or King of Hearts.
> //gs cancelhaste 1

