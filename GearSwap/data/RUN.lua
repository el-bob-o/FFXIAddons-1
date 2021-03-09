include("THHelper.lua")

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
Resist["thunder"] = "Telus"
Resist["stun"] = "Telus"
Resist["shock"] = "Telus"
Resist["mnddown"] = "Telus"
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
	CanDualWield = false
	ResistCharm = false
	EngravedBelt = false
	Combat = false
	DW_Needed = 0
	Buffs = {}
	
	ogmaDex = {name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%'}}
	ogmaStr = {name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10'}}
	
	sets.EngravedBelt = { waist="Engraved Belt" }
	
	ayaHead 		= { name = "Aya. Zucchetto +2", 	priority = 45 }	
	ayaBody			= { name = "Ayanmo Corazza +2", 	priority = 57 }
	ayaHands		= { name = "Aya. Manopolas +1",		priority = 22 }
	ayaLegs			= { name = "Aya. Cosciales +1", 	priority = 45 }
	ayaFeet			= { name = "Aya. Gambieras +1", 	priority = 11 }
	carmLegs		= { name = "Carmine Cuisses +1", 	priority = 50 }	
	carmFeet		= { name = "Carmine Greaves +1", 	priority = 15 }
	darkRing 		= { name = "Dark Ring", 			priority = -20 }
	despHelm		= { name = "Despair Helm", 			priority = 38 }
	eabaEar			= { name = "Eabani Earring", 		priority = 45 }
	emetBody		= { name = "Emet Harness +1",		priority = 61 }
	etheEar 		= { name = "Ethereal Earring", 		priority = 15 }
	etioEar			= { name = "Etiolation Earring",	priority = 50 }
	eriHead 		= { name = "Erilaz Galea +1", 		priority = 91 }	
	eriLegs			= { name = "Eri. Leg Guards +1",	priority = 80 }
	eriFeet			= { name = "Erilaz Greaves +1", 	priority = 18 }
	futhHead		= { name = "Fu. Bandeau +2", 		priority = 46 }
	futhNeck 		= { name = "Futhark Torque +1", 	priority = 30 }
	futhBody 		= { name = "Futhark Coat +1", 		priority = 99 }
	futhLegs 		= { name = "Futhark Trousers +1", 	priority = 87 }
	futhFeet		= { name = "Futhark Boots +1", 		priority = 13 }
	gelaRing		= { name = "Gelatinous Ring +1",	priority = 135 }
	hercHelm 		= { name = "Herculean Helm", 		priority = 38 }
	hercBody		= { name = "Herculean Vest", 		priority = 61 }
	hercHands		= { name = "Herculean Gloves",		priority = 20 }
	hercFeet		= { name = "Herculean Boots", 		priority = 9 }
	leylHands		= { name = "Leyline Gloves", 		priority = 25 }
	megHands		= { name = "Meg. Gloves +2",		priority = 30 }
	megLegs			= { name = "Meg. Chausses +2", 		priority = 35 }
	odnoEar 		= { name = "Odnowa Earring +1", 	priority = 110 }
	rawhLegs		= { name = "Rawhide Trousers", 		priority = 47 }
	runeHelm		= { name = "Rune. Bandeau +1", 		priority = 66 }
	runeBody		= { name = "Runeist's Coat +2", 	priority = 208 }
	runeLegs		= { name = "Rune. Trousers +1", 	priority = 47 }
	runeHands		= { name = "Runeist Mitons +1", 	priority = 50 }	
	samnBody		= { name = "Samnuha Coat", 			priority = 63 }
	supeRing		= { name = "Supershear Ring", 		priority = 30 }
	taeoHands		= { name = "Taeon Gloves", 			priority = 25 }

	-- dt -40
	sets.DT = {
		ammo="Staunch Tathlum", 
		head=ayaHead, neck=futhNeck, ear1=etherealEar, ear2=odnowaEar, 
		body=futhBody, hands=ayaHands, ring1="Vocane Ring +1", ring2=darkRing,
		back="Evasionist's Cape", legs=ayaLegs, feet=ayaFeet
	}
	
	-- pdt 51, mdt -40
	sets.MDT = set_combine(sets.DT, {
		ear2=etioEar,
		waist="Engraved Belt",
	})
	
	sets.PDT = set_combine(sets.DT, {
		head=futhHead,
		hands=megHands, ring2=gelaRing,
		waist="Flume Belt +1", legs=eriLegs, feet=eriFeet,
	})
	
	-- emnity +41, pdt - 53/50, mdt -22, +61 allresist, 388 magic eva
	sets.ShellVTank = set_combine(sets.PDT, {
		body=runeBody,
	})
	sets.NoBuffTank = sets.MDT
	
	sets.Hybrid = {
		ammo="Aurgelmir Orb",
		head=ayaHead, neck=futhNeck, ear1="Cessance Earring", ear2="Brutal Earring", 
		body=ayaBody, hands=hercHands,
		back=ogmaDex, waist="Sailfi Belt +1", legs=megLegs, feet=hercFeet,
	}
	sets.ShellVHybrid = set_combine(sets.ShellVTank, sets.Hybrid)
	sets.NoBuffHybrid = set_combine(sets.NoBuffTank, sets.Hybrid)
	
	sets.DW0 = {}
	sets.DW9 = { ear1 = "Suppanomimi", ear2=eabaEar } -- 9
	sets.DW21 = set_combine(sets.DW9, { 
		body=samnBody,
	}) -- 9 + 5 = 14
	
	-- Make sure first mode is not a DW mode
	Modes = { 
		{ name = "Hybrid", dwSub = false, hybrid = true },
		{ name = "Tank", dwSub = false, hybrid = false },
		{ name = "HybridDW", dwSub = true, hybrid = true },
		{ name = "DWTank", dwSub = true, hybrid = false },	
	}
	ModeCount = 4 --Update if add new modes
	
	-- 47 emnity
	sets.Emnity = {
		head=despHelm, neck=futhNeck, ear1="Friomisi Earring",
		body=emetBody, ring2=supeRing,
		back="Evasionist's Cape", legs=eriLegs, feet=eriFeet
	}
	
	sets.JA = {}
	sets.JA["Lunge"] = {
		neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body=samnBody,hands=leylHands,ring1="Locus Ring",
		back="Toro Cape"}
	sets.JA["Swipe"] = sets.JA["Lunge"]
	sets.JA["Vivacious Pulse"] = {head=eriHead,neck="Incanter's Torque", legs=runeLegs}
	sets.JA["Battuta"] = {head=futhHead}
	sets.JA["Valiance"] = {body = runeBody, legs=futhLegs, back = "Ogma's Cape"}
	sets.JA["Vallation"] = sets.JA["Valiance"]
	sets.JA["Elemental Sforzo"] = {body=futhBody}
	sets.JA["Rayke"] = {feet=futhFeet}
	sets.JA["Liement"] = {body=futhBody}
	sets.JA["Gambit"] = {hands=runeHands}
 
	sets.WS_Any = {ammo="Aurgelmir Orb", ear1="Cessance Earring", ear2="Brutal Earring"}
 
	sets.WS_DEX = set_combine(sets.WS_Any, {
		head=hercHelm, ear2="Odr Earring",
		body=hercBody,hands=megHands,ring1="Rajas Ring",ring2="Ramuh Ring",
		back=ogmaDex,waist="Sailfi Belt +1",legs=megLegs,feet=hercFeet})
	sets.WS_STR = set_combine(sets.WS_Any, {
		ammo="Seeth. Bomblet +1",
		head=hercHelm,
		body=hercBody,hands=hercHands,ring2="Rufescent Ring",
		back=ogmaStr,waist="Sailfi Belt +1",legs=megLegs,feet=hercFeet})
	sets.WS_MagicAcc = set_combine(sets.WS_Any, {
		ammo="Seeth. Bomblet +1",
		head=ayaHead, neck="Voltsurge Torque", ear1="Cessance Earring", ear2="Odr Earring",
		body=samnBody, hands=leylHands, ring1="Rufescent Ring", ring2="Vertigo Ring",
		back="Izdubar Mantle", waist="Kentarch Belt +1", legs=rawhLegs, feet=hercFeet
		})
		
	sets.WS = {}
	sets.WS["Dimidiation"] = sets.WS_DEX
	sets.WS["Resolution"] = set_combine(sets.WS_STR, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.WS["Savage Blade"] = sets.WS_STR
	sets.WS["Swift Blade"] = set_combine(sets.WS_STR, {neck="Fotia Gorget"})
	sets.WS["Armor Break"] = sets.WS_MagicAcc
	sets.WS["Fell Cleave"] = sets.WS_STR
	sets.WS["Shockwave"] = sets.WS_STR
	sets.WS["Upheaval"] = sets.WS_STR
	sets.WS["Steel Cyclone"] = sets.WS_STR
	sets.WS["Sanguine Blade"] = sets.JA["Lunge"]
	sets.WS["Freezebite"] = sets.JA["Lunge"]
	sets.WS["Requeiescat"] = {ammo="Seething Bomblet +1",
		head=hercHelm,neck="Fotia Gorget",ear2="Moonshade Earring",
		body=hercBody,hands=megHands,ring1="Vertigo Ring",ring2="Rufescent Ring",
		back=ogmaStr,waist="Fotia Belt",legs=carmLegs, feet=hercFeet}
 
	sets.Fastcast = {
		head=runeHelm,neck="Voltsurge Torque",ear1="Loquac. Earring",ear2=etioEar,
		body=samnBody, hands=leylHands,
		legs=rawhLegs,feet=carmFeet}
	sets.Fastcast["Enhancing"] = set_combine(sets.Fastcast, {legs=futhLegs})
	sets.Enhancing = {}
	sets.Enhancing["Any"] = {head=eriHead,hands=runeHands,legs=carmLegs}
	sets.Enhancing["Regen"] = set_combine(sets.Enhancing["Any"], {head=runeHelm})
	sets.Enhancing["Phalanx"] = set_combine(sets.Enhancing["Any"], 
	{
		head=futhHead,
		hands=taeoHands,
	})
 
	sets.Movement = {legs=carmLegs}
	sets.Idle = set_combine(sets.Movement, {body=runeBody,neck="Lissome Necklace",ring2="Chirich Ring"})
	
	sets.ResistCharm = { 
		ammo="Staunch Tathlum", 
		back="Solemnity Cape", legs= runeLegs,
	}
 
	sets.Reive = {neck="Ygnas's Resolve +1"}
 
	sets.TH = {ammo="Per. Lucky Egg", waist="Chaac Belt"}
 
	sets.CP = {back="Mecisto. Mantle"}
	
	subjob_check(player.sub_job)
	print_mode()
	print_current_rune()
	print_th_mode()
	send_command('@input /macro book 1;wait 1;input /macro set 1')
end
 
function precast(spell)
    if sets.JA[spell.english] then
		if EmnityMode == true and check_emnity("JA", spell.english) == true then
			equip(set_combine(sets.Emnity, sets.JA[spell.english]))
		else
			equip(sets.JA[spell.english])
		end
    elseif spell.type=="WeaponSkill" then
		local setToUse = {}
		if sets.WS[spell.english] then
			setToUse = sets.WS[spell.english]
		else
			setToUse = sets.WS["Any"]
		end
		if player.equipment.main == "Lionheart" then 
			if player.tp < 2500 then
				setToUse = set_combine(setToUse, {ear1="Moonshade Earring"})
			end
		else
			if player.tp < 3000 then
				setToUse = set_combine(setToUse, {ear1="Moonshade Earring"})
			end
		end
		if EmnityMode == true then
			setToUse = set_combine(setToUse, sets.Emnity)
		end
		equip(setToUse)
	elseif spell.action_type == 'Magic' then
		if spell.skill == "Enhancing Magic" then
			equip(sets.Fastcast["Enhancing"])
		else
			equip(sets.Fastcast)
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
		if spell.skill == "Enhancing Magic" then
			if sets.Enhancing[spell.english] then
				if equipEmnity == true then
					equip(set_combine(sets.Enhancing[spell.english], sets.Emnity))
				else
					equip(sets.Enhancing[spell.english])
				end
			else
				if equipEmnity == true then
					equip(set_combine(sets.Enhancing["Any"], sets.Emnity))
				else
					equip(sets.Enhancing["Any"])
				end
			end
		else		
			if equipEmnity == true then
				equip(set_combine(get_set(), sets.Emnity))
			else
				equip(get_set())
			end
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
	if name == "Reive Mark" then
		if gain then
			enable("neck")
			equip(sets.Reive)
			disable("neck")
		else
			enable("neck")
		end
	else
		Buffs[name] = gain
	end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		if Combat then
			equip(get_set())
		else
			equip(set_combine(sets.Idle, {body="Councilor's Garb"}))
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
			equip(sets.CP)
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
			equip(sets.Movement)
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
					if Modes[nextMode].dwSub == true and CanDualWield == false then
						add_to_chat(122, "Invalid node number, can't dual wield")
					else
						Mode = nextMode
					end
				end
			end
		else
			Mode = Mode + 1
			if Modes[Mode] == nil then
				Mode = 1
			else
				local validMode = nil
				for i = Mode, ModeCount, 1 do
					if Modes[Mode].dwSub == false then
						validMode = Mode
						break
					else
						if CanDualWield == true then
							validMode = Mode
							break
						end
					end
				end
				if validMode then
					Mode = validMode
				else
					Mode = 1
				end
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
	elseif args[1] == "resistCharm" then
		if ResistCharm == false then
			ResistCharm = true
			equip(sets.ResistCharm)
			disable("ammo")
			disable("back")
			disable("legs")
			add_to_chat(122, "Resist Charm on")
		else
			ResistCharm = false
			enable("ammo")
			enable("back")
			enable("legs")
			add_to_chat(122, "Resist Charm off")
		end
	elseif args[1] == "engravedbelt" then
		if EngravedBelt == false then
			EngravedBelt = true
			add_to_chat(122, "Engraved Belt on")
		else
			EngravedBelt = false
			add_to_chat(122, "Resist Charm off")
		end
	elseif args[1] == 'setWS' and args[2] then
		WS = args[2]
		print_current_ws()
	elseif args[1] == 'resist' and args[2] then
		local arg2 = string.lower(args[2])
		if Resist[arg2] then Rune = Resist[arg2] end
		print_current_rune()
	elseif args[1] == "dw" and args[2] then
		if type(tonumber(args[2])) == 'number' then
			local dwNo = tonumber(args[2])
			DwNeeded = dwNo
		end
	elseif args[1] == "th" then
		parse_th_command(args)
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
	for i = 1, ModeCount, 1 do
		if i == Mode then
			printString = printString .. "[" .. i .. ":" .. Modes[i].name .. "] "
		elseif Modes[i] == nil then
			break
		else
			local notDW = Modes[i].dwSub == false
			local canDW = Modes[i].dwSub == true and CanDualWield == true
			if notDW == true or canDW == true then 
				printString = printString .. i .. ":" .. Modes[i].name .. " "
			end
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
		CanDualWield = true
	elseif job == "DNC" then
		SJAction = nil
		CanDualWield = true
	elseif job == "SAM" then
		CanDualWield = false
		SJAction = '/ja "Third Eye" <me>'
	elseif job == "WAR" then
			CanDualWield = false
		SJAction = '/ja "Provoke" <stnpc>'
	elseif job == "DRK" then
		CanDualWield = false
		SJAction = '/ma "Stun" <stnpc>'
	else
		CanDualWield = false
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
	if Modes[Mode].dwSub then
		if Modes[Mode].hybrid then
			if Buffs["Shell"] then
				setToUse = set_combine(sets.ShellVHybrid, get_DW_set())
			else
				setToUse = set_combine(sets.NoBuffHybrid, get_DW_set())
			end
		else
			if Buffs["Shell"] then
				setToUse = set_combine(sets.ShellVTank, get_DW_set())
			else
				setToUse = set_combine(sets.NoBuffTank, get_DW_set())
			end
		end
	else
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
	end
	if EngravedBelt then setToUse = set_combine(setToUse, sets.EngravedBelt) end
	return setToUse
end

function get_DW_set()
	if DW_Needed > 11 then return sets.DW21
	elseif DW_Needed >= 9 then return sets.DW9
	else return sets.DW0
	end
end