include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Impulse Drive"] = { set = sets["Impulse Drive"], tp_bonus = true }
	ws["Camlann's Torment"] = { set = sets["Camlann's Torment"], tp_bonus = false }
	ws["Sonic Thrust"] = { set = sets["Camlann's Torment"], tp_bonus = true }
	ws["Drakesbane"] = { set = sets["Drakesbane"], tp_bonus = true }
	ws["Stardiver"] = { set = sets["Stardiver"], tp_bonus = false }
	ws["SO_Impulse Drive"] = { set = sets["SO_Impulse Drive"], tp_bonus = true }
	ws["SO_Camlann's Torment"] = { set = sets["SO_Camlann's Torment"], tp_bonus = true }
	ws["SO_Sonic Thrust"] = { set = sets["SO_Camlann's Torment"], tp_bonus = true }
	ws["SO_Drakesbane"] = { set = sets["SO_Drakesbane"], tp_bonus = true }
	ws["SO_Stardiver"] = { set = sets["SO_Drakesbane"], tp_bonus = true }
	
	send_command('@input /macro book 14')
end

function custom_precast(spell)
	if spell.type == "Weaponskill" then
		local equipment = windower.ffxi.get_items().equipment
		local main = windower.ffxi.get_items(equipment.main_bag, equipment.main)	
		if res.items[main.id].name == "Shining One" then
			if ws["SO_" .. spell.english] then equip(ws["SO_" .. spell.english].set)
			elseif ws[spell.english] then equip(ws[spell.english].set) end
			if player.tp < 3000 then
				equip(sets["TPBonus"])
			end
			return true
		end
	end
end