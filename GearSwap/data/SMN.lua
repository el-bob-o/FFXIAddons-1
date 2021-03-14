include('MasterGearList.lua')

function get_sets()
	CPMode = false
	
	sets = get_set_for_job("SMN")
	
	send_command('@input /macro book 4;wait 1;input /macro set 1')
end

function precast(spell)
	if sets[spell.english] then
		equip(sets[spell.english])
	end 
end
 
function midcast(spell)
	if (spell.type=="BloodPactWard" or spell.type=="BloodPactRage") then
        if not buffactive["Astral Conduit"] then
            equip(sets["PrecastBP"])
        end
	elseif sets[spell.english] then
		equip(sets[spell.english])
	end
end
 
function aftercast(spell)
	equip(sets["Idle"])
end

function pet_midcast(spell)
	equip(sets["BPDmg"])
end
 
windower.register_event('zone change', function()
	if world.area:contains("Adoulin") then
	else
		equip(sets["Idle"])
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
	if args[1] == 'cp' then
		if CPMode == false then
			add_to_chat(122, "CP Mode on")
			enable("back")
			equip(sets["CP"])
			disable("back")
			CPMode = true
		elseif CPMode == true then
			add_to_chat(122, "CP Mode off")
			enable("back")
			CPMode = false
		end
	else
		master_gear_list_command(args)
	end
end