local gh = getgenv()
gh.tables = {}
gh.backups = {}

getgchelper = {}

local function findgc(...)
    local keySets = {...}
    for _, v in pairs(getgc(true)) do
        if type(v) == 'table' then
            for setIndex, keys in ipairs(keySets) do
                local found = true
                for key, val in pairs(keys) do
                    if type(key) == "number" then
                        key = val
                        val = nil
                    end
                    if val ~= nil and rawget(v, key) ~= val then
                        found = false
                        break
                    elseif val == nil and rawget(v, key) == nil then
                        found = false
                        break
                    end
                end
                if found then
                    if not gh.tables[setIndex] then
                        gh.tables[setIndex] = {}
                    end
                    table.insert(gh.tables[setIndex], v)
                    break
                end
            end
        end
    end
end

local function backupstat(tableIndex, key)
    if gh.tables[tableIndex] then
        gh.backups[tableIndex] = gh.backups[tableIndex] or {}
        for _, tbl in ipairs(gh.tables[tableIndex]) do
            gh.backups[tableIndex][tbl] = gh.backups[tableIndex][tbl] or {}
            gh.backups[tableIndex][tbl][key] = tbl[key]
        end
    end
end

local function revertstat(tableIndex, key)
    if gh.tables[tableIndex] and gh.backups[tableIndex] then
        for _, tbl in ipairs(gh.tables[tableIndex]) do
            if gh.backups[tableIndex][tbl] and gh.backups[tableIndex][tbl][key] then
                local oldValue = tbl[key]
                local newValue = gh.backups[tableIndex][tbl][key]
                -- Explicitly convert values to string to avoid format errors
                print(string.format("%s -> %s", tostring(oldValue), tostring(newValue)))  -- Convert values to strings
            end
        end
    end
end

local function modifystats(tableIndex, key, newValue, valueType)
    if gh.tables[tableIndex] then
        for _, tbl in ipairs(gh.tables[tableIndex]) do
            local oldValue = tbl[key]
            
            -- If valueType is not specified, just modify the value
            if not valueType or type(oldValue) == valueType then
                tbl[key] = newValue
                -- Explicitly convert values to string to avoid format errors
                print(string.format("%s -> %s", tostring(oldValue), tostring(newValue)))  -- Convert values to strings
            end
        end
    end
end

getgchelper.findgc = findgc
getgchelper.backupstat = backupstat
getgchelper.revertstat = revertstat
getgchelper.modifystats = modifystats
return getgchelper
