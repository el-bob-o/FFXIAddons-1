_addon.name = 'Mandragora Mania Bot'
_addon.author = 'Dabidobido'
_addon.version = '1.0.7'
_addon.commands = {'mmbot'}

packets = require('packets')
require('logger')
socket = require('socket')

debugging = false

npc_ids = 
{
	[230] = { npc_id = 17719722, menu_id = 3624, game_menu_id = 3626 }, -- South Sandoria
	[235] = { npc_id = 17740023, menu_id = 686, game_menu_id = 688 }, -- Bastok Markets
	[238] = { npc_id = 17752429, menu_id = 1166, game_menu_id = 1168 }, -- Windurst Waters
}

delay_between_keypress = 0.5
delay_between_key_down_and_up = 0.1

area_1_option_index = 3
area_2_option_index = 19
area_3_option_index = 35
area_4_option_index = 51
area_5_option_index = 67
area_6_option_index = 99
area_7_option_index = 115
area_8_option_index = 131
ack = 227
quit_option_index = 243

zone = nil -- get zone from the incoming and use it for outgoing

game_state = 0 -- 0 = init, 1 = started, 2 = finished
player_turn = true -- assume player go first
game_board = {
	area1 = 3,
	area2 = 3,
	area3 = 3,
	area4 = 3,
	area5 = 3,
	area6 = 3,
	area7 = 3,
	area8 = 3,
}
times_to_do = 0
ack_delay = 1
waiting_for_ack = nil
time_to_wait_for_ack = 5
coroutines = {}
current_zone_id = 0
navigation_finished = false
time_between_0x5b = 1
last_0x5b_time = 0

windower.register_event('addon command', function(...)
	local args = {...}
	if args[1] == "debug" then
		if debugging then 
			debugging = false
			notice("Debug output off")
		else
			debugging = true
			notice("Debug output on")
		end
	elseif args[1] == "start" and args[2] then
		local number = tonumber(args[2])
		if number then 
			times_to_do = number 
			notice("Doing " .. times_to_do .. " time/s.")
		end
	elseif args[1] == "stop" then
		times_to_do = 0
		game_state = 2
		reset_state()
		notice("Stopping.")
		reset_key_coroutine_and_state()
	elseif args[1] == "setdelay" and args[2] and args[3] then
		local number = tonumber(args[3])
		if number then
			if args[2] == "keypress" then
				delay_between_keypress = number
				notice("Delay Between Keypress:" .. delay_between_keypress)
			elseif args[2] == "keydownup" then
				delay_between_key_down_and_up = number
				notice("Delay Between Key Down and Up:" .. delay_between_key_down_and_up)
			elseif args[2] == "ack" then
				ack_delay = number
				notice("Delay After Ack:" .. ack_delay)
			elseif args[2] == "waitforack" then
				time_to_wait_for_ack = number
				notice("Wait For Ack:" .. time_to_wait_for_ack)
			end
		end
	elseif args[1] == "help" then
		notice("//mmbot start <number>: Starts Automating for <number> of games")
		notice("//mmbot stop: Stops automation")
		notice("//mmbot setdelay <keypress / keydownup / ack / waitforack> <number>: Configures the delay for the various events")
		notice("//mmbot debug: Toggles debug output")
	end
end)

windower.register_event('incoming chunk', function(id, data)
	if id == 0x34 then
		local p = packets.parse('incoming',data)
		if p then
			current_zone_id = p['Zone']
			if npc_ids[current_zone_id] then 
				if p['NPC'] == npc_ids[current_zone_id].npc_id then
					if debugging then notice("Got menu packet menu id " .. p['Menu ID']) end
					if game_state == 0 or game_state == 2 then
						if p['Menu ID'] == npc_ids[current_zone_id].game_menu_id then
							if debugging then notice("Game State Start") end
							game_state = 1
							reset_state()
						elseif p['Menu ID'] == npc_ids[current_zone_id].menu_id and times_to_do >= 1 and game_state == 2 then
							reset_key_coroutine_and_state()
							notice("Doing " .. times_to_do .. " time/s.")
							navigate_to_menu_option(1, 3, true)
						end
					end
				end
			elseif debugging then
				notice("Couldn't find zone_id defined in npc_ids " .. current_zone_id)
			end
		end
	elseif id == 0x02A then 
		local p = packets.parse('incoming',data)
		if p then
			if p["Player"] == npc_ids[current_zone_id].npc_id then -- game ended
				game_state = 2
				times_to_do = times_to_do - 1
				navigation_finished = false
				if debugging then notice("Game Ended") end
			end
		end
	end
end)

