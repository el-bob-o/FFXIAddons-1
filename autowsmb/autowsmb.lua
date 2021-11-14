-- Some portions Copyright © 2017, Ivaar.

_addon.name     = 'autowsmb'
_addon.author   = 'Dabidobido'
_addon.version  = '0.0.5'
_addon.commands = {'autowsmb', 'awsmb'}

require('logger')
require('actions')
config = require('config')
skills = require('skills')
res = require('resources')

local default_setting = {
	["sc_level"] = 2,
	["open_ws"] = "",
	["ws_priority"] = "",
	["spell_priority"] = "",
	["mb_delay"] = 4,
}

local default_settings = {
	war = default_setting,
	mnk = default_setting,
	whm = default_setting,
	blm = default_setting,
	rdm = default_setting,
	thf = default_setting,
	pld = default_setting,
	drk = default_setting,
	bst = default_setting,
	brd = default_setting,
	rng = default_setting,
	smn = default_setting,
	sam = default_setting,
	nin = default_setting,
	drg = default_setting,
	blu = default_setting,
	cor = default_setting,
	pup = default_setting,
	dnc = default_setting,
	sch = default_setting,
	geo = default_setting,
	run = default_setting
}

local settings = config.load(default_settings)

local started = false
local dont_open = false
local should_mb = false
local current_main_job = "war"

-- .element, .name, .tp
local parsed_wses = {}

-- .name, .element, .recast_id, .mp
local parsed_spells = {}

local last_skillchain = { name = nil, time = 0 }
local categories = S{
	'melee',
    'weaponskill_finish',
    'spell_finish',
    'job_ability',
    'mob_tp_finish',
    'avatar_tp_finish',
    'job_ability_unblinkable',
}
local skillchain_ids = S{288,289,290,291,292,293,294,295,296,297,298,299,300,301,385,386,387,388,389,390,391,392,393,394,395,396,397,767,768,769,770}
local message_ids = S{110,185,187,317,802}
local sc_window_delay = 3
local sc_window_end = 8
local target_sc_step = 0
local double_light_darkness = false

local function insert_unique(elements_table, elements_to_insert)
	for _,element_to_insert in pairs(elements_to_insert) do
		if not elements_table:contains(element_to_insert) then
			table.insert(elements_table, element_to_insert)
		end
	end
	return elements_table
end

function get_next_skillchain_elements()
	local elements_to_return = T{}
	for _,v in pairs(last_skillchain.name) do
		local element = string.lower(v)
		local sc_level_to_use = settings[current_main_job]["sc_level"]
		if element == 'transfixion' then
			if sc_level_to_use > 1 then elements_to_return = insert_unique(elements_to_return, {"scission"} )
			else elements_to_return = insert_unique(elements_to_return, {"compression", "scission", "reverberation" }) end
		elseif element == 'compression' then
			if sc_level_to_use > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"transfixion", "detonation" }) end
		elseif element == 'liquefaction' then
			if sc_level_to_use > 1 then elements_to_return = insert_unique(elements_to_return, {"impaction"})
			else elements_to_return = insert_unique(elements_to_return, {"scission", "impaction" }) end
		elseif element == 'scission' then
			if sc_level_to_use > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"liquefaction", "reverberation", "detonation"}) end
		elseif element == "reverberation" then
			if sc_level_to_use > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"induration", "impaction"}) end
		elseif element == "detonation" then
			if sc_level_to_use > 1 then elements_to_return = insert_unique(elements_to_return, {"compression"})
			else elements_to_return = insert_unique(elements_to_return, {"compression", "scission"}) end
		elseif element == "induration" then
			if sc_level_to_use > 1 then elements_to_return = insert_unique(elements_to_return, {"reverberation"})
			else elements_to_return = insert_unique(elements_to_return, {"compression", "reverberation", "impaction"}) end
		elseif element == "impaction" then
			if sc_level_to_use > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"liquefaction", "detonation"}) end
		elseif element == "gravitation" then
			if sc_level_to_use > 2 then elements_to_return = insert_unique(elements_to_return, {"distortion"})
			else elements_to_return = insert_unique(elements_to_return, {"fragmentation", "distortion"}) end
		elseif element == "distortion" then
			if sc_level_to_use > 2 then elements_to_return = insert_unique(elements_to_return,{"gravitation"})
			else elements_to_return = insert_unique(elements_to_return,{"gravitation", "fusion"}) end
		elseif element == "fusion" then
			if sc_level_to_use > 2 then elements_to_return = insert_unique(elements_to_return, {"fragmentation"})
			else elements_to_return = insert_unique(elements_to_return, {"fragmentation", "gravitation"}) end
		elseif element == "fragmentation" then
			if sc_level_to_use > 2 then elements_to_return = insert_unique(elements_to_return, {"fusion"} )
			else elements_to_return = insert_unique(elements_to_return, {"fusion", "distortion"}) end
		elseif element == "light" then
			elements_to_return = insert_unique(elements_to_return, {"light"} )
		elseif element == "darkness" then
			elements_to_return = insert_unique(elements_to_return, {"darkness"} )
		end
	end
	return elements_to_return
