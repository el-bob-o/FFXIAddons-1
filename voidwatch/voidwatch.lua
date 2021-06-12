_addon.name     = 'voidwatch'
_addon.author   = 'Dabidobido'
_addon.version  = '0.1'
_addon.commands = {'vw'}

-- copied lots of code from https://github.com/Muddshuvel/Voidwatch/blob/master/voidwatch.lua

require('logger')
require('coroutine')
packets = require('packets')
res = require('resources')

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
	log('poke rift')
	wait_for_rift_0x34 = true
	poke_thing('Planar Rift')
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
            phase = 5,
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

local function escape()
	log('escaping')
	while escaping do
		windower.send_command('setkey escape down')
		coroutine.sleep(.2)
		windower.send_command('setkey escape up')
		coroutine.sleep(1)
	end
end

local function handle_command(...)
    local args = {...}
    if args[1] == "t" then
        trade_cells()
    else
        error("unknown command %s":format(cmd))
    end
end

local function parse_outgoing(id, data)
    if id == 0x5b then
		if wait_for_rift_0x5b then
			wait_for_rift_0x5b = false
			escaping = false
			log('start fight')
			local p = packets.parse('outgoing', data)
			p['Option Index'] = 0x51
			p['_unknown1'] = 0
			return packets.build(p)
		end
    end
end

local function parse_incoming(id, data)
	if id == 0x34 then
		if wait_for_rift_0x34 then
			wait_for_rift_0x34 = false
			wait_for_rift_0x5b = true
			escaping = true
			coroutine.schedule(escape, 1)
		end
	end
end

windower.register_event('addon command', handle_command)
windower.register_event('incoming chunk', parse_incoming)
windower.register_event('outgoing chunk', parse_outgoing)