--[[
  This is an io library re-creation for gamesense.
  It does not contain all functions of the original io library.
]]

-- Define a local table to represent the io module
local io = {}

-- Define a function to open a file
-- filename: the name of the file to open
-- mode: the mode to open the file in (e.g., "r" for read, "w" for write)
function io.open(filename, mode)
    -- Create a table to represent the file
    local file = {
        mode = mode, -- The mode the file was opened in
        position = 1, -- The current position in the file
    }

    -- If the mode is any of the readable or writable modes, read the file content
    if mode:match("[rawb]+") then
        file.content = readfile(filename) or ""
    end

    -- If the mode is any of the writable modes, clear the file content
    if mode:match("[wb]+") then
        file.content = ""
    end

    -- Define a method to read from the file
    -- format: the format to read in (e.g., "*all" for all, "*n" for number)
    function file:read(format)
        -- If the file is not readable, throw an error
        if not self.mode:match("[rb]+") then
            error("File is not readable.")
        end
    
        local startPos = self.position
        local endPos
    
        if format == "*all" or format == "*a" then
            endPos = #self.content
        elseif format == "*n" then
            local num = tonumber(self.content:match("%d+", startPos))
            return num
        elseif type(format) == "number" and self.mode:match("rb") then
            endPos = startPos + format - 1
        elseif format == "*b" then
            local byteArray = {}
            for i = 1, #self.content do
                byteArray[i] = string.byte(self.content, i)
            end
            return byteArray
        else
            error("Invalid format. : [\""..format.."\"]")
        end
    
        local result = self.content:sub(startPos, endPos)
        self.position = endPos + 1
        return result
    end   

    -- Define a method to iterate over the lines in the file
    function file:lines()
        self.position = 1
        
        return function()
            if self.position > #self.content then
                return nil
            end
            local startPos = self.position
            local endPos = self.content:find("\n", startPos) or #self.content
            self.position = endPos + 1
            
            return self.content:sub(startPos, endPos - 1)
        end
    end

    -- Define a method to write to the file
    -- str: the string to write
    function file:write(str)
        -- If the file is not writable, throw an error
        if not self.mode:match("[wab]+") then
            error("File is not writable.")
        end

        -- If the mode is append, move the position to the end of the content
        if self.mode:match("[ab]+") then
            self.position = #self.content + 1
        end

        local startPos = self.position
        local endPos = self.position + #str - 1

        -- Insert the string at the current position
        self.content = self.content:sub(1, startPos - 1) .. str .. self.content:sub(endPos + 1)
        self.position = endPos + 1
    end

    -- Definea method to flush the file content to disk
    function file:flush()
        -- If the file is not writable, throw an error
        if not self.mode:match("[wab]+") then
            error("File is not writable.")
        end
        -- Write the file content to disk
        writefile(filename, self.content)
    end

    -- Define a method to seek to a position in the file
    -- whence: the reference point ("set", "cur", or "end")
    -- offset: the offset from the reference point
    function file:seek(whence, offset)
        if whence == "set" then
            self.position = offset + 1
        elseif whence == "cur" then
            self.position = self.position + offset
        elseif whence == "end" then
            self.position = #self.content + 1 + offset
        else
            error("Invalid whence.")
        end

        -- Ensure the position is within the file content
        self.position = math.max(1, math.min(self.position, #self.content + 1))

        return self.position - 1
    end

    -- Define a method to close the file
    function file:close()
        -- If the file is writable, flush the content to disk
        if self.mode:match("[wab]+") then
            self:flush()
        end
    end

    return file
end

-- Define a function to iterate over the lines in a file
-- filename: the name of the file to iterate over
function io.lines(filename)
    local file = io.open(filename, "r")
    return file:lines()
end

-- Define a function to write to the output
-- ...: the values to write
function io.write(...)
    local args = {...}
    local str = table.concat(args)
    if not output then
        output = io.open("output.txt", "w")
    end
    print(str)
    output:write(str)
end

-- Define a function to read from the input
-- format: the format to read in (default to "*l")
function io.read(format)
    if not input then
        input = io.open("input.txt", "r")
    end
    format = format or "*l"
    return input:read(format)
end

-- Define a function to close the output
function io.close()
    if output then
        output:close()
        output = nil
    end
end

-- Return the io module
return io
