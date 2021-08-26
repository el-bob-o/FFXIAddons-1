include('THHelper/THHelper.lua')
include('HasteTracker/HasteTracker.lua')
include("MasterGear/MasterGearFunctions.lua")

function get_sets()
	CPMode = false
	Throwing = false
	current_ws = "Rudra's Storm"
	Mode = 1
	Buffs = {}
	
	get_set_for_job_from_json()
	
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] }
	}
	
	sets.SATA = set_combine(sets["SneakAttack"], sets["TrickAttack"])
	
	WS = {}
	WS["Rudra's Storm"] = { set = sets["DEX_WS"], tp_bonus = true }
	WS["Mandalic Stab"] = { set = sets["DEX_WS"], tp_bonus = true }
	WS["Shark Bite"] = { set = sets["DEX_WS"], tp_bonus = true }
	WS["Savage Blade"] = { set = sets["STR_WS"], tp_bonus = true }
	WS["Dancing Edge"] = { set = set_combine(sets["DEX_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Exenterator"] = { set = set_combine(sets["DEX_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Evisceration"] = { set = set_combine(sets["DEX_Crit_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
 
	sets.Idle = set_combine(sets["Hybrid"], sets["IdleRegen"], sets["Movement"])
	
	cancel_haste = 1
	
	print_current_ws()
	print_mode()
	print_th_mode()
	print_throwing()
	send_command('@input /macro book 2')
	subjob_macro_page(player.sub_job)
end
 
function precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
    elseif spell.type=="WeaponSkill" then
		if WS[spell.english] then
			local setToUse = WS[spell.english].set
			if WS[spell.english].tp_bonus then
				local maxTP = 3000
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				setToUse = set_combine(setToUse, sets["WeatherObi"])
			end
			setToUse = SATA_check(setToUse)
			equip(setToUse)
		end
	elseif sets[spell.english] then
        equip(sets[spell.english])
    end
end

function midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets["MagicAtk"])
		end
	end
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
	elseif args[1] == "ws" then
		send_command('input /ws "' .. current_ws .. '" <t>')
	elseif args[1] == "throwing" then
		if Throwing == false then
			Throwing = true
			equip(sets["Throwing"])
			disable("ammo")
			AmmoDisabled = true
		else
			Throwing = false
			enable("ammo")
			AmmoDisabled = false
		end
		print_throwing()
	elseif args[1] == "setWS" and args[2] then
		current_ws = string.sub(command, 7)
		print_current_ws()
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(Modes[Mode].set)
		end
	end
end

function sub_job_change(new, old)
	subjob_macro_page(new)
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end

function SATA_check(set)
	SA = buffactive["Sneak Attack"]
	TA = buffactive["Trick Attack"]
	if SA or TA then
		if SA and TA then
			set = set_combine(set, sets.SATA)
		elseif SA then
			set = set_combine(set, sets["SneakAttack"])
		elseif TA then
			set = set_combine(set, sets["TrickAttack"])
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
	elseif job == "WAR" then
		send_command('@wait 1;input /macro set 4')
	end
end