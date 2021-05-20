_addon.name = 'Mandragora Mania Bot'
_addon.author = 'Dabidobido'
_addon.version = '1.0.0'
_addon.commands = {'mmbot'}

packets = require('packets')
require('logger')

debugging = false

npc_id = 17740023 -- port bastok chacharoon
menu_id = 686 -- start menu
game_menu_id = 688
delay = 0.5

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

game_state = 0 -- 0 = init, 1 = started
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
		notice("Stopping.")
		for k, v in pairs(coroutines) do
			coroutine.close(v)
		end
		coroutines = {}
	end
end)

windower.register_event('incoming chunk', function(id, data)
	if times_to_do >= 1 then
		if id == 0x34 then
			local p = packets.parse('incoming',data)
			if p then
				if p['NPC'] == npc_id then
					if debugging then notice("Got menu packet menu id " .. p['Menu ID']) end
					if game_state == 0 then
						if p['Menu ID'] == game_menu_id then
							if debugging then notice("Game State Start") end
							game_state = 1
							reset_state()
						end
					elseif game_state == 2 then
						if p['Menu ID'] == menu_id then
							for k, v in pairs(coroutines) do
								coroutine.close(v)
							end
							coroutines = {}
							notice("Doing " .. times_to_do .. " time/s.")
							game_state = 0
							reset_state()
							navigate_to_menu_option(1, 3)
						end
					end
				end
			end
		elseif id == 0x02A then 
			local p = packets.parse('incoming',data)
			if p then
				if p["Player"] == npc_id then -- game ended
					game_state = 2
					times_to_do = times_to_do - 1
					if debugging then notice("Game Ended") end
				end
			end
		end
	end
end)

function reset_state()
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
end

windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
	if times_to_do >= 1 then
		if id == 0x5b then
			local p = packets.parse("outgoing", original)
			if p then
				if p['Menu ID'] == game_menu_id then
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
					elseif p['Option Index'] == ack then
						if debugging then notice("Ack") end
						waiting_for_ack = nil
						if player_turn then 
							if debugging then notice("scheduling do_player_turn in " .. ack_delay) end
							coroutine.schedule(do_player_turn, ack_delay)
						end
					elseif p['Option Index'] == quit_option_index then
						game_state = 2
					end
				end
			end
		end
	end
end)

function do_player_turn()
	if not player_turn then return end
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
			if game_board.area1 == 0 and game_board.area3 == 0 and game_board.area5 == 0
			and game_board.area6 == 0 and game_board.area7 == 0 and game_board.area8 == 0 then
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
	if debugging then notice("put_mandies_in_next_area " .. tostring(right) .. " " .. area) end
	if area == 5 and right then
		if not player_turn then
			add_mandy_to_area(6)
			area = 6
		else
			area = -1
		end
		return not right, area
	elseif area == 8 and not right then
		if player_turn then
			add_mandy_to_area(1)
			area = 1
		else 
			area = -2 
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

function set_key_enter_up()
	windower.send_command('setkey enter up')
end

function navigate_to_menu_option(option_index, override_delay)
	for k, v in pairs(coroutines) do
		coroutine.close(v)
	end
	coroutines = {}
	if debugging then notice("Navigate to " .. option_index) end
	local next_delay = 1
	if override_delay then next_delay = override_delay end
	local times_to_press_down = option_index - 1
	if times_to_press_down >= 1 then 
		for i = 1, times_to_press_down, 1 do
			if debugging then notice("Press down") end
			table.insert(coroutines, coroutine.schedule(set_key_down_down, next_delay))
			table.insert(coroutines, coroutine.schedule(set_key_down_up, next_delay + 0.1))
			next_delay = next_delay + delay 
		end	
	end
	if debugging then notice("Press enter") end
	table.insert(coroutines, coroutine.schedule(set_key_enter_down, next_delay))
	table.insert(coroutines, coroutine.schedule(set_key_enter_up, next_delay + 0.1))
end

windower.register_event('prerender', function()
	if waiting_for_ack and os.time() - waiting_for_ack > time_to_wait_for_ack then
		if debugging then notice("Waited more than " .. time_to_wait_for_ack .. " seconds, doing player turn") end
		waiting_for_ack = nil
		do_player_turn()
	end
end)