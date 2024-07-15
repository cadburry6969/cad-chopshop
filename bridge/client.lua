if Config.Framework == 'esx' then
ESX = exports["es_extended"]:getSharedObject()

function Notify(msg, type, duration)
    ESX.ShowNotification(msg, type, duration)
end

elseif Config.Framework == 'qb' then
QBCore = exports['qb-core']:GetCoreObject()

function Notify(msg, type, duration)
    QBCore.Functions.Notify(msg, type, duration)
end

end

function ChatMessage(msg)
    TriggerEvent('chat:addMessage', {
		color = { 0, 0, 255 },
		multiline = true,
		args = { "Chopshop", msg }
	})
end

function AddTargetEntity(entity)
    if Config.Target == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = {
                {
                    type = "client",
                    event = "cad-chopshop:HowToMsg",
                    icon = 'fa fa-clipboard',
                    label = 'Chopshop'
                }
            },
            distance = 1.5,
        })
    elseif Config.Target == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, {
            {
                label = 'Chopshop',
                icon = 'fa fa-clipboard',
                distance = 1.5,
                onSelect = function()
                    TriggerEvent("cad-chopshop:HowToMsg")
                end
            }
        })
    end
end