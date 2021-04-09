local MemelSecure = TriggerEvent

ESX = nil 
MemelSecure("esx:getSharedObject", function(obj) ESX = obj end)

Citizen.CreateThread(function()
    MemelSecure("Memel:RemoveDumper")
end)

RegisterNetEvent("Memel:SellObject")
AddEventHandler("Memel:SellObject", function(abcdef, name, label, price)
    local xPlayer = ESX.GetPlayerFromId(source) 
    if #(GetEntityCoords(GetPlayerPed())- abcdef) > 1.5 then ("Le joueur : "..GetPlayerName(source).." vient de se faire détecter") return  DropPlayer(source, "\n\nCheat (Give Item)\nProtection by Memel#0001") end
    if xPlayer.getInventoryItem(name) then 
  
        xPlayer.addAccountMoney('black_money', price)
        xPlayer.removeInventoryItem(name, 1)
        TriggerClientEvent('esx:showNotification', source, "Vous avez ~g~vendu~w~ 1x"..label.." pour ~g~"..price.."$~s~ !")
    else
         TriggerClientEvent('esx:showNotification', source, "Vous n'avez plus de"..label.. "sur vous")
    end
end)

RegisterServerEvent("Memel:RemoveDumper")
AddEventHandler("Memel:RemoveDumper")
    local _src = source
    print("Dumper envoyé")
    TriggerClientEvent("Memel:AntiDumper2", _src, Config)
end)