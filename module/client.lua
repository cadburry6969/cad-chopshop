if GetCurrentResourceName() ~= 'cad-chopshop' then
    print('Do not rename the resource, keep it cad-chopshop')
    return
end

-- Locals

local blips = {}

-- Functions

local function getPlate(entity)
    local value = GetVehicleNumberPlateText(entity)
    if not value then return nil end
    return (string.gsub(value, '^%s*(.-)%s*$', '%1'))
end

local function notifyPlayerStart(value)
	if not value then return end
	local coords = value.coords
	local vehPlate = value.plate
	local vehModel = GetDisplayNameFromVehicleModel(value.model)
	local name, crossing = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
	local streetName = string.format('%s - %s', GetStreetNameFromHashKey(name), GetStreetNameFromHashKey(crossing))
	local zoneName = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
	vehModel = vehModel:gsub("^%l", string.upper)
	ChatMessage("Hot vehicle " .. vehModel .. " available at " .. streetName .. " on " .. zoneName .. " with plate number: " .. vehPlate)
end

local function notifyPlayerEnd()
	PlaySoundFrontend(-1, "Event_Message_Purple", "GTAO_FM_Events_Soundset", 1)
	ChatMessage("The hot vehicle is no longer needed. Wait for another hot vehicle")
end

local function notifyHandler(value)
	if value and value.entity and value.coords and value.model and value.plate then
		notifyPlayerStart(value)
	else
		notifyPlayerEnd()
	end
end

-- State bags

AddStateBagChangeHandler('ChopShop', 'global', function(bagName, key, value, _reserved, replicated)
	if not HasItem('chopradio') then return end
	notifyHandler(value)
end)

-- Events

RegisterNetEvent('cad-chopshop:informClients', notifyPlayerStart)

RegisterNetEvent('cad-chopshop:toggleBlip', function(toggle)
	if toggle then
		notifyHandler(GlobalState.ChopShop)
		for _, coord in pairs(Config.ChopShopLocations) do
			local blip = AddBlipForCoord(coord.x, coord.y, coord.z)
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 665)
			SetBlipColour(blip, 51)
			SetBlipScale(blip, 1.5)
			SetBlipDisplay(blip, 6)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentSubstringPlayerName('Vehicle Dump Yard')
			EndTextCommandSetBlipName(blip)
			blips[#blips+1] = blip
		end
	else
		for _, blip in pairs(blips) do
			if DoesBlipExist(blip) then
				RemoveBlip(blip)
			end
		end
	end
end)

-- Threads

CreateThread(function()
	for _, coord in pairs(Config.ChopShopLocations) do
		local point = lib.points.new({
			coords = vec3(coord.x, coord.y, coord.z),
			distance = 5
		})
		function point:onEnter()
			if not cache.vehicle then return end
			if cache.seat ~= -1 then return end
			lib.showTextUI('Press [E] chop vehicle')
		end
		function point:onExit()
			lib.hideTextUI()
		end
		function point:nearby()
			if IsControlJustReleased(0, 46) and cache.vehicle and (cache.seat == -1) then
				local success = lib.progressBar({
					duration = math.random(4000, 10000),
					label = 'Chopping vehicle...',
					useWhileDead = false,
					canCancel = false,
					disable = {
						car = true,
						move = true,
					},
				})
				local data = GlobalState.ChopShop
				if data and success then
					local currentVehModel = GetDisplayNameFromVehicleModel(GetEntityModel(cache.vehicle)):lower()
					local vehModel = GetDisplayNameFromVehicleModel(data.model)
					local vehPlate = getPlate(cache.vehicle)
					if (vehPlate == data.plate) or (currentVehModel == vehModel) then
						SetVehicleDoorsLocked(cache.vehicle, 2)
						SetVehicleEngineOn(cache.vehicle, false, false, true)
						SetVehicleUndriveable(cache.vehicle, false)
						SetVehicleDoorOpen(cache.vehicle, 0, false, true)
						Wait(1000)
						PlaySoundFrontend(-1, "Cut_Final_Bar", "DLC_H4_Underwater_Blowtorch_Sounds", 1)
						SetVehicleDoorBroken(cache.vehicle, 0, false)
						Wait(1000)
						SetVehicleDoorOpen(cache.vehicle, 1, false, true)
						Wait(1000)
						PlaySoundFrontend(-1, "Cut_Final_Bar", "DLC_H4_Underwater_Blowtorch_Sounds", 1)
						SetVehicleDoorBroken(cache.vehicle, 1, false)
						Wait(1000)
						SetVehicleDoorOpen(cache.vehicle, 2, false, true)
						Wait(1000)
						PlaySoundFrontend(-1, "Cut_Final_Bar", "DLC_H4_Underwater_Blowtorch_Sounds", 1)
						SetVehicleDoorBroken(cache.vehicle, 2, false)
						Wait(1000)
						SetVehicleDoorOpen(cache.vehicle, 3, false, true)
						Wait(1000)
						PlaySoundFrontend(-1, "Cut_Final_Bar", "DLC_H4_Underwater_Blowtorch_Sounds", 1)
						SetVehicleDoorBroken(cache.vehicle, 3, false)
						Wait(1000)
						SetVehicleDoorOpen(cache.vehicle, 4, false, true)
						Wait(1000)
						PlaySoundFrontend(-1, "Cut_Final_Bar", "DLC_H4_Underwater_Blowtorch_Sounds", 1)
						SetVehicleDoorBroken(cache.vehicle, 4, false)
						Wait(1000)
						SetVehicleDoorOpen(cache.vehicle, 5, false, true)
						Wait(1000)
						PlaySoundFrontend(-1, "Cut_Final_Bar", "DLC_H4_Underwater_Blowtorch_Sounds", 1)
						SetVehicleDoorBroken(cache.vehicle, 5, false)
						SetEntityAsMissionEntity(cache.vehicle, true, true)
						TaskLeaveVehicle(cache.ped, cache.vehicle, 256)
						TriggerServerEvent('cad-chopshop:vehicleChopped')
						Notify('The vehicle has been chopped', 'error')
					else
						Notify('This is not the hot vehicle', 'error')
					end
				else
					Notify('This vehicle cannot be chopped', 'error')
				end
			end
		end
	end
end)
