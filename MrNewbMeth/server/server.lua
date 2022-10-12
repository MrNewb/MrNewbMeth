local QBCore = exports['qb-core']:GetCoreObject()
local Srv_coord = nil
local Srv_dealr = nil
local cookingskill = nil
local place_nthings = {[1] = vector3(2431.8738, 4967.6113, 42.3476), [2] = vector3(1443.4229, 6331.8169, 23.9819), [3] = vector3(28.40, 3665.70, 40.40), [4] = vector3(28.40, 3665.70, 40.40), [5] = vector3(1391.86, 3605.71, 38.94)}
local dealer_locations = {[1] = vector3(435.90001, 6463.90001, 27.70001), [2] = vector3(-1350.9001, -939.9001, 8.7001), [3] = vector3(955.5001, -195.1001, 72.2001)}
local meth_items = {[1] = 'meth', [2] = 'meth2', [3] = 'meth3',}

RegisterServerEvent('mvrp_cookin:debug_command')
AddEventHandler('mvrp_cookin:debug_command', function()
	location = math.random(1, 5)
	deallocation = math.random(1, 3)
	Srv_coord = place_nthings[location]
	Srv_dealr = dealer_locations[deallocation]
	TriggerClientEvent("mrnewbmeth:updatecoords_toclient", -1, Srv_coord, Srv_dealr)
end)

Citizen.CreateThread(function()
	location = math.random(1, 5)
	deallocation = math.random(1, 3)
	Srv_coord = place_nthings[location]
	Srv_dealr = dealer_locations[deallocation]
	updateserverlocation()
end)

function updateserverlocation()
	while true do
		Wait(120*60*1000)
		location = math.random(1, 5)
		deallocation = math.random(1, 3)
		Srv_coord = place_nthings[location]
		Srv_dealr = dealer_locations[deallocation]
		TriggerClientEvent("mrnewbmeth:updatecoords_toclient", -1, Srv_coord, Srv_dealr)
	end
end

QBCore.Functions.CreateUseableItem("meth_oz", function(source)
    TriggerClientEvent("mvrp_cookin:begin_bagging_meth", source)
end)

QBCore.Functions.CreateUseableItem("zipdocks", function(source)
    TriggerClientEvent("mvrp_cookin:begin_opening_zipdocks", source)
end)

RegisterNetEvent("mvrp_cookin:open_ziplock_bag", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local zipdocks = Player.Functions.GetItemByName('zipdocks')
    if zipdocks and zipdocks.amount >= 1 then
        Player.Functions.RemoveItem('zipdocks', 1)
		Wait(10)
		Player.Functions.AddItem('empty_weed_bag', 60 )
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['zipdocks'], "remove")
        Wait(1000)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_weed_bag'], "add")
        Wait(1000)
		TriggerClientEvent('QBCore:Notify', src, "Zipdocks everywhere!", "success")
    else
        print('item check has failed')
		TriggerClientEvent('QBCore:Notify', src, "You need some bags stupid", "error")
    end
end)

RegisterNetEvent("mvrp_cookin:cheknbby", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cookingskill = Player.PlayerData.metadata["methcooking"]
    local acetone = Player.Functions.GetItemByName('acetone')
    local antifreeze = Player.Functions.GetItemByName('antifreeze')
    local sudo = Player.Functions.GetItemByName('sudo')
    if acetone and acetone.amount >= 3 and antifreeze and antifreeze.amount >= 5 and sudo and sudo.amount >= 7 then
        Player.Functions.RemoveItem('acetone', 3 )
        Player.Functions.RemoveItem('antifreeze', 5)
        Player.Functions.RemoveItem('sudo', 7)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['acetone'], "remove")
        Wait(1000)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['antifreeze'], "remove")
        Wait(1000)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['sudo'], "remove")
        Wait(1000)
        TriggerClientEvent("mvrp_cookin:ingredients_setup", src)
    else
        print('Missing items, or stack counts still fucked')
        TriggerClientEvent("mvrp_cookin:doesnothaveshit", src)
    end
end)

RegisterNetEvent("mvrp_cookin:pass_skill_over", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	local cookingskill = Player.PlayerData.metadata["methcooking"]
    TriggerClientEvent("mvrp_cookin:begin_cook", src, cookingskill)
end)

RegisterServerEvent('mvrp_cookin:finish_cook')
AddEventHandler('mvrp_cookin:finish_cook', function()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local cookingskill = Player.PlayerData.metadata["methcooking"]
	local random_value = math.random(1, 2)
	if Player then
		if not Player.PlayerData.metadata['methcooking'] then
			Player.PlayerData.metadata['methcooking'] = 1
			Player.Functions.Save()
			Player.Functions.RemoveItem('meth_oz', random_value)
			TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meth'], "add")
			TriggerClientEvent('QBCore:Notify', src, "You feel you are just starting but getting better in the skill", "success")
		end
		Player.Functions.RemoveItem('meth_oz', random_value)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meth'], "add")
		Player.Functions.SetMetaData('methcooking', cookingskill +1)
		TriggerClientEvent('QBCore:Notify', src, "Added Meth, and gained some skill", "success")
		Player.Functions.Save()
	else
		print('Not a player da fuqqqqqqqqqq')
    end
end)

RegisterNetEvent("mvrp_cookin:bag_meth_oz", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local cookingskill = Player.PlayerData.metadata["methcooking"]
    local empty_weed_bag = Player.Functions.GetItemByName('empty_weed_bag')
    local meth_ounce = Player.Functions.GetItemByName('meth_oz')
    if meth_ounce and meth_ounce.amount >= 1 and empty_weed_bag and empty_weed_bag.amount >= 28 then
        Player.Functions.RemoveItem('meth_oz', 1 )
        Player.Functions.RemoveItem('empty_weed_bag', 28)
		Wait(1000)
		Player.Functions.AddItem('meth', 28 )
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meth_oz'], "remove")
        Wait(1000)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_weed_bag'], "remove")
        Wait(1000)
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['meth'], "add")
        Wait(1000)
		TriggerClientEvent('QBCore:Notify', src, "Meth is bagged", "success")
    else
        print('item check has failed')
		TriggerClientEvent('QBCore:Notify', src, "You need some bags stupid")
    end
end)

RegisterServerEvent('mvrp_cookin:playerloggedin')
AddEventHandler('mvrp_cookin:playerloggedin', function()
	local _source = source
	TriggerClientEvent("mrnewbmeth:updatecoords_toclient", _source, Srv_coord, Srv_dealr)
end)