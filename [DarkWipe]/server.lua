-- server.lua
-- This script handles the timing and logic for the Dark Wipe.

--[[================================================================
-- CONFIGURATION
-- You can easily change the settings here.
--================================================================]]
local Config = {}

-- Set how often the vehicle wipe occurs (in hours).
Config.IntervalHours = 12

-- Set how many minutes before the wipe to warn players.
Config.WarningMinutes = 5

-- The message that will be broadcast to all players before the wipe.
-- %d will be replaced with the number of minutes from the setting above.
Config.WarningMessage = "SERVER NOTICE: All unattended vehicles will be cleared from the map in %d minutes to improve performance. Please store any personal vehicles."

-- The message that will be broadcast after the wipe is complete.
Config.WipeMessage = "SERVER NOTICE: Vehicle cleanup complete. Thank you for your cooperation."


--[[================================================================
-- SCRIPT LOGIC (Do not edit below this line)
--================================================================]]
-- Convert hours and minutes to milliseconds for the timer.
local wipeInterval = Config.IntervalHours * 60 * 60 * 1000
local warningTime = Config.WarningMinutes * 60 * 1000

-- Main server loop
Citizen.CreateThread(function()
    print("[DarkWipe] Script started. Wipes will occur every " .. Config.IntervalHours .. " hours.")
    
    while true do
        -- Wait for the main interval period, minus the warning time.
        Citizen.Wait(wipeInterval - warningTime)

        -- Send the warning message to all players (-1 = all clients).
        print("[DarkWipe] Sending cleanup warning to all players.")
        TriggerClientEvent('darkwipe:client:ShowMessage', -1, string.format(Config.WarningMessage, Config.WarningMinutes))

        -- Wait for the warning period to pass.
        Citizen.Wait(warningTime)

        -- It's time to wipe the vehicles.
        print("[DarkWipe] Initiating vehicle cleanup.")
        local vehicleCount = 0

        -- GetAllVehicles() is a FiveM native that returns a table of all vehicle entities.
        for _, vehicle in ipairs(GetAllVehicles()) do
            -- We check if the vehicle is a network entity and actually exists before deleting it.
            -- This helps prevent errors and ensures we only delete relevant vehicles.
            if DoesEntityExist(vehicle) and IsEntityANetworkObject(vehicle) then
                DeleteEntity(vehicle)
                vehicleCount = vehicleCount + 1
            end
        end

        -- Log the action to the server console and notify players.
        print("[DarkWipe] Cleanup complete. Deleted " .. vehicleCount .. " vehicles.")
        TriggerClientEvent('darkwipe:client:ShowMessage', -1, Config.WipeMessage)
    end
end)