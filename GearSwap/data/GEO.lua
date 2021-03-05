function get_sets()
	KiteMode = false
	CPMode = false
	Combat = false
	Mode = 1
	Nuke = "Stone"
	Indi = "Indi-Fury"
	Geo = "Geo-Frailty"
	Entrust = "Indi-Haste"
	FullCircleBot = false
	BuffMode = 1
	BuffModes = {
		{ name = "Melee", Indi = "Indi-Fury", Geo = "Geo-Frailty" },
		{ name = "Magic", Indi = "Indi-Acumen", Geo = "Geo-Malaise" }
	}
	
	sets.CombatIdleDT = {
		main="Solstice", sub="Culminus", range="Dunna",
		head="Azimuth Hood +1",neck="Twilight Torque",ear1="Handler's Earring +1",ear2="Odnowa Earring +1", 
		body="Vrikodara Jupon",hands="Geo. Mitaines +2",ring1="Vocane Ring +1",ring2="Dark Ring",
		back="Lifestream Cape",waist="Isa Belt",legs="Psycloth Lappas",feet="Azimuth Gaiters +1"
	}
	
	sets.IdleRefresh =	{
		main="Daybreak",
		neck="Lissome Necklace", 
		body="Vrikodara Jupon", ring2="Chirich Ring",
		legs="Assid. Pants +1", feet="Geo. Sandals +2"
	}
	
	Modes = { 
		{ name = "CombatIdleDT", set = sets.CombatIdleDT},
	}
	
	-- Chanter's shield from Cirdas Cavern for 3%, Upgrade Geo Pants for +4%.
	sets.Fastcast = set_combine(sets.IdleDT, {
		main="Solstice",
		head="Vanya Hood", neck="Voltsurge Torque", ear1="Loquac. Earring", ear2="Malignance Earring", 
		body="Vrikodara Jupon",
		back="Lifestream Cape", waist="Witful Belt", legs="Geomancy Pants +2", feet="Regal Pumps +1"
	})
	sets.HealingFastcast = set_combine(sets.Fastcast, {
		main="Vadose Rod",
		ear1="Mendi. Earring",
	})
	sets.ElementalFastcast = set_combine(sets.Fastcast, {
		hands="Bagua Mitaines +1",
	})
	
	sets.ConserveMP = {
		main="Solstice",
		head="Vanya Hood", neck="Incanter's Torque", ear2="Mendi. Earring",
		back="Solemnity Cape",
	}
	
	sets.Geomancy = set_combine(sets.ConserveMP, {
		main="Solstice", ranged="Dunna",
		head="Azimuth Hood +1", neck="Incanter's Torque",
		body="Bagua Tunic +1", hands="Geo. Mitaines +2",
		back="Lifestream Cape", legs="Bagua Pants +2", feet="Azimuth Gaiters +1",
	})
	sets.Healing = set_combine(sets.ConserveMP, {
		main="Daybreak",
		head="Vanya Hood", neck="Incanter's Torque",ear2="Mendi. Earring",
		body="Vrikodara Jupon",
		back="Solemnity Cape", feet="Regal Pumps +1", 
	})
	sets.Elemental = set_combine(sets.ConserveMP, {
		main="Daybreak", sub="Culminus",
		head="Jhakri Coronal +1", neck="Eddy Necklace", ear1="Malignance Earring", ear2="Barkaro. Earring",
		body="Jhakri Robe +1", hands="Jhakri Cuffs +1", ring1="Resonance Ring", ring2="Vertigo Ring",
		back="Nantosuelta's Cape", waist="Sacro Cord", legs="Bagua Pants +2", feet="Jhakri Pigaches +1"
	})
	sets.MACC = set_combine(sets.ConserveMP, {
		main="Daybreak", ranged="Dunna",
		head="Jhakri Coronal +1", neck="Voltsurge Torque", ear1="Malignance Earring", ear2="Barkaro. Earring",
		body="Jhakri Robe +1", hands="Jhakri Cuffs +1",
		back="Nantosuelta's Cape", waist="Sacro Cord", legs="Bagua Pants +2",  feet="Jhakri Pigaches +1"
	})
	
	sets.Obi = { waist = "Hachirin-no-Obi" }
	
	sets.Drain = { head="Bagua Galero +1" }
	
	sets.JA = {}
	sets.JA["Bolster"] = { body="Bagua Tunic +1" }
	sets.JA["Life Cycle"] = { body="Geomancy Tunic +2", back="Nantosuelta's Cape" }
	sets.JA["Full Circle"] = { head="Azimuth Hood +1" }
	sets.JA["Curative Recantation"] = { hands="Bagua Mitaines +1" }	
	sets.JA["Radial Arcana"] = { feet="Bagua Sandals +1" }
 
	sets.Reive = {neck="Ygnas's Resolve +1"}
	sets.TH = {ammo="Per. Lucky Egg", waist="Chaac Belt"}
	sets.CP = {back="Mecisto. Mantle"}
	
	sets.WS = {}
	sets.WS.Any = { ear1 = "Moonshade Earring" }
	sets.WS.Mnd = set_combine(sets.WS.Any, {
		ear2="Malignance Earring",
		ring1="Vertigo Ring", ring2="Rufescent Ring",
		waist="Sacro Cord",
	})
	
	send_command('@input /macro book 3;wait 1;input /macro set 1')
	print_mode()
	print_current_nuke()
	print_current_geos()
	print_buff_mode()