function reset_state()
	if debugging then notice("reset_state") end
	player_turn = true
	game_board = {
		area1 = 3,
		area2 = 3,
		area3 = 3,
		area4 = 3,
		area5 = 3,
		area6 = 3,
		area7 = 3,
		area8 = 3,
	}
	waiting_for_ack = nil
	navigation_finished = false
end

windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
	if injected or blocked then return end
	if id == 0x5b then
		local p = packets.parse("outgoing", original)
		if p then
			if npc_ids[current_zone_id] then
				if p['Menu ID'] == npc_ids[current_zone_id].game_menu_id and times_to_do >= 1 then
					if p['Option Index'] == ack then
						if debugging then notice("Ack") end
						waiting_for_ack = nil
						if player_turn then 
							if debugging then notice("scheduling do_player_turn in " .. ack_delay) end
							coroutine.schedule(do_player_turn, ack_delay)
						end
					elseif p['Option Index'] == quit_option_index then
						game_state = 2
					else
						-- sometimes got multiple packets for some reason, so will mess up the board
						-- there should be more than 1 second between these board move messages
						local socket_time = socket.gettime()
						if socket_time - last_0x5b_time >= time_between_0x5b then
							last_0x5b_time = socket.gettime()
							navigation_finished = false
							if p['Option Index'] == area_1_option_index then
								update_game_board(1)
							elseif p['Option Index'] == area_2_option_index then
								update_game_board(2)
							elseif p['Option Index'] == area_3_option_index then
								update_game_board(3)
							elseif p['Option Index'] == area_4_option_index then
								update_game_board(4)
							elseif p['Option Index'] == area_5_option_index then
								update_game_board(5)
							elseif p['Option Index'] == area_6_option_index then
								update_game_board(6)
							elseif p['Option Index'] == area_7_option_index then
								update_game_board(7)
							elseif p['Option Index'] == area_8_option_index then
								update_game_board(8)
							end
						else
							if debugging then notice("Not updating board since only " .. socket_time - last_0x5b_time .. "s have passed.") end
						end
					end
				elseif p["Menu ID"] == npc_ids[current_zone_id].menu_id then
					if p['Option Index'] == 0 and p['_unknown1'] == 16384 then
						notice('Escaped from menu')
						reset_key_coroutine_and_state()
						reset_state()
					end
				end
			end
		end
	end
end)

