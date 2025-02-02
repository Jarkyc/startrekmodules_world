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
--       World Vector | Shared       --
---------------------------------------

-- Concept:
-- 2 Floats per Coordiate
-- Split at 1024*1024
-- plenty precision for ,... !
-- RANGE: (2^52) (2^20),(2^32)
-- Split Value is set here:
local MAX_SMALL_VALUE = 1024 * 1024
WorldVectorMaxSmallValue = MAX_SMALL_VALUE

local vectorMeta = {}
vectorMeta.IsWorldVector = true

-- Helper function, to determine if a table is a world vector.
function IsWorldVector(a)
	return (istable(a) and a.IsWorldVector) or false
end

-- Negates WorldVector and returns the result.
--
-- @param WorldVector a
-- @return WorldVector result
local function __unm(a)
	return WorldVector(
		-a[1],
		-a[2],
		-a[3],
		-a[4],
		-a[5],
		-a[6]
	)
end

-- Adds the given Vector or WorldVector to the WorldVector and returns the result.
--
-- @param WorldVector a
-- @param WorldVector/Vector b
-- @return WorldVector result
local function __add(a, b)
	if isvector(b) then
		return WorldVector(
			a[1], a[2], a[3],
			a[4] + b.x,
			a[5] + b.y,
			a[6] + b.z
		)
	end

	if IsWorldVector(b) then
		return WorldVector(
			a[1] + b[1],
			a[2] + b[2],
			a[3] + b[3],
			a[4] + b[4],
			a[5] + b[5],
			a[6] + b[6]
		)
	end

	error("Adding World Vectors: vector expected got " .. type(b))
end

-- Substracts the given Vector or WorldVector to the WorldVector and returns the result.
--
-- @param WorldVector a
-- @param WorldVector/Vector b
-- @return WorldVector result
local function __sub(a, b)
	if isvector(b) then
		return WorldVector(
			a[1], a[2], a[3],
			a[4] - b.x,
			a[5] - b.y,
			a[6] - b.z
		)
	end

	if IsWorldVector(b) then
		return WorldVector(
			a[1] - b[1],
			a[2] - b[2],
			a[3] - b[3],
			a[4] - b[4],
			a[5] - b[5],
			a[6] - b[6]
		)
	end

	error("Substracting World Vectors: vector expected got " .. type(b))
end

-- Mutliplies a given vector with a scalar and returns the result.
--
-- @param WorldVector a
-- @param Number b
-- @return WorldVector result
local function __mul(a, b)
	if isnumber(b) then
		return WorldVector(
			a[1] * b,
			a[2] * b,
			a[3] * b,
			a[4] * b,
			a[5] * b,
			a[6] * b
		)
	end

	error("Scaling World Vectors: number expected got" .. type(b))
end

-- Divides a given vector with a scalar and returns the result.
--
-- @param WorldVector a
-- @param Number b
-- @return WorldVector result
local function __div(a, b)
	if isnumber(b) then
		return WorldVector(
			a[1] / b,
			a[2] / b,
			a[3] / b,
			a[4] / b,
			a[5] / b,
			a[6] / b
		)
	end

	error("Division Scaling World Vectors: number expected got" .. type(b))
end

-- Compares two vectors with each other for being the same.
--
-- @param WorldVector a
-- @param WorldVector b
-- @return Boolean equal
local function __eq(a, b)
	if isnumber(b) then
		if  a[1] == b[1]
		and a[2] == b[2]
		and a[3] == b[3]
		and a[4] == b[4]
		and a[5] == b[5]
		and a[6] == b[6] then
			return true
		end

		return false
	end

	error("Comparing World Vectors: world vector expected got" .. type(b))
end

-- Converts the vector into a string, to be output.
--
-- @param WorldVector a
-- @return Strint string
local function __tostring(a)
	return "[B " .. a[1] .. " " .. a[2] .. " " .. a[3] .. " |S " .. a[4] .. " " .. a[5] .. " " .. a[6] .. " ]"
end

-- Define the Meta Table here. Optimisation!
local metaTable = {
	__index = vectorMeta,
	__unm = __unm, -- -(a)
	__add = __add, -- a + b
	__sub = __sub, -- a - b
	__mul = __mul, -- a * b
	__div = __div, -- a / b
	__eq  =  __eq, -- a == b
	__tostring = __tostring,
}

-- Create a World Vector and return it.
--
-- @param number bx
-- @param number by
-- @param number bz
-- @param number sx
-- @param number sy
-- @param number sz
-- @return WorldVector worldVector
function WorldVector(bx, by, bz, sx, sy, sz)
	local worldVector = {
		[1] = bx or 0,
		[2] = by or 0,
		[3] = bz or 0,
		[4] = sx or 0,
		[5] = sy or 0,
		[6] = sz or 0,
	}

	setmetatable(worldVector, metaTable)
	worldVector:FixValue()

	return worldVector
end

