-- ModuleScript: GCHandler

local GCHandler = {}

GCHandler.getgctables = {}
GCHandler.originalValues = {}

local function findgc(...)
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
                    table.insert(GCHandler.getgctables, v)
                end
            end
        end
    end
end

function GCHandler.backupstat(tableIndex, key)
    if GCHandler.getgctables[tableIndex] then
        local tbl = GCHandler.getgctables[tableIndex]
        if rawget(tbl, key) then
            GCHandler.originalValues[key] = tbl[key]
        else
            warn("Key '" .. key .. "' not found in table at index " .. tableIndex)
        end
    else
        warn("Table at index " .. tableIndex .. " not found.")
    end
end

function GCHandler.revertstat(tableIndex, key)
    if GCHandler.getgctables[tableIndex] then
        local tbl = GCHandler.getgctables[tableIndex]
        if rawget(tbl, key) and GCHandler.originalValues[key] then
            tbl[key] = GCHandler.originalValues[key]
        else
            warn("Key '" .. key .. "' not found or original value is not available.")
        end
    else
        warn("Table at index " .. tableIndex .. " not found.")
    end
end

function GCHandler.modifystats(tableIndex, key, newValue)
    if GCHandler.getgctables[tableIndex] then
        local tbl = GCHandler.getgctables[tableIndex]
        if rawget(tbl, key) then
            tbl[key] = newValue
        else
            warn("Key '" .. key .. "' not found in table at index " .. tableIndex)
        end
    else
        warn("Table at index " .. tableIndex .. " not found.")
    end
end

-- Return the module's functions and variables
return GCHandler
