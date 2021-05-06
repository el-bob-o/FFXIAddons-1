_addon.name = 'LastSynthBot'
_addon.author = 'Dabidobido'
_addon.version = '1.0.0'
_addon.commands = {'lsb'}

craft_delay = 22
current = 1
todo = 1

windower.register_event('addon command', function(...)
	local args = {...}
	if args[1] then
		if type(tonumber(args[1])) == 'number' then
			current = 1
			todo = tonumber(args[1])
			for i = 1, todo, 1 do
				coroutine.schedule(last_synth, craft_delay * (i - 1))
			end
		end
	end
end)

function last_synth()
	windower.add_to_chat(122, "Synth " .. current .. "/" .. todo)
	current = current + 1
	windower.send_command('input /lastsynth')
end