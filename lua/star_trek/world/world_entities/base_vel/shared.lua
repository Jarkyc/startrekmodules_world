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
--       Base Velocity | Shared      --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

SELF.BaseClass = "base"

SELF.Dynamic = true

function SELF:Think(sysTime, deltaT)
	self.Pos = self.Pos + (self.Vel * deltaT)
	self.Ang = self.Ang + (self.AngVel * deltaT)
end