function do_player_turn()
	if game_state ~= 1 or not player_turn then return end
	if debugging then notice("Do Player Turn") end
	local selected_option = false
	if game_board.area5 == 1 then -- multiple turns
		navigate_to_menu_option(5)
		selected_option = true
	elseif game_board.area4 == 2 then
		navigate_to_menu_option(4)
		selected_option = true
	elseif game_board.area3 == 3 then
		navigate_to_menu_option(3)
		selected_option = true
	elseif game_board.area2 == 4 then
		navigate_to_menu_option(2)
		selected_option = true
	elseif game_board.area1 == 5 then
		navigate_to_menu_option(1)
		selected_option = true
	end
	if not selected_option then
		if game_board.area6 == 5 then -- block opponent multiple turn
			if game_board.area5 >= 2 then
				navigate_to_menu_option(5)
				selected_option = true
			elseif game_board.area4 >= 3 then
				navigate_to_menu_option(4)
				selected_option = true
			elseif game_board.area3 >= 4 then
				navigate_to_menu_option(3)
				selected_option = true
			elseif game_board.area2 >= 5 then
				navigate_to_menu_option(2)
				selected_option = true
			elseif game_board.area1 >= 6 then
				navigate_to_menu_option(1)
				selected_option = true
			end
		elseif game_board.area4 == 4 then
			if game_board.area5 >= 3 then
				navigate_to_menu_option(5)
				selected_option = true
			else
				navigate_to_menu_option(4)
				selected_option = true
			end
		elseif game_board.area7 == 3 then
			if game_board.area5 >= 4 then
				navigate_to_menu_option(5)
				selected_option = true
			elseif game_board.area4 >= 5 then
				navigate_to_menu_option(4)
				selected_option = true
			elseif game_board.area3 >= 6 then
				navigate_to_menu_option(3)
				selected_option = true
			elseif game_board.area2 >= 7 then
				navigate_to_menu_option(2)
				selected_option = true
			elseif game_board.area1 >= 8 then
				navigate_to_menu_option(1)
				selected_option = true
			end
		elseif game_board.area2 == 2 then
			if game_board.area5 >= 5 then
				navigate_to_menu_option(5)
				selected_option = true
			elseif game_board.area4 >= 6 then
				navigate_to_menu_option(4)
				selected_option = true
			elseif game_board.area3 >= 7 then
				navigate_to_menu_option(3)
				selected_option = true
			elseif game_board.area4 ~= 2 then
				navigate_to_menu_option(2)
				selected_option = true
			end
		elseif game_board.area8 == 1 then
			if game_board.area5 >= 6 then
				navigate_to_menu_option(5)
				selected_option = true
			elseif game_board.area4 >= 7 then
				navigate_to_menu_option(4)
				selected_option = true
			elseif game_board.area3 >= 8 then
				navigate_to_menu_option(3)
				selected_option = true
			elseif game_board.area2 >= 9 then
				navigate_to_menu_option(2)
				selected_option = true
			elseif game_board.area1 >= 10 then
				navigate_to_menu_option(1)
				selected_option = true
			end
		end
	end
	if not selected_option then -- get points
		if game_board.area5 >= 1 then
			navigate_to_menu_option(5)
			selected_option = true
		elseif game_board.area4 >= 2 then
			navigate_to_menu_option(4)
			selected_option = true
		elseif game_board.area3 >= 3 then
			navigate_to_menu_option(3)
			selected_option = true
		elseif game_board.area2 >= 4 then
			navigate_to_menu_option(2)
			selected_option = true
		elseif game_board.area1 >= 5 then
			navigate_to_menu_option(1)
			selected_option = true
		end
	end
	if not selected_option then -- just move
		if game_board.area2 >= 1 then
			if game_board.area4 ~= 0 and game_board.area3 == 0 and game_board.area5 == 0
			and game_board.area7 == 0 and game_board.area8 == 0 then
				navigate_to_menu_option(4)
				selected_option = true
			else
				navigate_to_menu_option(2)
				selected_option = true
			end
		elseif game_board.area4 >= 1 then
			navigate_to_menu_option(4)
			selected_option = true
		elseif game_board.area5 >= 1 then
			navigate_to_menu_option(5)
			selected_option = true		
		elseif game_board.area3 >= 1 then
			navigate_to_menu_option(3)
			selected_option = true	
		elseif game_board.area1 >= 1 then
			navigate_to_menu_option(1)
			selected_option = true
		end
	end
end

function update_game_board(area_selected)
	if debugging then notice("Area " .. area_selected .. " selected") end
	waiting_for_ack = os.time()
	local right = player_turn
	local mandies = get_mandies_from_area(area_selected)
	if debugging then notice(mandies .. " from area " .. area_selected) end
	for i = 1, mandies, 1 do
		right, area_selected = put_mandies_in_next_area(right, area_selected)
	end
	if player_turn and area_selected ~= -1 then
		player_turn = not player_turn 
		if debugging then notice("Player Turn: " .. tostring(player_turn)) end		
	elseif not player_turn and area_selected ~= -2 then 	
		player_turn = not player_turn 
		if debugging then notice("Player Turn: " .. tostring(player_turn)) end
	end
	if player_turn then
		if game_board.area1 == 0 and game_board.area2 == 0 and game_board.area3 == 0 and game_board.area4 == 0 and game_board.area5 == 0 then
			game_state = 2
			if debugging then notice("Game Ended. Player has no more moves") end
		end
	else
		if game_board.area6 == 0 and game_board.area4 == 0 and game_board.area7 == 0 and game_board.area2 == 0 and game_board.area8 == 0 then
			game_state = 2
			if debugging then notice("Game Ended. Opponent has no more moves") end
		end
	end
end

function get_mandies_from_area(area)
	local ret = 0
	if area == 1 then
		ret = game_board.area1
		game_board.area1 = 0
	elseif area == 2 then
		ret = game_board.area2
		game_board.area2 = 0
	elseif area == 3 then
		ret = game_board.area3
		game_board.area3 = 0
	elseif area == 4 then
		ret = game_board.area4
		game_board.area4 = 0
	elseif area == 5 then
		ret = game_board.area5
		game_board.area5 = 0
	elseif area == 6 then
		ret = game_board.area6
		game_board.area6 = 0
	elseif area == 7 then
		ret = game_board.area7
		game_board.area7 = 0
	elseif area == 8 then
		ret = game_board.area8
		game_board.area8 = 0
	end
	return ret
end

