_addon.name = 'DynaD Shard Helper'
_addon.author = 'Dabidobido'
_addon.version = '1.0.5'
_addon.commands = {'ddsh'}

packets = require('packets')
res = require('resources')
config = require('config')
chatHelper = require('ChatHelper')

TellMode = 3

Loop = true

watchlist_file_path = windower.addon_path .. "data/watchList.txt"
lots_file_path = windower.addon_path .. "data/lots.txt"

default = {
     "WAR", "MNK", "WHM", "BLM", "RDM", "THF", "PLD", "DRK", "BST", "BRD", "RNG", "SAM", "NIN", "DRG", "SMN", "BLU", "COR", "PUP", "DNC", "SCH", "GEO", "RUN"
}

treasures = {}
got_treasure = false

windower.register_event('load', function()
	update_loop:loop(1, should_loop)
end)

function should_loop()
	return Loop
end

function update_loop()
	if got_treasure then
		chatHelper.clear()
		for k,v in pairs(treasures) do
			check(v.Index, v.Item)
		end
		got_treasure = false
	end
	chatHelper.print_lines()
end

windower.register_event('unload', function()
	Loop = false
end)

windower.register_event('incoming chunk', function(id, data)
    if id == 0x0D2 then
        local treasure = packets.parse('incoming', data)
		table.insert(treasures, treasure)
		got_treasure = true
    end
end)

windower.register_event('addon command', function(...)
	local args = L{...}
	if args[1] == "list" then
		print_lots()
	elseif args[1] == "testDrop" then
		if lots[string.upper(args[3])] then
			check_item_name(string.upper(args[2]), string.upper(args[3]))
			if args[4] then
				check_item_name(string.upper(args[4]), string.upper(args[3]))
			end		
		end
	elseif args[1] == "printMode" then
		if type(tonumber(args[2])) == 'number' then
			chatHelper.PrintMode = tonumber(args[2])
		end
	elseif args[1] == "add" and args[2] and args[3] then
		parse_chat(args[2], args[3], TellMode, false)
	elseif args[1] == "addDrop" and args[2] then
		local found = false
		for k, v in pairs(watchlist) do
			if v == string.upper(args[2]) then 		
				found = true
				break;
			end
		end
		if not found then
			table.insert(watchlist, string.upper(args[2]))
			windower.add_to_chat(122, "Added " .. args[2] .. " to watch list.")
			save_watchlist()
		else 
			windower.add_to_chat(122, args[2] .. " already in watch list.")
		end
	elseif args[1] == "removeDrop" and args[2] then
		for k, v in pairs(watchlist) do
			if v == string.upper(args[2]) then
				table.remove(watchlist, k)
				save_watchlist()
				windower.add_to_chat(122, "Removed " .. args[2] .. " from watch list.")
				break
			end
		end
	elseif args[1] == "clearLots" then
		lots = {}
		save_lots()
		windower.add_to_chat(122, "Cleared Lots")
	elseif args[1] == "reload" then
		lots = load_lots()
		watchlist = load_watchlist()
		windower.add_to_chat(122, "Reloaded lots and watchlist")
	elseif args[1] == "chatDelay" and args[2] then
		if type(tonumber(args[2])) == 'number' then
			chatHelper.ChatDelay = tonumber(args[2])
			windower.add_to_chat(122, "ChatDelat set to " .. tostring(chatHelper.ChatDelay))
		end
	else
		windower.add_to_chat(122, "Commands:")
		windower.add_to_chat(122, "//ddsh list: print the list of players who registered interest to the selected chat channel")
		windower.add_to_chat(122, "//ddsh printMode <mode>: sets the selected chat channel. 0 = Say, 4 = Party, -1 = Windower")
		windower.add_to_chat(122, "//ddsh add <chatmsg> <sender>: simulates a tell msg. E.g //ddsh add \"{ geo run\" Dabidobido")
		windower.add_to_chat(122, "//ddsh addDrop <dropName>: adds a drop to the watch list. E.g //ddsh addDrop Wings will add any drop with Wings in the name to the watchlist")
		windower.add_to_chat(122, "//ddsh removeDrop <dropName>: removes a drop from the watch list")
		windower.add_to_chat(122, "//ddsh clearLots: clears the list of interested players")
		windower.add_to_chat(122, "//ddsh reload: reloads watchlist and list of players from file")
		windower.add_to_chat(122, "//ddsh testDrop <itemName> <nameInWatchlist> <item2 - optional>: tests a itemDrop along with the name in the watchList")
		windower.add_to_chat(122, "//ddsh chatDelay <delay>: sets the delay between chats to <delay>. I get errors at 2 secs but it seems fine at 4 seconds")
	end	
end)

