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
--            World Entity           --
--       Base Velocity | Client      --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(clientData)
	SELF.Base.Init(self, clientData)
end

function SELF:SetData(clientData)
	self.Model = clientData.Model
	self.Diameter = clientData.Diameter
	self.Scale = clientData.Scale

	self.Vel = clientData.Vel
	self.AngVel = clientData.AngVel
end

function SELF:SetDynData(clientData)
	self.Pos = WorldVectorFromTable(clientData.Pos)
	self.Ang = clientData.Ang
end