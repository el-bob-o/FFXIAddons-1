res = require 'resources'
slips = require 'slips'

jobs = { "WAR", "MNK", "WHM", "BLM", "RDM", "THF", "PLD", "DRK", "BST", "BRD", "RNG", "SAM", "NIN", "DRG", "SMN", "BLU", "COR", "PUP", "DNC", "SCH", "GEO", "RUN" }

equipable_bags = { --0, -- don't care inventory 
					8, 10, 11, 12 } -- Mog Wardrobes
					
storage_bags = { 1, 2, 5, 6, 7, 9 }

function get_set_for_job(job, sets)
	return populate_set(sets, job)
end

function populate_set(sets, job)
	local count = 0
	for slot,gears in pairs(MasterGearList) do
		for k,gear in pairs(gears) do
			count = count + add_to_set(sets, gear, slot, job)
		end
	end
	return count
end

function add_to_set(sets, gear, slot, job)
	local count = 0
	for k,setData in pairs(gear.setList) do
		if string.upper(setData.job) == string.upper(job) then
			for k2, set in pairs(setData.sets) do
				if sets[set] == nil then
					sets[set] = { }
				end
				if sets[set][slot] == nil then
					sets[set][slot] = gear
					count = count + 1
				else
					add_to_chat(122, "Duplicate found at " .. tostring(set) .. " for " .. tostring(slot) .. " slot.")
				end
			end
		end
	end
	return count
end

function master_gear_list_command(args)
	if args[1] == "countgear" then
		count_gear(args)
	elseif args[1] == "extragear" and args[2] then
		print_extra_gear_not_in_master_list(args)
	elseif args[1] == "missinggear" and args[2] then
		print_missing_gear(args)
	elseif args[1] == "exportsets" then
		export_sets()
	elseif args[1] == "testFunction" then
		export_sets()
	else
		windower.add_to_chat(122, "MasterGear Commands:")
		windower.add_to_chat(122, "//gs c countgear <filter:optional> <jobs:csv>: Count number of gear for jobs specified in third argument if filter keyword is specified. Otherwise count all gear")
		windower.add_to_chat(122, "//gs c extragear <jobs:csv>: List gear that is in wardrobes but not in the MasterGearList for jobs specified in second argument")
		windower.add_to_chat(122, "//gs c missinggear <jobs:csv>: List gear that is in MasterGearList for jobs specified in second argument but not in wardrobes")
		windower.add_to_chat(122, "//gs c exportsets: Export all sets to a txt file")
	end
end

function export_sets()
	if not windower.dir_exists(windower.addon_path..'export') then
        windower.create_dir(windower.addon_path..'export')
    end
	local exportFilePath = windower.addon_path..'export/'..player.name..'.txt'
	local f = io.open(exportFilePath,'w+')
	local saveString = ""
	for k, job in pairs(jobs) do
		local sets = {} 
		if get_set_for_job(job, sets) > 0 then		
			saveString = saveString .. job .. " {\n"
			for set, gearlist in pairs(sets) do
				saveString = saveString .. "\t" .. set .. " {\n"
				if gearlist["main"] then saveString = saveString .. "\t\t main = " .. gearlist["main"].name .. "\n" end
				if gearlist["sub"] then saveString = saveString .. "\t\t sub = " .. gearlist["sub"].name .. "\n" end
				if gearlist["range"] then saveString = saveString .. "\t\t range = " .. gearlist["range"].name .. "\n" end
				if gearlist["ammo"] then saveString = saveString .. "\t\t ammo = " .. gearlist["ammo"].name .. "\n" end
				if gearlist["head"] then saveString = saveString .. "\t\t head = " .. gearlist["head"].name .. "\n" end
				if gearlist["neck"] then saveString = saveString .. "\t\t neck = " .. gearlist["neck"].name .. "\n" end
				if gearlist["ear1"] then saveString = saveString .. "\t\t ear1 = " .. gearlist["ear1"].name .. "\n" end
				if gearlist["ear2"] then saveString = saveString .. "\t\t ear2 = " .. gearlist["ear2"].name .. "\n" end
				if gearlist["body"] then saveString = saveString .. "\t\t body = " .. gearlist["body"].name .. "\n" end
				if gearlist["hands"] then saveString = saveString .. "\t\t hands = " .. gearlist["hands"].name .. "\n" end
				if gearlist["ring1"] then saveString = saveString .. "\t\t ring1 = " .. gearlist["ring1"].name .. "\n" end
				if gearlist["ring2"] then saveString = saveString .. "\t\t ring2 = " .. gearlist["ring2"].name .. "\n" end
				if gearlist["back"] then saveString = saveString .. "\t\t back = " .. gearlist["back"].name .. "\n" end
				if gearlist["waist"] then saveString = saveString .. "\t\t waist = " .. gearlist["waist"].name .. "\n" end
				if gearlist["legs"] then saveString = saveString .. "\t\t legs = " .. gearlist["legs"].name .. "\n" end
				if gearlist["feet"] then saveString = saveString .. "\t\t feet = " .. gearlist["feet"].name .. "\n" end
				saveString = saveString .. "\t}\n"
			end
			saveString = saveString .. "}\n"
		end
	end
	f:write(saveString)
	f:close()
