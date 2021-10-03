include("MasterGear/MasterGearLua.lua")

elemental_ninjutsu = { "Katon", "Suiton", "Raiton", "Doton", "Huton", "Hyoton" }

function custom_get_sets()		
	ws = {}
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Circle Blade"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Sanguine Blade"] = { set = sets["MagicAtk"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	send_command('@input /macro book 5;wait 1;input /macro set 1')
end
 
function custom_midcast(spell)
	if spell.action_type == 'Magic' and spell.skill == "Ninjutsu" then
		if is_elemental_ninjutsu(spell.name) then
			equip(sets["MagicAtk"])
			return true
		end
	end
end

function is_elemental_ninjutsu(spell_name)
	local upper_spell_name = string.upper(spell_name)
	for k,v in pairs(elemental_ninjutsu) do
		local startidx, endidx = string.upper(v):find(upper_spell_name)
		if startidx == 1 then return true end
	end
	return false
end