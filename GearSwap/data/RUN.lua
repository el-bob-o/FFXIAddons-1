include("THHelper.lua")
include("MasterGearFunctions.lua")

EmnityActions = {}
EmnityActions["JA"] = { "Valiance", "Vallation", "Swordplay", "Pflug", "Gambit", "Rayke", "Liement",
	"Battuta", "One for All", "Elemental Sforzo" }
EmnityActions["RUN"] = { "Flash", "Foil" }
EmnityActions["DRK"] = { "Poisonga", "Stun" }
EmnityActions["BLU"] = { "Blank Gaze", "Jettatura", "Geist Wall" }

Resist = {}
Resist["ice"] = "ignis"
Resist["paralyze"] = "ignis"
Resist["bind"] = "ignis"
Resist["frost"] = "ignis"
Resist["evadown"] = "ignis"
Resist["agidown"] = "ignis"
Resist["wind"] = "gelus"
Resist["silence"] = "gelus"
Resist["gravity"] = "gelus"
Resist["choke"] = "gelus"
Resist["defdown"] = "gelus"
Resist["vitdown"] = "gelus"
Resist["earth"] = "flabra"
Resist["slow"] = "flabra"
Resist["petrify"] = "flabra"
Resist["rasp"] = "flabra"
Resist["accdown"] = "flabra"
Resist["dexdown"] = "flabra"
Resist["thunder"] = "tellus"
Resist["stun"] = "tellus"
Resist["shock"] = "tellus"
Resist["mnddown"] = "tellus"
Resist["water"] = "sulpor"
Resist["poison"] = "sulpor"
Resist["strdown"] = "sulpor"
Resist["atkdown"] = "sulpor"
Resist["fire"] = "unda"
Resist["addle"] = "unda"
Resist["amnesia"] = "unda"
Resist["virus"] = "unda"
Resist["burn"] = "unda"
Resist["mabdown"] = "unda"
Resist["intdown"] = "unda"
Resist["dark"] = "lux"
Resist["blind"] = "lux"
Resist["bio"] = "lux"
Resist["sleep"] = "lux"
Resist["dispel"] = "lux"
Resist["drain"] = "lux"
Resist["curse"] = "lux"
Resist["doom"] = "lux"
Resist["zombie"] = "lux"
Resist["mevadown"] = "lux"
Resist["hpdown"] = "lux"
Resist["mpdown"] = "lux"
Resist["chrdown"] = "lux"
Resist["absorb"] = "lux"
Resist["light"] = "tenebrae"
Resist["dia"] = "tenebrae"
Resist["repose"] = "tenebrae"
Resist["finale"] = "tenebrae"
Resist["charm"] = "tenebrae"
Resist["lullaby"] = "tenebrae"
Resist["sheepsong"] = "tenebrae"
Resist["maccdown"] = "tenebrae"

Runes = {}
Runes["light"] = "lux"
Runes["dark"] = "tenebrae"
Runes["water"] = "unda"
Runes["thunder"] = "sulpor"
Runes["fire"] = "ignis"
Runes["wind"] = "flabra"
Runes["earth"] = "tellus"
Runes["ice"] = "gelus"

function get_sets()
	KiteMode = false
	CPMode = false
	Rune = "Lux"
	SJAction = nil
	Mode = 1
	EmnityMode = false
	EngravedBelt = false
	Combat = false
	Buffs = {}
	MultiRune = false
	TargetRuneCount = {
		["tenebrae"] = 0,
		["lux"] = 0,
		["unda"] = 0,
		["sulpor"] = 0,
		["tellus"] = 0,
		["flabra"] = 0,
		["gelus"] = 0,
		["ignis"] = 0,
	}
	
	get_set_for_job_from_json("RUN", sets)
	
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] },
		{ name = "Tank_Physical", set = sets["Tank_Physical"] },
		{ name = "Tank_Magical", set = sets["Tank_Magical"] },
	}
	
	sets["Swipe"] = sets["Lunge"]
	sets["Vallation"] = sets["Valiance"]
	sets["Frostbite"] = sets["Lunge"]
	sets["Freezebite"] = sets["Lunge"]
	sets["Herculean Slash"] = sets["Lunge"]
	sets["Shockwave"] = sets["STR_WS"]
	sets["Resolution"] = set_combine(sets["STR_WS"], sets["Fotia"])
	sets["Savage Blade"] = set_combine(sets["STR_WS"])
	sets["Requeiscat"] = set_combine(sets["MND_WS"], sets["Fotia"])
	sets["Dimidiation"] = set_combine(sets["DEX_WS"])
	
	sets["EnhancingRegen"] = set_combine(sets["EnhancingAny"], sets["EnhancingRegen"])
	sets["EnhancingPhalanx"] = set_combine(sets["EnhancingAny"], sets["EnhancingPhalanx"])
	sets["Idle"] = set_combine(sets["Hybrid"], sets["Tank_Magical"], sets["Movement"], sets["IdleRegen"])
	
	subjob_check(player.sub_job)
	print_mode()
	print_current_rune()
	print_th_mode()
	send_command('@input /macro book 1;wait 1;input /macro set 1')
