_addon.name     = 'voidwatch'
_addon.author   = 'Dabidobido'
_addon.version  = '0.3'
_addon.commands = {'vw'}

-- copied lots of code from https://github.com/Muddshuvel/Voidwatch/blob/master/voidwatch.lua

require('logger')
require('coroutine')
packets = require('packets')
res = require('resources')
config = require('config')

local default_settings = {
	["displacers"] = 5,
}

local settings = config.load(default_settings)

local bags = {
    'inventory',
    'safe',
    'safe2',
    'storage',
    'locker',
    'satchel',
    'sack',
    'case',
    'wardrobe',
    'wardrobe2',
    'wardrobe3',
    'wardrobe4',
}

local cells = {
    ['Cobalt Cell'] = 3434,
    ['Rubicund Cell'] = 3435,
    ['Phase Displacer'] = 3853,
}

local phase_cell_options = {
	[1] = 17,
	[2] = 33,
	[3] = 49,
	[4] = 65,
 	[5] = 81,
}

local voidwatch_officers = {
	[235] = { option_index = 2, cobalt_unknown1 = 769, rubicund_unknown1 = 770 },
}

local function leader()
    local self = windower.ffxi.get_player()
    local party = windower.ffxi.get_party()
    return (party.alliance_leader == self.id) or ((party.party1_leader == self.id) and (not party.alliance_leader)) or (not party.party1_leader)
end

local function get_mob_by_name(name)
    local mobs = windower.ffxi.get_mob_array()
    for i, mob in pairs(mobs) do
        if (mob.name == name) and (math.sqrt(mob.distance) < 6) then
            return mob
        end
    end
end

local function poke_thing(thing)
    local npc = get_mob_by_name(thing)
    if npc then
        local p = packets.new('outgoing', 0x1a, {
            ['Target'] = npc.id,
            ['Target Index'] = npc.index,
        })
        packets.inject(p)
    end
end

local function poke_rift()
	local npc = get_mob_by_name('Planar Rift')
	if npc then
		log('poke rift')
		wait_for_rift_0x34 = true
		poke_thing('Planar Rift')
	end
end

local function poke_officer()
	local npc = get_mob_by_name('Voidwatch Officer')
	if npc then
		log('poke officer')
		wait_for_officer_0x34 = true
		poke_thing('Voidwatch Officer')
	end
end

local function poke_ardrick()
	local npc = get_mob_by_name('Ardrick')
	if npc then
		log('poke_ardrick')
		wait_for_adrick_0x34 = true
		poke_thing('Ardrick')
	end
end

local function trade_cells()
    log('trade cells')
    local npc = get_mob_by_name('Planar Rift')
    if npc then
        local trade = packets.new('outgoing', 0x36, {
            ['Target'] = npc.id,
            ['Target Index'] = npc.index,
        })
        local remaining = {
            cobalt = 1,
            rubicund = 1,
            phase = settings["displacers"],
        }
        local idx = 1
        local n = 0
        local inventory = windower.ffxi.get_items(0)
        for index = 1, inventory.max do
            if (remaining.cobalt > 0) and (inventory[index].id == cells['Cobalt Cell']) then
                trade['Item Index %d':format(idx)] = index
                trade['Item Count %d':format(idx)] = 1
                idx = idx + 1
                remaining.cobalt = 0
                n = n + 1
            elseif (remaining.rubicund > 0) and (inventory[index].id == cells['Rubicund Cell']) then
                trade['Item Index %d':format(idx)] = index
                trade['Item Count %d':format(idx)] = 1
                idx = idx + 1
                remaining.rubicund = 0
                n = n + 1
            elseif (remaining.phase > 0) and (inventory[index].id == cells['Phase Displacer']) then
                local count = 0
                if (inventory[index].count >= remaining.phase) then
                    count = remaining.phase
                else
                    count = inventory[index].count
                end
                trade['Item Index %d':format(idx)] = index
                trade['Item Count %d':format(idx)] = count
                idx = idx + 1
                remaining.phase = remaining.phase - count
                n = n + count
            end
        end
        trade['Number of Items'] = n
        packets.inject(trade)
		coroutine.schedule(poke_rift, 1)
    end
