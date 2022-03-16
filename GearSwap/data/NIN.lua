include("MasterGear/MasterGearLua.lua")

elemental_ninjutsu = T{ "Katon", "Suiton", "Raiton", "Doton", "Huton", "Hyoton" }

function custom_get_sets()
	elemental_nin_to_use = "Raiton" 
	ws = {}
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Circle Blade"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Sanguine Blade"] = { set = sets["Blade: Ei"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["Aeolian Edge"], tp_bonus = true }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = true }
	ws["Viper Bite"] = { set = sets["Evisceration"], tp_bonus = false }
	
	ws["Blade: Shun"] = { set = sets["Blade: Shun"], tp_bonus = true }
	ws["Blade: Ku"] = { set = sets["Blade: Shun"], tp_bonus = false }
	ws["Blade: Jin"] = { set = sets["Blade: Jin"], tp_bonus = true }
	ws["Blade: Retsu"] = { set = sets["Blade: Shun"], tp_bonus = false }
	ws["Blade: Ten"] = { set = sets["Blade: Ten"], tp_bonus = true }
	ws["Blade: Kamu"] = { set = sets["Blade: Ten"], tp_bonus = false }
	ws["Blade: Hi"] = { set = sets["Blade: Hi"], tp_bonus = true }
	ws["Blade: Rin"] = { set = sets["Blade: Hi"], tp_bonus = true }
	ws["Blade: Chi"] = { set = sets["Blade: Chi"], tp_bonus = true }
	ws["Blade: To"] = { set = sets["Blade: Chi"], tp_bonus = true }
	ws["Blade: Teki"] = { set = sets["Blade: Chi"], tp_bonus = true }
	ws["Blade: Yu"] = { set = sets["Blade: Chi"], tp_bonus = false }
	ws["Blade: Ei"] = { set = sets["Blade: Ei"], tp_bonus = true }
	
	send_command('@input /macro book 5;wait 1;input /macro set 1')
	print_elemental()
end

function custom_precast(spell)
	if spell.type=="WeaponSkill" and ws[spell.english] then
		local setToUse = ws[spell.english].set
		local maxTP = 3000
		if player.equipment.main == "Heishi Shorinken" then
			maxTP = maxTP - 500
		end
		if player.tp < maxTP then
			setToUse = set_combine(setToUse, sets["TPBonus"])
		end
		equip(setToUse)
		return true
	end
end

function custom_midcast(spell)
	if spell.action_type == 'Magic' and spell.skill == "Ninjutsu" then
		if is_elemental_ninjutsu(spell.name) then
			equip(sets["NinjutsuMB"])
			return true
		elseif spell.name:startswith("Utsusemi") then
			equip(sets["Utsusemi"])
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

function print_elemental()
	windower.add_to_chat(122, "Using " .. elemental_nin_to_use)
end

function custom_command(args)
	if args[1] == "ElementalNin" then
		if args[2] then
			if elemental_ninjutsu:contains(args[2]) then
				elemental_nin_to_use = args[2]
			elseif args[2] == "fire" then elemental_nin_to_use = "Katon"
			elseif args[2] == "water" then elemental_nin_to_use = "Suiton"
			elseif args[2] == "lightning" then elemental_nin_to_use = "Raiton"
			elseif args[2] == "earth" then elemental_nin_to_use = "Doton"
			elseif args[2] == "wind" then elemental_nin_to_use = "Huton"
			elseif args[2] == "ice" then elemental_nin_to_use = "Hyoton"
			end
			print_elemental()
		else
			local recasts = windower.ffxi.get_spell_recasts()
			local spells = windower.ffxi.get_spells()
			if elemental_nin_to_use == "Katon" then
				if spells[322] and recasts[322] == 0 then windower.send_command('input /ma "Katon: San" <t>')
				elseif spells[321] and recasts[321] == 0 then windower.send_command('input /ma "Katon: Ni" <t>')
				elseif spells[320] and recasts[320] == 0 then windower.send_command('input /ma "Katon: Ichi" <t>')
				end
			elseif elemental_nin_to_use == "Suiton" then
				if spells[337] and recasts[337] == 0 then windower.send_command('input /ma "Suiton: San" <t>')
				elseif spells[336] and recasts[336] == 0 then windower.send_command('input /ma "Suiton: Ni" <t>')
				elseif spells[335] and recasts[335] == 0 then windower.send_command('input /ma "Suiton: Ichi" <t>')
				end
			elseif elemental_nin_to_use == "Raiton" then
				if spells[334] and recasts[334] == 0 then windower.send_command('input /ma "Raiton: San" <t>')
				elseif spells[333] and recasts[333] == 0 then windower.send_command('input /ma "Raiton: Ni" <t>')
				elseif spells[332] and recasts[332] == 0 then windower.send_command('input /ma "Raiton: Ichi" <t>')
				end
			elseif elemental_nin_to_use == "Doton" then
				if spells[331] and recasts[331] == 0 then windower.send_command('input /ma "Doton: San" <t>')
				elseif spells[330] and recasts[330] == 0 then windower.send_command('input /ma "Doton: Ni" <t>')
				elseif spells[329] and recasts[329] == 0 then windower.send_command('input /ma "Doton: Ichi" <t>')
				end
			elseif elemental_nin_to_use == "Huton" then
				if spells[328] and recasts[328] == 0 then windower.send_command('input /ma "Huton: San" <t>')
				elseif spells[327] and recasts[327] == 0 then windower.send_command('input /ma "Huton: Ni" <t>')
				elseif spells[326] and recasts[326] == 0 then windower.send_command('input /ma "Huton: Ichi" <t>')
				end
			elseif elemental_nin_to_use == "Hyoton" then
				if spells[325] and recasts[325] == 0 then windower.send_command('input /ma "Hyoton: San" <t>')
				elseif spells[324] and recasts[324] == 0 then windower.send_command('input /ma "Hyoton: Ni" <t>')
				elseif spells[323] and recasts[323] == 0 then windower.send_command('input /ma "Hyoton: Ichi" <t>')
				end
			end
		end
	elseif args[1] == "Utsusemi" then
		local recasts = windower.ffxi.get_spell_recasts()
		if recasts[340] == 0 then windower.send_command('input /ma "Utsusemi: San" <me>')
		elseif recasts[339] == 0 then windower.send_command('input /ma "Utsusemi: Ni" <me>')
		elseif recasts[338] == 0 then windower.send_command('input /ma "Utsusemi: Ichi" <me>')
		end
	end
end