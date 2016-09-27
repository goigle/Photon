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

local name = "Whelen Avenger Trio"

local COMPONENT = {}

COMPONENT.Model = "models/lonewolfie/whelenavenger_double.mdl"
COMPONENT.Skin = 0
COMPONENT.Category = "Interior"
COMPONENT.Bodygroups = {}
COMPONENT.NotLegacy = true
COMPONENT.DefaultColors = {
	[1] = "BLUE",
	[2] = "RED",
	[3] = "WHITE"
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
		[2] = { { 1, "_2" } },
		[3] = { { 1, "_3" } },
		[4] = { { 2, "_1" } },
		[5] = { { 2, "_2" } },
		[6] = { { 2, "_3" } },
	}
}

COMPONENT.Patterns = {
	["auto_whelen_avenger"] = {
		["code1"] = { 1, 1, 1, 1, 5, 5, 5, 5, 3, 3, 3, 3, 4, 4, 4, 4, 2, 2, 2, 2, 6, 6, 6, 6},
		["code2"] = { 1, 0, 1, 0, 5, 0, 5, 0, 3, 0, 3, 0, 4, 0, 4, 0, 2, 0, 2, 0, 6, 0, 6, 0},
		["code3"] = { 1, 1, 5, 5, 3, 3, 4, 4, 2, 2, 6, 6,},
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
	Illumination = {
		--Getting illum to work is still a WIP
		/*
		F = {
			{ 1, "_3" }, { 2, "_3" }
		},
		T = {
			{ 1, "_3" }, { 2, "_3" }
		}
		*/
	}
}

EMVU:AddAutoComponent( COMPONENT, name )
