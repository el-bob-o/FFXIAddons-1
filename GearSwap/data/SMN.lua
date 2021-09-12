include("Mastergear/MasterGearFunctions.lua")
include('THHelper/THHelper.lua')
texts = require('texts')

BPs = {
	["Carbuncle"] = 
		{
			["Rage1"] = { name = "Poison Nails",		target = "stnpc", 		set = "PhyBPDmg", 	description = "Pierce + poison" },
			["Rage2"] = { name = "Holy Mist",			target = "stnpc", 		set = "MagicBPDmg",	description = "Light Atk" },
			["Ward1"] = { name = "Healing Ruby II", 	target = "stpt", 							description = "Healing" },
			["Ward2"] = { name = "Soothing Ruby", 		target = "stpt", 							description = "Erase" },
			["Ward3"] = { name = "Pacifying Ruby", 		target = "stpt",							description = "-Emnity" },
		},
	["Ifrit"] = 
		{
			["Rage1"] = { name = "Flaming Crush",		target = "stnpc",	 	set = "MagicBPDmg",	description = "Blunt + Fire" },
			["Rage2"] = { name = "Conflag Strike",		target = "stnpc", 		set = "MagicBPDmg", description = "Fire + Burn" },
			["Ward1"] = { name = "Crimson Howl", 		target = "stpt", 		description = "+10% Atk" },
			["Ward2"] = { name = "Inferno Howl", 		target = "stpt", 		description = "Enfire" },
		},
	["Shiva"] = 
		{
			["Rage1"] = { name = "Rush",				target = "stnpc",	 	set = "PhyBPDmg",	description = "Blunt" },
			["Rage2"] = { name = "Heavenly Strike",		target = "stnpc", 		set = "MagicBPDmg", description = "Ice Nuke" },
			["Ward1"] = { name = "Frost Armor", 		target = "stpt", 		description = "Ice Spikes" },
			["Ward2"] = { name = "Sleepga", 			target = "stnpc", 		description = "Sleepga" },
			["Ward3"] = { name = "Diamond Storm", 		target = "stnpc", 		description = "-Evasion" },
			["Ward4"] = { name = "Crystal Blessing", 	target = "stpt", 		description = "TP Bonus" },
		},
	["Garuda"] = 
		{
			["Rage1"] = { name = "Predator Claws",		target = "stnpc",	 	set = "PhyBPDmg", 	description = "Slash" },
			["Rage2"] = { name = "Aero IV",				target = "stnpc", 		set = "MagicBPDmg", description = "Wind Nuke" },
			["Ward1"] = { name = "Aerial Armor", 		target = "stpt", 		description = "Blink" },
			["Ward2"] = { name = "Whispering Wind", 	target = "stpt", 		description = "Heal" },
			["Ward3"] = { name = "Fleet Wind", 			target = "stpt", 		description = "Movement" },
			["Ward4"] = { name = "Hastega II", 			target = "stpt", 		description = "Haste2" },
		},
	["Titan"] = 
		{
			["Rage1"] = { name = "Mountain Buster",		target = "stnpc",	 	set = "PhyBPDmg",	description = "Blunt" },
			["Rage2"] = { name = "Stone IV",			target = "stnpc", 		set = "MagicBPDmg",	description = "Earth Nuke" },
			["Ward1"] = { name = "Earthen Ward", 		target = "stpt", 		description = "Stoneskin" },
			["Ward2"] = { name = "Earthen Armor", 		target = "stpt", 		description = "Heavy Dmg Reduction" },
		},
	["Ramuh"] = 
		{
			["Rage1"] = { name = "Chaotic Strike",		target = "stnpc",	 	set = "PhyBPDmg",	description = "Blunt" },
			["Rage2"] = { name = "Volt Strike",			target = "stnpc",	 	set = "PhyBPDmg",	description = "Blunt" },
			["Rage3"] = { name = "Thunderstorm",		target = "stnpc", 		set = "MagicBPDmg",	description = "Thunder Nuke" },
			["Rage4"] = { name = "Thunderspark",		target = "stnpc", 		set = "MagicBPDmg",	description = "AOE Thunder Paralyze" },
			["Ward1"] = { name = "Rolling Thunder", 	target = "stpt", 		description = "Enthunder" },
			["Ward2"] = { name = "Lightning Armor", 	target = "stpt", 		description = "Shock Spikes" },
			["Ward3"] = { name = "Shock Squall", 		target = "stnpc", 		description = "Stun" },
		},
	["Leviathan"] = 
		{
			["Rage1"] = { name = "Spinning Dive",		target = "stnpc",	 	set = "PhyBPDmg",	description = "Slash" },
			["Rage2"] = { name = "Water IV",			target = "stnpc", 		set = "MagicBPDmg", description = "Water Nuke" },
			["Ward1"] = { name = "Slowga", 				target = "stnpc", 		description = "Slow" },
			["Ward2"] = { name = "Spring Water", 		target = "stpt", 		description = "Heal & Erase" },
			["Ward3"] = { name = "Tidal Roar", 			target = "stnpc", 		description = "-Atk" },
			["Ward4"] = { name = "Soothing Current", 	target = "stpt", 		description = "+Heal" },
		},
	["Cait Sith"] = 
		{
			["Rage1"] = { name = "Regal Gash",			target = "stnpc",	 	set = "PhyBPDmg",	description = "Slash" },
			["Rage2"] = { name = "Level ? Holy",		target = "stnpc", 		set = "MagicBPDmg",	description = "Light Nuke" },
			["Ward1"] = { name = "Raise II", 			target = "stpt", 		description = "Raise" },
			["Ward2"] = { name = "Mewing Lullaby", 		target = "stnpc", 		description = "-TP & Sleep" },
			["Ward3"] = { name = "Reraise II", 			target = "stpt", 		description = "Reraise" },
			["Ward4"] = { name = "Eerie Eye", 			target = "stnpc", 		description = "Silence & Amnesia" },
		},
	["Fenrir"] = 
		{
			["Rage1"] = { name = "Eclipse Bite",		target = "stnpc",	 	set = "PhyBPDmg", 	description = "Slash" },
			["Rage2"] = { name = "Lunar Bay",			target = "stnpc", 		set = "MagicBPDmg", description = "Dark Nuke" },
			["Rage3"] = { name = "Impact",				target = "stnpc", 		set = "MagicBPDmg", description = "Dark & -Attr" },
			["Ward1"] = { name = "Lunar Cry", 			target = "stnpc", 		description = "-Evasion" },
			["Ward2"] = { name = "Lunar Roar", 			target = "stnpc", 		description = "Dispel x2" },
			["Ward3"] = { name = "Ecliptic Growl", 		target = "stpt", 		description = "+Attr" },
			["Ward4"] = { name = "Ecliptic Howl", 		target = "stpt", 		description = "+Acc / +Eva" },
			["Ward5"] = { name = "Heavenward Howl", 	target = "stpt", 		description = "Endrain / Enaspir" },
		},
	["Diabolos"] = 
		{
			["Rage1"] = { name = "Blindside",			target = "stnpc",	 	set = "PhyBPDmg", 	description = "Slash" },
			["Rage2"] = { name = "Nether Blast",		target = "stnpc", 		set = "MagicBPDmg",	description = "Dark Ranged Atk" },
			["Rage3"] = { name = "Night Terror",		target = "stnpc", 		set = "MagicBPDmg",	description = "Dark Nuke" },
			["Ward1"] = { name = "Somnolence", 			target = "stnpc", 		set = "MagicBPDmg",	description = "Gravity & Magic Dmg" },
			["Ward2"] = { name = "Nightmare", 			target = "stnpc", 		description = "AOE Sleep & Dark Dmg" },
			["Ward3"] = { name = "Ultimate Terror", 	target = "stnpc", 		description = "AOE -Attr" },
			["Ward4"] = { name = "Noctoshield", 		target = "stpt", 		description = "Phalanx" },
			["Ward5"] = { name = "Dream Shroud", 		target = "stpt", 		description = "+MAB & +MDB" },
			["Ward6"] = { name = "Pavor Nocturnus", 	target = "stnpc", 		description = "Death / Dispel" },
		},
	["Siren"] = 
		{
			["Rage1"] = { name = "Hysteric Assault",	target = "stnpc",	 	set = "PhyBPDmg",	description = "Pierce" },
			["Rage2"] = { name = "Tornado II",			target = "stnpc", 		set = "MagicBPDmg", description = "Wind Nuke" },
			["Rage3"] = { name = "Sonic Buffet",		target = "stnpc", 		set = "MagicBPDmg", description = "Wind Nuke & Dispel" },
			["Ward1"] = { name = "Lunatic Voice", 		target = "stnpc", 		description = "AOE Silence" },
			["Ward2"] = { name = "Katabatic Blades", 	target = "stpt", 		description = "Enaero" },
			["Ward3"] = { name = "Chinook", 			target = "stpt", 		description = "Aquaveil" },
			["Ward4"] = { name = "Bitter Elegy", 		target = "stnpc", 		description = "-Atk Speed" },
			["Ward5"] = { name = "Wind's Blessing", 	target = "stpt", 		description = "Magic Shield" },
		},
}

