if GetCurrentResourceName() ~= 'cad-chopshop' then
    print('Do not rename the resource, keep it cad-chopshop')
    return
end

-- Locals

local cooldownTime = -1

GlobalState.ChopShop = nil

-- Functions

local function debugPrint(msg)
    if Config.Debug then print('^2INFO: '..msg) end
end

local function getMultiplierForPlayers(type)
    local playerCount = #GetPlayers()
    if type == 'item' then
        return Config.RewardItemsMultiplier * playerCount
    elseif type == 'money' then
        return Config.MoneyRewardMultiplier * playerCount
    end
end

local function getPlate(entity)
    local value = GetVehicleNumberPlateText(entity)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

local function isNearChopLocation(source)
    local _coords = GetEntityCoords(GetPlayerPed(source))
    for _, coords in pairs(Config.ChopShopLocations) do
        if #(vec3(_coords.x, _coords.y, _coords.z)-vec3(coords.x, coords.y, coords.z)) < 15 then
            return true
        end
    end
    return false
end

local function deleteVehicleEntity(entity)
    if entity and DoesEntityExist(entity) then
        local ped = GetPedInVehicleSeat(entity, -1)
        if ped ~= 0 then DeleteEntity(entity) end
    end
end

local function cooldownTimer(minutes)
    cooldownTime = minutes * 60
    CreateThread(function()
        debugPrint("Next hot vehicle in " .. minutes .. " minutes")
        while cooldownTime > 0 do
            Wait(1000)
            cooldownTime = cooldownTime - 1
            if (cooldownTime < 1) then
                cooldownTime = -1
                local data = GlobalState.ChopShop
                deleteVehicleEntity(data.entity)
                GlobalState.ChopShop = nil
                break
            end
        end
    end)
end

-- Loops

CreateThread(function()
    while true do
        Wait(5000)
        if GetPlayers and #GetPlayers() > 0 then
            ::skip::
            if GlobalState.ChopShop == nil and cooldownTime == -1 then
                debugPrint("Assigning new hot vehicle to chopshop")
                local chopVehCoords = Config.Locations[math.random(1, #Config.Locations)]
                local chopVehModel = Config.Vehicles[math.random(1, #Config.Vehicles)]
                Wait(100)
                local chopVehicle = CreateVehicle(chopVehModel, chopVehCoords.x, chopVehCoords.y, chopVehCoords.z, chopVehCoords.w, true, true)
                local timeout = Config.VehicleSpawnTimeout/1000
                while timeout > 0 and not DoesEntityExist(chopVehicle) do
                    Wait(1000)
                    timeout = timeout - 1
                end
                if timeout < 1 and not DoesEntityExist(chopVehicle) then goto skip end
                Wait(100)
                local chopVehiclePlate = getPlate(chopVehicle)
                SetEntityHeading(chopVehicle, chopVehCoords.w)
                SetVehicleDoorsLocked(chopVehicle, 2)
                debugPrint("Vehicle: " .. chopVehModel .. " | Coords: " .. chopVehCoords .. " | Plate: " .. chopVehiclePlate)
                GlobalState.ChopShop = {
                    entity = chopVehicle,
                    model = chopVehModel,
                    coords = chopVehCoords,
                    plate = chopVehiclePlate
                }
                cooldownTimer(Config.AssignVehicleCooldown)
            end
        end
    end
end)

-- Use Item

function UseItem(source)
    local src = source
    local data = GlobalState.ChopShop
    if data and data.entity and data.coords and data.model and data.plate then
        TriggerClientEvent('cad-chopshop:informClients', src)
    else
        Notify(src, 'You will be informed if there is another hot vehicle needed')
    end
end

-- Events

RegisterNetEvent('cad-chopshop:playerLoaded', function(source)
    Wait(2000)
    local data = GlobalState.ChopShop
    if not HasItem(source, "chopradio") then return end
    if data and data.entity and data.coords and data.model and data.plate then
        TriggerClientEvent('cad-chopshop:informClients', source)
    end
end)

RegisterNetEvent('cad-chopshop:vehicleChopped', function()
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    local data = GlobalState.ChopShop
    if not data then return end
    if not data.entity or not data.coords or not data.model or not data.plate then return end
    if not isNearChopLocation(src) then DropPlayer(src, 'Chop Reward Exploit') return end

    local vehicle = GetVehiclePedIsIn(GetPlayerPed(src), false)
    if vehicle then DeleteEntity(vehicle) end

    local money = lib.math.round(math.random(Config.MoneyReward[1], Config.MoneyReward[2]) * getMultiplierForPlayers('money'), 2)
    Player.AddMoney(money)
    if Config.RewardItems and #Config.RewardItems > 0 then
        for i = 1, math.random(3, 6), 1 do
            local data = Config.RewardItems[math.random(1, #Config.RewardItems)]
            local item = data.item
            local amount = lib.math.round(math.random(data.amount[1], data.amount[2]) * getMultiplierForPlayers('item'), 2)
            AddItem(Player.source, item, amount)
        end
    end

    -- Add Cooldown when vehicle is succesfully chopped
    if cooldownTime == -1 then
        cooldownTimer(Config.ChoppedVehicleCooldown)
    else
        cooldownTime = Config.ChoppedVehicleCooldown * 60
    end
    SetTimeout(500, function()
        deleteVehicleEntity(data.entity)
        GlobalState.ChopShop = nil
    end)
end)