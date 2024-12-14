--examples that teach you how to use require / getgc function(not that goodly described, but you can use other stuff to learn it).

for i, v in pairs(getgc(true)) do
    if type(v) == 'table' then
        if rawget(v, 'FireRate') then -- you can find the whatever strings, you want to modify by decompiling the modulescript that has gunstats.
            rawset(v,"FireRate",0.09)
        end
    end
end

-- require example, not made by me, credits to some youtube video I found:
-- get what the modulescript contains
local modulescript = require(modulescriptpath) -- or you could also use this to get strings, if you want to do it, without a decompiler, also the path is usually different in different games, this is just an example
for i,v in pairs(modulescript) do print(i,v) end
-- change it
local modulescript = require(modulescriptpath)
mod.(put the string name you want to change here) = value
