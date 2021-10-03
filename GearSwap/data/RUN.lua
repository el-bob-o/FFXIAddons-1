include("MasterGear/MasterGearLua.lua")

enmity_actions = {}
enmity_actions["JA"] = { "Valiance", "Vallation", "Swordplay", "Pflug", "Gambit", "Rayke", "Liement",
	"Battuta", "One for All", "Elemental Sforzo" }
enmity_actions["RUN"] = { "Flash", "Foil" }
enmity_actions["DRK"] = { "Poisonga", "Stun" }
enmity_actions["BLU"] = { "Blank Gaze", "Jettatura", "Geist Wall" }

resist_table = {}
resist_table["ice"] = "ignis"
resist_table["paralyze"] = "ignis"
resist_table["bind"] = "ignis"
resist_table["frost"] = "ignis"
resist_table["evadown"] = "ignis"
resist_table["agidown"] = "ignis"
resist_table["wind"] = "gelus"
resist_table["silence"] = "gelus"
resist_table["gravity"] = "gelus"
resist_table["choke"] = "gelus"
resist_table["defdown"] = "gelus"
resist_table["vitdown"] = "gelus"
resist_table["earth"] = "flabra"
resist_table["slow"] = "flabra"
resist_table["petrify"] = "flabra"
resist_table["rasp"] = "flabra"
resist_table["accdown"] = "flabra"
resist_table["dexdown"] = "flabra"
resist_table["thunder"] = "tellus"
resist_table["stun"] = "tellus"
resist_table["shock"] = "tellus"
resist_table["mnddown"] = "tellus"
resist_table["water"] = "sulpor"
resist_table["poison"] = "sulpor"
resist_table["strdown"] = "sulpor"
resist_table["atkdown"] = "sulpor"
resist_table["fire"] = "unda"
resist_table["addle"] = "unda"
resist_table["amnesia"] = "unda"
resist_table["virus"] = "unda"
resist_table["burn"] = "unda"
resist_table["mabdown"] = "unda"
resist_table["intdown"] = "unda"
resist_table["dark"] = "lux"
resist_table["blind"] = "lux"
resist_table["bio"] = "lux"
resist_table["sleep"] = "lux"
resist_table["dispel"] = "lux"
resist_table["drain"] = "lux"
resist_table["curse"] = "lux"
resist_table["doom"] = "lux"
resist_table["zombie"] = "lux"
resist_table["mevadown"] = "lux"
resist_table["hpdown"] = "lux"
resist_table["mpdown"] = "lux"
resist_table["chrdown"] = "lux"
resist_table["absorb"] = "lux"
resist_table["light"] = "tenebrae"
resist_table["dia"] = "tenebrae"
resist_table["repose"] = "tenebrae"
resist_table["finale"] = "tenebrae"
resist_table["charm"] = "tenebrae"
resist_table["lullaby"] = "tenebrae"
resist_table["sheepsong"] = "tenebrae"
resist_table["maccdown"] = "tenebrae"

runes_elemental_map = {}
runes_elemental_map["light"] = "lux"
runes_elemental_map["dark"] = "tenebrae"
runes_elemental_map["water"] = "unda"
runes_elemental_map["thunder"] = "sulpor"
runes_elemental_map["fire"] = "ignis"
runes_elemental_map["wind"] = "flabra"
runes_elemental_map["earth"] = "tellus"
runes_elemental_map["ice"] = "gelus"

function custom_get_sets()
	kite_mode = false
	rune = "Lux"
	subjob_action = nil
	enmity_mode = false
	spell_interrupt_mode = false
	target_rune_count = {
		["tenebrae"] = 0,
		["lux"] = 0,
		["unda"] = 0,
		["sulpor"] = 0,
		["tellus"] = 0,
		["flabra"] = 0,
		["gelus"] = 0,
		["ignis"] = 0,
	}
	rune_cast = { "lux", "lux", "lux" }
	rune_cast_index = 1
	
	sets["Swipe"] = sets["Lunge"]
	sets["Vallation"] = sets["Valiance"]
	
	ws = {}
	ws["Frostbite"] = { set = sets["Lunge"], tp_bonus = true }
	ws["Freezebite"] = { set = sets["Lunge"], tp_bonus = true }
	ws["Herculean Slash"] = { set = sets["Lunge"], tp_bonus = false }
	ws["Shockwave"] = { set = sets["Savage Blade"], tp_bonus = false }
	ws["Resolution"] = { set = sets["Resolution"], tp_bonus = true }
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Requiescat"] = { set = sets["Requiescat"], tp_bonus = true }
	ws["Dimidiation"] = { set = sets["Dimidiation"], tp_bonus = true }
	ws["Red Lotus Blade"] = { set = sets["Lunge"], tp_bonus = true }
	ws["Seraph Blade"] = { set = sets["Lunge"], tp_bonus = true }
	ws["Sanguine Blade"] = { set = sets["Sanguine Blade"], tp_bonus = false }
	
	sets["EnhancingRegen"] = set_combine(sets["EnhancingAny"], sets["EnhancingRegen"])
	sets["EnhancingPhalanx"] = set_combine(sets["EnhancingAny"], sets["EnhancingPhalanx"])
	sets["Idle"] = set_combine(sets["IdleRegen"], sets["Movement"])
	
	subjob_check(player.sub_job)
	print_current_rune()
	send_command('@input /macro book 1;wait 1;input /macro set 1')
