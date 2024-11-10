local enabled = true
local UIOpen = false
local currentStreet = nil
local frequency = Config.updateFrequency * 1000

CreateThread(function()
    local savedState = GetResourceKvpString("speedLimit")
    if savedState then
        enabled = savedState == "true"
    else
        SetResourceKvp("speedLimit", "true")
    end
end)

RegisterCommand(Config.toggleCommand, function(source, args)
    local toggle = not enabled
    if toggle then
        SendNUIMessage({action = "show"})
        UIOpen = true
    else
        SendNUIMessage({action = "hide"})
        UIOpen = false
        currentStreet = nil
    end
    enabled = toggle
    SetResourceKvp("speedLimit", tostring(enabled))
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
