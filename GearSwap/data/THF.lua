include('THHelper.lua')

function get_sets()
	CPMode = false
	Throwing = false
	WS = "Rudra's Storm"
	THMode = 1
	Mode = 1
	DW_Needed = 0
	Buffs = {}
		
	sets.TH = {
		ammo="Per. Lucky Egg", 
		hands="Plun. Armlets +1",
		waist="Chaac Belt", 
		feet="Skulk. Poulaines +1"
	}
	
	sets.Throwing = { ranged="Wingcutter +1" }
 
	sets.Hybrid = {
		ammo="Aurgelmir Orb",
		head="Malignance Chapeau",neck="Erudit. Necklace",ear1="Cessance Earring",ear2="Brutal Earring", 
		body="Malignance Tabard",hands="Herculean Gloves",ring1="Vocane Ring +1",ring2="Gelatinous Ring +1",
		back="Toutatis's Cape",waist="Sailfi Belt +1",legs="Meg. Chausses +2",feet="Malignance Boots"}
	sets.Lilith = set_combine(sets.Hybrid, {ring1="Vocane Ring +1", back="Repulse Mantle"})
	
	Modes = { 
		{ name = "Hybrid", set = sets.Hybrid },
		{ name = "Lilith", set = sets.Lilith }
	}
	
	sets.DW0 = {}
	sets.DW6 = { sub = "Shijo" } -- 5
	sets.DW11 = set_combine(sets.DW6, {ear2="Suppanomimi"} )
	sets.DW20 = set_combine(sets.DW6, { 
		ear1="Eabani Earring", ear2="Suppanomimi",
		body="Samnuha Coat",
	}) -- 5 + 4 + 5 + 5 = 19
	sets.DW26 = set_combine(sets.DW20, { 
		hands="Pill. Armlets +2",
	}) -- 19 + 3 = 22
	
	sets.FastCast = {
		head="Herculean Helm", neck="Voltsurge Torque", ear1="Loquac. Earring", ear2="Etiolation Earring", 
		body="Samnuha Coat", hands="Leyline Gloves", legs="Rawhide Trousers"}
	
	sets.JA = {}
	sets.JA["Perfect Dodge"] = {hands="Plun. Armlets +1"}
	sets.JA["Hide"] = {body="Pillager's Vest +2"}
	
	sets.SneakAttack = {back="Toutatis's cape"}
	sets.TrickAttack = {}
	sets.SATA = set_combine(sets.SneakAttack, sets.TrickAttack)
		
	sets.WS_Any = {
		ammo="Aurgelmir Orb",
		head="Pill. Bonnet +2", neck="Lissome Necklace", ear1="Cessance Earring", ear2="Brutal Earring", 
		body="Herculean Vest", hands="Meg. Gloves +2", 
		back="Toutatis's Cape",	waist="Sailfi Belt +1", legs="Pill. Culottes +2", feet="Herculean Boots"}
	sets.WS_DEX = set_combine(sets.WS_Any, {		
		ear2="Odr Earring",
		ring1="Rajas Ring",ring2="Ramuh Ring", 
		waist="Chiner's Belt +1"})
	sets.WS_Magical = {
		ammo="Seeth. Bomblet +1",
		head="Herculean Helm", neck="Satlada Necklace", ear1="Cessance Earring", ear2="Friomisi Earring",
		body="Samnuha Coat", hands="Leyline Gloves", 
		back="Toro Cape", feet="Herculean Boots"
		}
	sets.WS_Crit = {
		ammo="Yetshila",
		head="Pill. Bonnet +2", neck="Fotia Gorget", ear1="Cessance Earring", ear2="Odr Earring",
		body="Pillager's Vest +2", hands="Mummu Wrists +2", ring1="Mummu ring", ring2="Ramuh Ring",
		back="Toutatis's Cape", waist="Fotia Belt", legs="Pill. Culottes +2", feet="Mummu Gamash. +1"
		}
	sets.WS_Str = set_combine(sets.WS_Any, {
		ammo="Seeth. Bomblet +1",
		head="Herculean Helm", 
		body="Herculean Vest", hands="Herculean Gloves", ring1="Rajas Ring", ring2="Rufescent Ring",
		legs="Meg. Chausses +2", feet="Herculean Boots"
	})
 
	sets.WS = {}
	sets.WS["Rudra's Storm"] = sets.WS_DEX
	sets.WS["Evisceration"] = sets.WS_Crit
	sets.WS["Mandalic Stab"] = sets.WS_DEX
	sets.WS["Aeolian Edge"] = sets.WS_Magical
	sets.WS["Cyclone"] = sets.WS_Magical
	sets.WS["Gust Slash"] = sets.WS_Magical
	sets.WS["Savage Blade"] = sets.WS_Str
 
	sets.Movement = {feet="Jute Boots +1"}
	sets.Idle = set_combine(set_combine(sets.Hybrid, sets.Movement), {
		neck="Lissome Necklace", 
		ring2="Chirich Ring"
	})
	
	sets.ElementalMagic = set_combine(sets.WS_Magical, { 
		ear1="Hecate's Earring", 
		ring1="Locus Ring", ring2="Resonance Ring"
		})
 
	sets.Reive = {neck="Ygnas's Resolve +1"}
	sets.CP = {back="Mecisto. Mantle"}	
	print_current_ws()
	print_mode()
	print_th_mode()
	print_throwing()
	send_command('@input /macro book 2')
	subjob_macro_page(player.sub_job)