end
 
function custom_precast(spell)
	if enmity_mode == true and check_emnity("JA", spell.english) == true then
		equip(set_combine(sets["Emnity"], sets[spell.english]))
		return true
    elseif spell.type=="WeaponSkill" and ws[spell.english] then
		local setToUse = ws[spell.english].set
		local maxTP = 3000
		if player.equipment.main == "Lionheart" then
			maxTP = maxTP - 500
		end
		if player.tp < maxTP then
			setToUse = set_combine(setToUse, sets["TPBonus"])
		end
		if enmity_mode == true then
			setToUse = set_combine(setToUse, sets["Enmity"])
		end
		equip(setToUse)
		return true
	elseif spell.action_type == 'Magic' then
		if spell.skill == "Enhancing Magic" then
			equip(sets.FastcastEnhancing)
		else
			equip(sets["Fastcast"])
		end
		return true
	elseif sets[spell.english] then
		equip(sets[spell.english])
		return true
    end
end
 
function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		local equipEmnity = enmity_mode
		if equipEmnity == true then
			equipEmnity = check_emnity("RUN", spell.english)
			if equipEmnity == false then
				equipEmnity = check_emnity(player.sub_job, spell.english)
			end
		end
		local setToUse = nil
		if spell.skill == "Enhancing Magic" then
			if spell.english:match("Regen") then
				setToUse = sets["EnhancingRegen"]
			elseif spell.english:match("Phalanx") then
				setToUse = sets["EnhancingPhalanx"]
			else
				setToUse = sets["EnhancingAny"]
			end
		elseif sets[spell.english] then
			setToUse = sets[spell.english]
		end
		if equipEmnity then
			setToUse = (set_combine(setToUse, sets["Emnity"]))
		end
		if spell_interrupt_mode then
			setToUse = (set_combine(setToUse, sets["SIR"]))
		end
		equip(setToUse)
		return true
	end
end
 
