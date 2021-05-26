include("MasterGearList.lua")
texts = require('texts')

ranger_info = [[${ammo_name}:${ammo_count}
Flurry: ${flurry|0}
Hover Shot: ${distance|Off|%.2f}
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
	last_shot_position = nil
	cancel_haste = true
	
	get_set_for_job("RNG", sets)
		
	Modes = { 
		{ name = "RangedIdleDT", set = sets["RangedIdleDT"] },
		{ name = "MeleeHybrid", set = sets["MeleeHybrid"] },
	}
		
	sets.Idle = set_combine(sets["RangedIdleDT"], sets["IdleRegen"], sets["Movement"])
	
	sets["Flurry1"] = set_combine(sets["Flurry2"], sets["Flurry1"])
	sets["Flurry0"] = set_combine(sets["Flurry1"], sets["Flurry0"])
	
	sets["Hot Shot"] = set_combine(sets["MagicAtk"], sets["Fotia"])
	sets["Trueflight"] = sets["MagicAtk"]
	sets["Wildfire"] = sets["MagicAtk"]
	sets["Savage Blade"] = sets["STR_Melee_WS"]	
	sets["Last Stand"] = set_combine(sets["AGI_Ranged_WS"], sets["Fotia"])
	sets["Ruinator"] = set_combine(sets["STR_Melee_WS"], sets["Fotia"])
	
	setup_text_window()
	check_buffs()
	update_rng_info()
	
	print_mode()
	send_command('@input /macro book 7')
end
 
function precast(spell)
	if spell.action_type == 'Magic' then
		equip(sets["Fastcast"])
	elseif spell.action_type == "Ranged Attack" then
		equip(get_preshot_set())
    elseif spell.type=="WeaponSkill" then
		local setToUse = {}
        if sets[spell.english] then
			setToUse = sets[spell.english]
		end
		local maxTP = 3000
		if player.equipment.range == "Fomalhaut" and spell.skill == "Marksmanship" then
			maxTP = maxTP - 500
		end
		if player.sub_job == "WAR" then
			maxTP = maxTP - 200
		end
		if player.tp < maxTP then
			setToUse = set_combine(setToUse, sets["TPBonus"])
		end
		if CPMode then setToUse = set_combine(setToUse, sets["CP"]) end
		if spell.element == world.weather_element or spell.element == world.day_element then 
			setToUse = set_combine(setToUse, sets["WeatherObi"])
		end
		equip(setToUse)
	elseif sets[spell.english] then
        equip(sets[spell.english])
    end
end

function midcast(spell)
	if spell.action_type == "Ranged Attack" then
		local setToUse = sets["Midshot"]
		if DoubleShot then setToUse = set_combine(setToUse, sets["Double Shot"]) end
		if CPMode then setToUse = set_combine(setToUse, sets["CP"]) end
		equip(setToUse)
	end
end
 
function aftercast(spell)
	if spell.action_type == "Ranged Attack" 
	or (spell.type == "WeaponSkill" and (spell.skill == "Marksmanship" or spell.skill == "Archery")) then
		local player = windower.ffxi.get_mob_by_target('me')
		if player then 
			last_shot_position = player
		end
	end
    if player.status=='Engaged' then
        equip(Modes[Mode].set)
    else
        equip(sets.Idle)
    end
	update_rng_info()
end
 
function status_change(new,old)
	if new == 'Engaged' then
		equip(Modes[Mode].set)
	elseif T{'Idle','Resting'}:contains(new) then
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
	elseif args[1] == "cancelhaste" then
		if cancel_haste == false then
			add_to_chat(122, "Cancelling Haste Buffs")
			cancel_haste = true
		elseif cancel_haste == true then
			add_to_chat(122, "Keeping Haste Buffs")
			cancel_haste = false
		end
	else
		master_gear_list_command(args)
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
	if Flurry == 0 then return sets["Flurry0"]
	elseif Flurry == 1 then return sets["Flurry1"]
	else return sets["Flurry2"]
	end
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
	if cancel_haste then
		for k, _buff_id in pairs(playerbuffs) do
			if _buff_id == 33 then 
				cancel_buff(33)
				break
			elseif _buff_id == 580 then
				cancel_buff(580)
				break
			end
		end
	end
end

function update_rng_info()
	local items = windower.ffxi.get_items()
	if items.equipment.ammo and string.len(items.equipment.ammo) > 0 then
		ranger_info_hub.ammo_name = player.equipment.ammo
		local ammo_item = windower.ffxi.get_items(items.equipment.ammo_bag, items.equipment.ammo)
		if ammo_item then 
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

actor_started_flurry = 0
flurry_started = 0

function rng_action_helper(act)
	if act.category == 8 then
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				actor_started_flurry = act.actor_id
				for k2, v2 in pairs(v.actions) do
					if v2.param == 845 then flurry_started = 1
					elseif v2.param == 846 then flurry_started = 2
					end
				end
			end
		end
	elseif act.category == 4 then -- finish casting spell
		for k, v in pairs(act.targets) do
			if v.id == player.id then
				if act.param == 845 or act.param == 846 then -- flurry
					if act.actor_id == actor_started_flurry then
						if flurry_started > Flurry then 
							Flurry = flurry_started
							update_rng_info()
						end
					end
				end
			end
		end
	elseif act.category == 2 then -- ranged attack
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				for k2, v2 in pairs(v.actions) do
					ranger_info_hub.dmg = v2.param
					if v2.message == 352 then 
						ranger_info_hub.distance_correction = "..."
					elseif v2.message == 576 then
						ranger_info_hub.distance_correction = "Squarely."
					elseif v2.message == 577 then
						ranger_info_hub.distance_correction = "True!"
					end
				end
			end
		end
	elseif act.category == 3 then -- ws
		if act.actor_id == player.id then
			for k,v in pairs(act.targets) do
				for k2, v2 in pairs(v.actions) do
					ranger_info_hub.dmg = v2.param
				end
			end
		end
	end
end

function update_hover_shot_info()
	if HoverShot then
		ranger_info_hub.distance = 0
		local player = windower.ffxi.get_mob_by_target('me')
		if player and last_shot_position ~= nil then
			local x = math.abs(last_shot_position.x - player.x)
			local y = math.abs(last_shot_position.y - player.y)
			local z = math.abs(last_shot_position.z - player.z)
			x = (x*x)
			y = (y*y)
			z = (z*z)
			ranger_info_hub.distance = math.sqrt(x + y + z)
		end
	else
		ranger_info_hub.distance = nil
	end
end

function cancel_buff(id)
	windower.packets.inject_outgoing(0xF1,string.char(0xF1,0x04,0,0,id%256,math.floor(id/256),0,0)) -- Inject the cancel packet
end

windower.register_event('action', rng_action_helper)
windower.register_event('prerender', update_hover_shot_info)