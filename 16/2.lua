function read_matrix(filename)
    local fp = io.open(filename, 'r')
    local lines = {}
    while true do
        local line = fp:read()
        if (not line) or #line == 0 then break end
        table.insert(lines, line)
    end
    return lines
end

local layout = read_matrix('input')
local height = #layout
local width = #layout[1]

local count_actived = function(layout, x, y, direction)
    local trace_set = {}
    local active_set = {}
    local count = 0

    local trace
    trace = function (layout, x, y, direction)
        if x < 1 or x > width then return nil end
        if y < 1 or y > width then return nil end

        trace_key = x..','..y..','..direction
        if trace_set[trace_key] == nil then
            trace_set[trace_key] = 1
        else 
            return nil
        end
        
        if active_set[x..','..y] == nil then
            active_set[x..','..y] = 1
            count = count + 1
        end
        -- trace next
        local cur = layout[y]:sub(x,x)
        if cur == '.' then
            if direction == 'E' then
                trace(layout, x+1, y, direction)
            elseif direction == 'W' then
                trace(layout, x-1, y, direction)
            elseif direction == 'N' then
                trace(layout, x, y-1, direction)
            elseif direction == 'S' then
                trace(layout, x, y+1, direction)
            end
        elseif cur == '-' then
            if direction == 'E' then
                trace(layout, x+1, y, direction)
            elseif direction == 'W' then
                trace(layout, x-1, y, direction)
            elseif direction == 'N' or direction == 'S' then
                trace(layout, x+1, y, 'E')
                trace(layout, x-1, y, 'W')
            end
        elseif cur == '|' then
            if direction == 'E' or direction == 'W' then
                trace(layout, x, y-1, 'N')
                trace(layout, x, y+1, 'S')
            elseif direction == 'N' then
                trace(layout, x, y-1, direction)
            elseif direction == 'S' then
                trace(layout, x, y+1, direction)
            end
        elseif cur == '/' then
            if direction == 'E' then
                trace(layout, x, y-1, 'N')
            elseif direction == 'W' then
                trace(layout, x, y+1, 'S')
            elseif direction == 'N' then
                trace(layout, x+1, y, 'E')
            elseif direction == 'S' then
                trace(layout, x-1, y, 'W')
            end
        elseif cur == '\\' then
            if direction == 'E' then
                trace(layout, x, y+1, 'S')
            elseif direction == 'W' then
                trace(layout, x, y-1, 'N')
            elseif direction == 'N' then
                trace(layout, x-1, y, 'W')
            elseif direction == 'S' then
                trace(layout, x+1, y, 'E')
            end
        end
    end

    trace(layout, x, y, direction)
    return count
end


local max = -1

for i = 1,height do
    local count1 = count_actived(layout, 1, i, 'E')
    if count1 > max then max = count1 end
    local count2 = count_actived(layout, width, i, 'W')
    if count2 > max then max = count2 end
end

for i = 1,width do
    local count1 = count_actived(layout, i, 1, 'S')
    if count1 > max then max = count1 end
    local count2 = count_actived(layout, i, height, 'N')
    if count2 > max then max = count2 end
end

print(max)