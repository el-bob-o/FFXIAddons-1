include('MasterGearList.lua')
texts = require('texts')

BPs = {
	["Carbuncle"] = 
		{
			["Rage1"] = { name = "Poison Nails",		target = "stnpc", 		description = "Phy Atk + poison" },
			["Rage2"] = { name = "Meteorite",			target = "stnpc",  		description = "Light Atk" },
			["Rage3"] = { name = "Holy Mist",			target = "stnpc", 		description = "Light Atk" },
			["Ward1"] = { name = "Healing Ruby II", 	target = "stpt", 		description = "Healing" },
			["Ward2"] = { name = "Soothing Ruby", 		target = "stpt", 		description = "Erase" },
			["Ward3"] = { name = "Pacifying Ruby", 		target = "stpt",		description = "-Emnity" },
		},
	["Ifrit"] = 
		{
			["Rage1"] = { name = "Flaming Crush",		target = "stnpc",	 	description = "Hybrid Atk" },
			["Rage2"] = { name = "Fire IV",				target = "stnpc", 		description = "Fire Nuke" },
			["Rage2"] = { name = "Meteor Strike",		target = "stnpc", 		description = "Fire Nuke" },
			["Ward1"] = { name = "Crimson Howl", 		target = "stpt", 		description = "+10% Atk" },
			["Ward2"] = { name = "Inferno Howl", 		target = "stpt", 		description = "Enfire" },			
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
	StartedBPWard = false
	StartedBPRage = false
	TimerFromPrecast = 1.0
	
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
			equip(sets["SmnSkill"])          
		else
			equip(sets["PrecastBP"])
			StartedBPWard = true
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
		StartedBPRage = false
	elseif StartedBPWard then
		equip(sets["SmnSkill"])
		StartedBPWard = false
	end
end

function pet_midcast(spell)
	check_pet_midcast()
end

function pet_aftercast(spell)
	equip(sets["Idle"])
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
			infoString = infoString .. "Rage1" .. ": " .. BPs[petName]["Rage1"].name .. "(" .. BPs[petName]["Rage1"].description .. ")\n"
		end
		if BPs[petName]["Rage2"] then 
			infoString = infoString .. "Rage2" .. ": " .. BPs[petName]["Rage2"].name .. "(" .. BPs[petName]["Rage2"].description .. ")\n"
		end
		if BPs[petName]["Rage3"] then 
			infoString = infoString .. "Rage3" .. ": " .. BPs[petName]["Rage3"].name .. "(" .. BPs[petName]["Rage3"].description .. ")\n"
		end
		if BPs[petName]["Ward1"] then 
			infoString = infoString .. "Ward1" .. ": " .. BPs[petName]["Ward1"].name .. "(" .. BPs[petName]["Ward1"].description .. ")\n"
		end
		if BPs[petName]["Ward2"] then 
			infoString = infoString .. "Ward2" .. ": " .. BPs[petName]["Ward2"].name .. "(" .. BPs[petName]["Ward2"].description .. ")\n"
		end
		if BPs[petName]["Ward3"] then 
			infoString = infoString .. "Ward3" .. ": " .. BPs[petName]["Ward3"].name .. "(" .. BPs[petName]["Ward3"].description .. ")\n"
		end
		BloodPactTextHub.info = infoString
	else
		BloodPactTextHub.info = ""
	end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		equip(set_combine(sets["Idle"], sets["Adoulin"]))
	else
		equip(sets["Idle"])
	end
end)

function file_unload(file_name)
	if BloodPactTextHub ~= nil then texts.destroy(BloodPactTextHub) end
end

function status_change(new,old)
	equip(sets["Idle"])
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
	else
		master_gear_list_command(args)
	end
end