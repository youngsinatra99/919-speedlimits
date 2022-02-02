local SpeedLimitEnabled = false
local UIOpen = false

-- TEST COMMAND
--[[
RegisterCommand('speedlimit', function(source, args)
    SpeedLimitEnabled = not SpeedLimitEnabled
end)
]]

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
            if SpeedLimitEnabled and not UIOpen then
                SendNUIMessage({action = "show"})
                UIOpen = true
            elseif SpeedLimitEnabled and UIOpen then
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
        end
    end
end)

function GetSpeedLimit()
    local coords = GetEntityCoords(PlayerPedId())
    return Config.SpeedLimits[GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))]
end