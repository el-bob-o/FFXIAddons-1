include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	nuke = "Dia"
	indi = "Indi-Fury"
	geo = "Geo-Frailty"
	entrust = "Indi-Haste"
 
	ws = {}
	ws["Shining Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Seraph Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Flash Nova"] = { set = sets["Flash Nova"], tp_bonus = false }
	ws["Cataclysm"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Realmrazer"] = { set = sets["Hexa Strike"], tp_bonus = false }
	ws["Hexa Strike"] = { set = sets["Hexa Strike"], tp_bonus = false }
	ws["Judgement"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Black Halo"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Exudation"] = { set = sets["Black Halo"], tp_bonus = false }
	 
	send_command('@input /macro book 3;wait 1;input /macro set 1')
	print_current_nuke()
	print_current_geos()
end
 
function custom_precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
		return true
    end
end

function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Geomancy" then
			equip(sets["Geomancy"])
		elseif spell.skill == "Healing Magic" and spell.name:match("Cure") then
			equip(sets["Healing"])
		elseif spell.skill == "Elemental Magic" then
			if spell.element == world.weather_element or spell.element == world.day_element then 
				equip(set_combine(sets["Elemental"], sets["WeatherObi"]))
			else
				equip(sets["Elemental"])
			end
		elseif spell.skill == "Dark Magic" then
			if spell.name:match("Drain") or spell.name:match("Aspir") then
				equip(set_combine(sets["Elemental"], sets["Drain"]))
			elseif spell.name:match("Stun") then
				equip(sets["MACC"])
			end
		elseif spell.skill == "Enfeebling Magic" then
			equip(sets["MACC"])
		end
		return true
	end
end
 
function custom_command(args)
	if args[1] == "nuke" then
		send_command('input /ma "' .. nuke .. '" <t>')
	elseif args[1] == "indi" then
		send_command('input /ma "' .. indi .. '" <me>')
	elseif args[1] == "geo" then
		send_command('input /ma "' .. geo .. '" <t>')
	elseif args[1] == "entrust" then
		send_command('input /ma "' .. entrust .. '" <t>')
	elseif args[1] == 'tellParty' then
		party_current_geos()
	elseif args[1] == 'setNuke' and args[2] then
		nuke = args[2]
		print_current_nuke()
	elseif args[1] == 'setIndi' then
		indi = args[2]
		print_current_geos()
	elseif args[1] == 'setGeo' then
		geo = args[2]
		print_current_geos()
	elseif args[1] == 'setEntrust' then
		entrust = args[2]
		print_current_geos()
	end
end

function print_current_nuke()
	add_to_chat(122, "Current nuke: " .. nuke)
end

function print_current_geos()
	add_to_chat(122, "indi: " .. indi .. ", geo: " .. geo .. ", entrust: " .. entrust)
end

function party_current_geos()
	send_command('input /p ' .. "indi: " .. indi .. ", geo: " .. geo .. ", entrust: " .. entrust)
end
