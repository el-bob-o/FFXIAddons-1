include("MasterGear/MasterGearLua.lua")

function custom_get_sets()
	cancel_haste = 1
	
	ws = {}
	ws["Victory Smite"] = { set = sets["Victory Smite"], tp_bonus = true }
	ws["Ascetic's Fury"] = { set = sets["Victory Smite"], tp_bonus = true }
	ws["Shijin Spiral"] = { set = sets["Shijin Spiral"], tp_bonus = false }
	ws["Asuran Fists"] = { set = sets["Asuran Fists"], tp_bonus = false }
	ws["Raging Fists"] = { set = sets["Raging Fists"], tp_bonus = true }
	ws["Howling Fist"] = { set = sets["Howling Fist"], tp_bonus = true }
	ws["Dragon Kick"] = { set = sets["Howling Fist"], tp_bonus = true }
	ws["Tornado Kick"] = { set = sets["Howling Fist"], tp_bonus = true }
	
	send_command('@input /macro book 14')
end