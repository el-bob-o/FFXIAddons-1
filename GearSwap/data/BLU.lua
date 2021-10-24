include("Mastergear/MasterGearLua.lua")

function custom_get_sets()
	learn_blu_mode = false
		
	ws = {}
	ws["Savage Blade"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Expiacion"] = { set = sets["Savage Blade"], tp_bonus = true }
	ws["Black Halo"] = { set = sets["Black Halo"], tp_bonus = true }
	ws["Chant du Cygne"] = { set = sets["Chant Du Cygne"], tp_bonus = false }
	ws["Requiescat"] = { set = sets["Requiescat"], tp_bonus = true }
	ws["Realmrazer"] = { set = sets["Requiescat"], tp_bonus = false }
	ws["Seraph Blade"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Red Lotus Blade"] = { set = sets["MagicAtk"], tp_bonus = true }
	ws["Sanguine Blade"] = { set = sets["Sanguine Blade"], tp_bonus = false }
	
	sets["Sudden Lunge"] = sets["MagicAcc"]
	sets["Osmosis"] = sets["MagicAcc"]
	sets["Dream Flower"] = sets["MagicAcc"]
	sets["Anvil Lightning"] = sets["MagicAtk"]
	sets["Searing Tempest"] = sets["MagicAtk"]
	sets["Spectral Floe"] = sets["MagicAtk"]
	sets["Subduction"] = sets["MagicAtk"]
	sets["Tenebral Crush"] = sets["MagicAtk"]
	sets["Entomb"] = sets["MagicAtk"]
	
	send_command('@input /macro book 9;wait 1;input /macro set 1')
end
 
function custom_midcast(spell)
	if spell.action_type == 'Magic' then
		if spell.english == "Mighty Guard" and buffactive["Diffusion"] then
			equip(sets["DiffusionBuff"])
		elseif sets[spell.english] then 
			equip(sets[spell.english])
		end
		return true
	end
end
  
function custom_command(args)
	if args[1] == "learnblu" then
		if learn_blu_mode == false then
			add_to_chat(122, "Learning BLU Spells on")
			enable('hands')
			equip(sets["LearnBlu"])
			disable('hands')
			learn_blu_mode = true
		elseif learn_blu_mode == true then
			add_to_chat(122, "Learning BLU Spells off")
			enable('hands')
			learn_blu_mode = false
		end
	end
end