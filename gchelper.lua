getgctables = {}
originalValues = {}
local getgchelper = {}

function getgchelper.findgc(...)
    local args = {...}
    for i, v in pairs(getgc(true)) do
        if type(v) == 'table' then
            for _, argSet in ipairs(args) do
                local matches = true
                for i, key in ipairs(argSet) do
                    if not rawget(v, key) then
                        matches = false
                        break
                    end
                end
                
                if matches then
                    table.insert(getgenv().getgctables, v)
                end
            end
        end
    end
end

function getgchelper.backupstat(tableIndex, key)
    if getgenv().getgctables[tableIndex] then
        local tbl = getgenv().getgctables[tableIndex]
        if rawget(tbl, key) then
            getgenv().originalValues[key] = tbl[key]
        else
            print("Key '" .. key .. "' not found in table at index " .. tableIndex)
        end
    else
        print("Table at index " .. tableIndex .. " not found.")
    end
end

function getgchelper.revertstat(tableIndex, key)
    if getgenv().getgctables[tableIndex] then
        local tbl = getgenv().getgctables[tableIndex]
        if rawget(tbl, key) and getgenv().originalValues[key] then
            tbl[key] = getgenv().originalValues[key]
        else
            print("Key '" .. key .. "' not found or original value is not available.")
        end
    else
        print("Table at index " .. tableIndex .. " not found.")
    end
end

function getgchelper.modifystats(tableIndex, key, newValue)
    if getgenv().getgctables[tableIndex] then
        local tbl = getgenv().getgctables[tableIndex]
        if rawget(tbl, key) then
            tbl[key] = newValue
        else
            print("Key '" .. key .. "' not found in table at index " .. tableIndex)
        end
    else
        print("Table at index " .. tableIndex .. " not found.")
    end
end