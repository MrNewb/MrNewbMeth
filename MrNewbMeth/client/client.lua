local QBCore = exports['qb-core']:GetCoreObject()

local arewecookin = false
local current_coord = vector3(0.0, 0.0, 0.0)
local haschanged = nil
local msgs_labloc = {[1] = ' Me n sis tryna knock boots in the barn my labs open but you could come by instead... well no ok the labs at: ', [2] = ' Oh shit you got my life invader message, do you think ghosts pee? Oh just set the lab up at: ', [3] = ' Mommas madder than a wet hen bud keep the place on the downlow : ', [4] = ' I think mommas outta the house but I saw them clowns again man, go chill at the spot if you want : ', [5] = '  You been stealing the condoms from my room? Go hit the spot its at : ', [6] = '  I feel like im being used, do you want to text me for my booty or what? Go to the spot and wear a gimp suit if your into it. : ',}
local current_meth_level = 0


local PlayerData = {}

function UpdateLevel()
    local MyDrugSkill = PlayerData.metadata["drugskills"]["meth"]

    if MyDrugSkill ~= nil then
        if MyDrugSkill >= 1 and MyDrugSkill < 50 then
            Config.MyLevel = 1
        elseif MyDrugSkill >= 50 and MyDrugSkill < 100 then
            Config.MyLevel = 2
        elseif MyDrugSkill >= 100 and MyDrugSkill < 200 then
            Config.MyLevel = 3
        elseif MyDrugSkill >= 100 and MyDrugSkill < 200 then
            Config.MyLevel = 3
        elseif MyDrugSkill >= 200 then
            Config.MyLevel = 4
        end
    else
        Config.MyLevel = 1
    end

    local ReturnData = {
        lvl = Config.MyLevel,
        rep = MyDrugSkill
    }

    return ReturnData
end


RegisterCommand('changemethlocation', function()
	TriggerServerEvent("mvrp_cookin:debug_command")
end)


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('MrNewbMethv2QB:client:UpdateReputation', function(drugskills)
    PlayerData.metadata["drugskills"] = drugskills
    UpdateLevel()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)


RegisterNetEvent("mrnewbmeth:updatecoords_toclient")
AddEventHandler("mrnewbmeth:updatecoords_toclient", function(current_srvlocation)
	current_coord = current_srvlocation
end)

--Start of debug commands
RegisterCommand('changemethlocation', function()
	TriggerServerEvent("mvrp_cookin:debug_command")
end)

local function UseTelescope(entity)
	local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dstCheck = #(pedCoords - coordVec)
    if dstCheck <= 5.0 then
		TriggerEvent("mvrp_cookin:rolling")
	end
end

exports['qb-target']:AddTargetModel(`tr_prop_meth_table01a`, {
	options = {
		{
			icon = "fas fa-credit-card",
			label = "Charge Customer",
			action = function(entity)
				UseTelescope(entity)
			end
		}
	},
	distance = 1.5
})

function boom()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
    AddExplosion(coords.x, coords.y+2.0, coords.z, 32, 100000.0, true, false, 4.0)
	arewecookin = false

end

RegisterNetEvent("mvrp_cookin:rolling")
AddEventHandler("mvrp_cookin:rolling", function()
	local fuck = 20
	local luckynum = math.random(1, 120) 
	local ssuperfuck = fuck + luckynum
	local coordVec = vector3(current_coord.x, current_coord.y, current_coord.z)
    local pedCoords = GetEntityCoords(PlayerPedId())
    local dstCheck = #(pedCoords - coordVec)
	if ssuperfuck > 30 and dstCheck <= 5.0 then
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
		Citizen.Wait(60000)
		StopParticleFxLooped(particle, true)
	end
end)

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
			TriggerServerEvent("mvrp_cookin:giveitup")
			arewecookin = false
		else
			arewecookin = false
		end
	end)
end


