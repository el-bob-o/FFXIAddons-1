include('THHelper.lua')
include("MasterGearList.lua")

elemental_ninjutsu = { "Katon", "Suiton", "Raiton", "Doton", "Huton", "Hyoton" }

function get_sets()
	CPMode = false
	WS = "Savage Blade"
	THMode = 1
	Mode = 1
	Buffs = {}
	
	get_set_for_job("NIN", sets)
		
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] }
	}
		
	sets.Idle = set_combine(sets["Hybrid"], sets["IdleRegen"], sets["Movement"])
	sets["Savage Blade"] = sets["STR_WS"]
	sets["Circle Blade"] = sets["STR_WS"]
	sets["Sanguine Blade"] = sets["MagicAtk"]
	sets["Aeolian Edge"] = sets["MagicAtk"]
	
	print_current_ws()
	print_mode()
	print_th_mode()
	send_command('@input /macro book 5')
end
 
function precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
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
	if spell.action_type == 'Magic' then
		if spell.skill == "Ninjutsu" then
			if is_elemental_ninjutsu(spell.name) then
				equip(sets["MagicAtk"])
			end
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
	elseif args[1] == "setWS" and args[2] then
		WS = string.sub(command, 7)
		print_current_ws()
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(Modes[Mode].set)
		end
	else
		master_gear_list_command(args)
	end
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. WS)
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

function is_elemental_ninjutsu(spell_name)
	local upper_spell_name = string.upper(spell_name)
	for k,v in pairs(elemental_ninjutsu) do
		local startidx, endidx = string.upper(v):find(upper_spell_name)
		if startidx == 1 then return true end
	end
	return false
end