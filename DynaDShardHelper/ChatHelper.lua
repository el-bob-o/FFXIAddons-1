SayMode = 0
PartyMode = 4
WindowerMode = -1

local chatHelper = {
	ChatMaxLength = 120,
	PrintMode = 4, -- Party Mode
	Lines = {},
	ChatDelay = 4, -- I get errors at 2 seconds, 4 seconds seems okay
}

function chatHelper.clear()
	chatHelper.Lines = {}
end

function chatHelper.add_line(line)
	table.insert(chatHelper.Lines, line)
end

function chatHelper.print_lines()
	if chatHelper.PrintMode == WindowerMode or chatHelper.PrintMode == SayMode or chatHelper.PrintMode == PartyMode then
		if chatHelper.PrintMode == WindowerMode then
			for k, line in pairs(chatHelper.Lines) do
				windower.add_to_chat(122, line)
			end
		else
			local prefix = nil
			if chatHelper.PrintMode == SayMode then 
				prefix = "/s "
			elseif chatHelper.PrintMode == PartyMode then 
				prefix = "/p "
			end
			if prefix then
				local chatLines = {}
				local printString = ""
				for k, line in pairs(chatHelper.Lines) do
					if string.len(printString) == 0 then
						printString = prefix .. line -- first line
					else
						if chatHelper.ChatMaxLength - string.len(printString) - 1 - string.len(line) >= 0 then
							printString = printString .. "\n" .. line
						else
							table.insert(chatLines, printString)
							printString = ""
						end			
					end
				end
				chatHelper.ChatSchedule = 0.0
				for k, line in pairs(chatLines) do
					windower.chat.input:schedule(chatHelper.ChatSchedule, line)
					chatHelper.ChatSchedule = chatHelper.ChatSchedule + chatHelper.ChatDelay
				end
			end
		end
	else
		windower.add_to_chat(122, "Invalid chat channel!")
	end
end

return chatHelper