MeritBPs = T{ "Meteor Strike", "Heavenly Strike", "Wind Blade", "Geocrush", "Thunderstorm", "Grand Fall" }

BloodPactsInfo = [[${petName|none}
${info|}
]]

function setup_text_window()
	local default_settings = {}
	default_settings.pos = {}
	default_settings.pos.x = 1400
	default_settings.pos.y = 700
	default_settings.bg = {}
	default_settings.bg.alpha = 255
	default_settings.bg.red = 0
	default_settings.bg.green = 0
	default_settings.bg.blue = 0
	default_settings.bg.visible = true
	default_settings.flags = {}
	default_settings.flags.right = false
	default_settings.flags.bottom = false
	default_settings.flags.bold = false
	default_settings.flags.draggable = true
	default_settings.flags.italic = false
	default_settings.padding = 0
	default_settings.text = {}
	default_settings.text.size = 12
	default_settings.text.font = 'Arial'
	default_settings.text.fonts = {}
	default_settings.text.alpha = 255
	default_settings.text.red = 255
	default_settings.text.green = 255
	default_settings.text.blue = 255
	default_settings.text.stroke = {}
	default_settings.text.stroke.width = 0
	default_settings.text.stroke.alpha = 255
	default_settings.text.stroke.red = 0
	default_settings.text.stroke.green = 0
	default_settings.text.stroke.blue = 0
	
	if not (BloodPactTextHub == nil) then
        texts.destroy(BloodPactTextHub)
    end
    BloodPactTextHub = texts.new(BloodPactsInfo, default_settings, default_settings)

    BloodPactTextHub:show()
