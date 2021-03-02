SayMode = 0
PartyMode = 4
WindowerMode = -1

local chatHelper = {
	ChatMaxLength = 120,
	PrintMode = 4, -- Party Mode
	Lines = {},
	ChatDelay = 4, -- I get errors at 2 seconds, 4 seconds seems okay
	NextChat = -1
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
			chatHelper.clear()
		elseif os.time() >= chatHelper.NextChat then
			local prefix = nil
			if chatHelper.PrintMode == SayMode then 
				prefix = "/s "
			elseif chatHelper.PrintMode == PartyMode then
				prefix = "/p "
			end
			if prefix then
				local printString = ""
				local linesToPrint = 0
				for i = 1, #chatHelper.Lines do
					if string.len(printString) == 0 then
						printString = prefix .. chatHelper.Lines[i] -- first line
					else
						if chatHelper.ChatMaxLength - string.len(printString) - 1 - string.len(chatHelper.Lines[i]) >= 0 then
							printString = printString .. "\n" .. chatHelper.Lines[i]
						else
							break
						end
					end
					linesToPrint = i
				end
				for i = 1, linesToPrint do
					table.remove(chatHelper.Lines, 1)
				end
				windower.chat.input(printString)
				chatHelper.NextChat = os.time() + chatHelper.ChatDelay				
			end
		end
	else
		windower.add_to_chat(122, "Invalid chat channel!")
	end
end

return chatHelper