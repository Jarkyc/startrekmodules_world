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
--           Ship | Shared           --
---------------------------------------

if not istable(ENT) then Star_Trek:LoadAllModules() return end
local SELF = ENT

SELF.BaseClass = "base_acc"

SELF.Dynamic = true

function SELF:ResetManeuver()
	self.ActiveManeuver = nil
	self.ManeuverStart = nil

	if SERVER then
		local callback = self.ManeuverCallback
		self.ManeuverCallback = nil
		self.Updated = true

		if isfunction(callback) then
			callback(self)
		end
	end
end

function SELF:ManeuverThink(sysTime, deltaT, maneuverData)
	local time = sysTime - self.ManeuverStart

	local maneuverType = maneuverData.Type
	if maneuverType == "WARP" then
		local endPos = maneuverData.EndPos

		if time >= maneuverData.Duration then
			self.Pos = endPos
			self.Vel = Vector()
			self.Acc = Vector()

			self.OldPos = nil
			self.OldVel = nil

			self:ResetManeuver()

			return
		elseif time >= maneuverData.DeccelTime then
			local lerp = math.ease.OutQuad((time - maneuverData.DeccelTime) / maneuverData.DeccelDuration)
			self.Pos = Lerp(lerp, maneuverData.DeccelPos, endPos)
		elseif time >= maneuverData.AccelTime then
			local lerp = (time - maneuverData.AccelTime) / maneuverData.CoastDuration
			self.Pos = Lerp(lerp, maneuverData.AccelPos, maneuverData.DeccelPos)
		else
			local lerp = math.ease.InQuad(time / maneuverData.AccelTime)
			self.Pos = Lerp(lerp, maneuverData.StartPos, maneuverData.AccelPos)
		end

		local oldPos = self.OldPos or maneuverData.StartPos
		local diff = (self.Pos - oldPos) / deltaT
		self.Vel = diff:ToVector()
		self.OldPos = self.Pos

		local oldVel = self.OldVel or Vector()
		self.Acc = (self.Vel - oldVel) / deltaT
		self.OldVel = self.Vel
	elseif maneuverType == "ALIGN" then
		local targetAngle = maneuverData.TargetAngle

		if time >= maneuverData.Duration then
			self.Ang = targetAngle
			self.AngVel = Angle()
			self.AngAcc = Angle()

			self.OldAng = nil
			self.OldAngVel = nil

			self:ResetManeuver()

			return
		else
			local lerp = math.ease.InOutQuad(time / maneuverData.Duration)

			self.Ang = LerpAngle(lerp, maneuverData.StartAngle, targetAngle)
		end

		local oldAng = self.OldAng or maneuverData.StartAngle
		self.AngVel = (self.Ang - oldAng) / deltaT
		self.OldAng = self.Ang

		local oldAngVel = self.OldAngVel or Angle()
		self.AngAcc = (self.AngVel - oldAngVel) / deltaT
		self.OldAngVel = self.AngVel
	elseif maneuverType == "IMPULSE" then
		-- TODO

		return
	end
end