-- Locals
local QBCore = exports["qb-core"]:GetCoreObject()

local cooldown = -1
local inProgress = false
local randomLoc, randomVeh = nil, nil
local chopvehicle = nil
local currentplate = nil
local ChopItem = Config.ChopRadioItem
local randomLocations = Config.RandomLocations
local randomModels = Config.RandomVehicles
local RewardItems = Config.RewardItems

-- Functions

function CooldownTimer(minutes)
    cooldown = minutes * 60
    while cooldown > 0 do
        Wait(1000)
        cooldown = cooldown - 1
        if cooldown <= 0 then
            cooldown = -1
            inProgress = false
            TriggerEvent('cad-chopshop:timeOver')
            break
        end
        if not DoesEntityExist(chopvehicle) then
            cooldown = -1
            inProgress = false
            TriggerEvent('cad-chopshop:timeOver')
            break
        end
    end
end

-- Loops

CreateThread(function()
    while true do
        Wait(5000)
        if not inProgress then
            if randomLoc == nil and randomVeh == nil and currentplate == nil then
                randomLoc = randomLocations[math.random(1, #randomLocations)]
                randomVeh = randomModels[math.random(1, #randomModels)]
                inProgress = true
                Wait(1000)
                local nativeHash = GetHashKey("CREATE_AUTOMOBILE")
                chopvehicle = Citizen.InvokeNative(nativeHash, GetHashKey(randomVeh), randomLoc.x, randomLoc.y, randomLoc.z, randomLoc.w, true, true)
                while not DoesEntityExist(chopvehicle) do Wait(0) end
                currentplate = QBCore.Shared.RandomInt(2) .. QBCore.Shared.RandomStr(3) .. QBCore.Shared.RandomInt(3)
                SetVehicleNumberPlateText(chopvehicle, currentplate)
                SetVehicleDoorsLocked(chopvehicle, 2)
                print(tostring("Vehicle: " .. randomVeh .. " | Coords: " .. randomLoc .. " | Plate: " .. currentplate))
                local Players = QBCore.Functions.GetPlayers()
                for i = 1, #Players, 1 do
                    local Player = QBCore.Functions.GetPlayer(Players[i])
                    if Player.Functions.GetItemByName(ChopItem) then
                        TriggerClientEvent('cad-chopshop:notifyOwner', Players[i], randomLoc.x, randomLoc.y, randomLoc.z, randomVeh, currentplate)
                    end
                end
                CooldownTimer(Config.Cooldown)
            end
        end
    end
end)

-- Create Usable Items

QBCore.Functions.CreateUseableItem(ChopItem, function(source)
    local src = source
    if randomLoc and randomVeh and currentplate then
        TriggerClientEvent('cad-chopshop:notifyOwner', src, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh, currentplate)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You will be informed if there is another hot vehicle needed')
    end
end)

-- Events

RegisterNetEvent('cad-chopshop:clientjoined', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(ChopItem) then
        if randomLoc and randomVeh and currentplate then
            TriggerClientEvent('cad-chopshop:notifyOwner', source, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh, currentplate)
        end
    end
end)

RegisterNetEvent('cad-chopshop:vehicleChopped', function()
    local Players = QBCore.Functions.GetPlayers()
    for i = 1, #Players, 1 do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.Functions.GetItemByName(ChopItem) then
            TriggerClientEvent('cad-chopshop:informClients', Players[i])
        end
    end
    randomLoc = nil
    randomVeh = nil
    currentplate = nil
    chopvehicle = nil
end)

RegisterNetEvent('cad-chopshop:timeOver', function()
    local Players = QBCore.Functions.GetPlayers()
    for i = 1, #Players, 1 do
        local Player = QBCore.Functions.GetPlayer(Players[i])
        if Player.Functions.GetItemByName(ChopItem) then
            TriggerClientEvent('cad-chopshop:informClients', Players[i])
        end
    end
    randomLoc = nil
    randomVeh = nil
    currentplate = nil
    chopvehicle = nil
end)

RegisterNetEvent('cad-chopshop:recievereward', function(rarevalue)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(3500, 6500)
    if Player and randomLoc and randomVeh and currentplate then
        TriggerClientEvent('QBCore:Notify', src, 'You received $' .. amount .. ' for this hot vehicle', 'success')
        if rarevalue == "rare1" then
            Player.Functions.AddItem("tunerlaptop", 1)
            TriggerClientEvent('QBCore:Notify', src, 'Found a Laptop', 'success')
        elseif rarevalue == "rare2" then
            Player.Functions.AddItem("specialcard", 1) -- add your items
        elseif rarevalue == "normal" then
            Player.Functions.AddMoney("cash", amount)
            for i = 1, math.random(3, 6), 1 do
                local item = RewardItems[math.random(1, #RewardItems)]
                local amount = math.random(20, 50)
                Player.Functions.AddItem(item, amount)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add', amount)
            end
        end
    end
end)
