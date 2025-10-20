if Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'qb' then
    QBCore = exports['qb-core']:GetCoreObject()
end

function Notify(msg, type, duration)
    if Config.Framework == 'esx' then
        ESX.ShowNotification(msg, type, duration)
    elseif Config.Framework == 'qbox' then
        exports.qbx_core:Notify(msg, type, duration)
    elseif Config.Framework == 'qb' then
        QBCore.Functions.Notify(msg, type, duration)
    end
end

function ChatMessage(msg)
    local messageData = {
        args = {msg},
        tags = {"server"},
        channel = 'server',
    }
    TriggerEvent('chat:addMessage', messageData)
    TriggerEvent('InteractSound_CL:PlayOnOne', 'radiochatter', 1.0)
end

function HasItem(item)
    if Config.Inventory == 'qb-inventory' or Config.Inventory == 'lj-inventory' or Config.Inventory == 'ps-inventory'then
        return exports[Config.Inventory]:HasItem(item)
    elseif Config.Inventory == 'ox_inventory' then
        local count = exports[Config.Inventory]:GetItemCount(item)
        return count and count > 0
    end
end