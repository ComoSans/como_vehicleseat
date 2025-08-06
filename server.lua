local QBCore = exports['qb-core']:GetCoreObject()

-- Example server-side event (can be expanded for additional functionality)
RegisterNetEvent('como_vehicleseat:server:checkVehicleAccess', function(playerId, vehicle)
    -- Add server-side checks if needed (e.g., vehicle ownership)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        -- Example: Add logic to check vehicle ownership or permissions
        -- TriggerClientEvent('QBCore:Notify', playerId, 'Vehicle access check passed!', 'success')
    end
end)
