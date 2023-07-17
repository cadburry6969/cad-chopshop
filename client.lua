-- Locals
local QBCore = exports["qb-core"]:GetCoreObject()

local HotVehPlate = nil
local HotVehModel = nil
local ChopShop = Config.ChopShopLocations
local ChopShopPed = Config.ChopShopPeds
local chopTable = nil

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent("cad-chopshop:clientjoined")
end)

RegisterNetEvent('cad-chopshop:notifyOwner', function(x, y, z, randomVeh, currentplate)
	HotVehModel = randomVeh
	HotVehPlate = currentplate
	local streetName, crossingRoad = GetStreetNameAtCoord(x, y, z)
	local street = string.format('%s - %s', GetStreetNameFromHashKey(streetName), GetStreetNameFromHashKey(crossingRoad))
	local zone = GetLabelText(GetNameOfZone(x, y, z))
	chopTable = vector2(x, y)
	PlaySoundFrontend( -1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	randomVeh = randomVeh:gsub("^%l", string.upper)
	TriggerEvent('chat:addMessage', {
		color = { 0, 0, 255 },
		multiline = true,
		args = { "Chopshop", "Hot vehicle " .. randomVeh .. " available at " .. zone .. " on " .. street .. " with plate number: " .. HotVehPlate }
	})
end)

RegisterNetEvent('cad-chopshop:informClients', function()
	HotVehPlate = nil
	HotVehModel = nil
	PlaySoundFrontend( -1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
	TriggerEvent('chat:addMessage', {
		color = { 0, 0, 255 },
		multiline = true,
		args = { "Chopshop", "The hot vehicle is no longer needed. Wait for another hot vehicle" }
	})
end)

RegisterNetEvent('cad-chopshop:HowToMsg', function()
	if chopTable then
		QBCore.Functions.Notify("Bring the hot vehicle in front me and you will know.", 'success', 5000)
		SetNewWaypoint(chopTable.x, chopTable.y)
	else
		QBCore.Functions.Notify("Get a chop radio and ill tel you what to do.", 'success', 5000)
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
if Config.ChopShopPed and Config.ChopShopPeds then
	local function loadModel(model)
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end
	end
	local function loadAnim(dict)
		RequestAnimDict(dict)
		while not HasAnimDictLoaded(dict) do
			Wait(50)
		end
	end
	for _, data in pairs(ChopShopPed) do
		loadModel(data.model)
		local entity = CreatePed(0, data.model, data.coords.x, data.coords.y, data.coords.z, data.coords.w, true, false)
		FreezeEntityPosition(entity, true)
		SetBlockingOfNonTemporaryEvents(entity, true)
		if data.animDict and data.animName then
			loadAnim(data.animDict)
			TaskPlayAnim(entity, data.animDict, data.animName, 8.0, 0, -1, 1, 0, 0, 0)
		end
		if data.scenario then TaskStartScenarioInPlace(entity, data.scenario, 0, true) end
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
	end
end
end)

CreateThread(function()
	while true do
		Wait(0)
		local inRange = false
		local pPed = PlayerPedId()
		local plyCoords = GetEntityCoords(pPed)
		local isInChopRange = false
		for _, coord in pairs(ChopShop) do
			local distance = #(plyCoords-vector3(coord.x, coord.y, coord.z))
			if distance < 4 then
				if IsPedInAnyVehicle(pPed, true) then
					isInChopRange = true
					inRange = true
				end
			end
		end
		if isInChopRange then
			local pVehicle = GetVehiclePedIsIn(pPed, false)
			local pSeat = (GetPedInVehicleSeat(pVehicle, -1) == pPed)
			local pVehModel = GetDisplayNameFromVehicleModel(GetEntityModel(pVehicle))
			local pPlate = GetVehicleNumberPlateText(pVehicle)
			ShowHelpNotification("Press ~INPUT_CONTEXT~ to chop the vehicle", true, true, 10000)
			if IsControlJustReleased(0, 46) and pSeat then
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
					SetEntityAsMissionEntity(pVehicle, true, true)
					DeleteEntity(pVehicle)
					if DoesEntityExist(pVehicle) then DeleteEntity(pVehicle) end
					Wait(math.random(500, 2000))
					local chance = math.random()
					if chance < 0.15 then
						TriggerServerEvent('cad-chopshop:recievereward', "rare1")
					elseif chance > 0.85 then
						TriggerServerEvent('cad-chopshop:recievereward', "rare2")
					else
						TriggerServerEvent('cad-chopshop:recievereward', "normal")
					end
					QBCore.Functions.Notify('The vehicle has been chopped', 'error')
					TriggerServerEvent('cad-chopshop:vehicleChopped')
					HotVehPlate = nil
					HotVehModel = nil
				else
					QBCore.Functions.Notify('This is not the hot vehicle', 'error')
				end
			end
		end
		if not inRange then
			Wait(1000)
		end
	end
end)