end
 
function precast(spell)
	if sets.JA[spell.english] then
        equip(sets.JA[spell.english])
	elseif spell.action_type == 'Magic' then
		if spell.skill == "Healing Magic" then
			equip(sets.HealingFastcast)
		elseif spell.skill == "Elemental Magic" then
			equip(sets.ElementalFastcast)
		else
			equip(sets.Fastcast)
		end
	elseif spell.type=="WeaponSkill" then
        if sets.WS[spell.english] then 
			equip(sets.WS[spell.english])
		else 
			equip(sets.WS.Any)
		end
    end
end

function midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Geomancy" then
			equip(sets.Geomancy)
		elseif spell.skill == "Healing Magic" and spell.name:match("Cure") then
			equip(sets.Healing)
		elseif spell.skill == "Elemental Magic" then
			if spell.element == world.weather_element or spell.element == world.day_element then 
				equip(set_combine(sets.Elemental, sets.Obi))
			else
				equip(sets.Elemental)
			end
		elseif spell.skill == "Dark Magic" then
			if spell.name:match("Drain") or spell.name:match("Aspir") then
				equip(set_combine(sets.Elemental, sets.Drain))
			elseif spell.name:match("Stun") then
				equip(sets.MACC)
			end
		end
	end
end
 
function aftercast(spell)
	if Combat then
		equip(Modes[Mode].set)
	else
		equip(sets.IdleRefresh)
	end
end

function status_change(new,old)
    if T{'Idle','Resting'}:contains(new) then
		equip(sets.IdleRefresh)
    elseif new == 'Engaged' then
        equip(Modes[Mode].set)
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
	end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		if Combat == true then
			equip(set_combine(Modes[Mode].set, {body="Councilor's Garb"}))
		else
			equip(set_combine(sets.IdleRefresh, {body="Councilor's Garb"}))
		end
	else
		if Combat == true then
			equip(Modes[Mode].set)
		else
			equip(sets.IdleRefresh)
		end
	end
end)
 
