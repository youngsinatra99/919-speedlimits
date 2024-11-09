local enabled = false
local UIOpen = false
local currentStreet = nil
local frequency = Config.updateFrequency * 1000

local function SaveSpeedLimitState()
    SetResourceKvp("speedLimit", tostring(enabled))
end

local function LoadSpeedLimitState()
    local savedState = GetResourceKvpString("speedLimit")
    if savedState then
        enabled = savedState == "true"
    else
        enabled = true
        SaveSpeedLimitState()
    end
end

LoadSpeedLimitState()

RegisterCommand(Config.toggleCommand, function(source, args)
    enabled = not enabled
    SaveSpeedLimitState()
    TriggerEvent("919-speedlimit:client:ToggleSpeedLimit", enabled)
end)

RegisterNetEvent("919-speedlimit:client:ToggleSpeedLimit", function(toggle)
    if toggle then
        SendNUIMessage({action = "show"})
        UIOpen = true
    else
        SendNUIMessage({action = "hide"})
        UIOpen = false
        currentStreet = nil
    end
    enabled = toggle
    SaveSpeedLimitState()
end)

Citizen.CreateThread(function()
    while true do
        Wait(frequency)
        if IsPedInAnyVehicle(PlayerPedId()) and enabled then
            if not UIOpen then
                SendNUIMessage({action = "show"})
                UIOpen = true
            end
            
            local newStreet = GetStreetNameFromHashKey(GetStreetNameAtCoord(table.unpack(GetEntityCoords(PlayerPedId()))))
                
            if newStreet ~= currentStreet then
                currentStreet = newStreet
                local speed = Config.SpeedLimits[currentStreet]
                if speed then
                    SendNUIMessage({action = "setlimit", speed = speed})
                end
            end
        elseif UIOpen then
            SendNUIMessage({action = "hide"})
            UIOpen = false
        end
    end
end)