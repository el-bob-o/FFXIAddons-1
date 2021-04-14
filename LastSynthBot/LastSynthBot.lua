_addon.name = 'LastSynthBot'
_addon.author = 'Dabidobido'
_addon.version = '1.0.0'
_addon.commands = {'lsb'}

craft_delay = 20

windower.register_event('addon command', function(...)
	local args = {...}
	if args[1] then
		if type(tonumber(args[1])) == 'number' then
			for i = 1, tonumber(args[1]), 1 do
				coroutine.schedule(last_synth, craft_delay * (i - 1))
			end
		end
	end
end)

function last_synth()
	windower.send_command('input /lastsynth')
end