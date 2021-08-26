-- Version 1.1

res = require 'resources'
slips = require 'slips'
extdata = require 'extdata'
json = include('MasterGear/json.lua')

local default_gear_list = {
	main =  { },
	sub = { },
	range = { },
	ammo = { },
	head = { },
	neck = { },
	ear1 = { },
	ear2 = { },
	body = { },
	hands = { },
	ring1 = { },
	ring2 = { },
	back = { },
	waist = { },
	legs = { },
	feet = { },
}

jobs = { "WAR", "MNK", "WHM", "BLM", "RDM", "THF", "PLD", "DRK", "BST", "BRD", "RNG", "SAM", "NIN", "DRG", "SMN", "BLU", "COR", "PUP", "DNC", "SCH", "GEO", "RUN" }

equipable_bags = { --0, -- don't care inventory 
					8, 10, 11, 12 } -- Mog Wardrobes
					
-- storage_bags = { 1, 2, 5, 6, 7, 9 }  -- Maybe for future use when doing something like porterpacker

gear_list_file_path = windower.addon_path .. "data/gear_list.json"

function load_json_setting()
	local f = io.open(gear_list_file_path,'r')
	local json_string = ""
	if f then
		json_string = f:read("*a")
		f:close()
	end
	if not json_string or #json_string == 0 then
		f = io.open(gear_list_file_path,'w+')
		f:write(json:encode_pretty(default_gear_list))
		f:close()
		return default_gear_list
	else
		return json:decode(json_string)
	end
end

function save_json_setting()
	local f = io.open(gear_list_file_path,'w+')
	f:write(json:encode_pretty(gear_list))
	f:close()
end

gear_list = load_json_setting()

function save_gear_slots(slots_csv, set_name)
	local slots = slots_csv:lower():split(',') 
	local equipment = windower.ffxi.get_items().equipment
	for k, v in pairs(slots) do
		if v == 'main' then
			local main = windower.ffxi.get_items(equipment.main_bag, equipment.main)
			save_gear_to_slot(main, gear_list.main, set_name)
		elseif v == 'sub' then
			local sub = windower.ffxi.get_items(equipment.sub_bag, equipment.sub)
			save_gear_to_slot(sub, gear_list.sub, set_name)
		elseif v == 'range' then
			local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)
			save_gear_to_slot(range, gear_list.range, set_name)
		elseif v == 'ammo' then
			local ammo = windower.ffxi.get_items(equipment.ammo_bag, equipment.ammo)
			save_gear_to_slot(ammo, gear_list.ammo, set_name)
		elseif v == 'head' then
			local head = windower.ffxi.get_items(equipment.head_bag, equipment.head)
			save_gear_to_slot(head, gear_list.head, set_name)
		elseif v == 'neck' then
			local neck = windower.ffxi.get_items(equipment.neck_bag, equipment.neck)
			save_gear_to_slot(neck, gear_list.neck, set_name)
		elseif v == 'ear1' then
			local ear1 = windower.ffxi.get_items(equipment.left_ear_bag, equipment.left_ear)
			save_gear_to_slot(ear1, gear_list.ear1, set_name)
		elseif v == 'ear2' then
			local ear2 = windower.ffxi.get_items(equipment.right_ear_bag, equipment.right_ear)
			save_gear_to_slot(ear2, gear_list.ear2, set_name)
		elseif v == 'body' then
			local body = windower.ffxi.get_items(equipment.body_bag, equipment.body)
			save_gear_to_slot(body, gear_list.body, set_name)
		elseif v == 'hands' then
			local hands = windower.ffxi.get_items(equipment.hands_bag, equipment.hands)
			save_gear_to_slot(hands, gear_list.hands, set_name)
		elseif v == 'ring1' then
			local ring1 = windower.ffxi.get_items(equipment.left_ring_bag, equipment.left_ring)
			save_gear_to_slot(ring1, gear_list.ring1, set_name)
		elseif v == 'ring2' then
			local ring2 = windower.ffxi.get_items(equipment.right_ring_bag, equipment.right_ring)
			save_gear_to_slot(ring2, gear_list.ring2, set_name)
		elseif v == 'back' then
			local back = windower.ffxi.get_items(equipment.back_bag, equipment.back)
			save_gear_to_slot(back, gear_list.back, set_name)
		elseif v == 'waist' then
			local waist = windower.ffxi.get_items(equipment.waist_bag, equipment.waist)
			save_gear_to_slot(waist, gear_list.waist, set_name)
		elseif v == 'legs' then
			local legs = windower.ffxi.get_items(equipment.legs_bag, equipment.legs)
			save_gear_to_slot(legs, gear_list.legs, set_name)
		elseif v == 'feet' then
			local feet = windower.ffxi.get_items(equipment.feet_bag, equipment.feet)
			save_gear_to_slot(feet, gear_list.feet, set_name)
		end
	end
