-- Locals
local QBCore = exports["qb-core"]:GetCoreObject()

local cooldown = -1
local inProgress = false
local randomLoc, randomVeh = nil , nil
local chopvehicle = nil
local currentplate = nil
local ChopItem = "chopradio"

local randomLocations = {
    vector3(-2480.9, -212.0, 17.4),
    vector3(-2723.4, 13.2, 15.1),
    vector3(-3169.6, 976.2, 15.0),
    vector3(-3139.8, 1078.7, 20.2),
    vector3(-1656.9, -246.2, 54.5),
    vector3(-1586.7, -647.6, 29.4),
    vector3(-1036.1, -491.1, 36.2),
    vector3(-1029.2, -475.5, 36.4),
    vector3(75.2, 164.9, 104.7),
    vector3(-534.6, -756.7, 31.6),
    vector3(487.2, -30.8, 88.9),
    vector3(-772.2, -1281.8, 4.6),
    vector3(-663.8, -1207.0, 10.2),
    vector3(719.1, -767.8, 24.9),
    vector3(-971.0, -2410.4, 13.3),
    vector3(-1067.5, -2571.4, 13.2),
    vector3(-619.2, -2207.3, 5.6),
    vector3(1192.1, -1336.9, 35.1),
    vector3(-432.8, -2166.1, 9.9),
    vector3(-451.8, -2269.3, 7.2),
    vector3(939.3, -2197.5, 30.5),
    vector3(-556.1, -1794.7, 22.0),
    vector3(591.7, -2628.2, 5.6),
    vector3(1654.5, -2535.8, 74.5),
    vector3(1642.6, -2413.3, 93.1),
    vector3(1371.3, -2549.5, 47.6),
    vector3(383.8, -1652.9, 37.3),
    vector3(27.2, -1030.9, 29.4),
    vector3(229.3, -365.9, 43.8),
    vector3(-85.8, -51.7, 61.1),
    vector3(-4.6, -670.3, 31.9),
    vector3(-111.9, 92.0, 71.1),
    vector3(-314.3, -698.2, 32.5),
    vector3(-366.9, 115.5, 65.6),
    vector3(-592.1, 138.2, 60.1),
    vector3(-1613.9, 18.8, 61.8),
    vector3(-1709.8, 55.1, 65.7),
    vector3(-521.9, -266.8, 34.9),
    vector3(-451.1, -333.5, 34.0),
    vector3(322.4, -1900.5, 25.8),
    vector3(-2078.76, -331.44, 12.63),
    vector3(-2949.47, 461.58, 14.7),
    vector3(-2214.0, 4238.75, 47.0),
    vector3(-356.99, 6067.1, 31.07),
    vector3(1127.82, 2648.17, 37.49),
    vector3(1869.78, 2557.07, 45.17),
    vector3(1690.12, 3288.04, 40.64),
    vector3(2058.21, 3887.32, 31.21),
    vector3(2786.06, 3463.15, 54.91),
    vector3(727.21, -208.16, 67.84),
    vector3(-327.8, -2748.6, 6.02),
    vector3(510.21, -3054.7, 6.07),
    vector3(833.76, -1271.81, 26.28),
    vector3(4.49, -1762.49, 29.3),
    vector3(380.07, -739.98, 29.29),
    vector3(178.47, -698.52, 33.13),
    vector3(225.67, -776.58, 30.77),
    vector3(236.73, -795.25, 30.5),
    vector3(-1166.15, -888.1, 14.11),
    vector3(-56.5, -1117.01, 26.44),
    vector3(282.27, -327.14, 44.92),
    vector3(-391.13, -122.16, 38.67),
    vector3(-1329.0, -396.54, 36.45),
    vector3(61.6, 19.35, 69.35),
    vector3(362.87, 277.94, 103.25),
    vector3(2774.65, 3471.37, 55.44),
    vector3(2030.43, 3166.86, 45.24),
    vector3(1245.01, 2713.15, 38.01),
    vector3(627.56, 2731.54, 41.88),
    vector3(1768.18, 3697.84, 34.21),
    vector3(2150.18, 4797.54, 41.14),
    vector3(2411.72, 4970.77, 46.11),
    vector3(907.48, -54.72, 78.76),
    vector3(880.41, -39.27, 78.76),
    vector3(-723.8, -913.2, 19.01),
    vector3(-1800.38, -1180.45, 13.02),
    vector3(-1629.1, -888.81, 9.06),
    vector3(-1643.01, -834.77, 9.99),
    vector3(-1708.75, -899.46, 7.81),
    vector3(-1737.96, -723.72, 10.45),
    vector3(-2079.03, -335.51, 13.14),
    vector3(-1510.41, 1490.02, 116.16),
    vector3(-311.28, -757.9, 33.97),
    vector3(-622.68, 201.27, 71.13),
}