function parse_chat(message,sender,mode,gm)
	if mode == TellMode or mode == PartyMode then -- check tell or party only
		if string.sub(message, 1, 1) == "{" then -- use uncommon character
			remove_player_from_lots(sender)
			local cmdmsg = string.upper(string.sub(message, 2))
			local tokens = cmdmsg:split(' ')
			for k, token in pairs(tokens) do
				if token and string.len(token) > 0 then
					for k2,drop in pairs(watchlist) do
						local startidx, endidx = token:find(drop)
						if startidx == 1 then
							if not lots[drop] then
								lots[drop] = {}
							end
							table.insert(lots[drop], sender)
							save_lots()
							windower.add_to_chat(122, "Added " .. sender .. " to " .. drop .. " lots")
						end
					end
				end
			end
		end
	end
end

windower.register_event('chat message', parse_chat)


function check(index, itemId)
	chatHelper.clear()
	if res.items[itemId] then
		for k,v in pairs(watchlist) do 
			check_item_name(string.upper(res.items[itemId].name), v)
		end
	end
	chatHelper.print_lines()
end

function check_item_name(itemName, dropName)
	if string.find(itemName, dropName) then -- Check if it is a job shard
		local printString = itemName
		local found = false
		if lots[dropName] then -- If it is job shard then check if anyone registered interest
			for k,v in pairs(lots[dropName]) do
				found = true
				printString = printString .. ", "
				printString = printString .. v
			end	
		end
		if not found then
			printString = printString .. ", Free"
		end
		chatHelper.add_line(printString)
	end
end

function remove_player_from_lots(name)
	for k,v in pairs(lots) do
		for k2, v2 in pairs(v) do
			if v2 == name then 
				windower.add_to_chat(122, "Removed " .. name .. "from " .. k .. " lots")
				table.remove(v, k2)
				break
			end
		end
	end
end

function print_lots()
	chatHelper.clear()
	for k,v in pairs(lots) do
		local printString = k .. ": "
		if type(v) == "table" then
			for k2, v2 in pairs(v) do
				printString = printString .. v2 .. ", "
			end
			printString = printString
		end	
		chatHelper.add_line(printString)
	end
	chatHelper.print_lines()
end

function save_lots()
	if not windower.dir_exists(windower.addon_path..'data') then
        windower.create_dir(windower.addon_path..'data')
    end
	local f = io.open(lots_file_path,'w+')
	local saveString = ""
	for k, v in pairs(lots) do
		saveString = saveString .. k 
		for k2, v2 in pairs(v) do
			saveString = saveString .. ","
			saveString = saveString .. v2
		end
		saveString = saveString .. "\n"
	end
	f:write(saveString)
	f:close()
end

function save_watchlist()
	if not windower.dir_exists(windower.addon_path..'data') then
        windower.create_dir(windower.addon_path..'data')
    end
	local f = io.open(watchlist_file_path,'w+')
	local saveString = ""
	for k, v in pairs(watchlist) do
		saveString = saveString .. v .. ","
	end
	saveString = saveString.sub(saveString, 1, string.len(saveString) - 1)
	f:write(saveString)
	f:close()
end

-- from http://nocurve.com/2014/03/05/simple-csv-read-and-write-using-lua/
function string:split(sSeparator, nMax, bRegexp)
    if sSeparator == '' then
        sSeparator = ','
    end

    if nMax and nMax < 1 then
        nMax = nil
    end

    local aRecord = {}

    if self:len() > 0 then
        local bPlain = not bRegexp
        nMax = nMax or -1

        local nField, nStart = 1, 1
        local nFirst,nLast = self:find(sSeparator, nStart, bPlain)
        while nFirst and nMax ~= 0 do
            aRecord[nField] = self:sub(nStart, nFirst-1)
            nField = nField+1
            nStart = nLast+1
            nFirst,nLast = self:find(sSeparator, nStart, bPlain)
            nMax = nMax-1
        end
        aRecord[nField] = self:sub(nStart)
    end

    return aRecord
end

function load_lots()
	local tempTable = {}
	if windower.file_exists(lots_file_path) then
		for line in io.lines(lots_file_path) do
			local tokens = line:split(',')
			if #tokens > 1 then
				tempTable[tokens[1]] = {}
				for i = 2, #tokens do
					table.insert(tempTable[tokens[1]], tokens[i])
				end	
			end
		end
	end
	return tempTable
end

function load_watchlist()
	local tempTable = {}
	if windower.file_exists(watchlist_file_path) then
		for line in io.lines(watchlist_file_path) do
			local tokens = line:split(',')
			for k, token in pairs(tokens) do
				table.insert(tempTable, token)
			end
		end
	else 
		return default
	end
	return tempTable
end

lots = load_lots()
watchlist = load_watchlist()