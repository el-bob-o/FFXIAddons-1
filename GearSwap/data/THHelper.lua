-- declare a sets.TH and call on_status_change_for_th from your gearswap status change
-- set AmmoDisabled to true if you need to use a ranged weapon and your TH set has an ammo item

MobsTagged = {}
TimeToDead = 300 -- 5mins then remove from table
THMode = 1
THModes = { 
	{ name = "Off", 		thfMain = false,	onEngage = false, 	fulltime = false },
	{ name = "Tag", 		thfMain = false, 	onEngage = true, 	fulltime = false },
	{ name = "FullTime", 	thfMain = true, 	onEngage = true, 	fulltime = true },
}

SlotsUsed = S{}
AmmoDisabled = false

function parse_th_command(args)
	if args[2] and type(tonumber(args[2])) == 'number' then
		local nextMode = tonumber(args[2])
		if THModes[nextMode] == nil then
			add_to_chat(122, "Invalid TH mode number")
		else
			if THModes[nextMode].thfMain == false then
				THMode = nextMode
			elseif THModes[nextMode].thfMain and player.main_job == "THF" then
				THMode = nextMode
			else
				add_to_chat(122, "Invalid TH mode number")
			end
		end
		print_th_mode()
	else		
		THMode = THMode + 1		
		if THModes[THMode] == nil or (THModes[THMode].thfMain and player.main_job ~= "THF") then 
			THMode = 1
		end
		print_th_mode()
	end
end

function equip_th()
	if THModes[THMode].onEngage then
		equip(sets["TH"])
		if THModes[THMode].fulltime then
			for slot,item in pairs(sets["TH"]) do
				SlotsUsed:append(slot)
			end
			disable(SlotsUsed)
		end
	end
end

function unlock_th()
	for index, slot in pairs(SlotsUsed) do
		if AmmoDisabled then 
			if slot ~= "ammo" then enable(slot) end
		else
			enable(slot)
		end
	end
	SlotsUsed = S{}
end

function on_target_change_for_th(new_index, old_index)
	if gearswap.gearswap_disabled then return end
    -- Only care about changing targets while we're engaged, either manually or via current target death.
    if player.status == 'Engaged' then
       if THModes[THMode].onEngage then
			equip_th()
	   end
    end
end

function parse_action(act)
	if not THModes[THMode].onEngage then return end	
	if act.actor_id == windower.ffxi.get_player().id then -- add to MobsTagged if player initiated attack
		if act.category == 1 then -- melee
			for index, target in pairs(act.targets) do				
				MobsTagged[target.id] = os.clock()
			end
		end
	elseif MobsTagged[act.actor_id] then -- update timeToDead
		MobsTagged[act.actor_id] = os.clock()
	end
	
end

function clear_tags()
	MobsTagged = {}
end

function mob_tagged(mobId)
	return MobsTagged[mobId] ~= nil
end

function clean_up_tags(new, old)
	-- clean up stuff that haven't done anything for 5 mins
	local timeToCheck = os.clock() - TimeToDead
	for id, timeTagged in pairs(MobsTagged) do
		if timeTagged < timeToCheck then
			MobsTagged[id] = nil
		end
	end
end

function print_th_mode()
	local printString = "Current THMode: "
	local isThfMain = player.main_job == "THF"
	for i = 1, #THModes, 1 do
		local toPrint = THModes[i].thfMain == false or (THModes[i].thfMain == true and isThfMain)
		if toPrint then
			if i == THMode then
				printString = printString .. "[" .. i .. ":" .. THModes[i].name .. "] "
			elseif THModes[i] == nil then
				break
			else
				printString = printString .. i .. ":" .. THModes[i].name .. " "
			end
		end
	end	
	add_to_chat(122, printString)
end

function check_mode(modeNumber)
	add_to_chat(122, modeNumber)
	if THModes[modeNumber] == nil then
		THMode = 1
	else
		if THModes[modeNumber].thfMain == false then 
			THMode = modeNumber
		elseif THModes[modeNumber].thfMain and player.main_job == "THF" then
			THMode = modeNumber
		else
			THMode = 1
		end
	end
end

function on_status_change_for_th(new_status, old_status)
    if new_status == "Engaged" then -- engaged
        equip_th()
    elseif new_status == "Idle" then
        unlock_th()
    end
end

function on_incoming_chunk_for_th(id, data, modified, injected, blocked)
    if id == 0x29 then
        local target_id = data:unpack('I',0x09)
        local message_id = data:unpack('H',0x19)%32768

        -- Remove mobs that die from our tagged mobs list.
        if MobsTagged[target_id] then
            -- 6 == actor defeats target
            -- 20 == target falls to the ground
            if message_id == 6 or message_id == 20 then
                MobsTagged[target_id] = nil
            end
        end
    end
end

windower.register_event('action', parse_action)
windower.register_event('target change', on_target_change_for_th)
windower.raw_register_event('incoming chunk', on_incoming_chunk_for_th)
windower.register_event('zone change', clear_tags)
windower.register_event('time change', clean_up_tags)