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
                for _, key in ipairs(keys) do
                    if rawget(v, key) == nil then
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
                tbl[key] = newValue
                print(string.format("%s -> %s", oldValue, newValue))  -- Print change
            end
        end
    end
end

local function modifystats(tableIndex, key, newValue)
    if gh.tables[tableIndex] then
        for _, tbl in ipairs(gh.tables[tableIndex]) do
            local oldValue = tbl[key]
            tbl[key] = newValue
            print(string.format("%s -> %s", oldValue, newValue))
        end
    end
end

getgchelper.findgc = findgc
getgchelper.backupstat = backupstat
getgchelper.revertstat = revertstat
getgchelper.modifystats = modifystats
return getgchelper
