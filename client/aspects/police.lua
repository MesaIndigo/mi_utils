-- WIP DO NOT USE
local shield, holding = nil, {shield = 0, used = false}
local shieldmod = lib.requestModel('prop_ballistic_shield')
local dict, anim = lib.requestAnimDict('anim@random@shop_clothes@watches', 200),
lib.requestAnimSet('base', 200)

local rioton = function()
    while not HasModelLoaded(shieldmod) do
        Citizen.Wait(10)
    end
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end
    if not holding.used then
        if lib.progressBar({
            duration = UT.riotshield.time,
            label = 'Equipping Riot Shield',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d'
            },
        }) then
            local plycrd = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
            shield = CreateObject(shieldmod, plycrd.x, plycrd.y, plycrd.z, true, false, false)
            AttachEntityToEntity(shield, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()),
            45509),0.2, 0.25, -0.05, 305.0, 155.0, 87.5, true, true, true, true, 0, true)
            holding.shield = shield
            holding.used = true
            TaskPlayAnim(cache.ped, dict, anim, 8.0, 8.0, -1, 49, 0, false, false, false)
        end
    end
    
end

local riotoff = function()
    if holding.used then
        if lib.progressBar({
            duration = UT.riotshield.time,
            label = 'Removing Riot Shield',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d'
            },
        }) then
            ClearPedTasksImmediately(PlayerPedId())
            DetachEntity(holding.shield, false, true)
            DeleteEntity(holding.shield)
            holding.shield = 0
            holding.used = false
        end
    end
end

exports('riotshield', function()
    if not holding.used then
        rioton()
    elseif holding.used then
        riotoff()
    else return end
end)