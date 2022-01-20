-- Version 1.4.6

include("MasterGear/MasterGearFunctions.lua")
include('THHelper/THHelper.lua')
include('HasteTracker/HasteTracker.lua')

function get_sets()
	mode = 1
	cp_mode = false
	combat = false
	throwing = false
	killer_effect = false

	get_set_for_job_from_json()

	modes = {}
	for k, v in pairs(sets) do
		if k:startswith("Mode_") then
			local number = tonumber(k:slice(6, 6))
			if number then
				modes[number] = {name = k:slice(7), set = sets[k]}
			else
				windower.add_to_chat(122, "Please format mode sets as Mode_<num><name>. E.g 'Mode_1Hybrid")
			end
		end
	end
	if #modes == 0 then
		modes[1] = { name = "NoModesDefined", set = nil }
	end
	
	sets.Idle = set_combine(sets["IdleRegen"], sets["Movement"])
	
	if custom_get_sets and type(custom_get_sets) == 'function' then
		custom_get_sets()
	end
	
	print_mode()
	print_th_mode()
	if sets["Throwing"] then print_throwing() end
end

function precast(spell)
	if custom_precast and type(custom_precast) == 'function' and custom_precast(spell) then
	elseif spell.action_type == 'Magic' then
		if sets[modes[mode].name .. "Fastcast"] then equip(sets[modes[mode].name .. "Fastcast"])
		else equip(sets["Fastcast"]) end
    elseif spell.type=="WeaponSkill" then
		if ws and ws[spell.english] then
			local setToUse = nil
			if sets[modes[mode].name .. spell.english] then setToUse = sets[modes[mode].name .. spell.english]
			else setToUse = ws[spell.english].set end
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				setToUse = set_combine(setToUse, sets["WeatherObi"])
			end
			if killer_effect then
				setToUse = set_combine(setToUse, sets["KillerEffect"])
			end
			equip(setToUse)
		end
	elseif spell.action_type == "Ranged Attack" then equip(sets["Snapshot"])
	elseif sets["Precast_" .. modes[mode].name .. spell.english] then equip(sets["Precast_" .. modes[mode].name .. spell.english])
	elseif sets["Precast_" .. spell.english] then equip(sets["Precast_" .. spell.english])
    end
end

function midcast(spell)
	if custom_midcast and type(custom_midcast) == 'function' and custom_midcast(spell) then
	elseif spell.action_type == "Ranged Attack" then equip(sets["Midshot"])
	elseif sets["Midcast_" .. modes[mode].name ..spell.english] then 
		equip(sets["Midcast_" .. modes[mode].name ..spell.english])
		if spell.element == world.weather_element or spell.element == world.day_element then 
			equip(sets["WeatherObi"])
		end 
	elseif sets["Midcast_" .. spell.english] then 
		equip(sets["Midcast_" .. spell.english])
		if spell.element == world.weather_element or spell.element == world.day_element then 
			equip(sets["WeatherObi"])
		end
	elseif THModes[THMode].fulltime then
		equip(sets["TH"])
	end
end

function aftercast(spell)
	if custom_aftercast and type(custom_aftercast) == 'function' and custom_aftercast(spell) then
    elseif combat or player.status == "Engaged" then
		equip(modes[mode].set)
    else
        equip(sets.Idle)
    end
end

function status_change(new,old)
	if custom_status_change and type(custom_status_change) == 'function' and custom_status_change(new,old) then
	elseif new == 'Engaged' then
		equip(modes[mode].set)
		on_status_change_for_th(new, old)
	elseif T{'Idle','Resting'}:contains(new) then
		on_status_change_for_th(new, old)
		if combat == true then
			equip(modes[mode].set)
		else
			equip(sets.Idle)
		end
    end
end

windower.register_event('zone change', function()
	if custom_zone_change and type(custom_zone_change) == 'function' and custom_zone_change() then
	elseif world.area:contains("Adoulin") then
		equip(set_combine(sets.Idle, sets["Adoulin"]))
	else
		if combat == true then
			equip(modes[mode].set)
		else
			equip(sets.Idle)
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
	if args[1] == "cp" then
		if cp_mode == false then
			add_to_chat(122, "CP mode on")
			enable("back")
			equip(sets["CP"])
			disable("back")
			cp_mode = true
		elseif cp_mode == true then
			add_to_chat(122, "CP mode off")
			enable("back")
			cp_mode = false
		end
	elseif args[1] == "mode" then
		if args[2] and type(tonumber(args[2])) == 'number' then
			nextMode = tonumber(args[2])
			if nextMode == nil then
				add_to_chat(122, "Invalid mode number")
			else
				if modes[nextMode] == nil then
					add_to_chat(122, "Invalid node number")
				else
					mode = nextMode
					print_mode()
				end
			end
		else
			mode = mode + 1
			if modes[mode] == nil then
				mode = 1
			end
			print_mode()
		end
	elseif args[1] == "combat" then
		if combat == true then
			add_to_chat(122, "combat off!")
			combat = false
			if player.status ~= "Engaged" then
				equip(sets.Idle)
			else 
				equip(modes[mode].set)
			end
		else
			add_to_chat(122, "combat on!")
			combat = true
			equip(modes[mode].set)
		end
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(modes[mode].set)
		end
	elseif args[1] == "throwing" then
		if sets["Throwing"] then
			if throwing == false then
				throwing = true
				equip(sets["Throwing"])
				disable("ammo")
				AmmoDisabled = true
			else
				throwing = false
				enable("ammo")
				AmmoDisabled = false
			end
			print_throwing()
		else
			add_to_chat(122, "No Throwing set defined")
		end
	elseif args[1] == "killer" then
		if killer_effect == false then
			killer_effect = true
		else
			killer_effect = false
		end
		add_to_chat(122, "Killer Effect: " .. tostring(killer_effect))
	elseif custom_command and type(custom_command) == 'function' then
		custom_command(args)
	end
end

function print_mode()
	printString = "Current mode: "
	for i = 1, 9, 1 do
		if i == mode then
			printString = printString .. "[" .. i .. ":" .. modes[i].name .. "] "
		elseif modes[i] == nil then
			break
		else
			printString = printString .. i .. ":" .. modes[i].name .. " "
		end
	end	
	add_to_chat(122, printString)
end

function print_throwing()
	if throwing == true then 
		add_to_chat(122, "Boomerang: On")
	else
		add_to_chat(122, "Boomerang: Off")
	end
end