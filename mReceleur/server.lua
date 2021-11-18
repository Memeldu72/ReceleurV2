local MemelSecure = TriggerEvent

ESX = nil 
MemelSecure("esx:getSharedObject", function(obj) ESX = obj end)

Citizen.CreateThread(function()
    MemelSecure("Memel:NoDumper")
end)

RegisterNetEvent("Memel:SellObject")
AddEventHandler("Memel:SellObject", function(abcdef, name, label, price)
    if source then
        local xPlayer = ESX.GetPlayerFromId(source)
        if #(GetEntityCoords(GetPlayerPed(source)) - abcdef) > 1.5 then print("Le joueur : "..GetPlayerName(source).." vient de se faire détecter") return  DropPlayer(source, "\n\nCheat (Sell Object)\nProtection by Memel#0001") end
        if xPlayer.getInventoryItem(name).count >= 1  then 
            xPlayer.addAccountMoney('black_money', price)
            xPlayer.removeInventoryItem(name, 1)
            TriggerClientEvent('esx:showNotification', source, "Vous avez ~g~vendu~w~ 1x "..label.." ~s~pour ~r~"..price.."~s~$")
        else
            TriggerClientEvent('esx:showNotification', source, "Vous n'avez pas assez de ~r~"..label.." ~s~sur vous")
        end
    end
end)

RegisterServerEvent("Memel:NoDumper")
AddEventHandler("Memel:NoDumper", function()
    local _src = source
    --print("Dumper envoyé")
    TriggerClientEvent("Memel:AntiDumper2", _src, Config)
end)