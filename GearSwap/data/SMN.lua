include("Mastergear/MasterGearLua.lua")
texts = require('texts')

bps = {
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
			["Ward3"] = { name = "Fleet Wind", 			target = "stpt", 		description = "movement" },
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

merit_bps = T{ "Meteor Strike", "Heavenly Strike", "Wind Blade", "Geocrush", "Thunderstorm", "Grand Fall" }

blood_pacts_info = [[${petName|none}
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
	
	if not (blood_pacts_text_hub == nil) then
        texts.destroy(blood_pacts_text_hub)
    end
    blood_pacts_text_hub = texts.new(blood_pacts_info, default_settings, default_settings)

    blood_pacts_text_hub:show()
end

function custom_get_sets()
	movement = false
	engaged = false
	started_bp_ward = false
	started_bp_rage = false
	rage_set_to_use = ""
	timer_from_precast = 1.25
	
	setup_text_window()
	if pet.isvalid then update_blood_pact_info(pet.name) end
	
	send_command('@input /macro book 4;wait 1;input /macro set 1')
end

function get_set_to_use(spell_name)
	if bps[pet.name] then
		for _, v in pairs(bps[pet.name]) do 
			if v.name == spell_name and v.setToUse then
				return v.setToUse
			end
		end
	end
	return "MagicBPDmg"
end

function custom_precast(spell)
	if spell.english == "Alexander" then
		started_bp_ward = true
		coroutine.schedule(check_pet_midcast, timer_from_precast)
		return true
	elseif spell.english == "Odin" then
		started_bp_rage = true
		rage_set_to_use = "PhyBPDmg",
		coroutine.schedule(check_pet_midcast, timer_from_precast)
		return true
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
				rage_set_to_use = get_set_to_use(spell.name)
				started_bp_rage = true
			else
				started_bp_ward = true
			end
			coroutine.schedule(check_pet_midcast, timer_from_precast)
        end
		return true
	elseif spell.type=="BloodPactRage" then
        if buffactive["Astral Conduit"] then
			local setToUse = sets[get_set_to_use(spell.name)]
			if merit_bps:contains(spell.name) then setToUse = set_combine(setToUse, sets["MeritBPBurst"]) end
			equip(setToUse)
		else
			equip(sets["PrecastBP"])
			started_bp_rage = true
			if merit_bps:contains(spell.name) then 
				rage_set_to_use = "MeritBPBurst"
			else 
				rage_set_to_use = get_set_to_use(spell.name)
			end
			coroutine.schedule(check_pet_midcast, timer_from_precast)
        end
		return true
	end
end
 
function custom_midcast(spell)
	if spell.action_type == 'Magic' and spell.skill == "Enfeebling Magic" then
		equip(sets["MACC"]) 
		return true
	end
end
 
function custom_aftercast(spell)
	if started_bp_rage == false and started_bp_ward == false then -- don't equip idle set if still going to do a BP
		equip_idle_set()
		return true
	end
end

function check_pet_midcast()
	if started_bp_rage then
		local setToUse = sets[rage_set_to_use]
		equip(setToUse)
	elseif started_bp_ward then
		equip(sets["SmnSkill"])	
	end
end

function pet_midcast(spell)
	check_pet_midcast()
end

function pet_aftercast(spell)
	started_bp_rage = false
	started_bp_ward = false
	equip_idle_set()
end

function equip_idle_set()
	local setToUse = modes[mode].set
	if not combat and (not engaged or movement) then setToUse = set_combine(setToUse, sets["movement"]) end
	equip(setToUse)
end

function pet_change(pet,gain)
	if gain then
		if not bps[pet.name] then
			add_to_chat(122, "Pls set up bps for " .. pet.name)
		end
		update_blood_pact_info(pet.name)
	else
		update_blood_pact_info("none")
	end
end

function update_blood_pact_info(petName)
	blood_pacts_text_hub.petName = petName
	if bps[petName] then
		local infoString = ""
		if bps[petName]["Rage1"] then 
			infoString = infoString .. "[CTRL+1] Rage1" .. ": " .. bps[petName]["Rage1"].name .. "(" .. bps[petName]["Rage1"].description .. ")\n"
		end
		if bps[petName]["Rage2"] then 
			infoString = infoString .. "[CTRL+2] Rage2" .. ": " .. bps[petName]["Rage2"].name .. "(" .. bps[petName]["Rage2"].description .. ")\n"
		end
		if bps[petName]["Rage3"] then 
			infoString = infoString .. "[CTRL+3] Rage3" .. ": " .. bps[petName]["Rage3"].name .. "(" .. bps[petName]["Rage3"].description .. ")\n"
		end
		if bps[petName]["Rage4"] then 
			infoString = infoString .. "[CTRL+4] Rage4" .. ": " .. bps[petName]["Rage4"].name .. "(" .. bps[petName]["Rage4"].description .. ")\n"
		end
		if bps[petName]["Ward1"] then 
			infoString = infoString .. "[CTRL+5] Ward1" .. ": " .. bps[petName]["Ward1"].name .. "(" .. bps[petName]["Ward1"].description .. ")\n"
		end
		if bps[petName]["Ward2"] then 
			infoString = infoString .. "[CTRL+6] Ward2" .. ": " .. bps[petName]["Ward2"].name .. "(" .. bps[petName]["Ward2"].description .. ")\n"
		end
		if bps[petName]["Ward3"] then 
			infoString = infoString .. "[CTRL+7] Ward3" .. ": " .. bps[petName]["Ward3"].name .. "(" .. bps[petName]["Ward3"].description .. ")\n"
		end
		if bps[petName]["Ward4"] then 
			infoString = infoString .. "[CTRL+8] Ward4" .. ": " .. bps[petName]["Ward4"].name .. "(" .. bps[petName]["Ward4"].description .. ")\n"
		end
		if bps[petName]["Ward5"] then 
			infoString = infoString .. "[CTRL+9] Ward5" .. ": " .. bps[petName]["Ward5"].name .. "(" .. bps[petName]["Ward5"].description .. ")\n"
		end
		if bps[petName]["Ward6"] then 
			infoString = infoString .. "[CTRL+0] Ward6" .. ": " .. bps[petName]["Ward6"].name .. "(" .. bps[petName]["Ward6"].description .. ")\n"
		end
		
		blood_pacts_text_hub.info = infoString:sub(1, #infoString - 1)
	else
		blood_pacts_text_hub.info = ""
	end
end
 
function custom_zone_change()
	if pet.isvalid then update_blood_pact_info(pet.name)
	else update_blood_pact_info("none")
	end
end

function file_unload(file_name)
	if blood_pacts_text_hub ~= nil then texts.destroy(blood_pacts_text_hub) end
end

function custom_status_change(new,old)
	if T{'Idle','Resting'}:contains(new) then
		engaged = false
    elseif new == 'engaged' then
        engaged = true
    end
	equip_idle_set()
	return true
end
 
function custom_command(args)
	if args[1] == 'bp' and args[2] then
		if pet.isvalid then
			if bps[pet.name] then
				if bps[pet.name][args[2]] then
					send_command('input /pet "' .. bps[pet.name][args[2]].name .. '" <' .. bps[pet.name][args[2]].target .. '>')
				else
					add_to_chat(122, args[2] .. " doesn't exist in BP table")
				end
			else
				add_to_chat(122, "Please set up bps for " .. pet.name)
			end
		end
	elseif args[1] == "movement" then
		if movement == true then
			add_to_chat(122, "movement off!")
			movement = false
		else
			add_to_chat(122, "movement on!")
			movement = true
			equip_idle_set()
		end
	elseif args[1] == "thtagged" then
		if player.status == "engaged" then
			equip_idle_set()
		end
	end
end
