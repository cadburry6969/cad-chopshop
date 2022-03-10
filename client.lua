-- Locals
local QBCore = exports["qb-core"]:GetCoreObject()

local HotVehPlate = nil
local HotVehModel = nil
local ChopShop = {x = 2340.49, y = 3052.32, z = 48.15}
local ChopShopPed = {x = 2342.21, y = 3055.63, z = 47.2, h = 162.86}
local ChopCds = {}

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent("cad-chopshop:clientjoined")
end)

RegisterNetEvent('cad-chopshop:notifyOwner', function(x, y, z, randomVeh)	
	local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(x, y, z))
	local zone = GetLabelText(GetNameOfZone(x, y, z))	
	ChopCds = {x = x, y = y}	
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	randomVeh = randomVeh:gsub("^%l", string.upper)
	TriggerEvent('chat:addMessage', {
		template = '<div class="chat-message twitch"><i class="fas fa-door-open"></i> <b><span style="color: #7d7d7d">{0}</span>&nbsp;</b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
		args = { "Chopshop", "Hot vehicle " .. randomVeh .. " available at " .. zone .. " on " .. street .. " with plate number: " .. HotVehPlate }
	})	
end)

RegisterNetEvent('cad-chopshop:informClients', function()	
	PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	TriggerEvent('chat:addMessage', {
		template = '<div class="chat-message twitch"><i class="fas fa-door-open"></i> <b><span style="color: #7d7d7d">{0}</span>&nbsp;</b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
		args = { "Chopshop", 'The hot vehicle is no longer needed. Wait for another hot vehicle'}
	})	
end)

RegisterNetEvent('cad-chopshop:GetHotVehicleData', function(vehicle, plate)
	HotVehModel = vehicle
	HotVehPlate = plate	
end)

RegisterNetEvent('cad-chopshop:HowToMsg', function()
	QBCore.Functions.Notify("Bring the hot vehicle in front me and you will know.", 'success', 5000)
	if ChopCds ~= nil then
		SetNewWaypoint(ChopCds.x, ChopCds.y)
	end
end)

-- Functions

function ShowHelpNotification(msg, thisFrame, beep, duration)
	AddTextEntry('QBHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('QBHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('QBHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

-- Threads

CreateThread(function()
	exports['qb-target']:SpawnPed({
		model = 'g_m_y_mexgoon_03',
		coords = vector4(ChopShopPed.x, ChopShopPed.y, ChopShopPed.z, ChopShopPed.h),
		minusOne = true,
		freeze = true,
		invincible = true,
		blockevents = true,		
		scenario = 'WORLD_HUMAN_SMOKING', 
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
end)

CreateThread(function()
	while true do
		Wait(0)		
		local inRange = false	
		local pPed = PlayerPedId()
		local coords = GetEntityCoords(pPed)		
		local distance = GetDistanceBetweenCoords(coords, ChopShop.x, ChopShop.y, ChopShop.z, true)
		if distance < 4 then
			if IsPedInAnyVehicle(pPed, true) then
				inRange = true
				local pVehicle = GetVehiclePedIsIn(pPed,false)
				local pVehModel = GetDisplayNameFromVehicleModel(GetEntityModel(pVehicle))
				local pPlate = GetVehicleNumberPlateText(pVehicle)										
				ShowHelpNotification("Press ~INPUT_CONTEXT~ to chop the vehicle", true, true, 10000)
				if IsControlJustReleased(0,  46) then
					if (pPlate == HotVehPlate) or (pVehModel:lower() == HotVehModel) then												
						SetVehicleDoorsLocked(pVehicle, 2)
						SetVehicleEngineOn(pVehicle, false, false, true)
						SetVehicleUndriveable(pVehicle, false)
						SetVehicleDoorOpen(pVehicle, 0, false, true)
						Wait(1000)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)	
						SetVehicleDoorBroken(pVehicle, 0, false)
						Wait(1000)
						SetVehicleDoorOpen(pVehicle, 1, false, true)
						Wait(1000)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
						SetVehicleDoorBroken(pVehicle, 1, false)
						Wait(1000)
						SetVehicleDoorOpen(pVehicle, 2, false, true)
						Wait(1000)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)			
						SetVehicleDoorBroken(pVehicle, 2, false)
						Wait(1000)			
						SetVehicleDoorOpen(pVehicle, 3, false, true)
						Wait(1000)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
						SetVehicleDoorBroken(pVehicle, 3, false)
						Wait(1000)
						SetVehicleDoorOpen(pVehicle, 4, false, true)
						Wait(1000)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
						SetVehicleDoorBroken(pVehicle, 4, false)
						Wait(1000)
						SetVehicleDoorOpen(pVehicle, 5, false, true)
						Wait(1000)
						TriggerEvent('InteractSound_CL:PlayOnOne', 'chop', 0.4)
						SetVehicleDoorBroken(pVehicle, 5, false)
						SetEntityAsMissionEntity(pVehicle , true, true )
						DeleteEntity(pVehicle)
						if (DoesEntityExist(pVehicle)) then
							DeleteEntity(pVehicle)
						end
						Wait(1000)
						local chance = math.random(1, 20)
						if chance == 10 then
							TriggerServerEvent('cad-chopshop:recievereward', "rare1")
						end
						local RareValue = math.random(1, 1000)
						if RareValue == 500 then
							TriggerServerEvent('cad-chopshop:recievereward', "rare2")
						end
						TriggerServerEvent('cad-chopshop:recievereward', "normal")
						QBCore.Functions.Notify('The vehicle has been chopped', 'error')					
						TriggerServerEvent('cad-chopshop:vehicleChopped')						
						HotVehPlate = nil
						HotVehModel = nil
					else
						QBCore.Functions.Notify('This is not the hot vehicle', 'error')
					end
				end
			end
		end
		if not inRange then
			Wait(1500) --  1.5secs
		end
	end
end)
