local SpeedLimitEnabled = false
local UIOpen = false
local manualOverride = false

-- TEST COMMAND
--[[
RegisterCommand('speedlimit', function(source, args)
    SpeedLimitEnabled = not SpeedLimitEnabled
end)
]]

RegisterCommand('togglesl', function(_, _)
    if SpeedLimitEnabled then
        TriggerEvent("919-speedlimit:client:ToggleSpeedLimit", false)

    else
        TriggerEvent("919-speedlimit:client:ToggleSpeedLimit", true)
    end
    SpeedLimitEnabled = not SpeedLimitEnabled
    manualOverride = not manualOverride
end)

TriggerEvent('chat:addSuggestion', '/togglesl', 'Toggle the speed limit UI on or off.')

RegisterNetEvent("919-speedlimit:client:ToggleSpeedLimit", function(toggle)
    if toggle then
        SendNUIMessage({action = "show"})
        UIOpen = true
        SpeedLimitEnabled = true
    else
        SendNUIMessage({action = "hide"})
        UIOpen = false
        SpeedLimitEnabled = false
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if IsPedInAnyVehicle(PlayerPedId()) then
            if SpeedLimitEnabled and not manualOverride and not UIOpen then
                SendNUIMessage({action = "show"})
                UIOpen = true
            elseif SpeedLimitEnabled and UIOpen and not manualOverride then
                local speed = GetSpeedLimit()
                if speed then
                    SendNUIMessage({action = "setlimit", speed = speed})
                end
            end
        else
            if SpeedLimitEnabled and UIOpen then
                SendNUIMessage({action = "hide"})
                UIOpen = false
            end
            if manualOverride then
                manualOverride = false
            end
        end
    end
end)

function GetSpeedLimit()
    local coords = GetEntityCoords(PlayerPedId())
    return Config.SpeedLimits[GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))]
end