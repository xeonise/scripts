# a page for my scripts
how to use gchelper:
```lua
--1 table example
gh = loadstring(game:HttpGet("https://raw.githubusercontent.com/xeonise/scripts/refs/heads/main/gc.lua",true))()
gh.findgc( {"Horsepower", "MaxRPM"} ) -- finds all tables that contain these 2 values.
gh.backupstat(1,"Horsepower") -- backups the value named "Horsepower" in all tables that contain "Horsepower", "MaxRPM"
gh.modifystats(1,"Horsepower",9370) -- changes the value "Horsepower" in all tables that contain "Horsepower", "MaxRPM" to 9370
task.wait(5) -- waits 5 seconds
gh.revertstat(1,"Horsepower") -- reverts the value "Horsepower" in all tables that contain "Horsepower", "MaxRPM" to it's first value
```
--2 table example
```lua
gh = loadstring(game:HttpGet("https://raw.githubusercontent.com/xeonise/scripts/refs/heads/main/gc.lua",true))()
gh.findgc( {"Horsepower", "MaxRPM"}, {"Ammo", "FireRate} ) --finds all tables that contain 'Horsepower' and 'MaxRPM' and gives them index 1(which you use in backupstat,modifystats,revertstat), and does the same for "Ammo", "FireRate", except, it gives them index 2, which just like the index 1, you can use for the functions gchelper has.

gh.backupstat(1,"Horsepower") -- backups the value named "Horsepower" in all tables that contain "Horsepower", "MaxRPM"
gh.modifystats(1,"Horsepower",9370) -- changes the value "Horsepower" in all tables that contain "Horsepower", "MaxRPM" to 9370
task.wait(5) -- waits 5 seconds
gh.revertstat(1,"Horsepower") -- reverts the value "Horsepower" in all tables that contain "Horsepower", "MaxRPM" to it's first value

--everything else shall be pretty understandable from previous explanation, except instead of index 1, it uses index 2 now, since it's the 2nd table of tables which contain {"Ammo", "FireRate"} 
gh.backupstat(2,"Ammo")
gh.backupstat(2,"FireRate")
gh.modifystats(2,"Ammo", 924599)
gh.modifystats(2,"FireRate", 0)
task.wait(5)
gh.revertstat(2,"Ammo")
gh.revertstat(2,"FireRate")
```



```lua
--all types of search:
-- Search for tables that have the keys "FireRate" and "Ammo" (without checking values)
getgchelper.findgc({ "FireRate", "Ammo" })

-- Search for tables where "FireRate" is 0.1 and "Ammo" is 9
getgchelper.findgc({ {"FireRate", 0.1}, {"Ammo", 9} })

-- Search for tables where "FireRate" is 0.1 and "Ammo" is 9 (index 1),
-- and another set where "AAK" is 0.1 (index 2)
getgchelper.findgc({ {"FireRate", 0.1}, {"Ammo", 9} }, { {"AAK", 0.1} })

-- Search for tables where "FireRate" and "Ammo" are keys (no value check), 
-- and also where "Spread" is 0 (with value check)
getgchelper.findgc({ "FireRate", "Ammo" }, { {"Spread", 0} })
also credits to chatgpt for writing that
```
if you don't understand how to use it, you can contact me on discord (zxk2021), or create a issue on github, and ask, what you do not understand.
also, you can create issues, if you encounter any bugs.
