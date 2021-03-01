function get_sets()
	KiteMode = false
	CPMode = false
	Rune = "Lux"
	SJAction = nil
	Mode = 1
	EmnityMode = true
	CanDualWield = false
	ResistCharm = false
	EngravedBelt = false
	Combat = false
	DW_Needed = 0
	Buffs = {}
	
	ogmaDex = {name="Ogma's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Dbl.Atk."+10','Phys. dmg. taken-10%'}}
	ogmaStr = {name="Ogma's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10'}}
	
	sets.EngravedBelt = { waist="Engraved Belt" }
	
	-- dt -40
	sets.DT = {
		ammo="Staunch Tathlum", 
		head="Aya. Zucchetto +2", neck="Futhark Torque +1", ear1="Ethereal Earring", ear2="Odnowa Earring +1", 
		body="Futhark Coat +1", hands="Aya. Manopolas +1", ring1="Vocane Ring +1", ring2="Dark Ring",
		back="Evasionist's Cape", legs="Aya. Cosciales +1", feet="Aya. Gambieras +1"
	}
	
	-- pdt 51, mdt -40
	sets.MDT = set_combine(sets.DT, {
		ear2="Etiolation Earring",
		waist="Engraved Belt",
	})
	
	sets.PDT = set_combine(sets.DT, {
		head="Fu. Bandeau +1",
		hands="Meg. Gloves +2", ring2="Gelatinous Ring +1",
		waist="Flume Belt +1", legs="Eri. Leg Guards +1", feet="Erilaz Greaves +1",
	})
	
	-- emnity +41, pdt - 53/50, mdt -22, +61 allresist, 388 magic eva
	sets.ShellVTank = set_combine(sets.PDT, {
		body="Runeist's Coat +2",
	})
	sets.NoBuffTank = sets.MDT
	
	sets.Hybrid = {
		ammo="Aurgelmir Orb",
		head="Aya. Zucchetto +2", neck="Futhark Torque +1", ear1="Cessance Earring", ear2="Brutal Earring", 
		body="Ayanmo Corazza +2", hands="Herculean Gloves",
		back=ogmaDex, waist="Sailfi Belt +1", legs="Meg. Chausses +2", feet="Herculean Boots",
	}
	sets.ShellVHybrid = set_combine(sets.ShellVTank, sets.Hybrid)
	sets.NoBuffHybrid = set_combine(sets.NoBuffTank, sets.Hybrid)
	
	sets.DW0 = {}
	sets.DW9 = { ear1 = "Suppanomimi", ear2="Eabani Earring" } -- 9
	sets.DW21 = set_combine(sets.DW9, { 
		body="Samnuha Coat",
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
		head="Despair Helm", neck="Futhark Torque +1", ear1="Friomisi Earring",
		body="Emet Harness +1", ring2="Supershear Ring",
		back="Evasionist's Cape", legs="Eri. Leg Guards +1", feet="Erilaz Greaves +1"
	}
	EmnityActions = {}
	EmnityActions["JA"] = { "Valiance", "Vallation", "Swordplay", "Pflug", "Gambit", "Rayke", "Liement",
		"Battuta", "One for All", "Elemental Sforzo" }
	EmnityActions["RUN"] = { "Flash", "Foil" }
	EmnityActions["DRK"] = { "Poisonga", "Stun" }
	EmnityActions["BLU"] = { "Blank Gaze", "Jettatura", "Geist Wall" }
	
	sets.JA = {}
	sets.JA["Lunge"] = {
		neck="Eddy Necklace",ear1="Friomisi Earring",ear2="Hecate's Earring",
		body="Samnuha Coat",hands="Leyline Gloves",ring1="Locus Ring",
		back="Toro Cape"}
	sets.JA["Swipe"] = sets.JA["Lunge"]
	sets.JA["Vivacious Pulse"] = {head="Erilaz Galea +1",neck="Incanter's Torque", legs="Rune. Trousers +1"}
	sets.JA["Battuta"] = {head="Futhark Bandeau +1"}
	sets.JA["Valiance"] = {body = "Runeist's Coat +2", legs="Futhark Trousers +1", back = "Ogma's Cape"}
	sets.JA["Vallation"] = sets.JA["Valiance"]
	sets.JA["Elemental Sforzo"] = {body="Futhark Coat +1"}
	sets.JA["Rayke"] = {feet="Futhark Boots +1"}
	sets.JA["Liement"] = {body = "Futhark Coat +1"}
	sets.JA["Gambit"] = {hands="Runeist Mitons +1"}
 
	sets.WS_Any = {ammo="Aurgelmir Orb", ear1="Moonshade Earring", ear2="Brutal Earring"}
 
	sets.WS_DEX = set_combine(sets.WS_Any, {
		head="Herculean Helm", ear2="Odr Earring",
		body="Herculean Vest",hands="Meg. Gloves +2",ring1="Rajas Ring",ring2="Ramuh Ring",
		back=ogmaDex,waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Herculean Boots"})
	sets.WS_STR = set_combine(sets.WS_Any, {
		head="Herculean Helm",
		body="Herculean Vest",hands="Meg. Gloves +2",ring2="Rufescent Ring",
		back=ogmaStr,waist="Sailfi Belt +1",legs="Herculean Trousers",feet="Herculean Boots"})
	sets.WS_MagicAcc = set_combine(sets.WS_Any, {
		ammo="Seeth. Bomblet +1",
		head="Aya. Zucchetto +2", neck="Voltsurge Torque", ear1="Cessance Earring", ear2="Odr Earring",
		body="Samnuha Coat", hands="Leyline Gloves", ring1="Rufescent Ring", ring2="Vertigo Ring",
		back="Izdubar Mantle", waist="Kentarch Belt +1", legs="Rawhide Trousers", feet="Herculean Boots"
		})
		
	sets.WS = {}
	sets.WS["Dimidiation"] = sets.WS_DEX
	sets.WS["Resolution"] = set_combine(sets.WS_STR, {neck="Fotia Gorget",waist="Fotia Belt"})
	sets.WS["Savage Blade"] = sets.WS_STR
	sets.WS["Swift Blade"] = set_combine(sets.WS_STR, {neck="Fotia Gorget"})
	sets.WS["Armor Break"] = sets.WS_MagicAcc
	sets.WS["Fell Cleave"] = sets.WS_STR
	sets.WS["Upheaval"] = sets.WS_STR
	sets.WS["Steel Cyclone"] = sets.WS_STR
	sets.WS["Sanguine Blade"] = sets.JA["Lunge"]
	sets.WS["Freezebite"] = sets.JA["Lunge"]
	sets.WS["Requeiescat"] = {ammo="Seething Bomblet +1",
		head="Herculean Helm",neck="Fotia Gorget",ear2="Moonshade Earring",
		body="Herculean Vest",hands="Meg. Gloves +2",ring1="Vertigo Ring",ring2="Rufescent Ring",
		back=ogmaStr,waist="Fotia Belt",legs="Carmine Cuisses +1", feet="Herculean Boots"}
 
	sets.Precast = {
		head="Rune. Bandeau +1",neck="Voltsurge Torque",ear1="Loquac. Earring",ear2="Etiolation Earring",
		body="Samnuha Coat", hands="Leyline Gloves",
		legs="Rawhide Trousers",feet="Carmine Greaves +1"}
	sets.Enhancing = {}
	sets.Enhancing["Precast"] = set_combine(sets.Precast, {legs="Futhark Trousers +1"})
	sets.Enhancing["Any"] = {head="Erilaz Galea +1",hands="Runeist Mitons +1",legs="Carmine Cuisses +1"}
	sets.Enhancing["Regen"] = set_combine(sets.Enhancing["Any"], {head="Rune. Bandeau +1"})
	sets.Enhancing["Phalanx"] = set_combine(sets.Enhancing["Any"], 
	{
		head="Futhark Bandeau +1",
		hands="Taeon Gloves",
	})
 
	sets.Movement = {legs="Carmine Cuisses +1"}
	sets.Idle = set_combine(sets.Movement, {body="Runeist's Coat +2",neck="Lissome Necklace",ring2="Chirich Ring"})
	
	sets.ResistCharm = { 
		ammo="Staunch Tathlum", 
		back="Solemnity Cape", legs= "Rune. Trousers +1",
	}
 
	sets.Reive = {neck="Ygnas's Resolve +1"}
 
	sets.TH = {ammo="Per. Lucky Egg", waist="Chaac Belt"}
 
	sets.CP = {back="Mecisto. Mantle"}
	
	subjob_check(player.sub_job)
	print_mode()
	print_current_rune()
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
        if sets.WS[spell.english] then
			if EmnityMode == true then
				equip(set_combine(sets.Emnity, sets.WS[spell.english]))
			else
				equip(sets.WS[spell.english])
			end
		else
			if EmnityMode == true then
				equip(set_combine(sets.Emnity, sets.WS["Any"]))
			else
				equip(sets.WS["Any"])
			end
		end
	elseif spell.action_type == 'Magic' then
		if spell.skill == "Enhancing Magic" then
			equip(sets.Enhancing["Precast"])
		else
			equip(sets.Precast)
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
		equip(sets.Idle)
    elseif new == 'Engaged' then
        equip(set_combine(get_set(), sets.TH))
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
	if command == 'cp' then
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
	elseif command == "combat" then
		if Combat == true then
			add_to_chat(122, "Combat off!")
			Combat = false
		else
			add_to_chat(122, "Combat on!")
			equip(get_set())
			Combat = true
		end
	elseif command == 'kite' then
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
	elseif command == 'emnity' then
		if EmnityMode == false then
			add_to_chat(122, "Emnity Mode on")
			EmnityMode = true
		elseif EmnityMode == true then
			add_to_chat(122, "Emnity Mode off")
			EmnityMode = false
		end
	elseif command == "mode" then
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
		print_mode()
	elseif command == "rune" then
		send_command('input /ja "' .. Rune .. '" <me>')
	elseif command == "sjAction" then
		if SJAction == nil then
			add_to_chat(122, "No SubjobAction for " .. player.sub_job)
		else
			send_command('input ' .. SJAction)
		end
	elseif command == "resistCharm" then
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
	elseif command == "engravedbelt" then
		if EngravedBelt == false then
			EngravedBelt = true
			add_to_chat(122, "Engraved Belt on")
		else
			EngravedBelt = false
			add_to_chat(122, "Resist Charm off")
		end
	elseif string.sub(command, 1, 5) == 'setWS' then
		WS = string.sub(command, 7)
		print_current_ws()
	elseif string.sub(command, 1, 6) == 'resist' then
		resist = string.sub(command, 8)
		if resist == "light" then Rune = "Tenebrae"
		elseif resist == "dark" then Rune = "Lux"
		elseif resist == "fire" then Rune = "Unda"
		elseif resist == "water" then Rune = "Sulpor"
		elseif resist == "thunder" then Rune = "Tellus"
		elseif resist == "ice" then Rune = "Ignis"
		elseif resist == "wind" then Rune = "Gelus"
		elseif resist == "earth" then Rune = "Flabra"
		end
		print_current_rune()
	elseif string.sub(command, 1, 4) == 'rune' then
		resist = string.sub(command, 6)
		if resist == "light" then Rune = "Lux"
		elseif resist == "dark" then Rune = "Tenebrae" 
		elseif resist == "fire" then Rune = "Ignis"
		elseif resist == "water" then Rune = "Unda"
		elseif resist == "thunder" then Rune = "Sulpor"
		elseif resist == "ice" then Rune = "Gelus"
		elseif resist == "wind" then Rune = "Flabra"
		elseif resist == "earth" then Rune = "Tellus"
		end
		print_current_rune()
	elseif string.sub(command, 1, 4) == 'mode' then
		nextMode = tonumber(string.sub(command, 6))
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
					print_mode()
				end
			end
		end
	elseif string.sub(command, 1, 8) == 'gearinfo' then
		local gInfo = string.sub(command, 10)
		local index = string.find(gInfo, ' ')
		local dwParam = string.sub(gInfo, 1, index)
		if type(tonumber(dwParam)) == 'number' then
			local dwgi = tonumber(dwParam)
			if DW_Needed ~= dwgi then
				DW_Needed = dwgi
				if player.status == "Engaged" then
					equip(get_set())
				end
			end
		end
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