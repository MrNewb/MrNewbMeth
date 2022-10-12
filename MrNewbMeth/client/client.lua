local QBCore = exports['qb-core']:GetCoreObject()
local Is_Player_cooking_meth = false
local current_coord = vector3(0.0, 0.0, 0.0)
local dealer_doord = vector3(0.0, 0.0, 0.0)
local haschanged = nil
local msgs_labloc = {[1] = ' Me n sis tryna knock boots in the barn my labs open but you could come by instead...', [2] = ' Oh shit you got my life invader message, do you think ghosts pee', [3] = ' Mommas madder than a wet hen bud keep the place on the downlow', [4] = ' I think mommas outta the house but I saw them clowns again man, go chill at the spot if you want', [5] = '  You been stealing the condoms from my room and I know it but Go hit the spot its at', [6] = '  I feel like im being used, do you want to text me for my booty or what. Go to the spot and wear a gimp suit if your into it.',}
local msgs_dealerloc = {[1] = ' Whats up playa, meet me at the spot. ', [2] = ' Yo bro im free meet me on the corner. ',}
local cookingskill = 0

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    Citizen.Wait(1000)
    local ped = PlayerPedId()
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent("mvrp_cookin:playerloggedin")
end)

RegisterNetEvent("mrnewbmeth:updatecoords_toclient")
AddEventHandler("mrnewbmeth:updatecoords_toclient", function(current_srvlocation, current_srvdealer)
	current_coord = current_srvlocation
	dealer_doord = current_srvdealer
end)

--[[ Start Of Debug Commands ]]--


RegisterCommand('changemethlocation', function()
	TriggerServerEvent("mvrp_cookin:debug_command")
end)

RegisterCommand('clearcookstatus', function()
	Is_Player_cooking_meth = false
end)

--[[
RegisterCommand('phonetestcommand', function()
	send_player_text()
end)

--[[ End Of Debug Commands ]]--

--[[ Start of experimental phone addition ]]--

function send_player_text()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local random_number = math.random(1, 6)
	local random_text = msgs_labloc[random_number]
	local current_blip_location = AddBlipForCoord(current_coord.x, current_coord.y, current_coord.z)
	TriggerServerEvent('qs-smartphone:server:sendNewMail', {
		sender = 'Billy12inch@yodoo.com',
		subject = 'Hey bro, sending you the spot',
		message = random_text,
		button = {}
	})
	SetBlipSprite(current_blip_location,  464)
	SetBlipColour(current_blip_location,  3)
	SetBlipAsShortRange(current_blip_location, true)
end--]]
--[[ End of experimental qs-smartphone addition ]]--
--[[ Start 3dtext ]]--
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
--[[ End 3dtext ]]--
--[[ Start distance check ]]--
local MrNewbMeth_location_distance_checker = function()
	while true do
		local sleepThread = 2000
		local data = QBCore.Functions.GetPlayerData()
		local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
        local pedCoords = GetEntityCoords(PlayerPedId())
        local dstCheck = #(pedCoords - coordVec)
           	if dstCheck <= 8.0 then
               	sleepThread = 0
				DrawText3Ds(current_coord.x, current_coord.y, current_coord.z, '~g~Press [E] to cook meth.')
				if dstCheck <= 1.5 and not Is_Player_cooking_meth then
                    if IsControlJustReleased(0, 38) then
						Is_Player_cooking_meth = true
						TriggerServerEvent("mvrp_cookin:cheknbby")
					end
				end
			else
				--print(dead)
			end
    	Citizen.Wait(sleepThread)
 	end
end
--[[ End distance check ]]--

RegisterNetEvent("mvrp_cookin:doesnothaveshit")
AddEventHandler("mvrp_cookin:doesnothaveshit", function()
	TriggerEvent('inventory:client:requiredItems', {
		[1] = {name = QBCore.Shared.Items["acetone"]["name"], image = QBCore.Shared.Items["acetone"]["image"]},
		[2] = {name = QBCore.Shared.Items["sudo"]["name"], image = QBCore.Shared.Items["sudo"]["image"]},
		[3] = {name = QBCore.Shared.Items["antifreeze"]["name"], image = QBCore.Shared.Items["antifreeze"]["image"]}
	}, true)
	--QBCore.Functions.Notify("You dont have the required items.", "error")
	lib.notify({
		title = 'MethCook',
		description = 'You dont have the required items.',
		type = 'error'
	})
	Citizen.Wait(7000)
	TriggerEvent('inventory:client:requiredItems', {
		[1] = {name = QBCore.Shared.Items["acetone"]["name"], image = QBCore.Shared.Items["acetone"]["image"]},
		[2] = {name = QBCore.Shared.Items["sudo"]["name"], image = QBCore.Shared.Items["sudo"]["image"]},
		[3] = {name = QBCore.Shared.Items["antifreeze"]["name"], image = QBCore.Shared.Items["antifreeze"]["image"]}
	}, false)
	Is_Player_cooking_meth = false
end)

