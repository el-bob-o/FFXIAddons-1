include('THHelper.lua')
include("HasteTracker.lua")
include("MasterGearFunctions.lua")

function get_sets()
	CPMode = false
	Mode = 1
	
	get_set_for_job_from_json("DRK", sets)
	
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] }
	}
 
	sets.Idle = set_combine(sets["Hybrid"], sets["IdleRegen"], sets["Movement"])
	
	WS = {}
	WS["Cross Reaper"] = { set = sets["Catastrophe"], tp_bonus = true }
	WS["Spiral Hell"] = { set = sets["Catastrophe"], tp_bonus = true }
	WS["Catastrophe"] = { set = sets["Catastrophe"], tp_bonus = false }
	WS["Quietus"] = { set = sets["Catastrophe"], tp_bonus = false }
	WS["Spinning Scythe"] = { set = sets["Catastrophe"], tp_bonus = false }
	WS["Entropy"] = { set = sets["Entropy"], tp_bonus = true }
	WS["Insurgency"] = { set = sets["Insurgency"], tp_bonus = true }
	WS["Shadow of Death"] = { set = sets["DarkMagicAtk"], tp_bonus = true }
	WS["Infernal Scythe"] = { set = sets["DarkMagicAtk"], tp_bonus = false }
	
	absorb_cycle = 1
	absorbs = {}
	absorbs[1] = { buff = "STR Boost", spell = "Absorb-STR" }
	absorbs[2] = { buff = "INT Boost", spell = "Absorb-INT" }
	absorbs[3] = { buff = "Accuracy Boost", spell = "Absorb-Acc" }
	absorbs[4] = { buff = "DEX Boost", spell = "Absorb-DEX" }
 	
	cancel_haste = 1
	
	print_mode()
	print_th_mode()
	send_command('@input /macro book 11;wait 1;input /macro set 1')
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
	if not spell.interrupted then
		for k,v in pairs(absorbs) do
			if v.spell == spell.english then
				absorb_cycle = absorb_cycle + 1
				if absorb_cycle > #absorbs then absorb_cycle = 1 end
			end
		end
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
	absorb_cycle = 1
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
	elseif args[1] == "absorb" then
		for k,v in pairs(absorbs) do
			if not buffactive[v.buff] then
				absorb_cycle = k
				send_command('input /ma "' .. v.spell .. '" <t>')
				return
			end
		end
		send_command('input /ma "' .. absorbs[absorb_cycle].spell .. '" <t>')
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(Modes[Mode].set)
		end
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