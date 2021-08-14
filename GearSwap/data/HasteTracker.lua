haste_level = 0
cancel_haste = 0

local spells_started = {}

local function get_haste_level(id)
	if id == 57 or id == 358 then return 1 -- 57: Haste, 358: Hastega,
	elseif id == 511 or id == 710 then return 2 -- 511: Haste II, 710: Erratic Flutter
	else return 0
	end
end

local function set_spells_started(add, id, actor_id)
	if add then
		spells_started[actor_id] = id
	else
		spells_started[actor_id] = nil
	end
end

local function set_haste_level(actor_id)
	if spells_started[actor_id] then
		local level = get_haste_level(spells_started[actor_id])
		if level > haste_level then haste_level = level end
		spells_started[actor_id] = nil
	end
end

local function parse_action(act)
	if act.category == 8 then
		if act.param == 24931 then
			for k, v in pairs(act.targets) do
				if v.id == player.id then
					for k2, v2 in pairs(v.actions) do
						if get_haste_level(v2.param) > 0 then 
							set_spells_started(true, v2.param, act.actor_id)
							return
						end
					end
				end
			end
		elseif act.param == 28787 then
			for k, v in pairs(act.targets) do
				if v.id == player.id then
					for k2, v2 in pairs(v.actions) do
						if get_haste_level(v2.param) > 0 then 
							set_spells_started(false, v2.param, act.actor_id)
							return
						end
					end
				end
			end
		end
	elseif act.category == 4 then -- finish casting spell
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				if get_haste_level(act.param) > 0 then
					set_haste_level(act.actor_id)
					return
				end
			end
		end
	end
end

local function cancel_buff(id)
	windower.packets.inject_outgoing(0xF1,string.char(0xF1,0x04,0,0,id%256,math.floor(id/256),0,0)) -- Inject the cancel packet
end

local function gain_buff(id)
	if id == 33 or id == 580 then
		if cancel_haste >= haste_level then
			cancel_buff(id)
		end
	end
end

local function lose_buff(id)
	if id == 33 or id == 580 then
		haste_level = 0
	end
end

local function parse_command(...)
	local args = T{...}
	if string.lower(args[1]) == "hastetracker" then
		table.remove(args, 1)
		local arg1 = string.lower(args[1])
		if arg1 == "cancelhaste" and args[2] and type(tonumber(args[2])) == 'number' then
			local cancel_haste_number = tonumber(args[2])
			if cancel_haste_number >= 0 and cancel_haste_number <= 2 then
				cancel_haste = cancel_haste_number
				windower.add_to_chat(122, "Cancelling haste level " .. cancel_haste_number .. " and below.")
			else
				windower.add_to_chat(122, cancel_haste_number .. " is not between 0 and 2")
			end
		end
		return true
	end
	return false
end

windower.register_event('action', parse_action)
windower.register_event('gain buff', gain_buff)
windower.register_event('lose buff', lose_buff)
register_unhandled_command(parse_command)