include('THHelper.lua')
include("MasterGearList.lua")

function get_sets()
	CPMode = false
	Throwing = false
	WS = "Rudra's Storm"
	THMode = 1
	Mode = 1
	Buffs = {}
	
	sets = get_set_for_job("THF")
		
	sets.Lilith = set_combine(sets["Hybrid"], sets["Lilith"])
	
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] },
		{ name = "Lilith", set = sets.Lilith }
	}
	
	sets.SATA = set_combine(sets["SneakAttack"], sets["TrickAttack"])
		
	sets["Mandalic Stab"] = sets["Rudra's Storm"]
	sets["Cyclone"] = sets["Aeolian Edge"]
	sets["Gust Slash"] = sets["Aeolian Edge"]
 
	sets.Idle = set_combine(sets["Hybrid"], sets["IdleRegen"], sets["Movement"])
	
	print_current_ws()
	print_mode()
	print_th_mode()
	print_throwing()
	send_command('@input /macro book 2')
	subjob_macro_page(player.sub_job)
end
 
function precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["FastCast"])
    elseif spell.type=="WeaponSkill" then
		local setToUse = {}
        if sets[spell.english] then
			setToUse = sets[spell.english]
		else
			setToUse = sets["WS_Any"]
		end
		setToUse = SATA_check(setToUse)
		if player.tp < 3000 then
			setToUse = set_combine(setToUse, sets["TPBonus"])
		end
		equip(setToUse)
	elseif sets[spell.english] then
        equip(sets[spell.english])
    end
end

function midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets["WS_Magical"])
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
 
function buff_change(name,gain,buff_table)
	Buffs[name] = gain
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
	elseif args[1] == "ws" then
		send_command('input /ws "' .. WS .. '" <t>')
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
		WS = args[2]
		print_current_ws()
	else
		master_gear_list_command(args)
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
	end
end