include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	throwing = false
	current_ws = "Rudra's Storm"
	cancel_haste = 1
	
	sets.SATA = set_combine(sets["SneakAttack"], sets["TrickAttack"])
	
	ws = {}
	ws["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Mandalic Stab"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Shark Bite"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Dancing Edge"] = { set = sets["Dancing Edge"], tp_bonus = false }
	ws["Exenterator"] = { set = sets["Exenterator"], tp_bonus = false }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	ws["Savage Blade"] = { set = sets["STR_WS"], tp_bonus = true }
	ws["Asuran Fists"] = { set = sets["Dancing Edge"], tp_bonus = false }
	
	print_current_ws()
	print_throwing()
	send_command('@input /macro book 2')
	subjob_macro_page(player.sub_job)
end
 
function custom_precast(spell)
	if spell.type=="WeaponSkill" then
		if ws[spell.english] then
			local setToUse = ws[spell.english].set
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				setToUse = set_combine(setToUse, sets["WeatherObi"])
			end
			setToUse = SATA_check(setToUse)
			equip(setToUse)
			return true
		end
	elseif sets[spell.english] then
		equip(sets[spell.english])
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

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end

function SATA_check(set)
	SA = buffactive["Sneak Attack"]
	TA = buffactive["Trick Attack"]
	if SA or TA then
		if SA and TA then
			set = set_combine(set, sets.SATA)
		elseif SA then
			set = set_combine(set, sets["SneakAttack"])
		elseif TA then
			set = set_combine(set, sets["TrickAttack"])
		end
	end
	return set
end

function subjob_macro_page(job)
	if job == "DNC" then
		send_command('@wait 1;input /macro set 1')
	elseif job == "NIN" then
		send_command('@wait 1;input /macro set 2')
	elseif job == "RUN" then
		send_command('@wait 1;input /macro set 3')
	elseif job == "WAR" then
		send_command('@wait 1;input /macro set 4')
	elseif job == "DRG" then
		send_command('@wait 1;input /macro set 5')
	end
end