end

local function get_next_ws(player_tp, time_since_last_skillchain)
	if last_skillchain.name ~= nil and not double_light_darkness and time_since_last_skillchain <= sc_window_end then
		local elements_to_continue = get_next_skillchain_elements()
		if elements_to_continue then
			if time_since_last_skillchain >= sc_window_delay then 
				for i = 2, #parsed_wses do
					if player_tp >= parsed_wses[i].tp then
						for _, v2 in pairs(parsed_wses[i].elements) do
							for _, v3 in pairs(elements_to_continue) do
								if string.lower(v3) == string.lower(v2) then
									return parsed_wses[i].name
								end
							end
						end
					end
				end
			end
		elseif not dont_open and player_tp >= parsed_wses[1].tp then
			return parsed_wses[1].name
		end
	elseif not dont_open and player_tp >= parsed_wses[1].tp then
		return parsed_wses[1].name
	end
	return nil
end

local function get_burst_elements(animation)
	-- 0 = fire, 1 = ice, 2 = wind, 3 = earth, 4 = thunder, 5 = water, 6 = light, 7 = dark
	if animation == 'transfixion' then return T{ 6 }
	elseif animation == 'compression' then return T{ 7 }
	elseif animation == 'liquefaction' then return T{ 0 }
	elseif animation == 'scission' then return T{ 3 }
	elseif animation == "reverberation" then return T{ 5 }
	elseif animation == "detonation" then return T{ 2 }
	elseif animation == "induration" then return T{ 1 }
	elseif animation == "impaction" then return T{ 4 }
	elseif animation == "gravitation" then return T{ 3, 7 }
	elseif animation == "distortion" then return T{ 1, 5 }
	elseif animation == "fusion" then return T{ 0, 6 }
	elseif animation == "fragmentation" then return T{ 2, 4 }
	elseif animation == "light" or animation == "radiance" then return T{ 0, 2, 4, 6 }
	elseif animation == "darkness" or animation == "umbra" then return T{ 1, 3, 5, 7 }
	end
	return nil
end

local function get_mb_spells(animation)
	local mp_available = windower.ffxi.get_player().vitals.mp
	local recasts = windower.ffxi.get_spell_recasts()
	local spell_1 = nil
	local spell_2 = nil
	local burst_elements = get_burst_elements(animation)
	if burst_elements ~= nil then
		for _,v in pairs(parsed_spells) do
			if burst_elements:contains(v.element)
			and mp_available > v.mp 
			and (recasts[v.recast_id] == nil or recasts[v.recast_id] == 0) then
				if spell_1 == nil then spell_1 = v.name
				elseif spell_2 == nil then spell_2 = v.name
				end
				mp_available = mp_available - v.mp
				if spell_1 ~= nil and spell_2 ~= nil then break end
			end
		end
	end
	return spell_1, spell_2
end

