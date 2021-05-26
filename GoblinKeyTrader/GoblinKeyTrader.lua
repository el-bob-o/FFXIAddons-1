_addon.name = 'Goblin Key Trader'
_addon.author = 'Dabidobido'
_addon.version = '1.0.0'
_addon.commands = {'gkt'}

require('logger')

current_time = 1
total_times = 0
trade_item_name = "dial key #fo"
trade_delay = 12

coroutines = {}

windower.register_event('addon command', function(...)
	local args = {...}
	if args[1] == "tradekey" and args[2] then
		local number = tonumber(args[2])
		if number then
			current_time = 1
			total_times = number
			local next_delay = 0
			for i = 1, total_times, 1 do
				table.insert(coroutines, coroutine.schedule(trade_key, next_delay))
				next_delay = next_delay + trade_delay
			end
		end
	elseif args[1] == "setitem" and args[2] then
		trade_item_name = ""
		for i = 2, #args, 1 do
			trade_item_name = trade_item_name .. args[i]
			if i < #args then trade_item_name = trade_item_name .. " " end
		end
		notice("Setting trade item to " .. trade_item_name)
	elseif args[1] == "stop" then
		notice("Stopping all trades")
		for k, v in pairs(coroutines) do
			coroutine.close(v)
		end
		coroutines = {}
	elseif args[1] == "help" then
		notice("//gkt stop: Stops trading")
		notice("//gkt setitem <name>: Sets the name of item to trade")
		notice("//gkt tradekey <number>: Trades keys to nearest npc <number> of times, so make sure you are standing close to a goblin!")
	end
end)

function trade_key()
	notice("Trading " .. trade_item_name .. " " .. current_time .. "/" .. total_times)
	windower.send_command('input /targetnpc; wait 0.1; input /item "' .. trade_item_name .. '" <t>')
	current_time = current_time + 1
end