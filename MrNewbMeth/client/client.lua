ESX = nil
local arewecookin = false
local current_coord = vector3(0.0, 0.0, 0.0)
local dealer_doord = vector3(0.0, 0.0, 0.0)
local haschanged = nil
local msgs_labloc = {[1] = ' Me n sis tryna knock boots in the barn my labs open but you could come by instead... well no ok the labs at: ', [2] = ' Oh shit you got my life invader message, do you think ghosts pee? Oh just set the lab up at: ', [3] = ' Mommas madder than a wet hen bud keep the place on the downlow : ', [4] = ' I think mommas outta the house but I saw them clowns again man, go chill at the spot if you want : ', [5] = '  You been stealing the condoms from my room? Go hit the spot its at : ', [6] = '  I feel like im being used, do you want to text me for my booty or what? Go to the spot and wear a gimp suit if your into it. : ',}
local msgs_dealerloc = {[1] = ' Whats up playa, meet me at the spot. ', [2] = ' Yo bro im free meet me on the corner. ',}
local current_meth_level = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData) -- When a player loads
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
	TriggerServerEvent("mvrp_cookin:playerloggedin")
	--current_meth_level = (exports["Newbskillz"]:GetCurrentSkill("Methcook").Current * 1 ) * 1
end)


RegisterNetEvent("mrnewbmeth:updatecoords_toclient")
AddEventHandler("mrnewbmeth:updatecoords_toclient", function(current_srvlocation, current_srvdealer)
	current_coord = current_srvlocation
	dealer_doord = current_srvdealer
	RequestModel(1706635382)
    while not HasModelLoaded(1706635382) do
		Wait(100)
    end
        --PROVIDER
	meth_dealer_seller = CreatePed(1, 1706635382, dealer_doord.x, dealer_doord.y, dealer_doord.z, 60.0, false, true)
	SetBlockingOfNonTemporaryEvents(meth_dealer_seller, true)
	SetPedDiesWhenInjured(meth_dealer_seller, false)
	SetPedCanPlayAmbientAnims(meth_dealer_seller, true)
	SetPedCanRagdollFromPlayerImpact(meth_dealer_seller, false)
	SetEntityInvincible(meth_dealer_seller, true)
	FreezeEntityPosition(meth_dealer_seller, true)
	TaskStartScenarioInPlace(meth_dealer_seller, "WORLD_HUMAN_SMOKING", 0, true);
	Citizen.Wait(7200000)
	DeleteEntity(meth_dealer_seller)
end)

--[[exports.qtarget:AddTargetModel({1706635382}, {
    options = {
        {
			event = "seller:removec",
			icon = "fas fa-sign-in-alt",
			label = "Sell To Dealer",
        },
    },
    distance = 2.5
})--]]


--Start of debug commands
RegisterCommand('changemethlocation', function()
	TriggerServerEvent("mvrp_cookin:debug_command")
end)

--[[RegisterCommand('changemethlvl30', function()
	exports["Newbskillz"]:UpdateSkill("Methcook", 30.0)
end)

RegisterCommand('changemethlvl80', function()
	exports["Newbskillz"]:UpdateSkill("Methcook", 80.0)
end)


RegisterCommand('changemethlvlminus30', function()
	exports["Newbskillz"]:UpdateSkill("Methcook", -30.0)
end)--]]

RegisterCommand('BillyJoe', function()
	BillyJoe()
end)

RegisterCommand('Lamar', function()
	LamaR()
end)

RegisterCommand('resetcookstatus', function()
	arewecookin = false
end)


--End of debug commands

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

local MrNewbMeth_location_distance_checker = function()
	while true do
		local sleepThread = 2000
		local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
        local pedCoords = GetEntityCoords(PlayerPedId())
		local dead = exports["esx_ambulancejob"]:GetDeath()
        local dstCheck = #(pedCoords - coordVec)
           	if dstCheck <= 8.0 and not dead and not arewecookin then
               	sleepThread = 0
				--print('got to check')
				--print(dstCheck)
				--print(dead)
				DrawText3Ds(current_coord.x, current_coord.y, current_coord.z, '~g~Press [E] to cook meth.')
				if dstCheck <= 1.5 and not arewecookin then
                    if IsControlJustReleased(0, 38) then
						arewecookin = true
						print('are we dead?')
						print(dead)
						print('are we cookin?')
						print(arewecookin)
						--print('got to check')
						TriggerServerEvent("mvrp_cookin:cheknbby")
					end
				end
			else
				--print(dead)
			end
    	Citizen.Wait(sleepThread)
 	end
end



function getPhoneRandomNumber()
    local numBase0 = math.random(100, 999)
    local numBase1 = math.random(0, 9999)
    local num = string.format("%03d-%04d", numBase0, numBase1)
    return num
end