local function parse_action(act)
	if started then
		local actionpacket = ActionPacket.new(act)
		local category = actionpacket:get_category_string()
		
		if not categories:contains(category) or act.param == 0 then
			return
		end

		local actor_id = actionpacket:get_id()
		local target = actionpacket:get_targets()()
		local action = target:get_actions()()
		local message_id = action:get_message_id()
		local add_effect = action:get_add_effect()
		local param, resource, action_id, interruption, conclusion = action:get_spell()
		local ability = skills[resource] and skills[resource][action_id]	
		local player = windower.ffxi.get_player()
		local target_index = player.target_index
		if target_index then
			local mob = windower.ffxi.get_mob_by_index(target_index)
			if mob and target.id == mob.id then
				if category == 'melee' and actor_id == player.id then
					if player.vitals.tp >= 1000 then
						local time_since_last_skillchain = os.clock() - last_skillchain.time
						local next_ws = get_next_ws(player.vitals.tp, time_since_last_skillchain)
						if next_ws ~= nil then 
							windower.send_command('input /ws "' .. next_ws .. '" <t>')
						end
					end
				elseif add_effect and conclusion and skillchain_ids:contains(add_effect.message_id) then
					if target_sc_step >= 1 
					and ((last_skillchain.name ~= nil and #last_skillchain.name >= 1) and (last_skillchain.name[1] == "light" or last_skillchain.name[1] == "darkness")) 
					and (add_effect.animation == "light" 
					or add_effect.animation == "darkness" 
					or add_effect.animation == "radiance"
					or add_effect.animation == "umbra") then
						double_light_darkness = true
					else
						double_light_darkness = false
					end
					last_skillchain.name = { add_effect.animation }
					last_skillchain.time = os.clock()
					sc_window_delay = ability.delay or 3
					target_sc_step = target_sc_step + 1
					sc_window_end = 6 + sc_window_delay - target_sc_step
					if should_mb then
						local spell_1, spell_2 = get_mb_spells(add_effect.animation)
						if spell_1 ~= nil then
							local commandstring = ""
							if actor_id == player.id then
								commandstring = "wait 3;"
							end
							commandstring = commandstring .. 'input /ma "' .. spell_1 .. '" <t>'
							if actor_id ~= player.id and spell_2 ~= nil and settings[current_main_job]["mb_delay"] <= 8 then
								commandstring = commandstring .. ';wait ' .. settings[current_main_job]["mb_delay"] .. ';input /ma "' .. spell_2 .. '" <t>'
							end
							windower.send_command(commandstring)
						end
					end
				elseif ability and message_ids:contains(message_id) then
					double_light_darkness = false
					last_skillchain.name = ability.skillchain
					last_skillchain.time = os.clock()
					sc_window_delay = ability.delay or 3
					sc_window_end = 6 + sc_window_delay
					target_sc_step = 0
				end
			end
		end
	end
end

local function parse_ws_settings()
	parsed_wses = {}
	local open_ws_table = settings[current_main_job]["open_ws"]:split(',')
	if #open_ws_table ~= 2 then return false end
	local open_tp = tonumber(open_ws_table[2])
	if open_tp == nil or open_tp < 1000 or open_tp > 3000 then open_tp = 1000 end
	for _,v in pairs(skills.weapon_skills) do
		if string.lower(v.en) == open_ws_table[1] then
			parsed_wses[1] = { name = open_ws_table[1], elements = v.skillchain, tp = open_tp }
			break
		end
	end
	if #parsed_wses == 1 then
		local ws_p_table = settings[current_main_job]["ws_priority"]:split(',')
		if #ws_p_table % 2 ~= 0 then
		else
			for i = 1, #ws_p_table, 2 do
				local ws_tp = tonumber(ws_p_table[i + 1])
				if ws_tp == nil or ws_tp < 1000 or ws_tp > 3000 then ws_tp = 1000
				else
					for _, v2 in pairs(skills.weapon_skills) do
						if string.lower(v2.en) == ws_p_table[i] then
							table.insert(parsed_wses, {name = ws_p_table[i], elements = v2.skillchain, tp = ws_tp } )
							break
						end
					end
				end
			end
		end
		return true
	end
	return false
end

local function parse_spell_settings()
	parsed_spells = {}
	local spell_table = settings[current_main_job]["spell_priority"]:split(',')
	for _,v in pairs(spell_table) do
		for _,v2 in pairs(res.spells) do
			if v == string.lower(v2.en) then
				table.insert(parsed_spells, { name = v2.en, element = v2.element, recast = v2.recast_id, mp = v2.mp_cost })
			end
		end
	end
	if #parsed_spells > 1 then return true end
	return false
end

local function handle_command(...)
    local args = T{...}
	if args[1] == "start" then
		if parse_ws_settings() then
			started = true
			notice("Started: " .. tostring(started))
		else
			warning("Error parsing weapon skills")
		end
	elseif args[1] == "stop" then
		started = false
		notice("Started: " .. tostring(started))
	elseif args[1] == "dontopen" then
		dont_open = true
		notice("Don't Open: " .. tostring(dont_open))
	elseif args[1] == "open" then
		dont_open = false
		notice("Don't Open: " .. tostring(dont_open))
	elseif args[1] == 'setopenws' and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		commandstring = string.lower(commandstring)
		local old_open_ws = settings[current_main_job]["open_ws"]
		settings[current_main_job]["open_ws"] = commandstring
		if parse_ws_settings() then
			notice("WS To Use: " .. parsed_wses[1].name .. " (" .. parsed_wses[1].tp .. " TP)")
			config.save(settings)
		else
			settings[current_main_job]["open_ws"] = old_open_ws
			notice("Error parsing " .. commandstring)
		end
	elseif args[1] == "setwspriority" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		commandstring = string.lower(commandstring)
		local old_ws_priority = settings[current_main_job]["ws_priority"]
		settings[current_main_job]["ws_priority"] = commandstring
		if parse_ws_settings() then
			for i = 2, #parsed_wses do
				notice("WS Priority " .. tostring(i - 1) .. ": " .. parsed_wses[i].name .. " (" .. parsed_wses[i].tp .. " TP)")
			end
			config.save(settings)
		else
			settings[current_main_job]["ws_priority"] = old_ws_priority
			notice("Error parsing " .. commandstring)
		end
	elseif args[1] == "setsclevel" and args[2] then
		local level = tonumber(args[2])
		if level then
			if level >= 1 and level <= 3 then
				settings[current_main_job]["sc_level"] = level
				notice("SC Level: " .. tostring(settings[current_main_job]["sc_level"]))
				config.save(settings)
			else
				notice("SC Level needs to be between 1 and 3, not " .. tostring(level))
			end
		else
			notice("Error parsing " .. args[2])
		end
	elseif args[1] == "startmb" then
		should_mb = true
		notice("MB: " .. tostring(should_mb))
	elseif args[1] == "stopmb" then
		should_mb = false
		notice("MB: " .. tostring(should_mb))
	elseif args[1] == "setmbdelay" and args[2] then
		local delay = tonumber(args[2])
		if delay then
			settings[current_main_job]["mb_delay"] = delay
			notice("MB Delay: " .. tostring(settings[current_main_job]["mb_delay"]))
			config.save(settings)
		else
			notice("Error parsing " .. args[2])
		end
	elseif args[1] == "setspellpriority" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		commandstring = string.lower(commandstring)
		local old_spell_priority = settings[current_main_job]["spell_priority"]
		settings[current_main_job]["spell_priority"] = commandstring
		if parse_spell_settings() then
			for i = 1, #parsed_spells do
				notice("Spell Priority " .. tostring(i) .. ": " .. parsed_spells[i].name)
			end
			config.save(settings)
		else
			settings[current_main_job]["spell_priority"] = old_spell_priority
			notice("Error parsing " .. commandstring)
		end
    else
		notice("//awsmb start: Starts auto ws.")
		notice("//awsmb stop: Stops auto ws.")
		notice("//awsmb dontopen: Don't use open ws, only try to skill chain.")
		notice("//awsmb open: Use open ws.")
		notice("//awsmb setopenws (name,tp): Set the name of ws to open with and the minimum tp to use the ws.")
		notice("//awsmb setwspriority ((name,tp,name,tp,...): Set the name of ws and tp of ws to try to skillchain with. will try to make skillchains in the order of input.")
		notice("//awsmb setsclevel (1-3): Will only try to skillchain and make skillchains of the level set here or above.")
		notice("//awsmb startmb: Starts auto magic bursting.")
		notice("//awsmb stopmb: Stops auto magic bursting.")
		notice("//awsmb setmbdelay (number): Sets delay between spells for mb. Default is 4 seconds. If set more than 8 then will only burst 1 spell.")
		notice("//awsmb setspellpriority (spell_name as csv): Sets priority for spells to burst with. Will go in order of input and check elements.")
    end
end

local function handle_zone_change(new, old)
	started = false
	should_mb = false
	notice("Zoned. Stopped autows and automb")
end

local function check_job_and_parse_settings()
	current_main_job = string.lower(windower.ffxi.get_player().main_job)
	parse_ws_settings()
	parse_spell_settings()
end

windower.register_event('zone change', handle_zone_change)
windower.register_event('addon command', handle_command)
windower.register_event('load', check_job_and_parse_settings)
windower.register_event('login', check_job_and_parse_settings)
windower.register_event('job change', check_job_and_parse_settings)
ActionPacket.open_listener(parse_action)