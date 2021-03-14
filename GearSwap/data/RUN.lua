include("THHelper.lua")
include("MasterGearList.lua")

EmnityActions = {}
EmnityActions["JA"] = { "Valiance", "Vallation", "Swordplay", "Pflug", "Gambit", "Rayke", "Liement",
	"Battuta", "One for All", "Elemental Sforzo" }
EmnityActions["RUN"] = { "Flash", "Foil" }
EmnityActions["DRK"] = { "Poisonga", "Stun" }
EmnityActions["BLU"] = { "Blank Gaze", "Jettatura", "Geist Wall" }

Resist = {}
Resist["ice"] = "Ignis"
Resist["paralyze"] = "Ignis"
Resist["bind"] = "Ignis"
Resist["frost"] = "Ignis"
Resist["evadown"] = "Ignis"
Resist["agidown"] = "Ignis"
Resist["wind"] = "Gelus"
Resist["silence"] = "Gelus"
Resist["gravity"] = "Gelus"
Resist["choke"] = "Gelus"
Resist["defdown"] = "Gelus"
Resist["vitdown"] = "Gelus"
Resist["earth"] = "Flabra"
Resist["slow"] = "Flabra"
Resist["petrify"] = "Flabra"
Resist["rasp"] = "Flabra"
Resist["accdown"] = "Flabra"
Resist["dexdown"] = "Flabra"
Resist["thunder"] = "Tellus"
Resist["stun"] = "Tellus"
Resist["shock"] = "Tellus"
Resist["mnddown"] = "Tellus"
Resist["water"] = "Sulpor"
Resist["poison"] = "Sulpor"
Resist["strdown"] = "Sulpor"
Resist["atkdown"] = "Sulpor"
Resist["fire"] = "Unda"
Resist["addle"] = "Unda"
Resist["amnesia"] = "Unda"
Resist["virus"] = "Unda"
Resist["burn"] = "Unda"
Resist["mabdown"] = "Unda"
Resist["intdown"] = "Unda"
Resist["dark"] = "Lux"
Resist["blind"] = "Lux"
Resist["bio"] = "Lux"
Resist["sleep"] = "Lux"
Resist["dispel"] = "Lux"
Resist["drain"] = "Lux"
Resist["curse"] = "Lux"
Resist["doom"] = "Lux"
Resist["zombie"] = "Lux"
Resist["mevadown"] = "Lux"
Resist["hpdown"] = "Lux"
Resist["mpdown"] = "Lux"
Resist["chrdown"] = "Lux"
Resist["absorb"] = "Lux"
Resist["light"] = "Tenebrae"
Resist["dia"] = "Tenebrae"
Resist["repose"] = "Tenebrae"
Resist["finale"] = "Tenebrae"
Resist["charm"] = "Tenebrae"
Resist["lullaby"] = "Tenebrae"
Resist["sheepsong"] = "Tenebrae"
Resist["maccdown"] = "Tenebrae"
	

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
	
	sets = get_set_for_job("RUN")
		
	sets.ShellVTank = set_combine(sets["DT"], sets["PDT"])
	sets.NoBuffTank = set_combine(sets["DT"], sets["MDT"])	
	sets.ShellVHybrid = set_combine(sets.ShellVTank, sets["Hybrid"])
	sets.NoBuffHybrid = set_combine(sets.NoBuffTank, sets["Hybrid"])
	
	-- Make sure first mode is not a DW mode
	Modes = { 
		{ name = "Hybrid", hybrid = true },
		{ name = "Tank", hybrid = false },
	}
	
	sets["Swipe"] = sets["Lunge"]
	sets["Vallation"] = sets["Valiance"]
	sets["Dimidiation"] = sets["WS_DEX"]
	sets["Resolution"] = set_combine(sets["WS_STR"], sets["Fotia"])
	sets["Savage Blade"] = sets["WS_STR"]
	sets["Swift Blade"] = set_combine(sets["WS_STR"], sets["Fotia"])
	sets["Armor Break"] = sets["WS_MagicAcc"]
	sets["Fell Cleave"] = sets["WS_STR"]
	sets["Shockwave"] = sets["WS_STR"]
	sets["Upheaval"] = sets["WS_STR"]
	sets["Steel Cyclone"] = sets["WS_STR"]
	sets["Sanguine Blade"] = sets["Lunge"]
	sets["Freezebite"] = sets["Lunge"]
	sets["Requeiescat"] = sets["Requeiescat"]
	
	sets.FastcastEnhancing = set_combine(sets["Fastcast"], sets["FastcastEnhancing"])
	sets.EnhancingRegen = set_combine(sets["EnhancingAny"], sets["EnhancingRegen"])
	sets.EnhancingPhalanx = set_combine(sets["EnhancingAny"], sets["EnhancingPhalanx"])
	sets.Idle = set_combine(sets["Movement"], sets["IdleRegen"])
	
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
				setToUse = sets.EnhancingRegen
			elseif spell.english:match("Phalanx") then
				setToUse = sets.EnhancingPhalanx
			else
				setToUse = sets["EnhancingAny"]
			end
		else
			setToUse = get_set()		
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
        equip(get_set())
    else
        equip(sets.Idle)
    end
end
 
function status_change(new,old)
    if T{'Idle','Resting'}:contains(new) then
		on_status_change_for_th(new, old)
		equip(sets.Idle)
    elseif new == 'Engaged' then
		equip(get_set())
		on_status_change_for_th(new, old)
    end
end
 
function buff_change(name,gain,buff_table)
	Buffs[name] = gain
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		if Combat then
			equip(get_set())
		else
			equip(set_combine(sets.Idle, sets["Adoulin"]))
		end
	else
		if Combat then
			equip(get_set())
		else
			equip(sets.Idle)
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
			equip(get_set())
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
		if args[2] then
			if args[2] == "light" then Rune = "Lux"
			elseif args[2] == "dark" then Rune = "Tenebrae" 
			elseif args[2] == "fire" then Rune = "Ignis"
			elseif args[2] == "water" then Rune = "Unda"
			elseif args[2] == "thunder" then Rune = "Sulpor"
			elseif args[2] == "ice" then Rune = "Gelus"
			elseif args[2] == "wind" then Rune = "Flabra"
			elseif args[2] == "earth" then Rune = "Tellus"
			end
			print_current_rune()
		else
			send_command('input /ja "' .. Rune .. '" <me>')
		end
	elseif args[1] == "sjAction" then
		if SJAction == nil then
			add_to_chat(122, "No SubjobAction for " .. player.sub_job)
		else
			send_command('input ' .. SJAction)
		end
	elseif args[1] == 'setWS' and args[2] then
		WS = args[2]
		print_current_ws()
	elseif args[1] == 'resist' and args[2] then
		local arg2 = string.lower(args[2])
		if Resist[arg2] then Rune = Resist[arg2] end
		print_current_rune()
	elseif args[1] == "th" then
		parse_th_command(args)
	else
		master_gear_list_command(args)
	end
end

function sub_job_change(new, old)
	subjob_check(new)
end

function check_mode()
	if Modes[Mode].dwSub == true and CanDualWield == false then
		Mode = 1
	end
	print_mode()
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
	add_to_chat(122, "Current Rune: " .. Rune)
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
	check_mode()
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

function get_set()
	local setToUse = nil
	if Modes[Mode].hybrid then
		if Buffs["Shell"] then
			setToUse = sets.ShellVHybrid
		else
			setToUse = sets.NoBuffHybrid
		end
	else
		if Buffs["Shell"] then
			setToUse = sets.ShellVTank
		else
			setToUse = sets.NoBuffTank
		end
	end
	return setToUse
end