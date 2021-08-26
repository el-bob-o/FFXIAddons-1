include("MasterGear/MasterGearFunctions.lua")
include('THHelper/THHelper.lua')
include('HasteTracker/HasteTracker.lua')
texts = require('texts')
packets = require('packets')
require('chat')

ranger_info = [[${ammo_name}:${ammo_count}
Flurry: ${flurry|0}
Hover Shot: ${distance}
True Strike: ${distance_correction}
Last Attack: ${dmg}
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
	
	if not (ranger_info_hub == nil) then
        texts.destroy(ranger_info_hub)
    end
    ranger_info_hub = texts.new(ranger_info, default_settings, default_settings)

    ranger_info_hub:show()
end


function get_sets()
	CPMode = false
	Mode = 1
	Flurry = 0
	DoubleShot = false
	HoverShot = false
	last_shot_position_x = 0
	last_shot_position_y = 0
	last_shot_position_valid = false
	current_position_0x015_x = 0
	current_position_0x015_y = 0
	shot_position_0x015_x = 0 
	shot_position_0x015_y = 0
	AM3Mode = false
	DT = false
	ShootNextPosUpdate = false
	RecordPosNextRangedAttack = false
	HoverShotTarget = nil
	cancel_haste = 2
	
	setup_text_window()
	
	get_set_for_job_from_json("RNG", sets)
		
	Modes = { 
		{ name = "RangedIdleDT", set = sets["RangedIdleDT"] },
		{ name = "MeleeHybrid", set = sets["MeleeHybrid"] },
	}
		
	sets.Idle = set_combine(sets["RangedIdleDT"], sets["IdleRegen"], sets["Movement"])
	
	WS = {}
	WS["Hot Shot"] = { set = set_combine(sets["MagicAtk"], sets["Fotia"], sets["MagicAtkBullet"]), tp_bonus = true }
	WS["Trueflight"] = { set = set_combine(sets["MagicAtk"], sets["MagicAtkBullet"]), tp_bonus = true }
	WS["Wildfire"] = { set = set_combine(sets["MagicAtk"], sets["MagicAtkBullet"]), tp_bonus = false }	
	WS["Last Stand"] = { set = set_combine(sets["Ranged_AGI_WS"], sets["Fotia"], sets["RangedAttackBullet"]), tp_bonus = true }
	WS["Aeolian Edge"] = { set = sets["MagicAtk"], tp_bonus = true }
	WS["Savage Blade"] = { set = sets["STR_Melee_WS"], tp_bonus = true }
	WS["Ruinator"] = { set = set_combine(sets["STR_Melee_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Decimation"] = { set = set_combine(sets["STR_Melee_WS"], sets["Fotia"]), tp_bonus = false }
	WS["Flaming Arrow"] = { set = set_combine(sets["MagicAtk"], sets["Fotia"], sets["Arrow"]), tp_bonus = true }
	WS["Empyreal Arrow"] = { set = set_combine(sets["Ranged_AGI_WS"], sets["Arrow"]), tp_bonus = true }
	WS["Apex Arrow"] = { set = set_combine(sets["Ranged_AGI_WS"], sets["Arrow"]), tp_bonus = false }
	WS["Jishnu's Radiance"] = { set = set_combine(sets["AM3"], sets["Arrow"]), tp_bonus = false }
	
	check_buffs()
	update_rng_info()	
	
	print_mode()
	print_th_mode()
	send_command('@input /macro book 7;wait 1;input /macro set 1')
end
 
function precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
	elseif spell.action_type == "Ranged Attack" then
		equip(get_preshot_set())
    elseif spell.type=="WeaponSkill" then
		if WS[spell.english] then
			local setToUse = WS[spell.english].set
			if WS[spell.english].tp_bonus then
				local maxTP = 3000
				local equipment = windower.ffxi.get_items().equipment
				local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)
				if (res.items[range.id].name == "Fomalhaut" and spell.skill == "Marksmanship")
				or (res.items[range.id].name == "Fail-Not" and spell.skill == "Archery") then
					maxTP = maxTP - 500
				end
				if player.sub_job == "WAR" then
					maxTP = maxTP - 200
				end
				if player.tp < maxTP then
					setToUse = set_combine(setToUse, sets["TPBonus"])
				end
			end
			if CPMode then setToUse = set_combine(setToUse, sets["CP"]) end
			if spell.element == world.weather_element or spell.element == world.day_element then 
				setToUse = set_combine(setToUse, sets["WeatherObi"])
			end
			equip(setToUse)
		end
	elseif sets[spell.english] then
        equip(sets[spell.english])
    end
end

function midcast(spell)
	if spell.action_type == "Ranged Attack" then	
		local setToUse = sets["Midshot"]
		if DT then setToUse = sets["MidshotDT"] end
		if DoubleShot then setToUse = set_combine(setToUse, sets["Double Shot"]) end		
		if buffactive["Aftermath: Lv.3"] then
			local equipment = windower.ffxi.get_items().equipment
			local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)	
			if res.items[range.id].name == "Armageddon" then
				if DT then 
					setToUse = set_combine(setToUse, set["AM3DT"])
				else 
					setToUse = set_combine(setToUse, set["AM3"])
				end
			end
		end
		if buffactive["Barrage"] then setToUse = set_combine(setToUse, sets["Barrage"]) end
		if CPMode then setToUse = set_combine(setToUse, sets["CP"]) end
		equip(setToUse)
	elseif spell.skill == "Elemental Magic" then
		equip(sets["MagicAtk"])
	end
end
 
function aftercast(spell)
    if player.status=='Engaged' then
        equip(Modes[Mode].set)
    else
        equip(sets.Idle)
    end
	if CPMode then equip(sets["CP"]) end
	update_rng_info()
end
 
function status_change(new,old)
	if new == 'Engaged' then
		equip(Modes[Mode].set)
		on_status_change_for_th(new, old)
	elseif T{'Idle','Resting'}:contains(new) then
		on_status_change_for_th(new, old)
		equip(sets.Idle)
    end
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
		equip(set_combine(sets.Idle, sets["Adoulin"]))
	else
		equip(sets.Idle)
	end
end)

function get_distance_sq(playerpos)
	if last_shot_position_valid and playerpos then
		local x = math.abs(last_shot_position_x - playerpos.x)
		local y = math.abs(last_shot_position_y - playerpos.y)
		x = (x*x)
		y = (y*y)
		return x + y
	end
	return 0
end

function check_current_and_player_position(playerpos)
	local x = math.abs(last_shot_position_x - playerpos.x)
	local y = math.abs(last_shot_position_y - playerpos.y)
	x = (x*x)
	y = (y*y)
	return x + y < 0.01
end
 
function self_command(command)
	local args = T{}
	if type(command) == 'string' then
        args = T(command:split(' '))
        if #args == 0 then
            return
        end
    end
	if args[1] == "cp" then
		if CPMode == false then
			add_to_chat(122, "CP Mode on")
			CPMode = true
			equip(sets["CP"])
		elseif CPMode == true then
			add_to_chat(122, "CP Mode off")
			CPMode = false
		end
	elseif args[1] == "mode" then
		if args[2] and type(tonumber(args[2])) == 'number' then
			nextMode = tonumber(args[2])
			if nextMode == nil then
				add_to_chat(122, "Invalid mode number")
			else
				if Modes[nextMode] == nil then
					add_to_chat(122, "Invalid node number")
				else
					Mode = nextMode
					print_mode()
				end
			end
		else
			Mode = Mode + 1
			if Modes[Mode] == nil then
				Mode = 1
			end
			print_mode()
		end
	elseif args[1] == "dt" then
		if DT == false then
			add_to_chat(122, "DT true")
			DT = true
		elseif DT == true then
			add_to_chat(122, "DT false")
			DT = false
		end
	elseif args[1] == "thtagged" then
		if player.status == "Engaged" then
			equip(Modes[Mode].set)
		end
	elseif args[1] == "ra" then
		local playerpos = windower.ffxi.get_mob_by_target('me')
		if HoverShot then
			if last_shot_position_valid then
				local distance = get_distance_sq(playerpos)
				if distance > 1 or HoverShotTarget == nil or HoverShotTarget ~= player.target.id then
					shoot_now_or_wait_for_pos_update(playerpos)
				else
					windower.add_to_chat(123,"Not far enough for hover shot!")
				end
			else
				shoot_now_or_wait_for_pos_update(playerpos)
			end
		else
			shoot_now_or_wait_for_pos_update(playerpos)
		end
	end
end

function shoot_now_or_wait_for_pos_update(playerpos)
	local can_shoot = check_current_and_player_position(playerpos)
	if can_shoot then
		windower.send_command('input /ra <t>')
		shot_position_0x015_x = playerpos.x
		shot_position_0x015_y = playerpos.y
		if HoverShot then
			RecordPosNextRangedAttack = true
		end
	else
		ShootNextPosUpdate = true
		RecordPosNextRangedAttack = false
	end
end

function print_mode()
	printString = "Current Mode: "
	for i = 1, 10, 1 do
		if i == Mode then
			printString = printString .. "[" .. i .. ":" .. Modes[i].name .. "] "
		elseif Modes[i] == nil then
			break
		else
			printString = printString .. i .. ":" .. Modes[i].name .. " "
		end
	end	
	add_to_chat(122, printString)
end

function get_preshot_set()
	local set_to_use = {}
	if Flurry == 0 then set_to_use = sets["Flurry0"]
	elseif Flurry == 1 then set_to_use = sets["Flurry1"]
	else set_to_use = sets["Flurry2"]
	end
	local equipment = windower.ffxi.get_items().equipment
	local range = windower.ffxi.get_items(equipment.range_bag, equipment.range)		
	if res.items[range.id].skill == 25 then -- archery
		set_to_use = set_combine(set_to_use, sets["Arrow"])
	elseif res.items[range.id].skill == 26 then -- marksmanship
		if res.items[range.id].name == "Gastraphetes" then
			set_to_use = set_combine(set_to_use, sets["Bolt"])
		else
			set_to_use = set_combine(set_to_use, sets["RangedAttackBullet"])
		end
	end
	return set_to_use
end

buff_ids = 
T{
	581, -- Flurry II
	265, -- Flurry I
	628, -- Hover Shot
	433, -- Double Shot
}

function check_buffs()
	local playerbuffs = windower.ffxi.get_player().buffs
	local hover_found = false
	local double_found = false
	local AM_found = false
	for k, _buff_id in pairs(playerbuffs) do
		if buff_ids:contains(_buff_id) then
			if not hover_found then
				if _buff_id == 628 then 
					HoverShot = true
					hover_found = true
				end
			end
			if not double_found then
				if _buff_id == 433 then 
					DoubleShot = true
					double_found = true
				end
			end
		end
	end
	if not hover_found then HoverShot = false end
	if not double_found then DoubleShot = false end
	if not AM_found then AM3Mode = false end
end

function update_rng_info()
	local items = windower.ffxi.get_items()
	if items.equipment.ammo and string.len(items.equipment.ammo) > 0 then
		ranger_info_hub.ammo_name = player.equipment.ammo
		local ammo_item = windower.ffxi.get_items(items.equipment.ammo_bag, items.equipment.ammo)
		if ammo_item and ammo_item.id ~= 65535 then 
			ranger_info_hub.ammo_count = ammo_item.count
		else
			ranger_info_hub.ammo_count = 0
		end
	else
		ranger_info_hub.ammo_count = 0
	end
	ranger_info_hub.flurry = Flurry
end

function buff_change(name, gain, buff_details)
	if name == "Flurry" and not gain then
		Flurry = 0
	end
	check_buffs()
	update_rng_info()
end

local spells_started = {}

local function get_flurry_level(id)
	if id == 845 then return 1
	elseif id == 846 then return 2
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

local function set_flurry_level(actor_id)
	if spells_started[actor_id] then
		local level = get_flurry_level(spells_started[actor_id])
		if level > Flurry then Flurry = level end
		spells_started[actor_id] = nil
	end
end

function rng_action_helper(act)
	if act.category == 8 then
		if act.param == 24931 then
			for k, v in pairs(act.targets) do
				if v.id == player.id then
					for k2, v2 in pairs(v.actions) do
						if get_flurry_level(v2.param) > 0 then 
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
						if get_flurry_level(v2.param) > 0 then 
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
				if get_flurry_level(act.param) > 0 then
					set_flurry_level(act.actor_id)
					return
				end
			end
		end
	elseif act.category == 12 then
		if act.param == 28787 then -- ranged attack interrupted
			RecordPosNextRangedAttack = false
		end
	elseif act.category == 2 then -- ranged attack
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				local dmg = 0
				local shots = 0
				if HoverShot then HoverShotTarget = v.id end
				for k2, v2 in pairs(v.actions) do
					dmg = dmg + v2.param
					shots = shots + 1
					if v2.message == 352 then 
						ranger_info_hub.distance_correction = "..."
					elseif v2.message == 576 then
						ranger_info_hub.distance_correction = "Squarely."
					elseif v2.message == 577 then
						ranger_info_hub.distance_correction = "True!"
					end
				end
				if shots == 1 then
					ranger_info_hub.dmg = dmg
				else
					ranger_info_hub.dmg = dmg .. "[" .. shots .. "]"
				end
			end
			if RecordPosNextRangedAttack then
				RecordPosNextRangedAttack = false
				last_shot_position_valid = true
				last_shot_position_x = shot_position_0x015_x
				last_shot_position_y = shot_position_0x015_y
			end
		end
	elseif act.category == 3 then -- ws
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				if HoverShot then HoverShotTarget = v.id end
				for k2, v2 in pairs(v.actions) do
					ranger_info_hub.dmg = v2.param
				end
			end
			if HoverShot then
				local ws = res.weapon_skills[act.param]
				if ws and (ws.skill == 26 or ws.skill == 25)then
					local playerpos = windower.ffxi.get_mob_by_target('me')
					if playerpos then 
						last_shot_position_valid = true
						last_shot_position_x = playerpos.x
						last_shot_position_y = playerpos.y
					end
				end
			end
		end
	end
end

function update_hover_shot_info()
	if HoverShot then
		local playerpos = windower.ffxi.get_mob_by_target('me')
		local distance = math.sqrt(get_distance_sq(playerpos))
		local distance_string = string.format("%.2f", distance)
		if distance >= 1 or HoverShotTarget == nil then distance_string = string.text_color(distance_string, 0, 255, 0)
		else distance_string = string.text_color(distance_string, 255, 0, 0) end
		ranger_info_hub.distance = distance_string
	else
		ranger_info_hub.distance = nil
	end
end

function cancel_buff(id)
	windower.packets.inject_outgoing(0xF1,string.char(0xF1,0x04,0,0,id%256,math.floor(id/256),0,0)) -- Inject the cancel packet
end

function clear_last_shot_position()
	HoverShotTarget = nil
	last_shot_position_valid = false
end

function parse_outgoing(id, original, modified, injected, blocked)
	if id == 0x015 and not injected and not blocked then
		local p = packets.parse('outgoing', original)
		current_position_0x015_x = p['X']
		current_position_0x015_y = p['Y']
		if ShootNextPosUpdate then
			ShootNextPosUpdate = false
			windower.send_command('input /ra <t>')
			RecordPosNextRangedAttack = true
			shot_position_0x015_x = current_position_0x015_x
			shot_position_0x015_y = current_position_0x015_y
		end
	end
end

function parse_action_message(actor_id, target_id, actor_index, target_index, message_id, param_1, param_2, param_3)
	if (message_id == 6 or message_id == 20) and HoverShotTarget ~= nil and target_id == HoverShotTarget then
		clear_last_shot_position()
	end
end

windower.register_event('action', rng_action_helper)
windower.register_event('prerender', update_hover_shot_info)
windower.register_event('zone change', clear_last_shot_position)
windower.register_event('outgoing chunk', parse_outgoing)
windower.register_event('action message', parse_action_message)