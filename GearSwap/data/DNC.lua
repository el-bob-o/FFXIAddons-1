include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	current_ws = "Rudra's Storm"
	
	WS = {}
	WS["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	WS["Mandalic Stab"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	WS["Shark Bite"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	WS["Dancing Edge"] = { set = sets["Evisceration"], tp_bonus = false }
	WS["Exenterator"] = { set = sets["Evisceration"], tp_bonus = false }
	WS["Evisceration"] = { set = sets["Evisceration"], tp_bonus = false }
	WS["Pyrrhic Kleos"] = { set = sets["Pyrrhic Kleos"], tp_bonus = false }
	WS["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	cancel_haste = 1
	
	print_current_ws()
	send_command('@input /macro book 12;wait 1;input /macro set 1')
end
 
function custom_precast(spell)
	if buffactive["Climactic Flourish"] and spell.type=="WeaponSkill" then
		
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
		current_ws = string.sub(command, 7)
		print_current_ws()
	end
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end