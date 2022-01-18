This scripts been a long time dream, based off an idea my favorite server LARP pioneered.

The meth cook location moves based on a timer, syncs to clients, the commands Lamar/BillyJoe are in to have them send you the coords of where they are at the moment. -- this worked perfectly with my edit to the skill system and time gating.
The phone I was using with this at the time was btn phone because it supported sending gps location. if you dont wana use it you are on your own.

credit to disc on the snippet I yanked to make the texts work

originally I had a modified version of gamz skills doing a ton of stuff with the levels but I commented out the requirements and swapped with temp vars.
Originally I had an npc that would buy the meth from you but I commented/removed most of the code to it.
(modified version of MrNewbPawn)
I just switched to using qb-core so if anyone feels like making a qb-core version or improving it go right ahead but do not sell this, its a open community on an open platform and if you do you are a scumbag leach fk.


gc phone edit required


ESX.RegisterServerCallback('disc-gcphone:getNumber', function(source, cb)
    local player = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = player.identifier
    }, function(result)
        if result[1] ~= nil then
            return cb(result[1].phone_number)
        end
        return cb(nil)
    end)
end)

RegisterServerEvent('disc-gcphone:sendMessageFrom')
AddEventHandler('disc-gcphone:sendMessageFrom', function(from, number, message, serverId)
    TriggerEvent('gcPhone:_internalAddMessage', from, number, message, 0, function (smsMess)
        TriggerClientEvent("gcPhone:receiveMessage", serverId, smsMess)
    end)
end)


ambulance job edit required - add this at the bottom on esx_ambulancejob/client.lua

function GetDeath()
    if isDead then
        return true
    elseif not isDead then
        return false
    end
end

exports('GetDeath', GetDeath)


you will need these items in db

meth10g
sudo
acetone
antifreeze


if you rename this you are a cuck


https://streamable.com/vi495y

https://streamable.com/utqtlv