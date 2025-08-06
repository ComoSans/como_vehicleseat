local function isSeatOccupied(vehicle, seatIndex)
    return IsVehicleSeatFree(vehicle, seatIndex) == false
end

local function isVehicleLocked(vehicle)
    local lockStatus = GetVehicleDoorLockStatus(vehicle)
    return lockStatus == 2 or lockStatus == 3
end

local function getClosestVehicle()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(playerCoords.x, playerCoords.y, playerCoords.z, Config.SearchRadius, 0, 71)
    if not vehicle or vehicle == 0 then
        return nil, nil
    end
    local vehicleCoords = GetEntityCoords(vehicle)
    local distance = #(playerCoords - vehicleCoords)
    return vehicle, distance
end

local function sitInSeat(vehicle, seatIndex)
    if not vehicle or isVehicleLocked(vehicle) then
        lib.notify({ title = 'Error', description = Config.Notify.vehicle_locked, type = 'error' })
        return
    end

    if isSeatOccupied(vehicle, seatIndex) then
        lib.notify({ title = 'Error', description = Config.Notify.seat_taken, type = 'error' })
        return
    end

    TaskEnterVehicle(PlayerPedId(), vehicle, 10000, seatIndex, 1.0, 1, 0)
end

local function getDoorBones(vehicle)
    local doorBones = {}
    local numDoors = GetNumberOfVehicleDoors(vehicle)
    
    -- Standard door bones
    local standardDoors = {
        'door_dside_f', 'door_pside_f', 'door_dside_r', 'door_pside_r',
        'door_dside_f2', 'door_pside_f2', 'door_dside_r2', 'door_pside_r2'  -- For vehicles with extra doors
    }
    for _, boneName in ipairs(standardDoors) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
        if boneIndex ~= -1 then
            table.insert(doorBones, boneIndex)
        end
    end
    
    local hoodTrunkBones = {'bonnet', 'boot', 'door_hood', 'door_trunk'} 
    for _, boneName in ipairs(hoodTrunkBones) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
        if boneIndex ~= -1 then
            table.insert(doorBones, boneIndex)
        end
    end   

    for i = 0, numDoors - 1 do
        local boneName = 'door_' .. i
        local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
        if boneIndex ~= -1 then
            table.insert(doorBones, boneIndex)
        end
    end
    
    return doorBones
end

local function isNearDoor(vehicle, doorBones)
    local playerCoords = GetEntityCoords(PlayerPedId())
    for _, boneIndex in ipairs(doorBones) do
        local bonePos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
        if #(playerCoords - bonePos) <= Config.DoorRange then
            return true
        end
    end
    return false
end

local function addVehicleSeatTargets(vehicle)
    if not DoesEntityExist(vehicle) then return end

    exports.ox_target:removeLocalEntity(vehicle)

    local seatOptions = {}
    for seatIndex, label in pairs(Config.SeatLabels) do
        table.insert(seatOptions, {
            label = string.format(Config.Notify.enter_seat, label),
            icon = 'fas fa-chair',
            onSelect = function()
                sitInSeat(vehicle, seatIndex)
            end,
            canInteract = function()
                return not isSeatOccupied(vehicle, seatIndex) and not isVehicleLocked(vehicle)
            end
        })
    end

    exports.ox_target:addLocalEntity(vehicle, seatOptions)
end

local lastVehicle = nil
Citizen.CreateThread(function()
    while true do
        local vehicle, distance = getClosestVehicle()
        if vehicle and distance <= Config.SearchRadius then
            local doorBones = getDoorBones(vehicle)
            if isNearDoor(vehicle, doorBones) then
                if vehicle ~= lastVehicle then
                    addVehicleSeatTargets(vehicle)
                    lastVehicle = vehicle
                end
            elseif lastVehicle == vehicle then
                exports.ox_target:removeLocalEntity(lastVehicle)
                lastVehicle = nil
            end
        elseif lastVehicle then
            exports.ox_target:removeLocalEntity(lastVehicle)
            lastVehicle = nil
        end
        Citizen.Wait(500) -- Check every 0.5 seconds for better responsiveness
    end
end)

if Config.Debug then
    Citizen.CreateThread(function()
        while true do
            local vehicle, distance = getClosestVehicle()
            if vehicle and distance <= Config.SearchRadius then
                for seatIndex, _ in pairs(Config.SeatLabels) do
                    local seatPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, 'seat_dside_f' .. (seatIndex == -1 and '' or seatIndex)))
                    if seatPos ~= vector3(0, 0, 0) then
                        DrawMarker(1, seatPos.x, seatPos.y, seatPos.z, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 255, 0, 0, 100, false, true, 2, nil, nil, false)
                    end
                end
               local doorBones = getDoorBones(vehicle)
                for _, boneIndex in ipairs(doorBones) do
                    local bonePos = GetWorldPositionOfEntityBone(vehicle, boneIndex)
                    if bonePos ~= vector3(0, 0, 0) then
                        DrawMarker(28, bonePos.x, bonePos.y, bonePos.z, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0.5, 0, 255, 0, 100, false, true, 2, nil, nil, false)
                    end
                end
            end
            Citizen.Wait(0)
        end
    end)
end
