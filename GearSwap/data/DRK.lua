include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	sets.Idle = set_combine(sets["IdleRegen"], sets["Movement"])
	
	ws = {}
	ws["Cross Reaper"] = { set = sets["Catastrophe"], tp_bonus = true }
	ws["Spiral Hell"] = { set = sets["Catastrophe"], tp_bonus = true }
	ws["Catastrophe"] = { set = sets["Catastrophe"], tp_bonus = false }
	ws["Quietus"] = { set = sets["Catastrophe"], tp_bonus = false }
	ws["Spinning Scythe"] = { set = sets["Catastrophe"], tp_bonus = false }
	ws["Entropy"] = { set = sets["Entropy"], tp_bonus = true }
	ws["Guillotine"]= { set = sets["Insurgency"], tp_bonus = false }
	ws["Insurgency"] = { set = sets["Insurgency"], tp_bonus = true }
	ws["Shadow of Death"] = { set = sets["DarkMagicAtk"], tp_bonus = true }
	ws["Infernal Scythe"] = { set = sets["DarkMagicAtk"], tp_bonus = false }
	
	ws["Steel Cyclone"] = { set = sets["Catastrophe"], tp_bonus = true }
	ws["Keen Edge"] = { set = sets["Catastrophe"], tp_bonus = false }
	ws["Armor Break"] = { set = sets["Catastrophe"], tp_bonus = false }
	ws["Upheaval"] = { set = sets["Insurgency"], tp_bonus = true }
	ws["Fell Cleave"] = { set = sets["Catastrophe"], tp_bonus = false }
	
	ws["Scourge"] = { set = sets["Catastrophe"], tp_bonus = false }
	ws["Torcleaver"] = { set = sets["Catastrophe"], tp_bonus = true }
	ws["Ground Strike"] = { set = sets["Catastrophe"], tp_bonus = true }
	ws["Resolution"]= { set = sets["Insurgency"], tp_bonus = true }
	
	absorbs = {}
	absorbs[1] = { buff = "Accuracy Boost", spell = "Absorb-Acc", recast_id = 242 }
	absorbs[2] = { buff = "STR Boost", spell = "Absorb-STR", recast_id = 266 }
	absorbs[3] = { buff = "INT Boost", spell = "Absorb-INT", recast_id = 270 }
	absorbs[4] = { buff = "DEX Boost", spell = "Absorb-DEX", recast_id = 267 }
	absorbs[5] = { buff = "MND Boost", spell = "Absorb-MND", recast_id = 271 }
	absorbs[6] = { buff = "VIT Boost", spell = "Absorb-VIT", recast_id = 268 }
 	
	cancel_haste = 1
	
	send_command('@input /macro book 11;wait 1;input /macro set 1')
end
 
function custom_precast(spell)
    if spell.type=="WeaponSkill" and player.equipment.main == "Lycurgos" then
        if ws[spell.english] then
			local setToUse = ws[spell.english].set
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				local equipment = windower.ffxi.get_items().equipment
				local main = windower.ffxi.get_items(equipment.main_bag, equipment.main)
				if res.items[main.id].name == "Lycurgos" then
					local hp_bonus = math.floor(player.hp / 5)
					if hp_bonus > 1000 then hp_bonus = 1000 end
					maxTP = maxTP - hp_bonus
				end
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				setToUse = set_combine(setToUse, sets["WeatherObi"])
			end
			equip(setToUse)
		end
		return true
    end
end

function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		local set_to_use = {}
		if spell.skill == "Elemental Magic" then
			set_to_use = sets["MagicAtk"]
			if spell.element == world.weather_element or spell.element == world.day_element then 
				set_to_use = set_combine(set_to_use, sets["WeatherObi"])
			end
		elseif spell.skill == "Dark Magic" then
			if spell.english == "Dread Spikes" then
				set_to_use = set_combine(sets["HP"], sets["DreadSpikes"], sets["DarkDuration"])
			elseif spell.english:startswith("Drain") or spell.english:startswith("Aspir") then
				set_to_use = set_combine(sets["MagicAcc"], sets["DarkSkill"], sets["DrainAspir"], sets["DarkDuration"])
			elseif spell.english:startswith("Absorb") and (spell.english ~= "Absorb-TP" or spell.english ~= "Absorb-Attri") then
				set_to_use = set_combine(sets["MagicAcc"], sets["DarkSkill"], sets["AbsorbDuration"], sets["DarkDuration"])
			elseif spell.english:startswith("Endark") then
				set_to_use = set_combine(sets["DarkSkill"], sets["DarkDuration"])
			end
			if buffactive['Dark Seal'] then 
				set_to_use = set_combine(set_to_use, sets["DarkSeal"])
			end
		elseif sets[spell.english] then
			set_to_use = sets[spell.english]
		end
		equip(set_to_use)
		return true
	end
end
  
function custom_command(args)
	if args[1] == "absorb" then
		local recasts = windower.ffxi.get_spell_recasts()
		local lowest_time = -1
		local lowest_index = -1
		for k,v in pairs(absorbs) do
			if not buffactive[v.buff] and recasts[v.recast_id] == 0 then
				send_command('input /ma "' .. v.spell .. '" <t>')
				v.time = os.time()
				return
			elseif v.time and recasts[v.recast_id] == 0 then
				if lowest_time == -1 then 
					lowest_time = v.time
					lowest_index = k
				elseif v.time < lowest_time then 
					lowest_time = v.time
					lowest_index = k
				end
			end
		end
		if lowest_index ~= -1 then
			send_command('input /ma "' .. absorbs[lowest_index].spell .. '" <t>')
			absorbs[lowest_index].time = os.time()
		end
	end
end