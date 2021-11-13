#Auto WS and MB

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

## //awsmb setspellpriority (spell_name as csv)

Sets priority for spells to burst with. Will go in order of input and check elements.

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