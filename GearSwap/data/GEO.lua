include('MasterGearList.lua')

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
	
	sets = get_set_for_job("GEO")
		
	Modes = { 
		{ name = "CombatIdleDT", set = sets["CombatIdleDT"]},
	}
 
	sets["Shining Strike"] = sets["Elemental"]
	sets["Seraph Strike"] = sets["Elemental"]
	sets["Flash Nova"] = sets["Elemental"]
	
	send_command('@input /macro book 3;wait 1;input /macro set 1')
	print_mode()
	print_current_nuke()
	print_current_geos()
	print_buff_mode()
end
 
function precast(spell)
	if sets[spell.english] then
        equip(sets[spell.english])
	elseif spell.action_type == 'Magic' then
		if spell.skill == "Healing Magic" then
			equip(sets["HealingFastcast"])
		elseif spell.skill == "Elemental Magic" then
			equip(sets["ElementalFastcast"])
		else
			equip(sets["Fastcast"])
		end
	elseif spell.type=="WeaponSkill" then
        if sets[spell.english] then 
			equip(sets[spell.english])
		end
    end
end

function midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Geomancy" then
			equip(sets["Geomancy"])
		elseif spell.skill == "Healing Magic" and spell.name:match("Cure") then
			equip(sets["Healing"])
		elseif spell.skill == "Elemental Magic" then
			if spell.element == world.weather_element or spell.element == world.day_element then 
				equip(set_combine(sets["Elemental"], sets["WeatherObi"]))
			else
				equip(sets["Elemental"])
			end
		elseif spell.skill == "Dark Magic" then
			if spell.name:match("Drain") or spell.name:match("Aspir") then
				equip(set_combine(sets["Elemental"], sets["Drain"]))
			elseif spell.name:match("Stun") then
				equip(sets["MACC"])
			end
		elseif spell.skill == "Enfeebling Magic" then
			equip(sets["MACC"])
		end
	end
end
 
function aftercast(spell)
	if Combat then
		equip(Modes[Mode].set)
	else
		equip(sets["IdleRefresh"])
	end
end

function status_change(new,old)
    if T{'Idle','Resting'}:contains(new) then
		equip(sets["IdleRefresh"])
    elseif new == 'Engaged' then
        equip(Modes[Mode].set)
    end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		if Combat == true then
			equip(set_combine(Modes[Mode].set, sets["Adoulin"]))
		else
			equip(set_combine(sets["IdleRefresh"], sets["Adoulin"]))
		end
	else
		if Combat == true then
			equip(Modes[Mode].set)
		else
			equip(sets["IdleRefresh"])
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
			add_to_chat(122, "CP Mode On!")
			enable("back")
			equip(sets["CP"])
			disable("back")
			CPMode = true
		elseif CPMode == true then
			add_to_chat(122, "CP Mode Off!")
			enable("back")
			CPMode = false
		end
	elseif args[1] == "mode" then
		Mode = Mode + 1
		if Modes[Mode] == nil then
			Mode = 1
		end
		equip(Modes[Mode].set)
		print_mode()
	elseif args[1] == "buffMode" then
		if args[2] then
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
		else
			BuffMode = BuffMode + 1
			if BuffModes[BuffMode] == nil then
				BuffMode = 1
			end
			set_buffs()
			print_buff_mode()
			print_current_geos()
		end
	elseif args[1] == "melee" then
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
	elseif args[1] == "combat" then
		if Combat == true then
			add_to_chat(122, "Combat off!")
			Combat = false
		else
			add_to_chat(122, "Combat on!")
			equip(Modes[Mode].set)
			Combat = true
		end
	elseif args[1] == "nuke" then
		send_command('input /ma "' .. Nuke .. '" <t>')
	elseif args[1] == "indi" then
		send_command('input /ma "' .. Indi .. '" <me>')
	elseif args[1] == "geo" then
		send_command('input /ma "' .. Geo .. '" <t>')
	elseif args[1] == "entrust" then
		send_command('input /ma "' .. Entrust .. '" <t>')
	elseif args[1] == "startFCBot" then
		add_to_chat(122, "FCBot on!")
		FullCircleBot = true
	elseif args[1] == "stopFCBot" then
		add_to_chat(122, "FCBot off!")
		FullCircleBot = false
	elseif args[1] == 'tellParty' then
		party_current_geos()
	elseif args[1] == 'setNuke' and args[2] then
		Nuke = args[2]
		print_current_nuke()
	elseif args[1] == 'setIndi' then
		Indi = args[2]
		print_current_geos()
	elseif args[1] == 'setGeo' then
		Geo = args[2]
		print_current_geos()
	elseif args[1] == 'setEntrust' then
		Entrust = args[2]
		print_current_geos()
	else
		master_gear_list_command(args)
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