end

function save_equipped_as_set(set_name)
	save_gear_slots("ammo,head,neck,ear1,ear2,body,hands,ring1,ring2,back,waist,legs,feet", set_name)
	save_json_setting()
end

function get_hp(description)
	start,last = description:find("HP[+-]%d+")
	if start and last then
		return tonumber(description:sub(start+2, last))
	else
		return 0
	end
end

function save_gear_to_slot(item, slot, set_name)
	if not item or item.id == 65535 then return end -- equipping empty returns gil for some stupid reason
	remove_set_from_slot(slot, set_name)
	local item_name = res.items[item.id].name
	local augments = extdata.decode(item).augments
	for k,v in pairs(slot) do
		if item_name == v.name then
			if (not augments and not v.augments) or 
			   (augments and v.augments and extdata.compare_augments(v.augments ,augments)) then 
				for k2, v2 in pairs(v.set_list) do
					if v2[player.main_job] then
						table.insert(v2[player.main_job], set_name)
						return
					else
						v2[player.main_job] = T{}
						table.insert(v2[player.main_job], set_name)
						return
					end
				end
			end
		end
	end
	local descriptions = res.item_descriptions[item.id]
    local helptext = descriptions and descriptions.english or '' --for 'vanilla' items. e.g. Moonshade Earring
	local gear = { }
	gear.name = item_name
	gear.set_list = { }
	gear.priority = get_hp(helptext)
	if augments then gear.augments = augments end
	local set = { }
	set[player.main_job] = T{ }
	table.insert(set[player.main_job], set_name)
	table.insert(gear.set_list, set)
	table.insert(slot, gear)
end

function remove_set(set_name)
	remove_set_from_slot(gear_list.main, set_name)
	remove_set_from_slot(gear_list.sub, set_name)
	remove_set_from_slot(gear_list.range, set_name)
	remove_set_from_slot(gear_list.ammo, set_name)
	remove_set_from_slot(gear_list.head, set_name)
	remove_set_from_slot(gear_list.neck, set_name)
	remove_set_from_slot(gear_list.ear1, set_name)
	remove_set_from_slot(gear_list.ear2, set_name)
	remove_set_from_slot(gear_list.body, set_name)
	remove_set_from_slot(gear_list.hands, set_name)
	remove_set_from_slot(gear_list.ring1, set_name)
	remove_set_from_slot(gear_list.ring2, set_name)
	remove_set_from_slot(gear_list.back, set_name)
	remove_set_from_slot(gear_list.waist, set_name)
	remove_set_from_slot(gear_list.legs, set_name)
	remove_set_from_slot(gear_list.feet, set_name)
	save_json_setting()
end

function remove_set_from_slot(slot, set_name)
	for k,v in pairs(slot) do
		for k2, v2 in pairs(v.set_list) do
			if v2[player.main_job] then
				for k3, v3 in pairs(v2[player.main_job]) do
					if v3 == set_name then
						table.remove(v2[player.main_job], k3)
						break
					end
				end
				if #v2[player.main_job] == 0 then
					v2[player.main_job] = nil
				end
			end
		end
	end
	for k,v in pairs(slot) do
		local count = 0
		for k2, v2 in pairs(v.set_list) do
			for k3, v3 in pairs(v2) do
				count = count + 1
			end
		end
		if count == 0 then
			table.remove(slot, k)
		end
	end