--[[ Start Of Setup Animation ]]--
RegisterNetEvent("mvrp_cookin:ingredients_setup")
AddEventHandler("mvrp_cookin:ingredients_setup", function()
	local data = QBCore.Functions.GetPlayerData()
	local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dstCheck = #(pedCoords - coordVec)
	if dstCheck <= 5.0 then
		Request_Particle_To_Load_Dict_Now2()
		local particle2 = StartParticleFxLoopedAtCoord('cs_pls_tea_pour', current_coord.x, current_coord.y, current_coord.z - 2.0, 0.0, 0.0, 0.0, 5.0, false, false, false)
		QBCore.Functions.Progressbar("Setting_up_ingredients", "Setting out ingredients", 7000, false, true, {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		}, {
			animDict = "anim@amb@nightclub@mini@drinking@bar@drink_v2@beer",
			anim = "intro_bartender",
			flags = 16,
		}, {}, {}, function() -- Done
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
			StopParticleFxLooped(particle2, true)
			TriggerServerEvent("mvrp_cookin:pass_skill_over")
		end, function() -- Cancel
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
			QBCore.Functions.Notify("You cancelled the cook.", "error")
			StopParticleFxLooped(particle2, true)
			Is_Player_cooking_meth = false
		end)
		Citizen.Wait(10)
		--print('you have level')
		--print(cookingskill)
		--print('from setup process')
	else
		--QBCore.Functions.Notify("You walked to far away.", "error")
		lib.notify({
			title = 'MethCook',
			description = 'You walked to far away..',
			type = 'error'
		})
	end
end)
--[[ End Of Setup Animation ]]--
--[[ Start Of Cooking anim/math random and mini game ]]--
RegisterNetEvent("mvrp_cookin:begin_cook")
AddEventHandler("mvrp_cookin:begin_cook", function(cookingskill)
	local data = QBCore.Functions.GetPlayerData()
	local meth_cook_level = cookingskill
	local random_numer_chance = math.random(1, 120) 
	local ssuperfuck = meth_cook_level + random_numer_chance
	local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
	local dead_or_cuffed = data.metadata['isdead'] or data.metadata['inlaststand'] or data.metadata['ishandcuffed']
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dstCheck = #(pedCoords - coordVec)
	if ssuperfuck > 60 and dstCheck <= 11.0 then
		print('rolled')
		print('ssuperfuck')
		print('you have level')
		print(meth_cook_level)
		print('Meth cook skill, it has been factored into your chance of not going boom')
		Is_Player_cooking_meth = true
		Request_Particle_To_Load_Dict_Now()
		local particle = StartParticleFxLoopedAtCoord('scr_bomb_gas', current_coord.x, current_coord.y, current_coord.z - 1.9, 0.0, 0.0, 0.0, 1.1, false, false, false)
		local size = SetParticleFxLoopedColour(particle, 0.0, 0.8, 0.6, 0)
		local alphas = SetParticleFxLoopedAlpha(particle, 0.3)		
		QBCore.Functions.Progressbar("Starting_cooking_meth", "Mixing up some of the blue", 5000, false, true, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		}, {
			animDict = "anim@heists@prison_heiststation@cop_reactions",
			anim = "cop_b_idle",
			flags = 16,
		}, {}, {}, function() -- Done
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
			Citizen.Wait(5000)
			StopParticleFxLooped(particle, true)
			Is_Player_cooking_meth = false
		end, function() -- Cancel
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
			StopParticleFxLooped(particle, true)
			Is_Player_cooking_meth = false
		end)
		Citizen.Wait(7000)
		TriggerServerEvent("mvrp_cookin:finish_cook")
		Is_Player_cooking_meth = false
	else
		Request_Particle_To_Load_Dict_Now()
		local particle = StartParticleFxLoopedAtCoord('scr_bomb_gas', current_coord.x, current_coord.y, current_coord.z - 2.0, 0.0, 0.0, 0.0, 1.1, false, false, false)
		local size = SetParticleFxLoopedColour(particle, 0.0, 0.8, 0.6, 0)
		local alphas = SetParticleFxLoopedAlpha(particle, 0.3)
		QBCore.Functions.Progressbar("blowing_up_in_meth", "Something doesnt look like it should...", 8000, false, false, {
			disableMovement = false,
			disableCarMovement = false,
			disableMouse = false,
			disableCombat = false,
		}, {
			animDict = "missfinale_a_ig_2",
			anim = "franklin_trevor_death_reaction_po",
			flags = 16,
		}, {}, {}, function() -- Done
			if meth_cook_level >= 10 and dstCheck <= 15.0 then
				exports['ps-ui']:Circle(function(success)
					if success then
						--QBCore.Functions.Notify("You managed to stop the reaction but wasted materials.", "error")
						lib.notify({
							title = 'MethReaction',
							description = 'You managed to stop the reaction but wasted materials.',
							type = 'error'
						})
						Citizen.Wait(5000)
						StopParticleFxLooped(particle, true)
						Is_Player_cooking_meth = false
					else
						--QBCore.Functions.Notify("Oh shit run!.", "error")
						lib.notify({
							title = 'MethReaction',
							description = 'Oh shit run!.',
							type = 'error'
						})
						Citizen.Wait(5000)
						TriggerEvent("evidence:client:SetStatus", "methcook", 300)
						StopParticleFxLooped(particle, true)
						Is_Player_cooking_meth = false0
						boom()
					end
				end, 3, 25) -- NumberOfCircles, MS
			else
				Citizen.Wait(5000)
				TriggerEvent("evidence:client:SetStatus", "methcook", 300)
				StopParticleFxLooped(particle, true)
				Is_Player_cooking_meth = false
				boom()
			end
		end, function() -- Cancel
			lib.notify({
				title = 'MethReaction',
				description = 'Oh shit run!.',
				type = 'error'
			})
			--QBCore.Functions.Notify("Oh shit run!.", "error")
			Citizen.Wait(5000)
			print('how did you cancel this event?')
			QBCore.Functions.Notify("Broke function and somehow cancelled. Tell MrNewb#6475 how you did it", "error")
			Citizen.Wait(10000)
			StopParticleFxLooped(particle, true)
			Is_Player_cooking_meth = false
			boom()
		end)
	end
