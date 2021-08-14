include("MasterGearFunctions.lua")
include('THHelper.lua')
texts = require('texts')
packets = require('packets')
require('chat')

function get_sets()
	Mode = 1
	CPMode = false
	learn_blu_mode = false

	get_set_for_job_from_json("BLU", sets)
		
	Modes = { 
		{ name = "Hybrid", set = sets["Hybrid"] },
		{ name = "DT", set = set_combine(sets["Hybrid"], sets["DT"]) },
	}
		
	sets.Idle = set_combine(sets["DT"], sets["IdleRegen"], sets["Movement"])
	
	WS = {}
	WS["Savage Blade"] = { set = sets["STR_WS"], tp_bonus = true }
	WS["Expiacion"] = { set = sets["STR_WS"], tp_bonus = true }
	WS["Black Halo"] = { set = sets["STR_WS"], tp_bonus = true }
	WS["Chant du Cygne"] = { set = set_combine(sets["DEX_Crit_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Requiescat"] = { set = set_combine(sets["MND_WS"], sets["Fotia"]), tp_bonus = true }
	WS["Realmrazer"] = { set = set_combine(sets["MND_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Seraph Blade"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Red Lotus Blade"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Sanguine Blade"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	sets["Sudden Lunge"] = sets["MagicAcc"]
	sets["Osmosis"] = sets["MagicAcc"]
	sets["Anvil Lightning"] = sets["MagicAtk"]
	sets["Searing Tempest"] = sets["MagicAtk"]
	sets["Spectral Floe"] = sets["MagicAtk"]
	sets["Subduction"] = sets["MagicAtk"]
	sets["Tenebral Crush"] = sets["MagicAtk"]
	sets["Entomb"] = sets["MagicAtk"]
	
	print_mode()
	print_th_mode()
	send_command('@input /macro book 9')
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
		if spell.english == "Mighty Guard" and buffactive["Diffusion"] then
			equip(sets["DiffusionBuff"])
		elseif sets[spell.english] then	
			equip(sets[spell.english])
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
			enable('back')
			equip(sets["CP"])
			disable('back')
			CPMode = true
		elseif CPMode == true then
			add_to_chat(122, "CP Mode off")
			enable('back')
			CPMode = false
		end
	elseif args[1] == "learnblu" then
		if learn_blu_mode == false then
			add_to_chat(122, "Learning BLU Spells on")
			enable('hands')
			equip(sets["LearnBlu"])
			disable('hands')
			learn_blu_mode = true
		elseif learn_blu_mode == true then
			add_to_chat(122, "Learning BLU Spells off")
			enable('hands')
			learn_blu_mode = false
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