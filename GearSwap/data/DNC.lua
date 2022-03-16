include("MasterGear/MasterGearLua.lua")
texts = require('texts')
require('chat')

dnc_help_text = [[${combo_status}: ${combo_info}
:${disabled}, ${TP}, ${finishing_moves}, ${climactic_recast}, ${reverse_recast}, ${gp_recast}, ${tr_recast}
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
	
	if dnc_text_hub ~= nil then
        texts.destroy(dnc_text_hub)
    end
    dnc_text_hub = texts.new(dnc_help_text, default_settings, default_settings)
	
    dnc_text_hub:show()
end

climactic_combo = { name = "CF+RS", command = 'input /ja "Climactic Flourish" <me>;wait 1;input /ws "Rudra\'s Storm" <t>' }
reverse_combo = { name = "RF+RS", command = 'input /ja "Reverse Flourish" <me>;wait 1;input /ws "Rudra\'s Storm" <t>' }
grand_combo = { name = "RF+GP+RS", command = 'input /ja "Reverse Flourish" <me>;wait 1;input /ja "Grand Pas" <me>;wait 1;input /ws "Rudra\'s Storm" <t>' }
trance_combo = { name = "TR+RS", command = 'input /ja "Trance" <me>;wait 1;input /ws "Rudra\'s Storm" <t>' }

combo_steps = {
	climactic_combo,
	grand_combo,
	trance_combo,
	reverse_combo,
	reverse_combo,
}

function update_combo_info()
	local recasts = windower.ffxi.get_ability_recasts()
	local finishing_moves_6 = false
	local disabled = false
	if combo_step == 1 then
		local player_buffs = windower.ffxi.get_player().buffs
		for _,v in pairs(player_buffs) do
			if v == 588 then 
				finishing_moves_6 = true
			elseif v == 0 or v == 7 or v == 14 or v == 16 or v == 17 or v == 19 or v == 28 then
				disabled = true
			end
		end
		if finishing_moves_6 
		and recasts[226] == 0 -- Climactic
		and recasts[222] == 0 -- Reverse Flourish
		and recasts[254] == 0 -- Grand Pas
		and recasts[0] == 0 -- Trance
		and player.tp >= 1000
		and not disabled
		then
			can_combo = true
		else
			can_combo = false
		end
	else
		can_combo = true
	end
	
	local combo_info_string = ""
	for k,v in pairs(combo_steps) do
		if k == combo_step then combo_info_string = combo_info_string .. "[" .. v.name .. "]"
		else combo_info_string = combo_info_string .. v.name end
		if k ~= #combo_steps then combo_info_string = combo_info_string .. "," end
	end
	dnc_text_hub.combo_info = combo_info_string
	
	if can_combo then 
		dnc_text_hub.combo_status = string.text_color("Combo", 0, 255, 0)
	else 
		dnc_text_hub.combo_status  = string.text_color("Combo", 255, 0, 0)
	end
	
	if not disabled then
		dnc_text_hub.disabled = string.text_color("Status", 0, 255, 0)
	else
		dnc_text_hub.disabled = string.text_color("Status", 255, 0, 0)
	end
	
	if player.tp == 3000 then
		dnc_text_hub.TP = string.text_color("TP", 0, 255, 0)
	else
		dnc_text_hub.TP = string.text_color("TP", 255, 0, 0)
	end
	
	if finishing_moves_6 then 
		dnc_text_hub.finishing_moves = string.text_color("FM", 0, 255, 0)
	else
		dnc_text_hub.finishing_moves = string.text_color("FM", 255, 0, 0)
	end
	
	if recasts[226] == 0 then 
		dnc_text_hub.climactic_recast = string.text_color("CF", 0, 255, 0)
	else
		dnc_text_hub.climactic_recast = string.text_color("CF", 255, 0, 0)
	end
	
	if recasts[222] == 0 then 
		dnc_text_hub.reverse_recast = string.text_color("RF", 0, 255, 0)
	else
		dnc_text_hub.reverse_recast = string.text_color("RF", 255, 0, 0)
	end
	
	if recasts[254] == 0 then 
		dnc_text_hub.gp_recast = string.text_color("GP", 0, 255, 0)
	else
		dnc_text_hub.gp_recast = string.text_color("GP", 255, 0, 0)
	end
	
	if recasts[0] == 0 then 
		dnc_text_hub.tr_recast = string.text_color("Tr", 0, 255, 0)
	else
		dnc_text_hub.tr_recast = string.text_color("Tr", 255, 0, 0)
	end
end

function custom_get_sets()
	current_ws = "Rudra's Storm"
	can_combo = false
	doing_combo = false
	combo_step = 1
	
	ws = {}
	ws["Rudra's Storm"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Mandalic Stab"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Shark Bite"] = { set = sets["Rudra's Storm"], tp_bonus = true }
	ws["Dancing Edge"] = { set = sets["Dancing Edge"], tp_bonus = false }
	ws["Exenterator"] = { set = sets["Exenterator"], tp_bonus = false }
	ws["Evisceration"] = { set = sets["Evisceration"], tp_bonus = false }
	ws["Pyrrhic Kleos"] = { set = sets["Pyrrhic Kleos"], tp_bonus = false }
	ws["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Cyclone"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Gust Slash"] = { set = sets["MagicAtk"], tp_bonus = true }
	
	cancel_haste = 1
	
	print_current_ws()
	setup_text_window()
	update_combo_info()
	send_command('@input /macro book 12;wait 1;input /macro set 1')
end
 
function custom_precast(spell)
	if spell.type=="WeaponSkill" then
		if ws and ws[spell.english] then
			local set_to_use = nil
			if sets[modes[mode].name .. spell.english] then set_to_use = sets[modes[mode].name .. spell.english]
			else set_to_use = ws[spell.english].set end
			if ws[spell.english].tp_bonus then
				local maxTP = 3000
				if player.equipment.main == "Aeneas" then
					maxTP = maxTP - 500
				end 
				if player.equipment.sub == "Centovente" then
					maxTP = maxTP - 1000
				end
				if player.tp < maxTP then
					set_to_use = set_combine(set_to_use, sets["TPBonus"])
				end
			end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				set_to_use = set_combine(set_to_use, sets["WeatherObi"])
			end
			if killer_effect then
				set_to_use = set_combine(set_to_use, sets["KillerEffect"])
			end
			if buffactive["Climactic Flourish"] or buffactive["Sneak Attack"] or buffactive["Trick Attack"] then
				set_to_use = set_combine(set_to_use, sets["CritDmg"])
			end
			if th_next then
				set_to_use = set_combine(set_to_use, sets["TH"])
				th_next = false
			end
			equip(set_to_use)
		end
		return true
	elseif spell.english:contains("Samba") then
		equip(sets["Samba"])
		return true
	elseif spell.english:contains("Step") then
		equip(sets["Step"])
		return true
	elseif spell.english:contains("Healing Waltz") or spell.english == "Divine Waltz" then
		equip(sets["Waltz"])
		return true
	elseif spell.english:contains("Jig") then
		equip(sets["Jig"])
		return true
	elseif spell.english == "Climactic Flourish" then
		equip(sets["Climactic"])
		return true
	end
end

function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.skill == "Elemental Magic" then
			equip(sets["MagicAtk"])
			return true
		end
	end
end
 
function custom_command(args)
	if args[1] == "ws" then
		send_command('input /ws "' .. current_ws .. '" <t>')
	elseif args[1] == "setWS" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		current_ws = commandstring
		print_current_ws()
	elseif args[1] == "combo" then
		do_combo()
	elseif args[1] == 'tpitemws' then
		local temp_items = windower.ffxi.get_items(3)
		local tp_item = nil
		for k, v in pairs(temp_items) do
			if v.id ~= nil and v.id == 5834 then 
				tp_item = 5834
				break
			elseif v.id ~= nil and v.id == 6475 then
				tp_item = 6475
				break
			elseif v.id ~= nil and v.id == 4202 then
				tp_item = 4202
				break
			end
		end
		if tp_item ~= nil then
			if tp_item == 5834 then
				send_command('input /item "Lucid Wings I" <me>;wait 3.5;input /ws "Rudra\'s Storm" <t>')
			elseif tp_item == 6475 then
				send_command('input /item "Lucid Wings II" <me>;wait 3.5;input /ws "Rudra\'s Storm" <t>')
			elseif tp_item == 4202 then
				send_command('input /item "Daedalus Wing" <me>;wait 3.5;input /ws "Rudra\'s Storm" <t>')
			end
		end
	end
end

function print_current_ws()
	add_to_chat(122, "Current WS: " .. current_ws)
end

function do_combo()
	if can_combo then
		send_command(combo_steps[combo_step].command)
		combo_step = combo_step + 1
		if combo_step > #combo_steps then 
			combo_step = 1 
		end
	end
end

windower.register_event('time change', update_combo_info)