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
--           Base | Server           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

function SELF:Init(pos, ang, model, diameter)
	self:SetPos(pos)
	self:SetAng(ang)

	self:SetModel(model)
	self:SetDiameter(diameter)
end

function SELF:Terminate()
end

function SELF:Update()
	Star_Trek.World:NetworkUpdate(self)
end

function SELF:GetClientData(clientData)
	clientData.Pos = self.Pos
	clientData.Ang = self.Ang

	clientData.Model = self.Model
	clientData.Material = self.Material

	clientData.Diameter = self.Diameter
	clientData.Scale = self.Scale
end

function SELF:GetClientDynData(clientData)
end

function SELF:SetPos(pos)
	self.Pos = pos or WorldVector()

	self.Updated = true
end

function SELF:SetAngles(ang)
	self.Ang = ang or Angle()

	self.Updated = true
end
SELF.SetAng = SELF.SetAngles

function SELF:SetModel(model)
	self.Model = model or "models/hunter/blocks/cube4x4x4.mdl"

	self.Updated = true
end

function SELF:SetMaterial(material)
	self.Material = material

	self.Updated = true
end

function SELF:SetDiameter(diameter)
	local modelDiameter = Star_Trek.World:GetModelDiameter(self.Model)

	self.Diameter = diameter or modelDiameter
	self.Scale = self.Diameter / modelDiameter
end