function self_command(command)
	if command == 'cp' then
		if CPMode == false then
			add_to_chat(122, "CP Mode On!")
			enable("back")
			equip(sets.CP)
			disable("back")
			CPMode = true
		elseif CPMode == true then
			add_to_chat(122, "CP Mode Off!")
			enable("back")
			CPMode = false
		end
	elseif command == "mode" then
		Mode = Mode + 1
		if Modes[Mode] == nil then
			Mode = 1
		end
		equip(Modes[Mode].set)
		print_mode()
	elseif command == "buffMode" then
		BuffMode = BuffMode + 1
		if BuffModes[BuffMode] == nil then
			BuffMode = 1
		end
		set_buffs()
		print_buff_mode()
		print_current_geos()
	elseif command == "melee" then
		if Melee == true then
			Melee = false
			enable("main")
			enable("sub")
			enable("range")
			add_to_chat(122, "Melee off!")
		else
			Melee = true
			disable("main")
			disable("sub")
			disable("range")
			add_to_chat(122, "Melee on!")
		end
	elseif command == "combat" then
		if Combat == true then
			add_to_chat(122, "Combat off!")
			Combat = false
		else
			add_to_chat(122, "Combat on!")
			equip(Modes[Mode].set)
			Combat = true
		end
	elseif command == "nuke" then
		send_command('input /ma "' .. Nuke .. '" <t>')
	elseif command == "indi" then
		send_command('input /ma "' .. Indi .. '" <me>')
	elseif command == "geo" then
		send_command('input /ma "' .. Geo .. '" <t>')
	elseif command == "entrust" then
		send_command('input /ma "' .. Entrust .. '" <t>')
	elseif string.sub(command, 1, 8) == 'buffMode' then
		local nextMode = tonumber(string.sub(command, 10))
		if nextMode == nil then
			add_to_chat(122, "Invalid BuffMode number")
		else
			if BuffModes[nextMode] == nil then
				add_to_chat(122, "Invalid BuffMode number")
			else
				BuffMode = nextMode
				set_buffs()
				print_current_geos()
			end
		end
	elseif command == "startFCBot" then
		add_to_chat(122, "FCBot on!")
		FullCircleBot = true
	elseif command == "stopFCBot" then
		add_to_chat(122, "FCBot off!")
		FullCircleBot = false
	elseif command == 'tellParty' then
		party_current_geos()
	elseif string.sub(command, 1, 7) == 'setNuke' then
		Nuke = string.sub(command, 9)
		print_current_nuke()
	elseif string.sub(command, 1, 7) == 'setIndi' then
		Indi = string.sub(command, 9)
		print_current_geos()
	elseif string.sub(command, 1, 6) == 'setGeo' then
		Geo = string.sub(command, 8)
		print_current_geos()
	elseif string.sub(command, 1, 10) == 'setEntrust' then
		Entrust = string.sub(command, 12)
		print_current_geos()
	end
end

function print_mode()
	printString = "Current Mode: "
	for i = 1, 10, 1 do
		if i == Mode then
			printString = printString .. "[" .. i .. ":" .. Modes[i].name .. "] "
		elseif Modes[i] == nil then
			break
		else
			printString = printString .. i .. ":" .. Modes[i].name .. " "
		end
	end	
	add_to_chat(122, printString)
end

function set_buffs()
	Indi = BuffModes[BuffMode].Indi
	Geo = BuffModes[BuffMode].Geo
end

function print_buff_mode()
	printString = "Current Buff Mode: "
	for i = 1, 10, 1 do
		if i == BuffMode then
			printString = printString .. "[" .. i .. ":" .. BuffModes[i].name .. "] "
		elseif BuffModes[i] == nil then
			break
		else
			printString = printString .. i .. ":" .. BuffModes[i].name .. " "
		end
	end	
	add_to_chat(122, printString)
end

function print_current_nuke()
	add_to_chat(122, "Current Nuke: " .. Nuke)
end

function print_current_geos()
	add_to_chat(122, "Indi: " .. Indi .. " Geo: " .. Geo .. " Entrust: " .. Entrust)
end

function party_current_geos()
	send_command('input /p ' .. "Indi: " .. Indi .. " Geo: " .. Geo .. " Entrust: " .. Entrust)
end

windower.register_event('time change', function(old, new)
	if FullCircleBot == true then
		local luopan = nil
		if windower.ffxi.get_mob_by_target('pet') then
			luopan = windower.ffxi.get_mob_by_target('pet')
		end
		if luopan and luopan.distance:sqrt() > 5 then
			send_command('input /ja "Full Circle" <me>')
		end
	end
end)