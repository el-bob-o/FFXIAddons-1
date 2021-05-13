include("MasterGearList.lua")
texts = require('texts')

ranger_info = [[${ammo_name}:${ammo_count}
Flurry: ${flurry|0}
Hover Shot: ${distance|Off|%.2f}
True Strike: ${distance_correction}
Last Attack: ${dmg}
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
	
	if not (ranger_info_hub == nil) then
        texts.destroy(ranger_info_hub)
    end
    ranger_info_hub = texts.new(ranger_info, default_settings, default_settings)

    ranger_info_hub:show()
end


function get_sets()
	CPMode = false
	Mode = 1
	Flurry = 0
	Buffs = {}
	last_shot_position = nil
	
	get_set_for_job("RNG", sets)
		
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] }
	}
		
	sets.Idle = set_combine(sets["Hybrid"], sets["IdleRegen"], sets["Movement"])
	
	sets["Flurry1"] = set_combine(sets["Flurry2"], sets["Flurry1"])
	sets["Flurry0"] = set_combine(sets["Flurry1"], sets["Flurry0"])
	
	sets["Trueflight"] = sets["MagicAtk"]
	sets["Wildfire"] = sets["MagicAtk"]
	sets["Savage Blade"] = sets["STR_Melee_WS"]	
	sets["Last Stand"] = sets["AGI_Ranged_WS"]
	
	setup_text_window()
	update_rng_info()
	
	print_mode()
	send_command('@input /macro book 7')
end
 
function precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
	elseif spell.action_type == "Ranged Attack" then
		equip(get_preshot_set())
    elseif spell.type=="WeaponSkill" then
		local setToUse = {}
        if sets[spell.english] then
			setToUse = sets[spell.english]
		end
		if player.tp < 3000 then
			setToUse = set_combine(setToUse, sets["TPBonus"])
		end
		equip(setToUse)
	elseif sets[spell.english] then
        equip(sets[spell.english])
    end
end

function midcast(spell)
	if spell.action_type == "Ranged Attack" then
		local setToUse = sets["Midshot"]
		if Buffs["Double Shot"] then setToUse = set_combine(setToUse, sets["Double Shot"]) end
		equip(setToUse)
	end
end
 
function aftercast(spell)
	if spell.action_type == "Ranged Attack" 
	or (spell.type == "WeaponSkill" and (spell.skill == "Marksmanship" or spell.skill == "Archery")) then
		local player = windower.ffxi.get_mob_by_target('me')
		if player then 
			last_shot_position = player
		end
	end
    if player.status=='Engaged' then
        equip(Modes[Mode].set)
    else
        equip(sets.Idle)
    end
	update_rng_info()
end
 
function status_change(new,old)
	if new == 'Engaged' then
		equip(Modes[Mode].set)
	elseif T{'Idle','Resting'}:contains(new) then
		equip(sets.Idle)
    end
end
 
function buff_change(name,gain,buff_table)
	if name == "Flurry" and not gain then 
		Flurry = 0
	else
		Buffs[name] = gain
	end
	update_rng_info()
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		equip(set_combine(sets.Idle, sets["Adoulin"]))
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
	if args[1] == "cp" then
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

function get_preshot_set()
	if Flurry == 0 then return sets["Flurry0"]
	elseif Flurry == 1 then return sets["Flurry1"]
	else return sets["Flurry2"]
	end
end

function update_rng_info()
	ranger_info_hub.ammo_name = player.equipment.ammo
	local items = windower.ffxi.get_items()
	if items.equipment.ammo then
		local ammo_item = windower.ffxi.get_items(items.equipment.ammo_bag, items.equipment.ammo)
		ranger_info_hub.ammo_count = ammo_item.count
	else
		ranger_info_hub.ammo_count = 0
	end
	ranger_info_hub.flurry = Flurry
end

function rng_action_helper(act)
	if act.category == 4 then -- finish casting spell
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				if act.param == 845 then -- flurry I
					Flurry = 1
					update_rng_info()
				elseif act.param == 846 then -- flurry II
					Flurry = 2
					update_rng_info()
				end
			end
		end
	elseif act.category == 2 then -- ranged attack
		for k,v in pairs(act.targets) do
			for k2, v2 in pairs(v.actions) do
				ranger_info_hub.dmg = v2.param
				if v2.message == 352 then 
					ranger_info_hub.distance_correction = "..."
				elseif v2.message == 576 then
					ranger_info_hub.distance_correction = "Squarely."
				elseif v2.message == 577 then
					ranger_info_hub.distance_correction = "True!"
				end
			end
		end
	elseif act.category == 3 then -- ws
		for k,v in pairs(act.targets) do
			for k2, v2 in pairs(v.actions) do
				ranger_info_hub.dmg = v2.param
			end
		end
	end
end

function update_hover_shot_info()
	if Buffs["Hover Shot"] then
		ranger_info_hub.distance = 0
		local player = windower.ffxi.get_mob_by_target('me')
		if player and last_shot_position ~= nil then
			local x = math.abs(last_shot_position.x - player.x)
			local y = math.abs(last_shot_position.y - player.y)
			local z = math.abs(last_shot_position.z - player.z)
			x = (x*x)
			y = (y*y)
			z = (z*z)
			ranger_info_hub.distance = math.sqrt(x + y + z)
		end
	else
		ranger_info_hub.distance = nil
	end
end

function clear_last_shot_position()
	last_shot_position = nil
end

windower.register_event('action', rng_action_helper)
windower.register_event('prerender', update_hover_shot_info)
windower.register_event('target change', clear_last_shot_position)