end

function get_sets()
	CPMode = false
	DT = false
	Movement = false
	Engaged = false
	Combat = false
	StartedBPWard = false
	StartedBPRage = false
	RageSetToUse = ""
	BuffBot = false
	WardRecastId = 0
	Buffs = {}
	TimerFromPrecast = 1.25
	
	get_set_for_job_from_json("SMN", sets)
	
	print_th_mode()
	
	setup_text_window()
	if pet.isvalid then update_blood_pact_info(pet.name) end
	
	send_command('@input /macro book 4;wait 1;input /macro set 1')
end

function get_set_to_use(spell_name)
	if BPs[pet.name] then
		for _, v in pairs(BPs[pet.name]) do 
			if v.name == spell_name and v.setToUse then
				return v.setToUse
			end
		end
	end
	return "MagicBPDmg"
end

function precast(spell)
	if spell.type == "JobAbility" then
		if sets[spell.english] then
			equip(sets[spell.english])
		end
	elseif spell.english == "Alexander" then
		StartedBPWard = true
		coroutine.schedule(check_pet_midcast, TimerFromPrecast)
	elseif spell.english == "Odin" then
		StartedBPRage = true
		RageSetToUse = "PhyBPDmg",
		coroutine.schedule(check_pet_midcast, TimerFromPrecast)
	elseif spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
	elseif spell.type=="BloodPactWard" then
		if buffactive["Astral Conduit"] then
			if spell.name == "Somnolence" then
				equip(sets[get_set_to_use(spell.name)])
			else
				equip(sets["SmnSkill"])
			end
		else
			equip(sets["PrecastBP"])
			if spell.name == "Somnolence" then
				RageSetToUse = get_set_to_use(spell.name)
				StartedBPRage = true
			else
				StartedBPWard = true
			end
			coroutine.schedule(check_pet_midcast, TimerFromPrecast)
        end
	elseif spell.type=="BloodPactRage" then
        if buffactive["Astral Conduit"] then
			local setToUse = sets[get_set_to_use(spell.name)]
			if MeritBPs:contains(spell.name) then setToUse = set_combine(setToUse, sets["MeritBPBurst"]) end
			equip(setToUse)
		else
			equip(sets["PrecastBP"])
			StartedBPRage = true
			if MeritBPs:contains(spell.name) then 
				RageSetToUse = "MeritBPBurst"
			else 
				RageSetToUse = get_set_to_use(spell.name)
			end
			coroutine.schedule(check_pet_midcast, TimerFromPrecast)
        end
	end
