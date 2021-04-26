res = require 'resources'
slips = require 'slips'
extdata = require 'extdata'

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
	elseif args[1] == "mastergearhelp" then
		print_help()
	elseif args[1] == "testFunction" then
		export_sets()	
	end
end

function print_help()
	windower.add_to_chat(122, "MasterGear Commands:")
	windower.add_to_chat(122, "//gs c countgear <filter:optional> <jobs:csv>: Count number of gear for jobs specified in third argument if filter keyword is specified. Otherwise count all gear")
	windower.add_to_chat(122, "//gs c extragear <jobs:csv>: List gear that is in wardrobes but not in the MasterGearList for jobs specified in second argument")
	windower.add_to_chat(122, "//gs c missinggear <jobs:csv>: List gear that is in MasterGearList for jobs specified in second argument but not in wardrobes")
	windower.add_to_chat(122, "//gs c exportsets: Export all sets to a txt file")
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
				saveString = saveString .. gear_string(gearlist, "main")
				saveString = saveString .. gear_string(gearlist, "sub")
				saveString = saveString .. gear_string(gearlist, "range")
				saveString = saveString .. gear_string(gearlist, "ammo")
				saveString = saveString .. gear_string(gearlist, "head")
				saveString = saveString .. gear_string(gearlist, "neck")
				saveString = saveString .. gear_string(gearlist, "ear1")
				saveString = saveString .. gear_string(gearlist, "ear2")
				saveString = saveString .. gear_string(gearlist, "body")
				saveString = saveString .. gear_string(gearlist, "hands")
				saveString = saveString .. gear_string(gearlist, "ring1")
				saveString = saveString .. gear_string(gearlist, "ring2")
				saveString = saveString .. gear_string(gearlist, "back")
				saveString = saveString .. gear_string(gearlist, "waist")
				saveString = saveString .. gear_string(gearlist, "legs")
				saveString = saveString .. gear_string(gearlist, "feet")
				saveString = saveString .. "\t}\n"
			end
			saveString = saveString .. "}\n"
		end
	end
	f:write(saveString)
	f:close()
end

function gear_string(gearlist, slot_name)
	local ret_string = ""
	if gearlist[slot_name] then	
		ret_string = ret_string .. "\t\t " .. slot_name .. " = " .. gearlist[slot_name].name
		if gearlist[slot_name].augments then 
			ret_string = ret_string .. ", augments = "
			for k, augment in pairs(gearlist[slot_name].augments) do
				ret_string = ret_string .. augment .. ", "
			end
			ret_string = ret_string .. "\n"
		else
			ret_string = ret_string .. "\n"
		end
	end
	return ret_string
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
	for bagId, itemList in pairs(extra) do
		for k, item in pairs(itemList) do
			if res.items[item.id] then
				if item.extdata then
					local augments = extdata.decode(item).augments
					if augments then
						local print_string = res.items[item.id].name .. ", augments = "
						for k3, augment in pairs(augments) do
							print_string = print_string .. augment .. ", "
						end		
						add_to_chat(122, print_string .. " in " .. res.bags[bagId].name)
					else
						add_to_chat(122, res.items[item.id].name .. " in " .. res.bags[bagId].name)
					end
				else
					add_to_chat(122, res.items[item.id].name .. " in " .. res.bags[bagId].name)
				end
			end
		end
	end
end

function get_list_of_extra_gear(masterGearList)
	local invSet = get_list_of_gear_in_equipable_inventory()
	local extraGears = {}
	for bagId, itemList in pairs(invSet) do
		for k, item in pairs(itemList) do
			local found = false
			if res.items[item.id] then
				for k2, master_gear_item in pairs(masterGearList) do
					if master_gear_item.name == res.items[item.id].name then
						if master_gear_item.augments then
							if extdata.compare_augments(master_gear_item.augments ,extdata.decode(item).augments) then
								found = true
								break
							end
						else
							found = true
							break
						end
					end
				end
			end
			if not found then
				if extraGears[bagId] == nil then extraGears[bagId] = {} end
				table.insert(extraGears[bagId], item)
			end
		end
	end	
	return extraGears
end

function get_list_of_gear_in_master_list(filter)
	local gearSet = {}
	for slot,gears in pairs(MasterGearList) do
		for k, gear in pairs(gears) do
			if filter ~= nil then
				for k2, set in pairs(gear.setList) do
					if filter:contains(string.lower(set.job)) then
						table.insert(gearSet, gear)
					end
				end
			else
				table.insert(gearSet, gear)
			end
		end
	end
	return gearSet
end

function get_list_of_gear_in_equipable_inventory()
	local inventorySet = {}
	for _, bagId in pairs(equipable_bags) do
		local inv = windower.ffxi.get_items(bagId)
		for _, item in pairs(inv) do
			if type(item) == 'table' then
				if item.id ~= nil and item.id ~= 0 and res.items[item.id] then
					if inventorySet[bagId] == nil then inventorySet[bagId] = {} end
					table.insert(inventorySet[bagId], item)
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
	for k, gear in pairs(gearSet) do
		local found = false
		for bagId, itemList in pairs(invSet) do
			for k2, item in pairs(itemList) do
				if res.items[item.id] and res.items[item.id].name == gear.name then
					if gear.augments then
						if extdata.compare_augments(gear.augments ,extdata.decode(item).augments) then
							found = true
							break
						end
					else
						found = true
						break
					end
				end
			end
		end
		if not found then
			if gear.augments then 
				local print_string = gear.name .. ", augments = "
				for k3, augment in pairs(gear.augments) do
					print_string = print_string .. augment .. ", "
				end		
				add_to_chat(122, print_string)
			else
				add_to_chat(122, gear.name)
			end
		end
	end
end