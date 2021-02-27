_addon.name = 'DynaD Shard Helper'
_addon.author = 'Dabidobido'
_addon.version = '1.0.2'
_addon.commands = {'ddsh'}

packets = require('packets')
res = require('resources')
config = require('config')
chatHelper = require('ChatHelper')

TellMode = 3

default = {
	 "WAR", "MNK", "WHM", "BLM", "RDM", "THF", "PLD", "DRK", "BST", "BRD", "RNG", "SAM", "NIN", "DRG", "SMN", "BLU", "COR", "PUP", "DNC", "SCH", "GEO", "RUN"
}
drops = config.load(default)

lots_file_path = windower.addon_path .. "data/lots.txt"

windower.register_event('incoming chunk', function(id, data)
    if id == 0x0D2 then
        local treasure = packets.parse('incoming', data)
        check(treasure.Index, treasure.Item)
    end
end)

windower.register_event('addon command', function(...)
	local args = L{...}
	if args[1] == "list" then
		print_lots()
	elseif args[1] == "testDrop" then
		if lots[args[3]] then
			check_item_name(string.upper(args[2]), string.upper(args[3]))
		end
	elseif args[1] == "printMode" then
		if type(tonumber(args[2])) == 'number' then
			chatHelper.PrintMode = tonumber(args[2])
		end
	elseif args[1] == "add" then
		parse_chat(args[2], args[3], TellMode, false)
	elseif args[1] == "addDrop" then
		table.insert(drops, string.upper(args[2]))
		config.save(drops)
	elseif args[1] == "removeDrop" then
		local dropToRemove = string.upper(args[2])
		for k, v in ipairs(drops) do
			if v == dropToRemove then
				table.remove(drops, k)
				config.save(drops)
				break
			end
		end
	elseif args[1] == "clearLots" then
		lots = {}
		save_lots()
	elseif args[1] == "reload" then
		lots = load_lots()
		drops = config.load()
	elseif args[1] == "chatDelay" then
		if type(tonumber(args[2])) == 'number' then
			chatHelper.ChatDelay = tonumber(args[2])
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
		windower.add_to_chat(122, "//ddsh testDrop <itemName> <nameInWatchlist>: tests a itemDrop along with the name in the watchList")
		windower.add_to_chat(122, "//ddsh chatDelay <delay>: sets the delay between chats to <delay>. I get errors at 2 secs but it seems fine at 4 seconds")
	end	
end)

function parse_chat(message,sender,mode,gm)
	if mode == TellMode or mode == PartyMode then -- check tell or party only
		if string.sub(message, 1, 1) == "{" then -- use uncommon character
			local cmdmsg = string.upper(string.sub(message, 2))
			for k,drop in pairs(drops) do
				if cmdmsg:match(drop) then
					if not lots[drop] then
						lots[drop] = {}
					end
					if not already_in_lots(drop, sender) then
						table.insert(lots[drop], sender)
					end
					save_lots()
				end
			end
		end
	end
end

windower.register_event('chat message', parse_chat)


function check(index, itemId)
	chatHelper.clear()
	if res.items[itemId] then
		for k,v in pairs(drops) do 
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

function already_in_lots(key, name)
	for k,v in pairs(lots) do
		if key == k then
			for k2, v2 in pairs(v) do
				if v2 == name then 
					return true
				end
			end
		end
	end
	return false
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
	for line in io.lines(lots_file_path) do
		local tokens = line:split(',')
		if #tokens > 1 then
			tempTable[tokens[1]] = {}
			for i = 2, #tokens do
				table.insert(tempTable[tokens[1]], tokens[i])
			end	
		end
	end
	return tempTable
end

lots = load_lots()