include('MasterGearList.lua')
texts = require('texts')

BPs = {
	["Carbuncle"] = 
		{
			["Rage1"] = { name = "Poison Nails",		target = "stnpc", 		description = "Phy Atk + poison" },
			["Rage2"] = { name = "Holy Mist",			target = "stnpc", 		description = "Light Atk" },
			["Ward1"] = { name = "Healing Ruby II", 	target = "stpt", 		description = "Healing" },
			["Ward2"] = { name = "Soothing Ruby", 		target = "stpt", 		description = "Erase" },
			["Ward3"] = { name = "Pacifying Ruby", 		target = "stpt",		description = "-Emnity" },
		},
	["Ifrit"] = 
		{
			["Rage1"] = { name = "Flaming Crush",		target = "stnpc",	 	description = "Hybrid Atk" },
			["Rage2"] = { name = "Conflag Strike",		target = "stnpc", 		description = "Fire + Burn" },
			["Ward1"] = { name = "Crimson Howl", 		target = "stpt", 		description = "+10% Atk" },
			["Ward2"] = { name = "Inferno Howl", 		target = "stpt", 		description = "Enfire" },
		},
	["Shiva"] = 
		{
			["Rage1"] = { name = "Rush",				target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Heavenly Strike",		target = "stnpc", 		description = "Ice Nuke" },
			["Ward1"] = { name = "Frost Armor", 		target = "stpt", 		description = "Ice Spikes" },
			["Ward2"] = { name = "Sleepga", 			target = "stnpc", 		description = "Sleepga" },
			["Ward3"] = { name = "Diamond Storm", 		target = "stnpc", 		description = "-Evasion" },
			["Ward4"] = { name = "Crystal Blessing", 	target = "stpt", 		description = "TP Bonus" },
		},
	["Garuda"] = 
		{
			["Rage1"] = { name = "Predator Claws",		target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Aero IV",				target = "stnpc", 		description = "Wind Nuke" },
			["Ward1"] = { name = "Aerial Armor", 		target = "stpt", 		description = "Blink" },
			["Ward2"] = { name = "Whispering Wind", 	target = "stpt", 		description = "Heal" },
			["Ward3"] = { name = "Fleet Wind", 			target = "stpt", 		description = "Movement" },
			["Ward4"] = { name = "Hastega II", 			target = "stpt", 		description = "Haste2" },
		},
	["Titan"] = 
		{
			["Rage1"] = { name = "Mountain Buster",		target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Stone IV",			target = "stnpc", 		description = "Earth Nuke" },
			["Ward1"] = { name = "Earthen Ward", 		target = "stpt", 		description = "Stoneskin" },
			["Ward2"] = { name = "Earthen Armor", 		target = "stpt", 		description = "Heavy Dmg Reduction" },
		},
	["Ramuh"] = 
		{
			["Rage1"] = { name = "Volt Strike",			target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Thunderstorm",		target = "stnpc", 		description = "Thunder Nuke" },
			["Rage3"] = { name = "Thunderspark",		target = "stnpc", 		description = "AOE Thunder Paralyze" },
			["Ward1"] = { name = "Rolling Thunder", 	target = "stpt", 		description = "Enthunder" },
			["Ward2"] = { name = "Lightning Armor", 	target = "stpt", 		description = "Shock Spikes" },
			["Ward3"] = { name = "Shock Squall", 		target = "stnpc", 		description = "Stun" },
		},
	["Leviathan"] = 
		{
			["Rage1"] = { name = "Spinning Dive",		target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Water IV",			target = "stnpc", 		description = "Water Nuke" },
			["Ward1"] = { name = "Slowga", 				target = "stnpc", 		description = "Slow" },
			["Ward2"] = { name = "Spring Water", 		target = "stpt", 		description = "Heal & Erase" },
			["Ward3"] = { name = "Tidal Roar", 			target = "stnpc", 		description = "-Atk" },
			["Ward4"] = { name = "Soothing Current", 	target = "stpt", 		description = "+Heal" },
		},
	["Cait Sith"] = 
		{
			["Rage1"] = { name = "Regal Gash",			target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Level ? Holy",		target = "stnpc", 		description = "Light Nuke" },
			["Ward1"] = { name = "Raise II", 			target = "stpt", 		description = "Raise" },
			["Ward2"] = { name = "Mewing Lullaby", 		target = "stnpc", 		description = "-TP & Sleep" },
			["Ward3"] = { name = "Reraise II", 			target = "stpt", 		description = "Reraise" },
			["Ward4"] = { name = "Eerie Eye", 			target = "stnpc", 		description = "Silence & Amnesia" },
		},
	["Fenrir"] = 
		{
			["Rage1"] = { name = "Eclipse Bite",		target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Lunar Bay",			target = "stnpc", 		description = "Dark Nuke" },
			["Rage3"] = { name = "Impact",				target = "stnpc", 		description = "Dark & -Attr" },
			["Ward1"] = { name = "Lunar Cry", 			target = "stnpc", 		description = "-Evasion" },
			["Ward2"] = { name = "Lunar Roar", 			target = "stnpc", 		description = "Dispel x2" },
			["Ward3"] = { name = "Ecliptic Growl", 		target = "stpt", 		description = "+Attr" },
			["Ward4"] = { name = "Ecliptic Howl", 		target = "stpt", 		description = "+Acc / +Eva" },
			["Ward5"] = { name = "Heavenward Howl", 	target = "stpt", 		description = "Endrain / Enaspir" },
		},
	["Diabolos"] = 
		{
			["Rage1"] = { name = "Blindside",			target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Nether Blast",		target = "stnpc", 		description = "Dark Ranged Atk" },
			["Rage3"] = { name = "Night Terror",		target = "stnpc", 		description = "Dark Nuke" },
			["Ward1"] = { name = "Somnolence", 			target = "stnpc", 		description = "Gravity & Magic Dmg" },
			["Ward2"] = { name = "Nightmare", 			target = "stnpc", 		description = "AOE Sleep & Dark Dmg" },
			["Ward3"] = { name = "Ultimate Terror", 	target = "stnpc", 		description = "AOE -Attr" },
			["Ward4"] = { name = "Noctoshield", 		target = "stpt", 		description = "Phalanx" },
			["Ward5"] = { name = "Dream Shroud", 		target = "stpt", 		description = "+MAB & +MDB" },
			["Ward6"] = { name = "Pavor Nocturnus", 	target = "stnpc", 		description = "Death / Dispel" },
		},
	["Siren"] = 
		{
			["Rage1"] = { name = "Hysteric Assault",	target = "stnpc",	 	description = "Phy Atk" },
			["Rage2"] = { name = "Tornado II",			target = "stnpc", 		description = "Wind Nuke" },
			["Rage3"] = { name = "Sonic Buffet",		target = "stnpc", 		description = "Wind Nuke & Dispel" },
			["Ward1"] = { name = "Lunatic Voice", 		target = "stnpc", 		description = "AOE Silence" },
			["Ward2"] = { name = "Katabatic Blades", 	target = "stpt", 		description = "Enaero" },
			["Ward3"] = { name = "Chinook", 			target = "stpt", 		description = "Aquaveil" },
			["Ward4"] = { name = "Bitter Elegy", 		target = "stnpc", 		description = "-Atk Speed" },
			["Ward5"] = { name = "Wind's Blessing", 	target = "stpt", 		description = "Magic Shield" },
		},
}

BloodPactsInfo = [[${petName|none}
${info|}
]]

function setup_text_window()
	local default_settings = {}
	default_settings.pos = {}
	default_settings.pos.x = 1500
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
	StartedBPWard = false
	StartedBPRage = false
	TimerFromPrecast = 1.25
	
	sets = get_set_for_job("SMN")
	
	setup_text_window()
	if pet.isvalid then update_blood_pact_info(pet.name) end
	
	send_command('@input /macro book 4;wait 1;input /macro set 1')
end

function precast(spell)
	if spell.type == "JobAbility" then
		if sets[spell.english] then
			equip(sets[spell.english])
		end
	elseif spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
	elseif spell.type=="BloodPactWard" then
		if buffactive["Astral Conduit"] then
			if spell.name == "Somnolence" then
				equip(sets["BPDmg"])
			else
				equip(sets["SmnSkill"])
			end
		else
			equip(sets["PrecastBP"])
			if spell.name == "Somnolence" then
				StartedBPRage = true
			else
				StartedBPWard = true
			end
			coroutine.schedule(check_pet_midcast, TimerFromPrecast)
        end
	elseif spell.type=="BloodPactRage" then
        if buffactive["Astral Conduit"] then
			equip(sets["BPDmg"])
		else
			equip(sets["PrecastBP"])
			StartedBPRage = true
			coroutine.schedule(check_pet_midcast, TimerFromPrecast)
        end
	end
end
 
function midcast(spell)
	if sets[spell.english] then
		equip(sets[spell.english])
	end
end
 
function aftercast(spell)
	if StartedBPRage == false and StartedBPWard == false then -- don't equip idle set if still going to do a BP
		equip(sets["Idle"])
	end
end

function check_pet_midcast()
	if StartedBPRage then
		equip(sets["BPDmg"])		
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
	if not Engaged or Movement then setToUse = set_combine(setToUse, sets["Movement"]) end
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
		if Combat == true then
			add_to_chat(122, "DT off!")
			DT = false
		else
			add_to_chat(122, "DT on!")		
			DT = true
			equip_idle_set()
		end
	elseif args[1] == "movement" then
		if Combat == true then
			add_to_chat(122, "Movement off!")
			Movement = false
		else
			add_to_chat(122, "Movement on!")
			Movement = true
			equip_idle_set()
		end
	else
		master_gear_list_command(args)
	end
end