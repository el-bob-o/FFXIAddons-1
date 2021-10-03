include("Mastergear/MasterGearLua.lua")

ws = {}
ws["Combo"] = { set = sets["Raging Fist"], tp_bonus = true }
ws["Shoulder Tackle"] = { set = sets["Dragon Kick"], tp_bonus = true }
ws["One Inch Punch"] = { set = sets["Dragon Kick"], tp_bonus = true }
ws["Backhand Blow"] = { set = sets["Dragon Kick"], tp_bonus = false }
ws["Raging Fist"] = { set = sets["Raging Fist"], tp_bonus = true }
ws["Spinning Attack"] = { set = sets["Dragon Kick"], tp_bonus = false }
ws["Howling Fist"] = { set = sets["Dragon Kick"], tp_bonus = true }
ws["Dragon Kick"] = { set = sets["Dragon Kick"], tp_bonus = true }
ws["Asuran Fist"] = { set = sets["Victory Smite"], tp_bonus = false }
ws["Tornado Kick"] = { set = sets["Victory Smite"], tp_bonus = true }
ws["Shijin Spiral"] = { set = sets["Raging Fist"], tp_bonus = false }
ws["Victory Smite"] = { set = sets["Victory Smite"], tp_bonus = false }
ws["Stringing Pummel"] = { set = sets["Victory Smite"], tp_bonus = false }

target_maneuver_count = {
	["light maneuver"] = 1,
	["dark maneuver"] = 0,
	["earth maneuver"] = 0,
	["wind maneuver"] = 1,
	["water maneuver"] = 0,
	["ice maneuver"] = 0,
	["fire maneuver"] = 1,
	["thunder maneuver"] = 0,
}
maneuver_cast = {"light maneuver", "wind maneuver", "fire maneuver"}
maneuver_cast_index = 1

function custom_get_sets()
	print_current_maneuvers()
	send_command('@input /macro book 13;wait 1;input /macro set 1')
end

function custom_command(args)
	if args[1] == "maneuver" then
		if args[2] and args[3] and args[4] then
			local ele1 = string.lower(args[2]) .. " maneuver"
			local ele2 = string.lower(args[3]) .. " maneuver"
			local ele3 = string.lower(args[4]) .. " maneuver"
			if target_maneuver_count[ele1] and target_maneuver_count[ele2] and target_maneuver_count[ele3] then
				target_maneuver_count["light maneuver"] = 0
				target_maneuver_count["dark maneuver"] = 0
				target_maneuver_count["earth maneuver"] = 0
				target_maneuver_count["wind maneuver"] = 0
				target_maneuver_count["water maneuver"] = 0
				target_maneuver_count["ice maneuver"] = 0
				target_maneuver_count["fire maneuver"] = 0
				target_maneuver_count["thunder maneuver"] = 0
				target_maneuver_count[ele1] = target_maneuver_count[ele1] + 1
				target_maneuver_count[ele2] = target_maneuver_count[ele2] + 1
				target_maneuver_count[ele3] = target_maneuver_count[ele3] + 1
				maneuver_cast = {ele1, ele2, ele3}
				maneuver_cast_index = 1
				print_current_maneuvers()
			end
		else
			for i = 1, 3 do
				local temp_index = maneuver_cast_index + i - 1
				if temp_index > 3 then temp_index = temp_index - 3 end
				local maneuver = maneuver_cast[temp_index]
				if buffactive[maneuver] == nil or buffactive[maneuver] < target_maneuver_count[maneuver] then
					send_command('input /ja "' .. maneuver .. '" <me>')
					maneuver_cast_index = temp_index + 1
					if maneuver_cast_index > 3 then maneuver_cast_index = 1 end
					return
				end
			end
			send_command('input /ja "' .. maneuver_cast[maneuver_cast_index] .. '" <me>')
			maneuver_cast_index = maneuver_cast_index + 1
			if maneuver_cast_index > 3 then maneuver_cast_index = 1 end
		end
	end
end

function custom_precast(spell)
	if string.lower(spell.english):contains("maneuver") then
		equip(sets["Maneuver"])
		return true
	end
end

function print_current_maneuvers()
	local text = ""
	for k,v in pairs(maneuver_cast) do
		text = text .. v .. ", "
	end
	add_to_chat(122, "Current Maneuvers: " .. text)
end