end

function get_set_for_job_from_json()
	return populate_sets_from_json(sets, player.main_job)
end

function get_set_from_json(job, set_list)
	return populate_sets_from_json(set_list, job)
end

function populate_sets_from_json(sets, job)
	local count = 0
	for slot, gears in pairs(gear_list) do
		for k, gear in pairs(gears) do
			count = count + add_to_set_json(sets, gear, slot, job)
		end
	end
	return count
end

function export_sets_from_json()
	if not windower.dir_exists(windower.addon_path..'export') then
        windower.create_dir(windower.addon_path..'export')
    end
	local exportFilePath = windower.addon_path..'export/'..player.name..'.txt'
	windower.add_to_chat(122, "Exporting sets to " .. exportFilePath)
	local f = io.open(exportFilePath,'w+')
	local saveString = ""
	for k, job in pairs(jobs) do
		local sets = {} 
		if get_set_from_json(job, sets) > 0 then		
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

function count_gear_from_json(args)
	add_to_chat(122, "Gear Count")
	local filter = nil
	if args[2] == "filter" and args[3] then
		filter = string.upper(args[3]):split(',')
		add_to_chat(122,  "Only: " .. args[3])
	end
	local totalGearCount = 0
	for slot,gears in pairs(gear_list) do
		local gearCount = 0
		for k, gear in pairs(gears) do
			if filter ~= nil then
				for k2, set in pairs(gear.set_list) do
					for k3, v3 in pairs(set) do
						if filter:contains(k3) then
							gearCount = gearCount + 1
							totalGearCount = totalGearCount + 1
							break
						end
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

function get_list_of_gear_in_json(filter)
	local gearSet = {}
	for slot,gears in pairs(gear_list) do
		for k, gear in pairs(gears) do
			if filter ~= nil then
				for k2, v2 in pairs(gear.set_list) do
					for k3, v3 in pairs(v2) do
						if filter:contains(string.lower(k3)) then
							table.insert(gearSet, gear)
						end
					end
				end
			else
				table.insert(gearSet, gear)
			end
		end
	end
	return gearSet
end

function print_extra_gear_not_in_json(args)
	add_to_chat(122, "Extra Gear")
	local filter = nil 
	if args[2] then filter = string.lower(args[2]):split(',') end
	local gears = get_list_of_gear_in_json(filter)
	local extra = get_list_of_extra_gear(gears)	
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

function print_missing_gear_json(args)
	add_to_chat(122, "Missing Gear")
	local filter = args[2]:split(',')
	local gears = get_list_of_gear_in_json(filter)
	local inv_gears = get_list_of_gear_in_equipable_inventory()
	for k, gear in pairs(gears) do
		local found = false
		for bagId, itemList in pairs(inv_gears) do
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

function add_to_set_json(sets, gear, slot, job)
	local count = 0
	for k, v in pairs(gear.set_list) do
		for k2, v2 in pairs(v) do
			if string.upper(k2) == string.upper(job) then
				for k3, v3 in pairs(v2) do
					local set_name = v3:split('.')
					local set = nil
					for i = 1, #set_name do
						if set == nil then
							if sets[set_name[i]] == nil then
								sets[set_name[i]] = { }
							end
							set = sets[set_name[i]]
						else
							if set[set_name[i]] == nil then
								set[set_name[i]] = { }
							end
							set = set[set_name[i]]
						end
					end
					if set[slot] == nil then
						set[slot] = gear
						count = count + 1
					else
						add_to_chat(122, "Duplicate found at " .. tostring(v3) .. " for " .. tostring(slot) .. " slot.")
					end
				end
			end
		end
	end
	return count
end

function update_gear_name(name1, name2)
	if update_gear_name_in_slot(gear_list.main, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.sub, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.range, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.ammo, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.head, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.neck, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.ear1, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.ear2, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.body, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.hands, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.ring1, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.ring2, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.back, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.waist, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.legs, name1, name2) then return true end
	if update_gear_name_in_slot(gear_list.feet, name1, name2) then return true end
	return false