function BillyJoe()
	Citizen.Wait(1000)
	serverId = GetPlayerServerId(PlayerId())
	local current_meth_level = 31 --(exports["Newbskillz"]:GetCurrentSkill("Methcook").Current * 1 ) * 1
	if current_meth_level >= 30 then
		ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
			local howmany_lols = math.random(1, 4)
			local messagetxt = msgs_labloc[howmany_lols]
			local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
			message = messagetxt .. current_coord.x .. ', ' .. current_coord.y
			TriggerServerEvent('disc-gcphone:sendMessageFrom', 'BillyJoe', number, message, serverId)
			print(json.encode(current_coord))
		end)
	else
		ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
			local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
			message = 'Who are you? ARE YOU THE FIB!?! DAD!?! SANTA?!'
			TriggerServerEvent('disc-gcphone:sendMessageFrom', 'BillyJoe', number, message, serverId)
		end)
		Citizen.Wait(40000)
		--print("long wait shit")
	end
end

function LamaR()
	Citizen.Wait(1000)
	serverId = GetPlayerServerId(PlayerId())
	local current_meth_level = 31--(exports["Newbskillz"]:GetCurrentSkill("Methcook").Current * 1 ) * 1
	if current_meth_level >= 30 then
		ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
			local howmany_lols = math.random(1, 2)
			local messagetxt = msgs_dealerloc[howmany_lols]
			local coordVec = vector3(dealer_doord.x, dealer_doord.y, dealer_doord.z)
			message = messagetxt .. dealer_doord.x .. ', ' .. dealer_doord.y
			TriggerServerEvent('disc-gcphone:sendMessageFrom', 'Lamar', number, message, serverId)
			print(json.encode(dealer_doord))
		end)
	else
		ESX.TriggerServerCallback('disc-gcphone:getNumber', function(number)
			local coordVec = vector3(dealer_doord.x, dealer_doord.y, dealer_doord.z)
			message = 'Who dis'
			TriggerServerEvent('disc-gcphone:sendMessageFrom', 'Lamar', number, message, serverId)
		end)
		Citizen.Wait(300000)
	end
end

function boom()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
    AddExplosion(coords.x, coords.y+2.0, coords.z, 32, 100000.0, true, false, 4.0)
	arewecookin = false

end


RegisterNetEvent("mvrp_cookin:doesnothaveshit")
AddEventHandler("mvrp_cookin:doesnothaveshit", function()
	arewecookin = false
end)


RegisterNetEvent("mvrp_cookin:rolling")
AddEventHandler("mvrp_cookin:rolling", function()
	local fuck = 20 --(exports["Newbskillz"]:GetCurrentSkill("Methcook").Current * 1 ) * 1
	local luckynum = math.random(1, 120) 
	local ssuperfuck = fuck + luckynum
	local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
	local dead = exports["esx_ambulancejob"]:GetDeath()
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dstCheck = #(pedCoords - coordVec)
	if ssuperfuck > 30 and not dead and dstCheck <= 5.0 then
		arewecookin = true
		start_particles_bby()
		local particle = StartParticleFxLoopedAtCoord('ent_amb_smoke_foundry', current_coord.x, current_coord.y, current_coord.z, 0.0, 0.0, 0.0, 5.0, false, false, false)
		animation()
		Citizen.Wait(30000)
		StopParticleFxLooped(particle, true)
	else
		start_particles_bby()
		local particle = StartParticleFxLoopedAtCoord('ent_amb_smoke_foundry', current_coord.x, current_coord.y, current_coord.z, 0.0, 0.0, 0.0, 5.0, false, false, false)
		boom()
		arewecookin = false
		print('from boom are we cookin?')
		print(arewecookin)
		print('from boom are we dead?')
		print(dead)
		exports['mythic_notify']:SendAlert('error', 'Oh dear you went boom', 10000)
		Citizen.Wait(60000)

		StopParticleFxLooped(particle, true)
	end
end)

function boom()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
    AddExplosion(coords.x, coords.y+2.0, coords.z, 32, 100000.0, true, false, 4.0)
	arewecookin = false
end

function start_particles_bby()
	RequestNamedPtfxAsset('core')
	while not HasNamedPtfxAssetLoaded('core') do
		Citizen.Wait(1)
	end
	
	UseParticleFxAssetNextCall('core')
end


function animation()
	exports['mythic_progbar']:Progress({
	name = "cook_da_meth",
	duration = 5000,
	label = 'Processing the meth',
	useWhileDead = false,
	canCancel = false,
	controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
	},
	animation = {
			animDict = "anim@heists@prison_heiststation@cop_reactions",
			anim = "cop_b_idle",
			flags = 49,
	},
	prop = {
			model = "prop_paint_tray",
			bone = 18905,
			coords = { x = 0.10, y = 0.02, z = 0.08 },
			rotation = { x = -150.0, y = 0.0, z = 0.0 },
	},
	}, function(cancelled)
		if not cancelled then
			exports['mythic_notify']:SendAlert('success', 'You managed to cook some good ole meth', 6000)
			TriggerServerEvent("mvrp_cookin:giveitup")
			--exports["Newbskillz"]:UpdateSkill("Methcook", 0.5)
			arewecookin = false
		else
			arewecookin = false
		end
	end)
end

SetTimeout(2000, MrNewbMeth_location_distance_checker)
