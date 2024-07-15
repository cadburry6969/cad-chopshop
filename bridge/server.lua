if Config.Framework == 'esx' then
ESX = exports["es_extended"]:getSharedObject()

function GetAllPlayers()
    return ESX.GetPlayers()
end

function GetPlayer(src)
    local player = ESX.GetPlayerFromId(src)
    return player and {
        source = player.source,
        identifier = player.identifier,
        AddMoney = function(amount)
            if Config.MoneyType == 'cash' then
                player.setMoney(amount)
            else
                AddItem(player.source, Config.MoneyType, amount)
            end
        end
    } or nil
end

function Notify(src, msg, type, duration)
    TriggerClientEvent('esx:showNotification', src, msg, type, duration)
end

RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
    TriggerEvent('cad-chopshop:playerLoaded', player)
end)

elseif Config.Framework == 'qb' then
QBCore = exports['qb-core']:GetCoreObject()

function GetAllPlayers()
    return QBCore.Functions.GetPlayers()
end

function GetPlayer(src)
    local player = QBCore.Functions.GetPlayer(src)
    return player and {
        source = player.PlayerData.source,
        identifier = player.PlayerData.citizenid,
        AddMoney = function(amount)
            if Config.MoneyType == 'cash' then
                player.Functions.AddMoney('cash', amount)
            else
                AddItem(player.PlayerData.source, Config.MoneyType, amount)
            end
        end
    } or nil
end

function Notify(src, msg, type, duration)
    QBCore.Functions.Notify(src, msg, type, duration)
end

RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
    TriggerEvent('cad-chopshop:playerLoaded', player.PlayerData.source)
end)

end

if Config.Inventory == 'qb-inventory' or Config.Inventory == 'lj-inventory' or Config.Inventory == 'ps-inventory'then

function HasItem(src, item)
    return exports[Config.Inventory]:HasItem(src, item)
end

function AddItem(src, item, amount)
    return exports[Config.Inventory]:AddItem(src, item, amount)
end

function RemoveItem(src, item, amount)
    return exports[Config.Inventory]:RemoveItem(src, item, amount)
end

QBCore.Functions.CreateUseableItem("chopradio", function(source)
    UseItem(source)
end)

elseif Config.Inventory == 'ox_inventory' then

function HasItem(src, item)
    local count = exports[Config.Inventory]:GetItem(src, item, nil, true)
    return count and count > 0
end

function AddItem(src, item, amount)
    return exports[Config.Inventory]:AddItem(src, item, amount)
end

function RemoveItem(src, item, amount)
    return exports[Config.Inventory]:RemoveItem(src, item, amount)
end

exports('useItem', function(event, item, inv, slot, data)
    if event == 'usingItem' then
        if item.name == "chopradio" then
            UseItem(inv.id)
            return false
        end
    end
end)

end