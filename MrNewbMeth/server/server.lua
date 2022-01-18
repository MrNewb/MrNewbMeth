local ESX = nil
local Srv_coord = nil
local Srv_dealr = nil
local place_nthings = {[1] = vector3(2431.8738, 4967.6113, 42.3476), [2] = vector3(1443.4229, 6331.8169, 23.9819), [3] = vector3(28.40, 3665.70, 40.40), [4] = vector3(28.40, 3665.70, 40.40), [5] = vector3(1391.86, 3605.71, 38.94)}
local dealer_locations = {[1] = vector3(435.90001, 6463.90001, 27.70001), [2] = vector3(-1350.9001, -939.9001, 8.7001), [3] = vector3(955.5001, -195.1001, 72.2001)}

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterServerEvent('mvrp_cookin:debug_command')
AddEventHandler('mvrp_cookin:debug_command', function()
	location = math.random(1, 5)
	deallocation = math.random(1, 3)
	Srv_coord = place_nthings[location]
	Srv_dealr = dealer_locations[deallocation]
	print("DEBUG COMMAND TRIGGERED Coords updating for meth location rolled "..json.encode(location).. " Vector 3s are "..json.encode(Srv_coord))
	print("DEBUG COMMAND TRIGGERED Coords updating for meth dealer rolled "..json.encode(deallocation).. " Vector 3s are "..json.encode(Srv_dealr))
	TriggerClientEvent("mrnewbmeth:updatecoords_toclient", -1, Srv_coord, Srv_dealr)
end)

Citizen.CreateThread(function()
	location = math.random(1, 5)
	deallocation = math.random(1, 3)
	Srv_coord = place_nthings[location]
	Srv_dealr = dealer_locations[deallocation]
	print("MrNewbMeth started and rolling starter meth location coords as number "..json.encode(location).. " the Vector 3s are "..json.encode(Srv_coord))
	print("MrNewbMeth started and rolling starter dealer location coords as number "..json.encode(deallocation).. " the Vector 3s are "..json.encode(Srv_dealr))
	updateserverlocation()
end)

function updateserverlocation()
	while true do
		Wait(120*60*1000)
		location = math.random(1, 5)
		deallocation = math.random(1, 3)
		Srv_coord = place_nthings[location]
		Srv_dealr = dealer_locations[deallocation]
		print("Coords time updating for meth location rolled "..json.encode(location).. " Vector 3s are "..json.encode(Srv_coord))
		print("Coords time updating for meth dealer rolled "..json.encode(deallocation).. " Vector 3s are "..json.encode(Srv_dealr))
		TriggerClientEvent("mrnewbmeth:updatecoords_toclient", -1, Srv_coord, Srv_dealr)
	end
end

RegisterServerEvent("mvrp_cookin:cheknbby")
AddEventHandler("mvrp_cookin:cheknbby", function()
    local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getInventoryItem('acetone').count > 2 and xPlayer.getInventoryItem('antifreeze').count > 4 and xPlayer.getInventoryItem('sudo').count > 9 then 
        xPlayer.removeInventoryItem("acetone", 3)
		Wait(300)
        xPlayer.removeInventoryItem("antifreeze", 5)
		Wait(300)
        xPlayer.removeInventoryItem("sudo", 10)
		Wait(300)
        TriggerClientEvent("mvrp_cookin:rolling", _source)
    else
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Seems like you are missing something for this.', style = { ['background-color'] = '##99ff99', ['color'] = '#000000' } })
		TriggerClientEvent('mvrp_cookin:doesnothaveshit', _source)
		Wait(40000)
    end
end)

RegisterServerEvent('mvrp_cookin:giveitup')
AddEventHandler('mvrp_cookin:giveitup', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.addInventoryItem('meth10g', 1)
end)

RegisterServerEvent('mvrp_cookin:playerloggedin')
AddEventHandler('mvrp_cookin:playerloggedin', function()
	local _source = source
	TriggerClientEvent("mrnewbmeth:updatecoords_toclient", _source, Srv_coord, Srv_dealr)
end)
