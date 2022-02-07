local QBCore = exports["qb-core"]:GetCoreObject()
local Srv_coord = nil
local place_nthings = {[1] = vector3(2431.8738, 4967.6113, 42.3476), [2] = vector3(1443.4229, 6331.8169, 23.9819), [3] = vector3(28.40, 3665.70, 40.40), [4] = vector3(28.40, 3665.70, 40.40), [5] = vector3(1391.86, 3605.71, 38.94)}

RegisterServerEvent('mvrp_cookin:debug_command')
AddEventHandler('mvrp_cookin:debug_command', function()
	location = math.random(1, 5)
	Srv_coord = place_nthings[location]
	TriggerClientEvent("mrnewbmeth:updatecoords_toclient", -1, Srv_coord)
	print("DEBUG COMMAND TRIGGERED Coords updating for meth location rolled "..json.encode(location).. " Vector 3s are "..json.encode(Srv_coord))
	local cookbench = CreateObject(656091709, Srv_coord.x, Srv_coord.y, Srv_coord.z, true, false, false)
end)

Citizen.CreateThread(function()
	location = math.random(1, 5)
	Srv_coord = place_nthings[location]
	print("DEBUG COMMAND TRIGGERED Coords updating for meth location rolled "..json.encode(location).. " Vector 3s are "..json.encode(Srv_coord))
	local cookbench = CreateObject(656091709, Srv_coord.x, Srv_coord.y, Srv_coord.z, true, false, false)
	updateserverlocation()
end)

function updateserverlocation()
	while true do
		Wait(120*60*1000)
		location = math.random(1, 5)
		Srv_coord = place_nthings[location]
		TriggerClientEvent("mrnewbmeth:updatecoords_toclient", -1, Srv_coord)
		print("DEBUG COMMAND TRIGGERED Coords updating for meth location rolled "..json.encode(location).. " Vector 3s are "..json.encode(Srv_coord))
		local cookbench = CreateObject(656091709, Srv_coord.x, Srv_coord.y, Srv_coord.z, true, false, false)
	end
end

RegisterNetEvent('MrNewbMethv2QB:server:UpdateReputation', function(quality)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local methskill = Player.PlayerData.metadata["meth"]

	if methskill["meth"] ~= nil and methskill["meth"] + 3 > Config.MaxReputation then
		methskill["meth"] = Config.MaxReputation
		Player.Functions.SetMetaData("meth", methskill)
		TriggerClientEvent('MrNewbMethv2QB:client:UpdateReputation', src, methskill)
		return
	end
	if methskill["meth"] == nil then
		methskill["meth"] = 3
	else
		methskill["meth"] = methskill["meth"] + 3
	end
    Player.Functions.SetMetaData("meth", methskill)
    TriggerClientEvent('MrNewbMethv2QB:client:UpdateReputation', src, methskill)
end)

RegisterServerEvent('mvrp_cookin:transform', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
	
	local Item = Player.Functions.GetItemByName('acetone')
	local Item2 = Player.Functions.GetItemByName('antifreeze')
	local Item3 = Player.Functions.GetItemByName('sudo')

	if Item.amount >= 3 and Item2.amount >= 2 and Item3.amount >= 10 then
		Player.Functions.RemoveItem('acetone', 3)
		Player.Functions.RemoveItem('antifreeze', 5)
		Player.Functions.RemoveItem('sudo', 10)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['acetone'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['antifreeze'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['sudo'], "remove")
		wait(5000)
		Player.Functions.AddItem('meth10g', 1)
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['meth10g'], "add")
	else
		TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error")
	end
end)

RegisterServerEvent('mvrp_cookin:playerloggedin')
AddEventHandler('mvrp_cookin:playerloggedin', function()
	local _source = source
	TriggerClientEvent("mrnewbmeth:updatecoords_toclient", _source, Srv_coord)
end)