function custom_command(args)
	if args[1] == "sir" then
		if spell_interrupt_mode == true then
			add_to_chat(122, "spell_interrupt_mode off!")
			spell_interrupt_mode = false
		else
			add_to_chat(122, "spell_interrupt_mode on!")
			spell_interrupt_mode = true
		end
	elseif args[1] == 'kite' then
		if kite_mode == false then
			add_to_chat(122, "Kite Mode on")
			enable("legs")
			equip(sets["Movement"])
			disable("legs")
			kite_mode = true
		elseif kite_mode == true then
			add_to_chat(122, "Kite Mode off")
			enable("legs")
			kite_mode = false
		end
	elseif args[1] == 'emnity' then
		if enmity_mode == false then
			add_to_chat(122, "Emnity Mode on")
			enmity_mode = true
		elseif enmity_mode == true then
			add_to_chat(122, "Emnity Mode off")
			enmity_mode = false
		end
	elseif args[1] == "rune" then
		if args[2] and args[3] and args[4] then
			local ele1 = string.lower(args[2])
			local ele2 = string.lower(args[3])
			local ele3 = string.lower(args[4])
			if runes_elemental_map[ele1] and runes_elemental_map[ele2] and runes_elemental_map[ele3] then
				local rune1 = runes_elemental_map[ele1]
				local rune2 = runes_elemental_map[ele2]
				local rune3 = runes_elemental_map[ele3]
				if target_rune_count[rune1] and target_rune_count[rune2] and target_rune_count[rune3] then
					target_rune_count["lux"] = 0
					target_rune_count["tenebrae"] = 0
					target_rune_count["unda"] = 0
					target_rune_count["sulpor"] = 0
					target_rune_count["tellus"] = 0
					target_rune_count["flabra"] = 0
					target_rune_count["gelus"] = 0
					target_rune_count["ignis"] = 0
					target_rune_count[rune1] = target_rune_count[rune1] + 1
					target_rune_count[rune2] = target_rune_count[rune2] + 1
					target_rune_count[rune3] = target_rune_count[rune3] + 1
					rune_cast = { rune1, rune2, rune3 }
					rune_cast_index = 1
					print_current_rune()
				end
				
			end
		elseif args[2] then
			local rune_to_cast = runes_elemental_map[string.lower(args[2])]
			if rune_to_cast then
				rune_cast = { rune_to_cast, rune_to_cast, rune_to_cast }
				rune_cast_index = 1
				print_current_rune()
			end
		else
			for k,v in pairs(rune_cast) do			
				if buffactive[v] == nil or buffactive[v] < target_rune_count[v] then
					send_command('input /ja "' .. v .. '" <me>')
					rune_cast_index = k + 1
					if rune_cast_index > 3 then rune_cast_index = 1 end
					return
				end
			end
			send_command('input /ja "' .. rune_cast[rune_cast_index] .. '" <me>')
			rune_cast_index = rune_cast_index + 1
			if rune_cast_index > 3 then rune_cast_index = 1 end
		end
	elseif args[1] == "sjAction" then
		if subjob_action == nil then
			add_to_chat(122, "No SubjobAction for " .. player.sub_job)
		else
			send_command('input ' .. subjob_action)
		end
	elseif args[1] == 'setWS' and args[2] then
		ws = string.sub(command, 7)
		print_current_ws()
	elseif args[1] == 'resist' and args[2] then
		if args[2] and args[3] and args[4] then
			local res1 = string.lower(args[2])
			local res2 = string.lower(args[3])
			local res3 = string.lower(args[4])
			if resist_table[res1] and resist_table[res2] and resist_table[res3] then
				local rune1 = resist_table[res1]
				local rune2 = resist_table[res2]
				local rune3 = resist_table[res3]
				if target_rune_count[rune1] and target_rune_count[rune2] and target_rune_count[rune3] then
					target_rune_count["lux"] = 0
					target_rune_count["tenebrae"] = 0
					target_rune_count["unda"] = 0
					target_rune_count["sulpor"] = 0
					target_rune_count["tellus"] = 0
					target_rune_count["flabra"] = 0
					target_rune_count["gelus"] = 0
					target_rune_count["ignis"] = 0
					target_rune_count[rune1] = target_rune_count[rune1] + 1
					target_rune_count[rune2] = target_rune_count[rune2] + 1
					target_rune_count[rune3] = target_rune_count[rune3] + 1
					rune_cast = { rune1, rune2, rune3 }
					rune_cast_index = 1
					print_current_rune()
				end
			end
		else
			local arg2 = string.lower(args[2])
			if resist_table[arg2] then 
				rune_cast = { resist_table[arg2], resist_table[arg2], resist_table[arg2] }
				rune_cast_index = 1
				print_current_rune()
			end
		end
	end
end

function sub_job_change(new, old)
	subjob_check(new)
end

function print_current_rune()
	local runeString = ""
	for k,v in pairs(rune_cast) do
		runeString = runeString .. v .. ", "
	end
	add_to_chat(122, "Current runes: " .. runeString)
end

function print_subjob_action()
	if subjob_action == nil then
	else
		add_to_chat(122, "Current Subjob Action: " .. subjob_action)
	end
end

function subjob_check(job)
	if job == "NIN" then
		subjob_action = '/ma "Utsusemi: Ni" <me>;input /ma "Utsusemi: Ichi" <me>'
	elseif job == "DNC" then
		subjob_action = nil
	elseif job == "SAM" then
		subjob_action = '/ja "Third Eye" <me>'
	elseif job == "WAR" then
		subjob_action = '/ja "Provoke" <stnpc>'
	elseif job == "DRK" then
		subjob_action = '/ma "Stun" <stnpc>'
	else
		subjob_action = nil
	end
	print_subjob_action()
end

function check_emnity(type, spellName)
	if enmity_actions[type] then
		for k,v in ipairs(enmity_actions[type]) do
			if spellName == v then 
				return true 
			end
		end
	end
	return false
end