end
 
function midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Enfeebling Magic" then
			equip(sets["MACC"]) 
		elseif sets[spell.english] then
			equip(sets[spell.english])
		end
	end
end
 
function aftercast(spell)
	if StartedBPRage == false and StartedBPWard == false then -- don't equip idle set if still going to do a BP
		equip_idle_set()
	end
	if spell.type =="BloodPactWard" and BuffBot then
		WardRecastId = spell.recast_id
	end
end

function check_pet_midcast()
	if StartedBPRage then
		local setToUse = sets[RageSetToUse]
		equip(setToUse)
	elseif StartedBPWard then
		equip(sets["SmnSkill"])	
	end
end

function pet_midcast(spell)
	check_pet_midcast()
end

function pet_aftercast(spell)
	StartedBPRage = false
	StartedBPWard = false
	equip_idle_set()
end

function equip_idle_set()
	local setToUse = sets["Idle"]
	if DT then setToUse = set_combine(setToUse, sets["IdleDT"]) end
	if not Combat and (not Engaged or Movement) then setToUse = set_combine(setToUse, sets["Movement"]) end
	equip(setToUse)
end

function pet_change(pet,gain)
	if gain then
		if not BPs[pet.name] then
			add_to_chat(122, "Pls set up BPs for " .. pet.name)
		end
		update_blood_pact_info(pet.name)
	else
		update_blood_pact_info("none")
	end
end

function update_blood_pact_info(petName)
	BloodPactTextHub.petName = petName
	if BPs[petName] then
		local infoString = ""
		if BPs[petName]["Rage1"] then 
			infoString = infoString .. "[CTRL+1] Rage1" .. ": " .. BPs[petName]["Rage1"].name .. "(" .. BPs[petName]["Rage1"].description .. ")\n"
		end
		if BPs[petName]["Rage2"] then 
			infoString = infoString .. "[CTRL+2] Rage2" .. ": " .. BPs[petName]["Rage2"].name .. "(" .. BPs[petName]["Rage2"].description .. ")\n"
		end
		if BPs[petName]["Rage3"] then 
			infoString = infoString .. "[CTRL+3] Rage3" .. ": " .. BPs[petName]["Rage3"].name .. "(" .. BPs[petName]["Rage3"].description .. ")\n"
		end
		if BPs[petName]["Rage4"] then 
			infoString = infoString .. "[CTRL+4] Rage4" .. ": " .. BPs[petName]["Rage4"].name .. "(" .. BPs[petName]["Rage4"].description .. ")\n"
		end
		if BPs[petName]["Ward1"] then 
			infoString = infoString .. "[CTRL+5] Ward1" .. ": " .. BPs[petName]["Ward1"].name .. "(" .. BPs[petName]["Ward1"].description .. ")\n"
		end
		if BPs[petName]["Ward2"] then 
			infoString = infoString .. "[CTRL+6] Ward2" .. ": " .. BPs[petName]["Ward2"].name .. "(" .. BPs[petName]["Ward2"].description .. ")\n"
		end
		if BPs[petName]["Ward3"] then 
			infoString = infoString .. "[CTRL+7] Ward3" .. ": " .. BPs[petName]["Ward3"].name .. "(" .. BPs[petName]["Ward3"].description .. ")\n"
		end
		if BPs[petName]["Ward4"] then 
			infoString = infoString .. "[CTRL+8] Ward4" .. ": " .. BPs[petName]["Ward4"].name .. "(" .. BPs[petName]["Ward4"].description .. ")\n"
		end
		if BPs[petName]["Ward5"] then 
			infoString = infoString .. "[CTRL+9] Ward5" .. ": " .. BPs[petName]["Ward5"].name .. "(" .. BPs[petName]["Ward5"].description .. ")\n"
		end
		if BPs[petName]["Ward6"] then 
			infoString = infoString .. "[CTRL+0] Ward6" .. ": " .. BPs[petName]["Ward6"].name .. "(" .. BPs[petName]["Ward6"].description .. ")\n"
		end
		
		BloodPactTextHub.info = infoString:sub(1, #infoString - 1)
	else
		BloodPactTextHub.info = ""
	end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		equip(set_combine(sets["Idle"], sets["Adoulin"]))
	else
		equip(set_combine(sets["Idle"], sets["Movement"]))
	end
	if pet.isvalid then update_blood_pact_info(pet.name)
	else update_blood_pact_info("none")
	end
end)