end
 
function precast(spell)
    if sets[spell.english] then
		if EmnityMode == true and check_emnity("JA", spell.english) == true then
			equip(set_combine(sets["Emnity"], sets[spell.english]))
		else
			equip(sets[spell.english])
		end
    elseif spell.type=="WeaponSkill" then
		local setToUse = {}
		if sets[spell.english] then
			setToUse = sets[spell.english]
		else
			setToUse = sets["WS_Any"]
		end
		local maxTP = 3000
		if player.equipment.main == "Lionheart" then
			maxTP = 2500
		end
		if player.tp < maxTP then
			setToUse = set_combine(setToUse, sets["TPBonus"])
		end
		if EmnityMode == true then
			setToUse = set_combine(setToUse, sets["Emnity"])
		end
		equip(setToUse)
	elseif spell.action_type == 'Magic' then
		if spell.skill == "Enhancing Magic" then
			equip(sets.FastcastEnhancing)
		else
			equip(sets["Fastcast"])
		end
    end
end
 
function midcast(spell)
	if spell.action_type == 'Magic' then
		local equipEmnity = EmnityMode
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
		else
			setToUse = Modes[Mode].set
		end
		if equipEmnity then
			equip(set_combine(setToUse, sets["Emnity"]))
		else
			equip(setToUse)
		end
	end
end
 
function aftercast(spell)
    if player.status=='Engaged' or Combat then
        equip(Modes[Mode].set)
    else
        equip(sets["Idle"])
    end
end
 
function status_change(new,old)
    if T{'Idle','Resting'}:contains(new) then
		on_status_change_for_th(new, old)
		equip(sets["Idle"])
    elseif new == 'Engaged' then
		equip(Modes[Mode].set)
		on_status_change_for_th(new, old)
    end
end
 
function buff_change(name,gain,buff_table)
	Buffs[name] = gain
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		if Combat then
			equip(Modes[Mode].set)
		else
			equip(set_combine(sets["Idle"], sets["Adoulin"]))
		end
	else
		if Combat then
			equip(Modes[Mode].set)
		else
			equip(sets["Idle"])
		end
	end
end)
 
