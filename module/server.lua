if GetCurrentResourceName() ~= 'cad-chopshop' then
    print('Do not rename the resource, keep it cad-chopshop')
    return
end

-- Locals

local cooldown = -1
local inProgress = false
local randomLoc, randomVeh = nil, nil
local chopvehicle = nil
local currentplate = nil

-- Functions

function GetPlate(entity)
    local value = GetVehicleNumberPlateText(entity)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

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
        if chopvehicle and not DoesEntityExist(chopvehicle) then
            cooldown = -1
            inProgress = false
            TriggerEvent('cad-chopshop:timeOver')
            break
        end
    end
end

function IsNearChopLocation(source)
    local _coords = GetEntityCoords(GetPlayerPed(source))
    for _, coords in pairs(Config.ChopShopLocations) do
        if #(vec3(_coords.x, _coords.y, _coords.z)-vec3(coords.x, coords.y, coords.z)) < 15 then
            return true
        end
    end
    return false
end

-- Loops

CreateThread(function()
    while true do
        Wait(5000)
        if not inProgress then
            if randomLoc == nil and randomVeh == nil and currentplate == nil then
                randomLoc = Config.Locations[math.random(1, #Config.Locations)]
                randomVeh = Config.Vehicles[math.random(1, #Config.Vehicles)]
                inProgress = true
                Wait(1000)
                local model = GetHashKey(randomVeh)
                chopvehicle = CreateVehicle(model, randomLoc.x, randomLoc.y, randomLoc.z, randomLoc.w, true, false)
                while not DoesEntityExist(chopvehicle) do Wait(0) end
                currentplate = GetPlate(chopvehicle)
                Wait(100)
                SetEntityHeading(chopvehicle, randomLoc.w)
                SetVehicleDoorsLocked(chopvehicle, 2)
                print(tostring("Vehicle: " .. randomVeh .. " | Coords: " .. randomLoc .. " | Plate: " .. currentplate))
                local Players = GetAllPlayers()
                for i = 1, #Players, 1 do
                    local source = Players[i]
                    if HasItem(source, "chopradio") then
                        TriggerClientEvent('cad-chopshop:notifyOwner', source, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh, currentplate)
                    end
                end
                CooldownTimer(Config.Cooldown)
            end
        end
    end
end)

-- Use Item

function UseItem(source)
    local src = source
    if randomLoc and randomVeh and currentplate then
        TriggerClientEvent('cad-chopshop:notifyOwner', src, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh, currentplate)
    else
        Notify(src, 'You will be informed if there is another hot vehicle needed')
    end
end

-- Events

RegisterNetEvent('cad-chopshop:playerLoaded', function(source)
    Wait(2000)
    if HasItem(source, "chopradio") then
        if randomLoc and randomVeh and currentplate then
            TriggerClientEvent('cad-chopshop:notifyOwner', source, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh, currentplate)
        end
    end
end)

RegisterNetEvent('cad-chopshop:vehicleChopped', function()
    local Players = GetAllPlayers()
    for i = 1, #Players, 1 do
        local source = Players[i]
        if HasItem(source, "chopradio") then
            TriggerClientEvent('cad-chopshop:informClients', source)
        end
    end
    randomLoc = nil
    randomVeh = nil
    currentplate = nil
    chopvehicle = nil
end)

RegisterNetEvent('cad-chopshop:timeOver', function()
    local Players = GetAllPlayers()
    for i = 1, #Players, 1 do
        local source = Players[i]
        if HasItem(source, "chopradio") then
            TriggerClientEvent('cad-chopshop:informClients', source)
        end
    end
    randomLoc = nil
    randomVeh = nil
    currentplate = nil
    chopvehicle = nil
end)

RegisterNetEvent('cad-chopshop:reward', function()
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    if randomLoc and randomVeh and currentplate and IsNearChopLocation(src) then
        local amount = math.random(Config.MoneyReward[1], Config.MoneyReward[2])
        Player.AddMoney(amount)
        for i = 1, math.random(3, 6), 1 do
            local data = Config.RewardItems[math.random(1, #Config.RewardItems)]
            AddItem(Player.source, data.item, math.random(data.amount[1], data.amount[2]))
        end
    else
        DropPlayer(src, 'Chop Reward Exploit')
    end
end)
