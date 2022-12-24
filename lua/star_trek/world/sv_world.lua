---------------------------------------
---------------------------------------
--         Star Trek Modules         --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2020 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--           World | Server          --
---------------------------------------

local id = 1
local function getId()
	id = id + 1
	return id
end

local function addTestingShip(pos, model)
	local success, worldEnt = Star_Trek.World:LoadEntity(getId(), "ship",
		WorldVector(0, 0, 0, pos.x, pos.y, pos.z),
		Angle(0, 0, 0),
		model or "models/hunter/blocks/cube1x1x1.mdl",
		M(344)
	)

	if not success then
		return false, worldEnt
	end

	return worldEnt
end

local function addPlanet(pos, model, radius, spin)
	local success, worldEnt = Star_Trek.World:LoadEntity(getId(), "planet",
		WorldVector(0, 0, 0, pos.x, pos.y, pos.z), Angle(), model, radius, spin
	)

	if not success then
		return false, worldEnt
	end

	return worldEnt
end

timer.Simple(0, function()
	for i = 1, 32 do
		local ship = addTestingShip(
			Vector(0, i * 8, 0),
			"models/kingpommes/startrek/intrepid/intrepid_sky_1024.mdl"
		)
	end

	local earthRadius = 6371
	local earthDistance = earthRadius + 35786
	local earthPos = Vector(-KM(earthDistance), 0, 0)
	local earth = addPlanet(
		earthPos,
		"models/planets/earth.mdl",
		KM(earthRadius * 2),
		1
	)

	local moonRadius = 1737.4
	local moonDistance = 384400 - earthDistance
	local moonPos = earthPos + Vector(KM(moonDistance), 0, 0)
	local moon = addPlanet(
		moonPos,
		"models/planets/luna_big.mdl",
		KM(moonRadius * 2)
	)

	local sunRadius = 696340
	local sunDistance = 150000000
	local sunPos = earthPos + Vector(KM(sunDistance), 0, 0)
	local sun = addPlanet(
		sunPos,
		"models/planets/sun.mdl",
		KM(sunRadius * 2)
	)
end)

hook.Add("Star_Trek.LCARS.BasicPressed", "WarpDrive.Weeee", function(ply, interfaceData, buttonId, buttonData)
	local ent = interfaceData.Ent
	local name = ent:GetName()

	if name == "connBut4" then
		if buttonId == 1 then
			timer.Simple(5, function()
				local c = Star_Trek.World:WarpToC(5)
				Star_Trek.World.MapShip:SetVelocity(Vector(KM(300000 * c), 0, 0))
			end)
		else
			timer.Simple(2, function()
				Star_Trek.World.MapShip:SetVelocity(Vector(0, 0, 0))
			end)
		end
	end
end)