end

function update_gear_name_in_slot(slot, name1, name2)
	for k,v in pairs(slot) do
		if v.name == name1 then
			v.name = name2
			return true
		end
	end
	return false
end

function remove_item_by_name(slot)
	local equipment = windower.ffxi.get_items().equipment
	if slot == 'main' then
		local main = windower.ffxi.get_items(equipment.main_bag, equipment.main)
		return remove_item_by_name_in_slot(main, gear_list.main)
	elseif slot == 'sub' then
		local sub = windower.ffxi.get_items(equipment.sub_bag, equipment.sub)
		return remove_item_by_name_in_slot(sub, gear_list.sub)
	elseif slot == 'range' then
		local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)
		return remove_item_by_name_in_slot(range, gear_list.range)
	elseif slot == 'ammo' then
		local ammo = windower.ffxi.get_items(equipment.ammo_bag, equipment.ammo)
		return remove_item_by_name_in_slot(ammo, gear_list.ammo)
	elseif slot == 'head' then
		local head = windower.ffxi.get_items(equipment.head_bag, equipment.head)
		return remove_item_by_name_in_slot(head, gear_list.head)
	elseif slot == 'neck' then
		local neck = windower.ffxi.get_items(equipment.neck_bag, equipment.neck)
		return remove_item_by_name_in_slot(neck, gear_list.neck)
	elseif slot == 'ear1' then
		local ear1 = windower.ffxi.get_items(equipment.left_ear_bag, equipment.left_ear)
		return remove_item_by_name_in_slot(ear1, gear_list.ear1)
	elseif slot == 'ear2' then
		local ear2 = windower.ffxi.get_items(equipment.right_ear_bag, equipment.right_ear)
		return remove_item_by_name_in_slot(ear2, gear_list.ear2)
	elseif slot == 'body' then
		local body = windower.ffxi.get_items(equipment.body_bag, equipment.body)
		return remove_item_by_name_in_slot(body, gear_list.body)
	elseif slot == 'hands' then
		local hands = windower.ffxi.get_items(equipment.hands_bag, equipment.hands)
		return remove_item_by_name_in_slot(hands, gear_list.hands)
	elseif slot == 'ring1' then
		local ring1 = windower.ffxi.get_items(equipment.left_ring_bag, equipment.left_ring)
		return remove_item_by_name_in_slot(ring1, gear_list.ring1)
	elseif slot == 'ring2' then
		local ring2 = windower.ffxi.get_items(equipment.right_ring_bag, equipment.right_ring)
		return remove_item_by_name_in_slot(ring2, gear_list.ring2)
	elseif slot == 'back' then
		local back = windower.ffxi.get_items(equipment.back_bag, equipment.back)
		return remove_item_by_name_in_slot(back, gear_list.back)
	elseif slot == 'waist' then
		local waist = windower.ffxi.get_items(equipment.waist_bag, equipment.waist)
		return remove_item_by_name_in_slot(waist, gear_list.waist)
	elseif slot == 'legs' then
		local legs = windower.ffxi.get_items(equipment.legs_bag, equipment.legs)
		return remove_item_by_name_in_slot(legs, gear_list.legs)
	elseif slot == 'feet' then
		local feet = windower.ffxi.get_items(equipment.feet_bag, equipment.feet)
		return remove_item_by_name_in_slot(feet, gear_list.feet)
	end
end

function remove_item_by_name_in_slot(item, slot)
	local item_name = res.items[item.id].name
	for k,v in pairs(slot) do
		if item_name == v.name then
			table.remove(slot, k)
			return true
		end
	end
	return false
end

-- reusable old lua function

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

function get_list_of_extra_gear(gears)
	local invSet = get_list_of_gear_in_equipable_inventory()
	local extraGears = {}
	for bagId, itemList in pairs(invSet) do
		for k, item in pairs(itemList) do
			local found = false
			if res.items[item.id] then
				for k2, master_gear_item in pairs(gears) do
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

