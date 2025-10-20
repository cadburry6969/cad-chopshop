if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()

    RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
        TriggerEvent('cad-chopshop:playerLoaded', player)
    end)
elseif Config.Framework == 'qbox' then
    RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
        TriggerEvent('cad-chopshop:playerLoaded', player.PlayerData.source)
    end)
elseif Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()

    RegisterNetEvent('QBCore:Server:PlayerLoaded', function(player)
        TriggerEvent('cad-chopshop:playerLoaded', player.PlayerData.source)
    end)
end

function GetPlayer(src)
    if Config.Framework == 'esx' then
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
    elseif Config.Framework == 'qbox' then
        local player = exports.qbx_core:GetPlayer(src)
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
    elseif Config.Framework == 'qb' then
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
end

function Notify(src, msg, type, duration)
    if Config.Framework == 'esx' then
        TriggerClientEvent('esx:showNotification', src, msg, type, duration)
    elseif Config.Framework == 'qbox' then
        exports.qbx_core:Notify(src, msg, type, duration)
    elseif Config.Framework == 'qb' then
        QBCore.Functions.Notify(src, msg, type, duration)
    end
end

function HasItem(src, item)
    if Config.Inventory == 'qb-inventory' or Config.Inventory == 'lj-inventory' or Config.Inventory == 'ps-inventory' then
        return exports[Config.Inventory]:HasItem(src, item)
    elseif Config.Inventory == 'ox_inventory' then
        local count = exports[Config.Inventory]:GetItemCount(src, item)
        return count and count > 0
    end
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

if Config.Inventory ~= 'ox_inventory' then
    if Config.Framework == 'esx' then
        ESX.RegisterUsableItem('chopradio', function(playerId)
            UseItem(playerId)
        end)
    elseif Config.Framework == 'qb' then
        QBCore.Functions.CreateUseableItem("chopradio", function(source)
            UseItem(source)
        end)
    end
end
