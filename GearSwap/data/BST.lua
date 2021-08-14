include('THHelper.lua')
include('HasteTracker.lua')
include("MasterGearFunctions.lua")

ready = {
	["Slug"] = {
		["Ready1"] = { name = "Purulent Ooze", target = "me", set = "PetTP", cost = 2 },
		["Ready2"] = { name = "Corrosive Ooze", target = "me", set = "PetTP", cost = 3 },
	},
	["Raaz"] = {
		["Ready1"] = { name = "Sweeping Gouge", target = "t", set = "PetTP", cost = 1 },
		["Ready2"] = { name = "Zealous Snort", target = "me", set = "PetTP", cost = 3 },
	},
}

pets = {
	["GenerousArthur"] = "Slug",
	["CaringKiyomaro"] = "Raaz",
	["VivaciousVickie"] = "Raaz",
}

pet_info = [[${pet_name|none}
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
	
	if pet_text_hub ~= nil then
        texts.destroy(pet_text_hub)
    end
    pet_text_hub = texts.new(pet_info, default_settings, default_settings)

    pet_text_hub:show()
end

function get_sets()
	CPMode = false
	Mode = 1
	cancel_haste = 1
	
	get_set_for_job_from_json("BST", sets)
	sub_job_change(player.sub_job)
	
	Modes = { 
		{ name = "Hybrid", set = sets["HybridSet"] }
	}
 
	sets.Idle = set_combine(sets["Hybrid"], sets["IdleRegen"], sets["Movement"])
	sets["Beastial Loyalty"] = sets["Call Beast"]
	
	sets["Decimation"].tp_bonus = false
	sets["Ruinator"] = sets["Decimation"]
	sets["Calamity"] = sets["Decimation"]
	sets["Calamity"].tp_bonus = true
	sets["Primal Rend"].tp_bonus = true
	sets["Cloudsplitter"] = sets["Primal Rend"]
	
	print_mode()
	print_th_mode()
	setup_text_window()
	if pet.isvalid then update_pet_info(pet.name) end
	send_command('@input /macro book 10')
end

function pet_change(pet,gain)
	if gain then
		if not pets[pet.name] then
			add_to_chat(122, "Pls set up info for " .. pet.name)
		end
		update_pet_info(pet.name)
	else
		update_pet_info("none")
	end
end

function update_pet_info(name)
	pet_text_hub.pet_name = name
	if pets[name] then
		local infoString = ""
		if ready[pets[name]]["Ready1"] then 
			infoString = infoString .. "[CTRL+1] Ready1" .. ": " .. ready[pets[name]]["Ready1"].name .. "(" .. ready[pets[name]]["Ready1"].cost .. ")\n"
		end
		if ready[pets[name]]["Ready2"] then 
			infoString = infoString .. "[CTRL+2] Ready2" .. ": " .. ready[pets[name]]["Ready2"].name .. "(" .. ready[pets[name]]["Ready2"].cost .. ")\n"
		end
		
		pet_text_hub.info = infoString:sub(1, #infoString - 1)
	else
		pet_text_hub.info = ""
	end

end

function sub_job_change(new, old)
	if new == "NIN" or new == "DNC" then
		sets["HybridSet"] = set_combine(sets["Hybrid"], sets["DW"])
	else
		sets["HybridSet"] = sets["Hybrid"]
	end
end
 
function precast(spell)
	if spell.type == "Monster" and not spell.interrupted then
        if not buffactive['Unleash'] then
            equip(sets["Ready"])
        end
    elseif spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
    elseif spell.type=="WeaponSkill" then
        if sets[spell.english] then
			local setToUse = {}
			setToUse = sets[spell.english]
			if sets[spell.english].tp_bonus then
				local maxTP = 3000
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			equip(setToUse)
		end
	elseif sets[spell.english] then
        equip(sets[spell.english])
    end
end

function midcast(spell)
end
 
function aftercast(spell)
    if player.status=='Engaged' then
        equip(Modes[Mode].set)
    else
        equip(sets.Idle)
    end
end
 
function status_change(new,old)
	if new == 'Engaged' then
		equip(Modes[Mode].set)
		on_status_change_for_th(new, old)
	elseif T{'Idle','Resting'}:contains(new) then
		on_status_change_for_th(new, old)
		equip(sets.Idle)
    end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		equip(set_combine(sets.Idle, sets["Adoulin"]))
	else
		equip(sets.Idle)
	end
	if pet.isvalid then update_pet_info(pet.name)
	else update_pet_info("none")
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
			equip(sets["CP"])
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
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(Modes[Mode].set)
		end
	elseif args[1] == "ready" and args[2] then
		if pet.isvalid then
			if ready[pets[pet.name]] then
				if ready[pets[pet.name]][args[2]] then
					send_command('input /pet "' .. ready[pets[pet.name]][args[2]].name .. '" <' .. ready[pets[pet.name]][args[2]].target .. '>')
				else
					add_to_chat(122, args[2] .. " doesn't exist in ready table")
				end
			else
				add_to_chat(122, "Please set up info for " .. pet.name)
			end
		end
	end
end

function file_unload(file_name)
	if pet_text_hub ~= nil then texts.destroy(pet_text_hub) end
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