end

function check_zone()
	local zone = windower.ffxi.get_info().zone
	if zone == 280 then -- Mog Garden
		return true
	else	
		add_to_chat(122, "Not in Mog Garden!")
		return false
	end
end

function check_porter_moogle()
    local npc = windower.ffxi.get_mob_by_name('Porter Moogle')
    if npc and math.sqrt(npc.distance) < 6 and npc.valid_target and npc.is_npc and bit.band(npc.spawn_type, 0xDF) == 2 then
        return true
    end
    add_to_chat(122, 'Porter Moogle is not in range')
	return false
end

function count_gear(args)
	add_to_chat(122, "Gear Count")
	local filter = nil
	if args[2] == "filter" and args[3] then
		filter = string.upper(args[3]):split(',')
		add_to_chat(122,  "Only: " .. args[3])
	end
	local totalGearCount = 0
	for slot,gears in pairs(MasterGearList) do
		local gearCount = 0
		for k, gear in pairs(gears) do
			if filter ~= nil then
				for k2, set in pairs(gear.setList) do
					if filter:contains(set.job) then
						gearCount = gearCount + 1
						totalGearCount = totalGearCount + 1
						break
					end
				end
			else
				gearCount = gearCount + 1
				totalGearCount = totalGearCount + 1
			end
		end
		add_to_chat(122, tostring(slot) .. ": " .. tostring(gearCount))
	end
	add_to_chat(122, "Total: " .. tostring(totalGearCount))
end

function print_extra_gear_not_in_master_list(args)
	add_to_chat(122, "Extra Gear")
	local filter = args[2]:split(',')
	local masterGearList = get_list_of_gear_in_master_list(filter)
	local extra = get_list_of_extra_gear(masterGearList)	
	for itemId, bagId in pairs(extra) do
		if res.items[itemId] then
			local itemName = res.items[itemId].name
			if masterGearList[itemName] == nil then
				add_to_chat(122, itemName .. " in " .. res.bags[bagId].name)
			end
		end	
	end
end

function get_list_of_extra_gear(masterGearList)
	local invSet = get_list_of_gear_in_equipable_inventory()
	local extraGears = {}
	for itemId, bagId in pairs(invSet) do
		if masterGearList[res.items[itemId].name] == nil then
			table.insert(extraGears, itemId, bagId)
		end
	end	
	return extraGears
end

function get_list_of_gear_in_master_list(filter)
	local gearSet = S{}
	for slot,gears in pairs(MasterGearList) do
		for k, gear in pairs(gears) do
			if filter ~= nil then
				for k2, set in pairs(gear.setList) do
					if filter:contains(string.lower(set.job)) then
						gearSet[gear.name] = 1
						break
					end
				end
			else
				gearSet[gear.name] = 1
			end
		end
	end
	return gearSet
end

function get_list_of_gear_in_equipable_inventory()
	local inventorySet = S{}
	for _, bagId in pairs(equipable_bags) do
		local inv = windower.ffxi.get_items(bagId)
		for _, item in pairs(inv) do
			if type(item) == 'table' then
				if item.id ~= nil and item.id ~= 0 and res.items[item.id] then
					inventorySet[item.id] = bagId
				end
			end
		end
	end
	return inventorySet
end

function print_missing_gear(args)
	add_to_chat(122, "Missing Gear")
	local filter = args[2]:split(',')
	local gearSet = get_list_of_gear_in_master_list(filter)
	local invSet = get_list_of_gear_in_equipable_inventory()
	for itemId, bagId in pairs(gearSet) do
		if res.items[itemId] then
			local itemName = res.items[itemId].name
			if invSet[itemName] == nil then
				add_to_chat(122, item)
			end
		end
	end
end