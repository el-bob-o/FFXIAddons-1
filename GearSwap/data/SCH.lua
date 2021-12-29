include("MasterGear/MasterGearLua.lua")

maintain_black = false
maintain_white = false

function custom_get_sets()
	ws = {}
	ws["Flash Nova"] = { set = sets["Flash Nova"], tp_bonus = false }
	ws["Shining Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Seraph Strike"] = { set = sets["Flash Nova"], tp_bonus = true }
	ws["Myrkr"] = { set = sets["Myrkr"], tp_bonus = true }
		
	sets["Midcast_Shell"] = sets["EnhDur"]
	sets["Midcast_Shell II"] = sets["EnhDur"]
	sets["Midcast_Shell III"] = sets["EnhDur"]
	sets["Midcast_Shell IV"] = sets["EnhDur"]
	sets["Midcast_Shell V"] = sets["EnhDur"]
	sets["Midcast_Protect"] = sets["EnhDur"]
	sets["Midcast_Protect II"] = sets["EnhDur"]
	sets["Midcast_Protect III"] = sets["EnhDur"]
	sets["Midcast_Protect IV"] = sets["EnhDur"]
	sets["Midcast_Protect V"] = sets["EnhDur"]
	
	sets["Midcast_Haste"] = sets["EnhDur"]
	sets["Midcast_Klimaform"] = sets["EnhDur"]
	sets["Midcast_Sandstorm"] = sets["EnhDur"]
	sets["Midcast_Rainstorm"] = sets["EnhDur"]
	sets["Midcast_Windstorm"] = sets["EnhDur"]
	sets["Midcast_Firestorm"] = sets["EnhDur"]
	sets["Midcast_Hailstorm"] = sets["EnhDur"]
	sets["Midcast_Thunderstorm"] = sets["EnhDur"]
	sets["Midcast_Voidstorm"] = sets["EnhDur"]
	sets["Midcast_Aurorastorm"] = sets["EnhDur"]
	sets["Midcast_Sandstorm II"] = sets["EnhDur"]
	sets["Midcast_Rainstorm II"] = sets["EnhDur"]
	sets["Midcast_Windstorm II"] = sets["EnhDur"]
	sets["Midcast_Firestorm II"] = sets["EnhDur"]
	sets["Midcast_Hailstorm II"] = sets["EnhDur"]
	sets["Midcast_Thunderstorm II"] = sets["EnhDur"]
	sets["Midcast_Voidstorm II"] = sets["EnhDur"]
	sets["Midcast_Aurorastorm II"] = sets["EnhDur"]
	sets["Midcast_Animus Augeo"] = sets["EnhDur"]
	sets["Midcast_Animus Minuo"] = sets["EnhDur"]
	sets["Midcast_Adloquium"] = sets["EnhDur"]
	
	sets["Midcast_Regen V"] = sets["EnhDur"]
	
	sets["Midcast_Fire V"] = sets["MagicBurst"]
	sets["Midcast_Fire IV"] = sets["MagicBurst"]
	sets["Midcast_Fire III"] = sets["MagicBurst"]
	sets["Midcast_Fire II"] = sets["MagicBurst"]
	sets["Midcast_Fire"] = sets["MagicBurst"]
	sets["Midcast_Blizzard V"] = sets["MagicBurst"]
	sets["Midcast_Blizzard IV"] = sets["MagicBurst"]
	sets["Midcast_Blizzard III"] = sets["MagicBurst"]
	sets["Midcast_Blizzard II"] = sets["MagicBurst"]
	sets["Midcast_Blizzard"] = sets["MagicBurst"]
	sets["Midcast_Aero V"] = sets["MagicBurst"]
	sets["Midcast_Aero IV"] = sets["MagicBurst"]
	sets["Midcast_Aero III"] = sets["MagicBurst"]
	sets["Midcast_Aero II"] = sets["MagicBurst"]
	sets["Midcast_Aero"] = sets["MagicBurst"]
	sets["Midcast_Stone V"] = sets["MagicBurst"]
	sets["Midcast_Stone IV"] = sets["MagicBurst"]
	sets["Midcast_Stone III"] = sets["MagicBurst"]
	sets["Midcast_Stone II"] = sets["MagicBurst"]
	sets["Midcast_Stone"] = sets["MagicBurst"]
	sets["Midcast_Thunder V"] = sets["MagicBurst"]
	sets["Midcast_Thunder IV"] = sets["MagicBurst"]
	sets["Midcast_Thunder III"] = sets["MagicBurst"]
	sets["Midcast_Thunder II"] = sets["MagicBurst"]
	sets["Midcast_Thunder"] = sets["MagicBurst"]
	sets["Midcast_Water V"] = sets["MagicBurst"]
	sets["Midcast_Water IV"] = sets["MagicBurst"]
	sets["Midcast_Water III"] = sets["MagicBurst"]
	sets["Midcast_Water II"] = sets["MagicBurst"]
	sets["Midcast_Water"] = sets["MagicBurst"]
	
	sets["Midcast_Geohelix"] = sets["MagicBurst"]
	sets["Midcast_Hydrohelix"] = sets["MagicBurst"]
	sets["Midcast_Anemohelix"] = sets["MagicBurst"]
	sets["Midcast_Pyrohelix"] = sets["MagicBurst"]
	sets["Midcast_Cryohelix"] = sets["MagicBurst"]
	sets["Midcast_Ionohelix"] = sets["MagicBurst"]
	sets["Midcast_Noctohelix"] = sets["MagicBurst"]
	sets["Midcast_Luminohelix"] = sets["MagicBurst"]
	
	sets["Midcast_Kaustra"] = sets["MagicBurst"]
	sets["Midcast_Embrava"] = sets["EnhDur"]
	
	sets["Midcast_Cure"] = sets["Cure"]
	sets["Midcast_Cure II"] = sets["Cure"]
	sets["Midcast_Cure III"] = sets["Cure"]
	sets["Midcast_Cure IV"] = sets["Cure"]
	sets["Midcast_Curaga"] = sets["Cure"]
	sets["Midcast_Curaga II"] = sets["Cure"]
	sets["Midcast_Curaga III"] = sets["Cure"]
	
	send_command('@input /macro book 16')
