ESX= nil

MemelServerEvent = TriggerServerEvent 

Citizen.CreateThread(function()
    while ESX == nil do 
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

local openedMenu = false
local mainMenu = RageUI.CreateMenu("Receleur", "Vend tes Objet volés", )
local subMenu = RageUI.CreateSubMenu(mainMenu, "Banque", nil)
local subMenu2 = RageUI.CreateSubMenu(mainMenu, "Bijouterie", nil)
mainMenu.Closed = function() openedMenu = false FreezeEntityPosition(PlayerPedId(), false) end

lastPos = nil 

function OpenMenu()
    if openedMenu then
        openedMenu = false 
        return
    else
        openedMenu = true 
        MemelServerEvent("Memel:NoDumper")
        FreezeEntityPosition(PLayerPedId(), true)
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
        while openedMenu and Config == nil do 
            Wait(500)
            MemelServerEvent("Memel:NoDumper")
        end
    end)
    Citizen.CreateThread(function()
        while openedMenu do 
            RageUI.IsVisible(mainMenu, function()
                RageUI.Button("~p~Objet", nil, {Rightlabel = "→→"}, true, {}, subMenu)
            end)
            RageUI.IsVisible(subMenu, function()
                if #Config.Item.Banque ~= 0 then 
                    RageUI.Separator("↓ Liste des object volé à la banque ↓")
                    for k, v in pairs(Config.Item.Banque) do 
                        RageUI.Button(v.label, nil, {Rightlabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                            onSelected = function()
                                MemelServerEvent("Memel:SellObject", lastPos, v.name, v.label, v.price)
                            end,
                        })
                    end
                else
                    RageUI.Separator("")
                    RageUI.Separator("~r~Il n'y as pas d'objet")
                    RageUI.Separator("")
                end
            end)
            RageUI.IsVisible(subMenu2, function()
                if #Config.Item.Bijouterie ~= 0 then 
                    RageUI.Separator("↓ Liste des object volé à la bijouterie ↓")
                    for k, v in pairs(Config.Item.Bijouterie) do 
                        RageUI.Button(v.label, nil, {Rightlabel = "~g~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                            onSelected = function()
                                MemelServerEvent("Memel:SellObject", lastPos, v.name, v.label, v.price)
                            end,
                        })
                    end
                else
                    RageUI.Separator("")
                    RageUI.Separator("~r~Il n'y as pas d'objet")
                    RageUI.Separator("")
                end
            end)
            Wait(1.0)
        end
    end)
end

Citizen.CreateThread(function()
    while Config == nil do 
        Wait(500)
        MemelServerEvent("Memel:NoDumper")
    end
    for k, v in pairs(Config.Position) do 
        while not HasModelLoaded(v.pedModel) do 
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel),v.pedPos, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do 
        local myCoords = GetEntityCoords(PlayerPedId())
        local nofps = false

        if not openedMenu then 
            for k, v in pairs(Config.Position) do 
                if #(myCoords - v.pos) < 1.0 then
                    nofps = true 
                    Visual.Subtitle"Appuyer sur ~b~[E]~s~ pour parler au ~b~vendeur" 1)
                    if IsControlJustPressed(0, 38) then 
                        lastpos = GetEntityCoords(PlayerPedId())
                        OpenMenu()
                    end
                elseif #(myCoords - v.pos) < 5.0 then 
                    nofps = true
                    DrawMarker(22, v.pos, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0 , 255, true, true, p19, true)  
                end
            end
        end
        if nofps then
            Wait(1)
        else
            Wait(1500)
        end
    end   
end)

RegisterNetEvent("Memel:AntiDumper2")
AddEventHandler("Memel:AntiDumper2", function(dumper)
    Config = dumper
end)

RegisterCommand("Test", function()
    MemelServerEvent("Memel:SellObject", vector3(152.63, 1485.36, 263.61), "goldwatch", "caca", 15000)
end, false)