end)
--[[ End Of Cooking anim/math random and mini game ]]--
--[[ Star Of animto bag meth ]]--
RegisterNetEvent("mvrp_cookin:begin_bagging_meth")
AddEventHandler("mvrp_cookin:begin_bagging_meth", function()
	local PlayerData = QBCore.Functions.GetPlayerData()
	QBCore.Functions.Progressbar("starting_bagging_meth", "Baggin up all the good shit", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@heists@prison_heiststation@cop_reactions",
		anim = "cop_b_idle",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
		Citizen.Wait(5000)
		TriggerEvent("evidence:client:SetStatus", "methcook", 300)
		TriggerServerEvent("mvrp_cookin:bag_meth_oz")
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
		TriggerEvent("evidence:client:SetStatus", "methcook", 300)
	end)
end)
--[[ End Of animto bag meth ]]--
--[[ Star Of animto bag zipdocks ]]--
RegisterNetEvent("mvrp_cookin:begin_opening_zipdocks")
AddEventHandler("mvrp_cookin:begin_opening_zipdocks", function()
	local PlayerData = QBCore.Functions.GetPlayerData()
	QBCore.Functions.Progressbar("starting_open_zip", "opening the zipdocks", 5000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "anim@heists@prison_heiststation@cop_reactions",
		anim = "cop_b_idle",
		flags = 16,
	}, {}, {}, function() -- Done
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
		Citizen.Wait(5000)
		TriggerServerEvent("mvrp_cookin:open_ziplock_bag")
	end, function() -- Cancel
		StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_ped", 1.0)
	end)
end)
--[[ End Of animto bag zipdocks ]]--

function boom()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
    AddExplosion(current_coord.x, current_coord.y, current_coord.z, 32, 100000.0, true, false, 4.0)
	Is_Player_cooking_meth = false
end

function Request_Particle_To_Load_Dict_Now()
	RequestNamedPtfxAsset('scr_weap_bombs')
	while not HasNamedPtfxAssetLoaded('scr_weap_bombs') do
		Citizen.Wait(1)
	end
	UseParticleFxAssetNextCall('scr_weap_bombs')
end

function Request_Particle_To_Load_Dict_Now2()
	RequestNamedPtfxAsset('cut_portoflsheist')
	while not HasNamedPtfxAssetLoaded('cut_portoflsheist') do
		Citizen.Wait(1)
	end
	UseParticleFxAssetNextCall('cut_portoflsheist')
end

--- lazy place to put prop stuck in
RegisterCommand('propstuck', function()
    for k, v in pairs(GetGamePool('CObject')) do
        if IsEntityAttachedToEntity(PlayerPedId(), v) then
            SetEntityAsMissionEntity(v, true, true)
            DeleteObject(v)
            DeleteEntity(v)
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
            if IsPedInAnyVehicle(PlayerPedId(), false) then
            TriggerEvent("propstuck")
        end
        Wait(100)
    end
end)

-- end of lazy place to put prop stuck in

Citizen.CreateThread(function ()
    while true do
		if exports['qs-housing']:inDecorate() then
			SetPauseMenuActive(false)
		end
	Wait(1000)
	end
end)

SetTimeout(2000, MrNewbMeth_location_distance_checker)