-- command functions

function print_help()
	windower.add_to_chat(122, "MasterGear Commands:")
	windower.add_to_chat(122, "//gs mastergear countgear (filter:optional) (jobs:csv): Count number of gear for jobs specified in third argument if filter keyword is specified. Otherwise count all gear")
	windower.add_to_chat(122, "//gs mastergear extragear (jobs:csv): List gear that is in wardrobes but not in the MasterGearList for jobs specified in second argument")
	windower.add_to_chat(122, "//gs mastergear missinggear (jobs:csv): List gear that is in MasterGearList for jobs specified in second argument but not in wardrobes")
	windower.add_to_chat(122, "//gs mastergear exportsets: Export all sets to a txt file")
	windower.add_to_chat(122, "//gs mastergear saveeq (set_name): Saved equipped gear to a set. Won't save main, sub, ranged.")
	windower.add_to_chat(122, "//gs mastergear saveslots (slots:csv) (set_name): Saved gear in specified slots to a set.")
	windower.add_to_chat(122, "//gs mastergear removeset (set_name): Remove specified set.")
	windower.add_to_chat(122, "//gs mastergear update (gear_1_name,gear_2_name): Updates name of gear from gear_1_name to gear_2_name.")
	windower.add_to_chat(122, "//gs mastergear removename (slot): Removes from gear list item with the same name as the gear that is equipped in specified slot.")
end

function parse_command(...)
	local args = T{...}
	if args[1] == "mastergear" then
		table.remove(args, 1)
		if args[1] == "countgear" then
			count_gear_from_json(args)
		elseif args[1] == "extragear" then
			print_extra_gear_not_in_json(args)
		elseif args[1] == "missinggear" and args[2] then
			print_missing_gear_json(args)
		elseif args[1] == "exportsets" then
			export_sets_from_json()
		elseif args[1] == "help" then
			print_help()
		elseif args[1] == "saveeq" and args[2] then
			local set_name = ""
			for i = 2, #args do
				set_name = set_name .. args[i] .. " "
			end
			set_name = string.sub(set_name, 1, #set_name - 1)
			save_equipped_as_set(set_name)
			windower.add_to_chat(122, "Equipment saved to " .. set_name)
		elseif args[1] == "saveslots" and args[2] and args[3] then
			local set_name = ""
			for i = 3, #args do
				set_name = set_name .. args[i] .. " "
			end
			set_name = string.sub(set_name, 1, #set_name - 1)
			save_gear_slots(args[2], set_name)
			save_json_setting()
			windower.add_to_chat(122, args[2] .. " saved to " .. set_name)
		elseif args[1] == 'removeset' and args[2] then
			local set_name = ""
			for i = 2, #args do
				set_name = set_name .. args[i] .. " "
			end
			set_name = string.sub(set_name, 1, #set_name - 1)
			remove_set(set_name)
			windower.add_to_chat(122, "Removing " .. set_name)
		elseif args[1] == 'update' and args[2] then
			local commandstring = ""
			for i = 2, #args do
				commandstring = commandstring .. args[i] .. " "
			end
			commandstring = string.sub(commandstring, 1, #commandstring - 1)
			local gear_names = T(commandstring:split(','))
			if #gear_names == 2 then
				if update_gear_name(gear_names[1], gear_names[2]) then
					windower.add_to_chat(122, "Updated " .. gear_names[1] .. " to " .. gear_names[2])
					save_json_setting()
				else
					windower.add_to_chat(122, "Couldn't find any gear with name: " .. gear_names[1])
				end
			else
				windower.add_to_chat(122, "Please input 2 names separated by comma: " .. commandstring)
			end
		elseif args[1] == 'removename' and args[2] then
			if remove_item_by_name(args[2]) then
				windower.add_to_chat(122, "Removed " .. args[2] .. " item by name")
				save_json_setting()
			else
				windower.add_to_chat(122, "Couldn't find any gear with same name as item in " .. args[2] .. " slot.")
			end
		else
			print_help()
		end
		return true
	end
	return false
end

register_unhandled_command(parse_command)