-- Create a World Vector from a table and return it.
--
-- @param Table worldVector
-- @return WorldVector worldVector
function WorldVectorFromTable(worldVector)
	if IsWorldVector(worldVector) then
		return worldVector
	end

	setmetatable(worldVector, metaTable)
	worldVector:FixValue()

	return worldVector
end

-- Reduces the Value to its minimum "Small" Vector Size.
-- Should be called after any operation.
function vectorMeta:FixValue()
	-- Fix non integer big values.
	local xDiff = self[1] - math.floor(self[1])
	local yDiff = self[2] - math.floor(self[2])
	local zDiff = self[3] - math.floor(self[3])
	if xDiff ~= 0 or yDiff ~= 0 or zDiff ~= 0 then
		self[1] = math.floor(self[1])
		self[4] = self[4] + xDiff * MAX_SMALL_VALUE

		self[2] = math.floor(self[2])
		self[5] = self[5] + yDiff * MAX_SMALL_VALUE

		self[3] = math.floor(self[3])
		self[6] = self[6] + zDiff * MAX_SMALL_VALUE
	end

	-- Fix Overflow
	if 	self[4] <= MAX_SMALL_VALUE and self[4] > 0
	and self[5] <= MAX_SMALL_VALUE and self[5] > 0
	and self[6] <= MAX_SMALL_VALUE and self[6] > 0 then
		return
	end

	local x = self[4] % MAX_SMALL_VALUE
	self[1] = math.floor(self[1] + (self[4] - x) / MAX_SMALL_VALUE)
	self[4] = x

	local y = self[5] % MAX_SMALL_VALUE
	self[2] = math.floor(self[2] + (self[5] - y) / MAX_SMALL_VALUE)
	self[5] = y

	local z = self[6] % MAX_SMALL_VALUE
	self[3] = math.floor(self[3] + (self[6] - z) / MAX_SMALL_VALUE)
	self[6] = z
end

function vectorMeta:GetX()
	return self[1] * MAX_SMALL_VALUE + self[4]
end

function vectorMeta:GetY()
	return self[2] * MAX_SMALL_VALUE + self[5]
end

function vectorMeta:GetZ()
	return self[3] * MAX_SMALL_VALUE + self[6]
end

-- Returns a normal Vector from the worldVector.
-- WARNING: This can cause a loss of precision!
--
-- @return Vector result
function vectorMeta:ToVector()
	return Vector(
		self:GetX(),
		self:GetY(),
		self:GetZ()
	)
end

-- Returns the squared length of the world vector.
-- WARNING: This can cause a loss of precision!
--
-- @return Number lengthSqr
function vectorMeta:LengthSqr()
	local temp = self:ToVector()
	return temp:LengthSqr()
end

-- Returns the distance between 2 world vectors.
-- WARNING: This can cause a loss of precision!
function vectorMeta:DistanceSqr(b)
	return (self - b):LengthSqr()
end

-- Returns the length of the world vector.
-- WARNING: This can cause a loss of precision!
--
-- @return Number length
function vectorMeta:Length()
	local temp = self:ToVector()
	return temp:Length()
end

-- Returns the distance between 2 world vectors.
-- WARNING: This can cause a loss of precision!
function vectorMeta:Distance(b)
	return (self - b):Length()
end

function vectorMeta:GetNormalized()
	return self:ToVector():GetNormalized()
end

function vectorMeta:GetCeil()
	return WorldVector(
		self[1],
		self[2],
		self[3],
		math.ceil(self[4]),
		math.ceil(self[5]),
		math.ceil(self[6])
	)
end

function vectorMeta:GetFloor()
	return WorldVector(
		self[1],
		self[2],
		self[3],
		math.floor(self[4]),
		math.floor(self[5]),
		math.floor(self[6])
	)
end

function WorldToLocalBig(pos, ang, newSystemOrigin, newSystemAngles)
	local offsetPos = pos - newSystemOrigin

	return WorldToLocal(offsetPos:ToVector(), ang, Vector(), newSystemAngles)
end

function LocalToWorldBig(localPos, localAng, originPos, originAng)
	if IsWorldVector(localPos) then
		localPos = localPos:ToVector()
	end

	local pos, ang = LocalToWorld(localPos, localAng, Vector(), originAng)

	return originPos + pos, ang
end

function net.ReadWorldVector()
	local bx = net.ReadDouble()
	local by = net.ReadDouble()
	local bz = net.ReadDouble()
	local sx = net.ReadDouble()
	local sy = net.ReadDouble()
	local sz = net.ReadDouble()

	return WorldVector(bx, by, bz, sx, sy, sz)
end

function net.WriteWorldVector(worldVector)
	net.WriteDouble(worldVector[1])
	net.WriteDouble(worldVector[2])
	net.WriteDouble(worldVector[3])
	net.WriteDouble(worldVector[4])
	net.WriteDouble(worldVector[5])
	net.WriteDouble(worldVector[6])
end