function put_mandies_in_next_area(right, area)
	if area == 5 and right then
		if not player_turn then
			add_mandy_to_area(6)
			area = 6
		else
			area = -1
			if debugging then notice("Player scored") end
		end
		return not right, area
	elseif area == 8 and not right then
		if player_turn then
			add_mandy_to_area(1)
			area = 1
		else 
			area = -2
			if debugging then notice("Opponent scored") end
		end
		return not right, area
	else
		if right then
			if area == -2 then
				add_mandy_to_area(1)
				area = 0 -- +1 later at the end
			elseif area == 1 then
				add_mandy_to_area(2)
			elseif area == 2 then
				add_mandy_to_area(3)
			elseif area == 3 then
				add_mandy_to_area(4)
			elseif area == 4 then
				add_mandy_to_area(5)
			end
			area = area + 1
		else
			if area == -1 then
				add_mandy_to_area(6)
				area = 6
			elseif area == 6 then
				add_mandy_to_area(4)
				area = 4
			elseif area == 4 then
				add_mandy_to_area(7)
				area = 7
			elseif area == 7 then
				add_mandy_to_area(2)
				area = 2
			elseif area == 2 then
				add_mandy_to_area(8)
				area = 8
			end
		end	
	end
	return right, area
end

function add_mandy_to_area(area)
	if debugging then notice("Adding mandy to area " .. area) end
	if area == 1 then
		game_board.area1 = game_board.area1 + 1
	elseif area == 2 then
		game_board.area2 = game_board.area2 + 1
	elseif area == 3 then
		game_board.area3 = game_board.area3 + 1
	elseif area == 4 then
		game_board.area4 = game_board.area4 + 1
	elseif area == 5 then
		game_board.area5 = game_board.area5 + 1
	elseif area == 6 then
		game_board.area6 = game_board.area6 + 1
	elseif area == 7 then
		game_board.area7 = game_board.area7 + 1
	elseif area == 8 then
		game_board.area8 = game_board.area8 + 1
	end
end

function set_key_down_down()
	windower.send_command('setkey down down')
end

function set_key_down_up()
	windower.send_command('setkey down up')
end

function set_key_enter_down()
	windower.send_command('setkey enter down')
end

function set_key_enter_up(from_reset)
	windower.send_command('setkey enter up')
	if not from_reset then
		check_for_0x5b_time = os.time() + time_to_wait_for_ack
		navigation_finished = true
	end
end

function set_key_left_down()
	windower.send_command('setkey left down')
end

function set_key_left_up()
	windower.send_command('setkey left up')
end

function navigate_to_menu_option(option_index, override_delay, from_main_menu)
	reset_key_coroutine_and_state()
	if debugging then notice("Navigate to " .. option_index) end
	if not from_main_menu then navigation_finished = false end
	local next_delay = 1
	if override_delay then next_delay = override_delay end
	local times_to_press_down = option_index - 1
	if times_to_press_down >= 1 then 
		for i = 1, times_to_press_down, 1 do
			table.insert(coroutines, coroutine.schedule(set_key_down_down, next_delay))
			table.insert(coroutines, coroutine.schedule(set_key_down_up, next_delay + delay_between_key_down_and_up))
			next_delay = next_delay + delay_between_keypress 
		end	
	end
	table.insert(coroutines, coroutine.schedule(set_key_enter_down, next_delay))
	table.insert(coroutines, coroutine.schedule(set_key_enter_up, next_delay + delay_between_key_down_and_up))	
end

function reset_key_coroutine_and_state()
	for k, v in pairs(coroutines) do
		coroutine.close(v)
	end
	coroutines = {}
	set_key_enter_up(true)
	set_key_down_up()
	navigation_finished = false
end

windower.register_event('prerender', function()
	if waiting_for_ack and os.time() - waiting_for_ack > time_to_wait_for_ack then
		if debugging then notice("Waited more than " .. time_to_wait_for_ack .. " seconds, doing player turn") end
		waiting_for_ack = nil
		do_player_turn()
	elseif navigation_finished and os.time() > check_for_0x5b_time then
		if debugging then notice("No action detected, redoing action") end
		reset_key_coroutine_and_state()
		local next_delay = 0
		-- reset to first item
		table.insert(coroutines, coroutine.schedule(set_key_left_down, next_delay))
		table.insert(coroutines, coroutine.schedule(set_key_left_up, next_delay + delay_between_key_down_and_up))
		next_delay = next_delay + delay_between_keypress
		table.insert(coroutines, coroutine.schedule(set_key_left_down, next_delay))
		table.insert(coroutines, coroutine.schedule(set_key_left_up, next_delay + delay_between_key_down_and_up))
		next_delay = next_delay + delay_between_keypress
		coroutine.schedule(do_player_turn, next_delay)
	end
end)

windower.register_event('logout', function()
	reset_key_coroutine_and_state()
	reset_state()
end)