end

local function handle_command(...)
    local args = {...}
    if args[1] == "t" then
        trade_cells()
	elseif args[1] == "bc" then
		buying_cobalt = true
		poke_officer()
	elseif args[1] == "br" then
		buying_rubicund = true
		poke_officer()
	elseif args[1] == "bp" and args[2] then
		number_to_buy = tonumber(args[2])
		if number_to_buy then
			if number_to_buy >= 1 and number_to_buy <= 99 then
				poke_ardrick()
			else
				log("Number must be between 1 and 99")
			end
		end
	elseif args[1] == "setp" and args[2] then
		local number = tonumber(args[2])
		if number then
			if number >= 1 and number <= 5 then
				settings["displacers"] = number
				config.save(settings)
				log("Using " .. number .. " of phase displacers each fight.")
			else
				log("Number must be between 1 and 5")
			end
		end
    else
        notice('//vw t: trade cells and displacers and start fight')
		notice('//vw bc: buy 12 cobalt cells from nearby Voidwatch Officer')
		notice('//vw br: buy 12 rubicund cells from nearby Voidwatch Officer')
		notice('//vw bp (number): buy (number) phase displacers from Ardrick')
		notice('//vw setp (number): set number of phase displacers to use')
    end
end

local function start_fight()
	log('start fight')
	local p = packets.new('outgoing', 0x5b, {
            ['Target'] = npc_id,
            ['Target Index'] = npc_index,
			['Menu ID'] = menu_id,
			['Zone'] = zone,
			['Option Index'] = phase_cell_options[settings["displacers"]],
			['_unknown1'] = 0,
		})
	packets.inject(p)
end

local function buy_cell()
	log('buying cells')
	local p = packets.new('outgoing', 0x5b, {
            ['Target'] = npc_id,
            ['Target Index'] = npc_index,
			['Menu ID'] = menu_id,
			['Zone'] = zone,
			['Option Index'] = voidwatch_officers[zone].option_index,
			['_unknown1'] = cell_unknown,
		})
	packets.inject(p)
end

local function buy_phase()
	log('buying ' .. number_to_buy .. ' phase displacers')
	local p = packets.new('outgoing', 0x5b, {
            ['Target'] = npc_id,
            ['Target Index'] = npc_index,
			['Menu ID'] = menu_id,
			['Zone'] = zone,
			['Option Index'] = 1,
			['_unknown1'] = number_to_buy,
		})
	packets.inject(p)
end

local function parse_menu_data(p)
	npc_id = p['NPC']
	npc_index = p['NPC Index']
	menu_id = p['Menu ID']
	zone = p['Zone']
end

local function parse_incoming(id, data)
	if id == 0x34 then
		if wait_for_rift_0x34 then
			wait_for_rift_0x34 = false
			local p = packets.parse('incoming', data)
			parse_menu_data(p)
			coroutine.schedule(start_fight, 0.1)
			return true
		elseif wait_for_officer_0x34 then
			wait_for_officer_0x34 = false
			local p = packets.parse('incoming', data)
			parse_menu_data(p)
			if voidwatch_officers[zone] then
				if buying_cobalt then
					buying_cobalt = false
					cell_unknown = voidwatch_officers[zone].cobalt_unknown1
				elseif buying_rubicund then
					buying_rubicund = false
					cell_unknown = voidwatch_officers[zone].rubicund_unknown1
				else
					cell_unknown = nil
				end
				if cell_unknown then
					coroutine.schedule(buy_cell, 0.1)
					return true
				else
					log("Didn't set buying_cobalt or buying_rubicund")
				end
			else
				log("No info for voidwatch officer in zone " .. zone)
			end
		elseif wait_for_adrick_0x34 then
			wait_for_adrick_0x34 = false
			local p = packets.parse('incoming', data)
			parse_menu_data(p)
			coroutine.schedule(buy_phase, 0.1)
			return true
		end
	end
end

windower.register_event('addon command', handle_command)
windower.register_event('incoming chunk', parse_incoming)