local randomModels = {"fugitive","surge","sultan","asea","premier", "baller", "blista", "panto", "blista3", "blista2", "prairie", "rhapsody", "exempler", "cogcabrio", "felon", "oracle", "sentinel", "blade", "buccaneer", "chino", "dominator", "dukes", "faction", "gauntlet", "moonbeam", "ratloader", "stalion", "tampa", "voodoo", "sandking", "rancherxl", "xls", "rocoto", "serrano", "cognoscenti", "emperor", "ingot", "regina", "surge", "primo", "washington", "comet", "carbonizzare", "banshee", "coquette", "futo", "jester", "massacro", "ninef", "schafter", "adder", "infernus", "voltic", "vacca", "sadler", "bison"}

-- Functions

function CooldownTimer(minutes)
    cooldown = minutes * 60 * 1000
    while cooldown > 0 do
        Wait(1000)
        cooldown = cooldown - 1000
        if cooldown <= 0 then
            cooldown = -1
            inProgress = false
            TriggerEvent('cad-chopshop:timeOver')
            break
        end
    end
end

-- Loops

CreateThread(function()
    print("Chopshop made for Indian Ultra RP by Cadburry#7547")
	while true do
		Wait(1000)   
        if not inProgress then     
            if randomLoc == nil and randomVeh == nil and currentplate == nil then
                randomLoc = randomLocations[math.random(1, #randomLocations)]
                randomVeh = randomModels[math.random(1, #randomModels)]        
                currentplate = tostring(math.random(11111111,99999999))
                inProgress = true
                Wait(5000)                         
                chopvehicle = CreateVehicle(randomVeh, randomLoc, 90.0, true, true)                
                SetVehicleNumberPlateText(chopvehicle, currentplate)                
                local Players = QBCore.Functions.GetPlayers()
                for i=1, #Players, 1 do
                    local Player = QBCore.Functions.GetPlayer(Players[i])
                    if Player.Functions.GetItemByName(ChopItem) then
                        TriggerClientEvent("cad-chopshop:GetHotVehicleData", Players[i], randomVeh, currentplate)                    
                        TriggerClientEvent('cad-chopshop:notifyOwner', Players[i], randomLoc.x, randomLoc.y, randomLoc.z, randomVeh)                        
                    end
                end        
                CooldownTimer(30)          
            end        
        end
	end
end)

-- Create Usable Items

QBCore.Functions.CreateUseableItem(ChopItem, function(source)
    local src = source        
    if randomLoc and randomVeh then      
        TriggerClientEvent("cad-chopshop:GetHotVehicleData", src, randomVeh, currentplate)      		                                                  
        TriggerClientEvent('cad-chopshop:notifyOwner', src, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh)               
	else        		    
        TriggerClientEvent('QBCore:Notify', src, 'You will be informed if there is another hot vehicle needed')         	        
	end
end)

-- Events

RegisterNetEvent('cad-chopshop:clientjoined', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(ChopItem) then
        if randomLoc and randomVeh then      
            TriggerClientEvent("cad-chopshop:GetHotVehicleData", source, randomVeh, currentplate)      		                                                  
            TriggerClientEvent('cad-chopshop:notifyOwner', source, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh)            	
        end
    end
end)

RegisterNetEvent('cad-chopshop:vehicleChopped', function()	
	local Players = QBCore.Functions.GetPlayers()
    for i=1, #Players, 1 do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.Functions.GetItemByName(ChopItem) then
            TriggerClientEvent('cad-chopshop:informClients', Players[i])
            randomLoc = nil
            randomVeh = nil
            currentplate = nil         
            chopvehicle = nil   
        end
    end
end)

RegisterNetEvent('cad-chopshop:timeOver', function()
    local Players = QBCore.Functions.GetPlayers()    
    for i=1, #Players, 1 do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.Functions.GetItemByName(ChopItem) then
            TriggerClientEvent('cad-chopshop:informClients', Players[i])
            randomLoc = nil
            randomVeh = nil
            currentplate = nil    
            chopvehicle = nil        
        end
    end
end)

RewardItems = { 
    "metalscrap",
    "plastic",
    "copper",
    "iron",
    "aluminum",
    "steel",
    "glass",
}

RegisterNetEvent('cad-chopshop:recievereward', function(rarevalue)	
	local Player = QBCore.Functions.GetPlayer(source)
	local amount = math.random(3500, 6500)
    if Player ~= nil then	        
        TriggerClientEvent('QBCore:Notify', source, 'You received $' .. amount .. ' for this hot vehicle', 'success')
        if rarevalue == "rare1" then        
            Player.Functions.AddItem("pixellaptop", 1)
            TriggerClientEvent('QBCore:Notify', source, 'Found a Laptop', 'success')        
        elseif rarevalue == "rare2" then
            Player.Functions.AddItem("specialcard", 1)
            TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items["specialcard"], 'add')
        elseif rarevalue == "normal" then
            Player.Functions.AddMoney("cash",amount)	
            for i = 1, math.random(3,6), 1 do
                local item = RewardItems[math.random(1, #RewardItems)]
                local amount = math.random(20,50)
                Player.Functions.AddItem(item, amount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
            end
        end
    end
end)
