#Auto WS and MB
0.0.12:
- Changed spell priority to include hp% threshold.
- Changed magic burst behaviour to check if the second cast would burst instead of trying to cast it anyway
- Added seperate AM3 ws
- Added some self target ws and non skillchain ws

0.0.11:
- Fixed issue some skillchains being mistaken for double light/dark
- Fixed issue with skillchains not being target specific
- Fixed issue with magic bursting not working if it was enabled when skillchains were not started
- Fixed some debug issues

0.0.10:
- Fix bug with not recognizing double light/dark if it was only 2 step SC
- Added AM3 maintenance function
- Added spam mode for zerg situations like Mireu
- Only stop autowsmb on first zoning, not every zoning

0.0.9:
- Add a WS Spam mode where it doesn't care about SC
- Fix bug with needing at least 2 spells to parse

0.0.8:
- Fix issue with using ws immediately and not waiting for skillchain window 

0.0.7:
- Really fix the logic issue with not opening with ws immediately if cannot continue skillchain

0.0.6:
- Fix logic issue with not opening with ws immediately if cannot continue skillchain

0.0.5:
- Fix logic issue with opening with ws when not being able to continue skillchain even though don't open was set

0.0.4:
- Fix logic issue with not wsing even though not being able to continue skillchain

0.0.3: 
- Changed settings file structure to be able to save settings by job. ***Please delete the previous settings file.***
- Added mb functionality.
- Added function to only try to skill chain without using open ws.

0.0.2: 
- Added skillchain timing and don't try and continue double dark/light skillchains

0.0.1: 
- Auto ws and try to skillchain

# How it works

Use //autowsmb or //awsmb

## //awsmb start

Starts auto ws.

## //awsmb stop

Stops auto ws.

## //awsmb dontopen

Don't use open ws, only try to skill chain.

## //awsmb open: 

Use open ws.
		
## //awsmb setopenws (name,tp)

Set the name of ws to open with and the minimum tp to use the ws.

## //awsmb setwspriority ((name,tp,name,tp,...)

Set the name of ws and tp of ws to try to skillchain with. will try to make skillchains in the order of input.

## //awsmb setsclevel (1-3)

Will only try to skillchain and make skillchains of the level set here or above.

## //awsmb startmb

Starts auto magic bursting.
		
## //awsmb stopmb

Stops auto magic bursting.
			
## //awsmb setmbdelay (number) 

Sets delay between spells for mb. Default is 4 seconds. If set more than 8 then will only burst 1 spell.

## //awsmb setspellpriority (spell_name,hpp,spell_name,hpp,...)

Sets priority for spells to burst with. Will go in order of input and check elements. Hpp is amount of Hpp (HP percent) mob must have in order for spell to be used. Set to 0 for always use.

## //awsmb spam (on/off) 

Starts/Stops spamming opener ws

## //awsmb am3 (on/off)

Holds/Don't hold until 3000TP to trigger AM3. Will use open ws for AM3.")

## SC Example

1. //awsmb setopenws Primal Rend,1750
2. //awsmb setwspriority Decimation,1000,Cloudsplitter,1750
3. //awsmb setsclevel 2

Now, in this example, this will start with Primal Rend at 1750TP, then go to Cloudsplitter at 1750TP since there is no level 2 SC with Decimation from Primal Rend. After Cloudsplitter, this will then do Decimation at 1000TP to do a 3-step Light SC.

But if Noillurie is in the party, if she does Tachi: Kaiten, this will wait for the skillchain window and do Decimation to 2-step Light. Or if this does Primal Rend and Noillurie does Tachi: Kaiten for a Fragmentation skillchain, this will then do Decimation for a 3-step Light.

## MB Example

1. //awsmb setspellpriority fire vi,thunder vi,water vi,fire v,blizzard iii

When there is a liquefaction skillchain, will try to burst Fire VI and Fire V after 4 seconds.

2. //awsmb setmbdelay 10

When there is a darkness skillchain, will only burst Water VI since delay is more than 8

# TO DO:

1. Aeonic support