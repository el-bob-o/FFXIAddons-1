include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	current_ws = "Rudra's Storm"
	
	ws = {}
	ws["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Mandalic Stab"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Shark Bite"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Dancing Edge"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Exenterator"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Pyrrhic Kleos"] = { set = sets["Pyrrhic Kleos"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	cancel_haste = 1
	
	print_current_ws()
	send_command('@input /macro book 12;wait 1;input /macro set 1')
end
 
function custom_precast(spell)
	if spell.type=="WeaponSkill" then
		if ws and ws[spell.english] then
			local set_to_use = nil
			if sets[modes[mode].name .. spell.english] then set_to_use = sets[modes[mode].name .. spell.english]
			else set_to_use = ws[spell.english].set end
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if player.tp < maxTP then
					set_to_use = set_combine(set_to_use, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				set_to_use = set_combine(set_to_use, sets["WeatherObi"])
			end
			if killer_effect then
				set_to_use = set_combine(set_to_use, sets["KillerEffect"])
			end
			if buffactive["Climactic Flourish"] then
				set_to_use = set_combine(set_to_use, sets["Climactic"])
			end
			equip(set_to_use)
		end
		return true
	elseif spell.english:contains("Samba") then
		equip(sets["Samba"])
		return true
	elseif spell.english:contains("Step") then
		equip(sets["Step"])
		return true
	elseif spell.english:contains("Healing Waltz") or spell.english == "Divine Waltz" then
		equip(sets["Waltz"])
		return true
	elseif spell.english:contains("Jig") then
		equip(sets["Jig"])
		return true
	end
end

function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets["MagicAtk"])
			return true
		end
	end
end
 
 
function custom_command(args)
	if args[1] == "ws" then
		send_command('input /ws "' .. current_ws .. '" <t>')
	elseif args[1] == "setWS" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		current_ws = commandstring
		print_current_ws()
	end
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end