end

function custom_precast(spell)
	if spell.action_type == 'Magic' then
		if sets[modes[mode].name .. "Fastcast"] then equip(sets[modes[mode].name .. "Fastcast"])
		else equip(sets["Fastcast"]) end
		if (spell.type == "BlackMagic" and (buffactive["Dark Arts"] or buffactive["Addendum: Black"]))
		or (spell.type == "WhiteMagic" and (buffactive["Light Arts"] or buffactive["Addendum: White"]))
		then
			equip(sets["GrimoireFastcast"])
		end
		return true
	end
end

function custom_command(args)
	if args[1] == "maintain" and args[2] then
		if args[2] == "black" then
			maintain_black = true
			maintain_white = false
		elseif args[2] == "white" then
			maintain_black = false
			maintain_white = true
		else
			maintain_black = false
			maintain_white = false
		end
		add_to_chat(122, "Maintain Addendum Black: " .. tostring(maintain_black))
		add_to_chat(122, "Maintain Addendum White: " .. tostring(maintain_white))
		check_addendum()
	end
end

function check_addendum()
	if maintain_black then
		if not buffactive["Addendum: Black"] then
			if not buffactive["Dark Arts"] then
				send_command('input /ja "Dark Arts" <me>')
			else
				send_command('input /ja "Addendum: Black" <me>')
			end
		end
	elseif maintain_white then
		if not buffactive["Addendum: White"] then
			if not buffactive["Light Arts"] then
				send_command('input /ja "Light Arts" <me>')
			else
				send_command('input /ja "Addendum: White" <me>')
			end
		end
	end
end

function custom_zone_change()
	if maintain_black then
		maintain_black = false
		add_to_chat(122, "Maintain Addendum Black: " .. tostring(maintain_black))
	end
	if maintain_white then
		maintain_white = false
		add_to_chat(122, "Maintain Addendum White: " .. tostring(maintain_white))
	end
end

windower.register_event('time change', check_addendum)