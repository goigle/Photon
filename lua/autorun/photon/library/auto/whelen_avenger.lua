AddCSLuaFile()

local A = "AMBER"
local R = "RED"
local DR = "D_RED"
local B = "BLUE"
local W = "WHITE"
local CW = "C_WHITE"
local SW = "S_WHITE"
local G = "GREEN"
local RB = "BLUE/RED"

local name = "Whelen Avenger Dual"

local COMPONENT = {}

COMPONENT.Model = "models/lonewolfie/whelenavenger_double.mdl"
COMPONENT.Skin = 0
COMPONENT.Category = "Interior"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.DefaultColors = {
	[1] = "BLUE",
	[2] = "RED",
}

COMPONENT.Meta = {
	auto_avenger = {
		AngleOffset = 90,
		W = 5.7,
		H = 5.9,
		WMult = 2,
		Sprite = "sprites/emv/emv_whelen_src.vtf",
		Scale = 1.5,
		NoLegacy = true,
		DirAxis = "Up",
		DirOffset = -90,
	},
}

COMPONENT.Positions = {
	[1] = { Vector( -0.72, 2.6, -0.85 ), Angle( 0, 90, 0 ), "auto_avenger" },
	[2] = { Vector( -0.72, -2.6, -0.85 ), Angle( 0, 90, 0 ), "auto_avenger" },

}

COMPONENT.Sections = {
	["auto_whelen_avenger"] = {
		[1] = { { 1, "_1" } },
		[2] = { { 2, "_2" } }
	}
}

COMPONENT.Patterns = {
	["auto_whelen_avenger"] = {
		["code1"] = { 1, 1, 1, 1, 2, 2, 2, 2},
		["code2"] = { 1, 0, 1, 0, 2, 0, 2, 0},
		["code3"] = { 1, 1, 2, 2},
	},
}

COMPONENT.Modes = {
	Primary = {
		M1 = { ["auto_whelen_avenger"] = "code1", },
		M2 = { ["auto_whelen_avenger"] = "code2", },
		M3 = { ["auto_whelen_avenger"] = "code3", },
		--ALERT = { ["auto_whelen_avenger"] = "alert", },
	},
	Auxiliary = {},
	Illumination = {}
}

EMVU:AddAutoComponent( COMPONENT, name )
