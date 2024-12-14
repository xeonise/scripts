getgenv().getgctables = {}
getgenv().originalValues = {}
getgchelper = {}

-- Function to find all tables that contain a specific key
local function findgc(...)
    local args = {...}
    for i, v in pairs(getgc(true)) do
        if type(v) == 'table' then
            for _, argSet in ipairs(args) do
                local matches = true
                for i, key in ipairs(argSet) do
                    -- Check if the key exists in the table
                    if not rawget(v, key) then
                        matches = false
                        break
                    end
                end
                
                -- If the table matches, add it to getgctables
                if matches then
                    table.insert(getgenv().getgctables, v)
                end
            end
        end
    end
end

-- Function to backup the original value of a specific key in a specific table by index
local function backupstat(tableIndex, key)
    local tbl = getgenv().getgctables[tableIndex]
    if tbl and rawget(tbl, key) then
        -- Store the original value of the key in a global backup table
        getgenv().originalValues[key] = getgenv().originalValues[key] or {}
        table.insert(getgenv().originalValues[key], tbl[key])
    else
        print("Key '" .. key .. "' not found in the table at index " .. tableIndex)
    end
end

-- Function to revert the value of a specific key in a specific table by index
local function revertstat(tableIndex, key)
    local tbl = getgenv().getgctables[tableIndex]
    if tbl and rawget(tbl, key) then
        -- Check if the backup exists
        if getgenv().originalValues[key] then
            tbl[key] = getgenv().originalValues[key][1]  -- Revert to the first backed-up value (assuming one backup for each key)
        else
            print("No backup available for key '" .. key .. "'.")
        end
    else
        print("Key '" .. key .. "' not found in the table at index " .. tableIndex)
    end
end

-- Function to modify the value of a specific key in a specific table by index
local function modifystats(tableIndex, key, newValue)
    local tbl = getgenv().getgctables[tableIndex]
    if tbl and rawget(tbl, key) then
        print('Changed', tbl[key], '->', newValue)
        tbl[key] = newValue
    else
        print("Key '" .. key .. "' not found in the table at index " .. tableIndex)
    end
end

getgchelper.findgc = findgc
getgchelper.backupstat = backupstat
getgchelper.revertstat = revertstat
getgchelper.modifystats = modifystats
return getgchelper