function file_unload(file_name)
	if BloodPactTextHub ~= nil then texts.destroy(BloodPactTextHub) end
end

function status_change(new,old)
	if T{'Idle','Resting'}:contains(new) then
		Engaged = false
    elseif new == 'Engaged' then
        Engaged = true
    end
	equip_idle_set()
end
 
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
	elseif args[1] == 'bp' and args[2] then
		if pet.isvalid then
			if BPs[pet.name] then
				if BPs[pet.name][args[2]] then
					send_command('input /pet "' .. BPs[pet.name][args[2]].name .. '" <' .. BPs[pet.name][args[2]].target .. '>')
				else
					add_to_chat(122, args[2] .. " doesn't exist in BP table")
				end
			else
				add_to_chat(122, "Please set up BPs for " .. pet.name)
			end
		end
	elseif args[1] == "dt" then
		if DT == true then
			add_to_chat(122, "DT off!")
			DT = false
		else
			add_to_chat(122, "DT on!")		
			DT = true
			equip_idle_set()
		end
	elseif args[1] == "movement" then
		if Movement == true then
			add_to_chat(122, "Movement off!")
			Movement = false
		else
			add_to_chat(122, "Movement on!")
			Movement = true
			equip_idle_set()
		end
	elseif args[1] == "combat" then
		if Combat == true then
			add_to_chat(122, "Combat off!")
			Combat = false
			equip_idle_set()
		else
			add_to_chat(122, "Combat on!")
			Combat = true
			equip_idle_set()
		end
	elseif args[1] == "buffbot" then
		if BuffBot == true then
			add_to_chat(122, "BuffBot off!")
			BuffBot = false
		else
			add_to_chat(122, "BuffBot on!")
			BuffBot = true
		end
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip_idle_set()
		end
	end
end

-- should probably change to windower.ffxi.get_player().buffs and check buffIds

function buff_change(name,gain,buff_table)
	Buffs[name] = gain
	--add_to_chat(122, name)
end

BuffsBotCheck = T
{
	{ BuffName = "TP Bonus", PetName = "Shiva", BloodPactName = "Crystal Blessing", Check = true },
	{ BuffName = "STR Boost", PetName = "Fenrir", BloodPactName = "Ecliptic Growl", Check = true },
	{ BuffName = "Evasion Boost", PetName = "Fenrir", BloodPactName = "Ecliptic Howl", Check = true },
	{ BuffName = "Haste", 	PetName = "Garuda", BloodPactName = "Hastega II", Check = true },
	{ BuffName = "Enaero", PetName = "Siren", BloodPactName = "Katabatic Blades", Check = false },
	{ BuffName = "Warcry", PetName = "Ifrit", BloodPactName = "Crimson Howl", Check = true },
}

FavorBot = 
{ 	
	{ BuffName = "Ifrit's Favor", PetName ="Ifrit", BloodPactName = nil, Check = true },
}

function summon_pet_or_do_bloodpact(pet_name, bp_name)
	if pet.isvalid then
		if pet.name ~= pet_name then
			send_command('input /ja Release <me>')
		elseif bp_name then
			send_command('input /pet "' .. bp_name .. '" <me>')
		end
	else
		send_command('input /ma ' .. pet_name .. ' <me>')
	end
end

function check_buff(buff_name, pet_name, bloodpact_name)
	if not Buffs[buff_name] then
		summon_pet_or_do_bloodpact(pet_name, bloodpact_name)
		return false
	end
	return true
end

windower.register_event('time change', function(old, new)
	if BuffBot == true and party.count == 6 then
		if player.mpp < 25 and player.sub_job == "RDM" then 
			send_command('input /ja "Convert" <me>')
			return
		end
		if WardRecastId == 0 or windower.ffxi.get_ability_recasts()[WardRecastId] == 0 then
			if pet.isvalid and not Buffs["Avatar's Favor"] then
				send_command('input /ja "Avatar\'s Favor" <me>')
			end
			for k,v in pairs(BuffsBotCheck) do
				if v.Check then
					if not check_buff(v.BuffName, v.PetName, v.BloodPactName) then return end
				end
			end
			for k,v in pairs(FavorBot) do
				if v.Check then
					if not check_buff(v.BuffName, v.PetName, v.BloodPactName) then return end
				end
			end
		end
	end
end)