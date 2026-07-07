if not game:IsLoaded() then
    game.Loaded:Wait()
end

local currentPlaceID = game.PlaceId

local SilentHubScripts = {
    DuelistPay = {
        IDs = {122310270867133}, 
        Url = "https://raw.githubusercontent.com/Silent-lua/Universal/main/Duelist.Pay.lua"
    }
}

local targetScriptUrl = nil
local detectedGameName = nil

for gameName, gameData in pairs(SilentHubScripts) do
    for _, id in ipairs(gameData.IDs) do
        if id == currentPlaceID then
            targetScriptUrl = gameData.Url
            detectedGameName = gameName
            break
        end
    end
    if targetScriptUrl then break end 
end

if targetScriptUrl then
    print("SilentHub: Juego detectado (" .. detectedGameName .. "). Iniciando...")
    
    local success, err = pcall(function()
        -- Se añade ?t= y la marca de tiempo actual para evitar la caché vieja del servidor
        local rawCode = game:HttpGet(targetScriptUrl .. "?t=" .. os.time())
        local loadedFunction, compileError = loadstring(rawCode)
        
        if loadedFunction then
            loadedFunction()
        else
            error("Error de compilación en el script remoto: " .. tostring(compileError))
        end
    end)

    if not success then
        warn("SilentHub: Error crítico al cargar " .. detectedGameName)
        warn("Detalles: " .. tostring(err))
    end
else
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "SilentHub",
            Text = "Juego no soportado. ID actual: " .. tostring(currentPlaceID),
            Duration = 5
        })
    end)
end
