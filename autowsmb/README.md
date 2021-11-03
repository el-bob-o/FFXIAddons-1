#Auto WS and MB

- 0.0.1: Auto ws and try to skillchain

# How it works

## //autowsmb setopenws (ws_name:string)

Use this to set a ws to use to open skillchains

## //autowsmb setwspriority (ws:csv)

Use this to set ws to use in order of priority. 

## //autowsmb setsclevel (level:number)

Use this to search for skillchains only of a certain level or above.

## Example

1. //autowsmb setopenws Primal Rend
2. //autowsmb setwspriority Decimation,Cloudsplitter
3. //autowsmb setsclevel 2

Now, in this example, this will start with Primal Rend, then go to Cloudsplitter since there is no level 2 SC with Decimation from Primal Rend. After Cloudsplitter, this will then do Decimation to do a 3-step Light SC.

But if Noillurie is in the party, if she does Tachi: Kaiten, this will wait for the skillchain window and do Decimation to 2-step Light. Or if this does Primal Rend and Noillurie does Tachi: Kaiten for a Fragmentation skillchain, this will then do Decimation for a 3-step Light.