function self_command(command)
	local args = T{}
	if type(command) == 'string' then
        args = T(command:split(' '))
        if #args == 0 then
            return
        end
    end
	if args[1] == 'cp' then
		if CPMode == false then
			add_to_chat(122, "CP Mode on")
			enable("back")
			equip(sets["CP"])
			disable("back")
			CPMode = true
		elseif CPMode == true then
			add_to_chat(122, "CP Mode off")
			enable("back")
			CPMode = false
		end
	elseif args[1] == "combat" then
		if Combat == true then
			add_to_chat(122, "Combat off!")
			Combat = false
		else
			add_to_chat(122, "Combat on!")
			equip(Modes[Mode].set)
			Combat = true
		end
	elseif args[1] == 'kite' then
		if KiteMode == false then
			add_to_chat(122, "Kite Mode on")
			enable("legs")
			equip(sets["Movement"])
			disable("legs")
			KiteMode = true
		elseif KiteMode == true then
			add_to_chat(122, "Kite Mode off")
			enable("legs")
			KiteMode = false
		end
	elseif args[1] == 'emnity' then
		if EmnityMode == false then
			add_to_chat(122, "Emnity Mode on")
			EmnityMode = true
		elseif EmnityMode == true then
			add_to_chat(122, "Emnity Mode off")
			EmnityMode = false
		end
	elseif args[1] == "mode" then
		if args[2] and type(tonumber(args[2])) == 'number' then
			nextMode = tonumber(args[2])
			if nextMode == nil then
				add_to_chat(122, "Invalid mode number")
			else
				if Modes[nextMode] == nil then
					add_to_chat(122, "Invalid node number")
				else
					Mode = nextMode
				end
			end
		else
			Mode = Mode + 1
			if Modes[Mode] == nil then
				Mode = 1
			end
		end
		print_mode()
	elseif args[1] == "rune" then
		if args[2] and args[3] and args[4] then
			local ele1 = string.lower(args[2])
			local ele2 = string.lower(args[3])
			local ele3 = string.lower(args[4])
			if Runes[ele1] and Runes[ele2] and Runes[ele3] then
				local rune1 = Runes[ele1]
				local rune2 = Runes[ele2]
				local rune3 = Runes[ele3]
				if TargetRuneCount[rune1] and TargetRuneCount[rune2] and TargetRuneCount[rune3] then
					MultiRune = true
					TargetRuneCount["lux"] = 0
					TargetRuneCount["tenebrae"] = 0
					TargetRuneCount["unda"] = 0
					TargetRuneCount["sulpor"] = 0
					TargetRuneCount["tellus"] = 0
					TargetRuneCount["flabra"] = 0
					TargetRuneCount["gelus"] = 0
					TargetRuneCount["ignis"] = 0
					TargetRuneCount[rune1] = TargetRuneCount[rune1] + 1
					TargetRuneCount[rune2] = TargetRuneCount[rune2] + 1
					TargetRuneCount[rune3] = TargetRuneCount[rune3] + 1
					print_current_rune()
				end
			end
		elseif args[2] then
			MultiRune = false
			if Runes[string.lower(args[2])] then
				Rune = Runes[string.lower(args[2])]
				print_current_rune()
			end
		else
			if MultiRune then
				for k,v in pairs(TargetRuneCount) do
					if v > 0 then
						if buffactive[k] == nil or buffactive[k] < v then
							send_command('input /ja "' .. k .. '" <me>')
							break;
						end
					end
					-- can't get duration info so can't refresh time... have to wait for it to expire
				end
			else
				send_command('input /ja "' .. Rune .. '" <me>')
			end
		end
	elseif args[1] == "sjAction" then
		if SJAction == nil then
			add_to_chat(122, "No SubjobAction for " .. player.sub_job)
		else
			send_command('input ' .. SJAction)
		end
	elseif args[1] == 'setWS' and args[2] then
		WS = string.sub(command, 7)
		print_current_ws()
	elseif args[1] == 'resist' and args[2] then
		if args[2] and args[3] and args[4] then
			local res1 = string.lower(args[2])
			local res2 = string.lower(args[3])
			local res3 = string.lower(args[4])
			if Resist[res1] and Resist[res2] and Resist[res3] then
				local rune1 = Resist[res1]
				local rune2 = Resist[res2]
				local rune3 = Resist[res3]
				if TargetRuneCount[rune1] and TargetRuneCount[rune2] and TargetRuneCount[rune3] then
					MultiRune = true
					TargetRuneCount["lux"] = 0
					TargetRuneCount["tenebrae"] = 0
					TargetRuneCount["unda"] = 0
					TargetRuneCount["sulpor"] = 0
					TargetRuneCount["tellus"] = 0
					TargetRuneCount["flabra"] = 0
					TargetRuneCount["gelus"] = 0
					TargetRuneCount["ignis"] = 0
					TargetRuneCount[rune1] = TargetRuneCount[rune1] + 1
					TargetRuneCount[rune2] = TargetRuneCount[rune2] + 1
					TargetRuneCount[rune3] = TargetRuneCount[rune3] + 1
					print_current_rune()
				end
			end
		else
			local arg2 = string.lower(args[2])
			if Resist[arg2] then 
				Rune = Resist[arg2] 
				MultiRune = false
				print_current_rune()
			end
		end
	elseif args[1] == "printBuffs" then
		for k,v in pairs(buffactive) do
			add_to_chat(122, k .. " " .. tostring(v))
		end
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(Modes[Mode].set)
		end
	end
end

function sub_job_change(new, old)
	subjob_check(new)
end

function print_mode()
	printString = "Current Mode: "	
	for i = 1, #Modes do
		if i == Mode then
			printString = printString .. "[" .. i .. ":" .. Modes[i].name .. "] "
		else
			printString = printString .. i .. ":" .. Modes[i].name .. " "
		end
	end	
	add_to_chat(122, printString)
end

function print_current_rune()
	if MultiRune then
		local runeString = ""
		for k,v in pairs(TargetRuneCount) do
			if v > 0 then
				runeString = runeString .. k .. "*" .. v .. " "
			end
		end
		add_to_chat(122, "Current Runes: " .. runeString)
	else
		add_to_chat(122, "Current Rune: " .. Rune)
	end
end

function print_subjob_action()
	if SJAction == nil then
	else
		add_to_chat(122, "Current Subjob Action: " .. SJAction)
	end
end

function subjob_check(job)
	if job == "NIN" then
		SJAction = '/ma "Utsusemi: Ni" <me>'
	elseif job == "DNC" then
		SJAction = nil
	elseif job == "SAM" then
		SJAction = '/ja "Third Eye" <me>'
	elseif job == "WAR" then
		SJAction = '/ja "Provoke" <stnpc>'
	elseif job == "DRK" then
		SJAction = '/ma "Stun" <stnpc>'
	else
		SJAction = nil
	end
	print_subjob_action()
end

function check_emnity(type, spellName)
	if EmnityActions[type] then
		for k,v in ipairs(EmnityActions[type]) do
			if spellName == v then 
				return true 
			end
		end
	end
	return false
end