end
 
function precast(spell)
    if sets.JA[spell.english] then
        equip(sets.JA[spell.english])
	elseif spell.action_type == 'Magic' then
		equip(sets.FastCast)
    elseif spell.type=="WeaponSkill" then
		local setToUse = {}
        if sets.WS[spell.english] then
			setToUse = sets.WS[spell.english]
		else
			setToUse = sets.WS["Any"]
		end
		setToUse = SATA_check(setToUse)
		if player.tp < 3000 then
			setToUse = set_combine(setToUse, {ear1="Moonshade Earring"})
		end
		equip(setToUse)
    end
end

function midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets.ElementalMagic)
		end
	end
end
 
function aftercast(spell)
    if player.status=='Engaged' then
        equip(set_combine(Modes[Mode].set, getDWSet()))
    else
        equip(sets.Idle)
    end
end
 
function status_change(new,old)
	if new == 'Engaged' then
		equip(set_combine(Modes[Mode].set, getDWSet()))
		on_status_change_for_th(new, old)
	elseif T{'Idle','Resting'}:contains(new) then
		on_status_change_for_th(new, old)
		equip(sets.Idle)
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
		equip(set_combine(sets.Idle, {body="Councilor's Garb"}))
	else
		equip(sets.Idle)
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
	if args[1] == "th" then
		parse_th_command(args)
	elseif args[1] == "cp" then
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
					print_mode()
				end
			end
		else
			Mode = Mode + 1
			if Modes[Mode] == nil then
				Mode = 1
			end
			print_mode()
		end
	elseif args[1] == "ws" then
		send_command('input /ws "' .. WS .. '" <t>')
	elseif args[1] == "throwing" then
		if Throwing == false then
			Throwing = true
			equip(sets.Throwing)
			disable("ammo")
			AmmoDisabled = true
		else
			Throwing = false
			enable("ammo")
			AmmoDisabled = false
		end
		print_throwing()
	elseif args[1] == "setWS" and args[2] then
		WS = args[2]
		print_current_ws()
	elseif args[1] == "dw" and args[2] then
		if type(tonumber(args[2])) == 'number' then
			local dwNo = tonumber(args[2])
			DwNeeded = dwNo
		end
	end
end

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. WS)
end

function SATA_check(set)
	SA = Buffs["Sneak Attack"]
	TA = Buffs["Trick Attack"]
	if SA or TA then
		if SA and TA then
			set = set_combine(set, sets.SATA)
		elseif SA then
			set = set_combine(set, sets.SA)
		elseif TA then
			set = set_combine(set, sets.TA)
		end
	end
	return set
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

function print_throwing()
	if Throwing == true then 
		add_to_chat(122, "Boomerang: On")
	else
		add_to_chat(122, "Boomerang: Off")
	end
end

function subjob_macro_page(job)
	if job == "DNC" then
		send_command('@wait 1;input /macro set 1')
	elseif job == "NIN" then
		send_command('@wait 1;input /macro set 2')
	elseif job == "RUN" then
		send_command('@wait 1;input /macro set 3')
	end
end

function getDWSet()
	if DW_Needed >= 26 then
		return sets.DW26
	elseif DW_Needed >= 20 then
		return sets.DW20
	elseif DW_Needed >= 11 then
		return sets.DW11
	elseif  DW_Needed >= 6 then
		return sets.DW6
	else
		return sets.DW0
	end
end