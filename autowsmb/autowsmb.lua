-- Some portions Copyright © 2017, Ivaar.

_addon.name     = 'autowsmb'
_addon.author   = 'Dabidobido'
_addon.version  = '0.0.1'
_addon.commands = {'autowsmb', 'awsmb'}

require('logger')
require('actions')
config = require('config')
skills = require('skills')

local default_settings = {
	["sc_level"] = 2,
	["open_ws"] = "",
	["ws_priority"] = ""
}

local settings = config.load(default_settings)

local tp_to_ws = 1000
local started = false
local should_mb = false
local parsed_wses = {}
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
		if element == 'transfixion' then
			if settings["sc_level"] > 1 then elements_to_return = insert_unique(elements_to_return, {"scission"} )
			else elements_to_return = insert_unique(elements_to_return, {"compression", "scission", "reverberation" }) end
		elseif element == 'compression' then
			if settings["sc_level"] > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"transfixion", "detonation" }) end
		elseif element == 'liquefaction' then
			if settings["sc_level"] > 1 then elements_to_return = insert_unique(elements_to_return, {"impaction"})
			else elements_to_return = insert_unique(elements_to_return, {"scission", "impaction" }) end
		elseif element == 'scission' then
			if settings["sc_level"] > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"liquefaction", "reverberation", "detonation"}) end
		elseif element == "reverberation" then
			if settings["sc_level"] > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"induration", "impaction"}) end
		elseif element == "detonation" then
			if settings["sc_level"] > 1 then elements_to_return = insert_unique(elements_to_return, {"compression"})
			else elements_to_return = insert_unique(elements_to_return, {"compression", "scission"}) end
		elseif element == "induration" then
			if settings["sc_level"] > 1 then elements_to_return = insert_unique(elements_to_return, {"reverberation"})
			else elements_to_return = insert_unique(elements_to_return, {"compression", "reverberation", "impaction"}) end
		elseif element == "impaction" then
			if settings["sc_level"] > 1 then
			else elements_to_return = insert_unique(elements_to_return, {"liquefaction", "detonation"}) end
		elseif element == "gravitation" then
			if settings["sc_level"] > 2 then elements_to_return = insert_unique(elements_to_return, {"distortion"})
			else elements_to_return = insert_unique(elements_to_return, {"fragmentation", "distortion"}) end
		elseif element == "distortion" then
			if settings["sc_level"] > 2 then elements_to_return = insert_unique(elements_to_return,{"gravitation"})
			else elements_to_return = insert_unique(elements_to_return,{"gravitation", "fusion"}) end
		elseif element == "fusion" then
			if settings["sc_level"] > 2 then elements_to_return = insert_unique(elements_to_return, {"fragmentation"})
			else elements_to_return = insert_unique(elements_to_return, {"fragmentation", "gravitation"}) end
		elseif element == "fragmentation" then
			if settings["sc_level"] > 2 then elements_to_return = insert_unique(elements_to_return, {"fusion"} )
			else elements_to_return = insert_unique(elements_to_return, {"fusion", "distortion"}) end
		elseif element == "light" then
			elements_to_return = insert_unique(elements_to_return, {"light"} )
		elseif element == "darkness" then
			elements_to_return = insert_unique(elements_to_return, {"darkness"} )
		end
	end
	return elements_to_return
end

local function get_open_ws()
	if last_skillchain.name ~= nil then 
		local elements_to_continue = get_next_skillchain_elements()
		if elements_to_continue then
			for i = 2, #parsed_wses do
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
	return nil
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
					if player.vitals.tp >= tp_to_ws then
						local next_ws = get_open_ws()
						local time_since_last_skillchain = os.time() - last_skillchain.time
						if next_ws ~= nil then
							if time_since_last_skillchain < 4 then
							elseif time_since_last_skillchain >= 4 and time_since_last_skillchain <= 8 then
								windower.send_command('input /ws "' .. next_ws .. '" <t>')
							else
								windower.send_command('input /ws "' .. settings["open_ws"] .. '" <t>')
							end
						else
							windower.send_command('input /ws "' .. settings["open_ws"] .. '" <t>')
						end
					end
				elseif add_effect and conclusion and skillchain_ids:contains(add_effect.message_id) then
					last_skillchain.name = { add_effect.animation }
					last_skillchain.time = os.time()
				elseif ability and message_ids:contains(message_id) then
					last_skillchain.name = ability.skillchain
					last_skillchain.time = os.time()
				end
			end
		end
	end
end

local function parse_ws_settings()
	parsed_wses = {}
	for _,v in pairs(skills.weapon_skills) do
		if string.lower(v.en) == string.lower(settings["open_ws"]) then
			parsed_wses[1] = { name = settings["open_ws"], elements = v.skillchain }
			break
		end
	end
	if #parsed_wses == 1 then
		local ws_p_table = settings["ws_priority"]:split(',')
		for _, v in pairs(ws_p_table) do
			for _, v2 in pairs(skills.weapon_skills) do
				if string.lower(v2.en) == string.lower(v) then
					table.insert(parsed_wses, {name = v, elements = v2.skillchain } )
					break
				end
			end
		end
		return true
	end
	return false
end

local function handle_command(...)
    local args = T{...}
	if args[1] == "start" then
		if parse_ws_settings() then
			if started then started = false
			else started = true
			end
			notice("Started: " .. tostring(started))
		else
			warning("Error parsing weapon skills")
		end
	elseif args[1] == 'setopenws' and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		local old_open_ws = settings["open_ws"]
		settings["open_ws"] = commandstring
		if parse_ws_settings() then
			notice("WS To Use: " .. settings["open_ws"])
			config.save(settings)
		else
			settings["open_ws"] = old_open_ws
			notice("Error parsing " .. commandstring)
		end
	elseif args[1] == "setwspriority" and args[2] then
		local commandstring = ""
		for i = 2, #args do
			commandstring = commandstring .. args[i] .. " "
		end
		commandstring = string.sub(commandstring, 1, #commandstring - 1)
		local old_ws_priority = settings["ws_priority"]
		settings["ws_priority"] = commandstring
		if parse_ws_settings() then
			for i = 2, #parsed_wses do
				notice("WS Priority " .. tostring(i - 1) .. ": " .. parsed_wses[i].name)
			end
			config.save(settings)
		else
			settings["ws_priority"] = old_ws_priority
			notice("Error parsing " .. commandstring)
		end
	elseif args[1] == "setsclevel" and args[2] then
		local level = tonumber(args[2])
		if level then
			if level >= 1 and level <= 3 then
				settings["sc_level"] = level
				notice("SC Level: " .. tostring(settings["sc_level"]))
				config.save(settings)
			else
				notice("SC Level needs to be between 1 and 3, not " .. tostring(level))
			end
		else
			notice("Error parsing " .. args[2])
		end
		
    else
		notice("//awsmb start " .. tostring(started))
    end
end

windower.register_event('addon command', handle_command)
ActionPacket.open_listener(parse_action)