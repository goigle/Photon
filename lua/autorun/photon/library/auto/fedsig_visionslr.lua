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

local name = "Federal Signal Vision SLR"

local COMPONENT = {}

COMPONENT.Model = "models/schmal/fedsig_visionslr/vision_lightbar.mdl"
COMPONENT.Skin = 0
COMPONENT.Bodygroups = {}

COMPONENT.Meta = {
	visionslr_a = {
		AngleOffset = "R",
		Speed = 10,
		W = 8,
		H = 4,
		Sprite = "sprites/emv/visionslr",
		Scale = 1.75,
		WMult = 1.33,
	},
	visionslr_b = {
		AngleOffset = "R",
		W = 8,
		H = 4,
		Speed = 8,
		Sprite = "sprites/emv/visionslr",
		Scale = 1,
		WMult = 1.33,
	},
	visionslr_rear = {
		AngleOffset = 90,
		W = 6.2,
		H = 6,
		Sprite = "sprites/emv/visionslr_rear",
		Scale = 1,
		WMult = 2,
	},
	visionslr_side = {
		AngleOffset = -90,
		W = 7,
		H = 6.4,
		Sprite = "sprites/emv/visionslr_side",
		Scale = 1,
		WMult = 2.25,
	},
}

COMPONENT.Positions = {

	[1] = { Vector( 0, 16.78, 2.05 ), Angle( 0, 0, 0 ), "visionslr_a" },

	[2] = { Vector( -8.02, 10.28, 2.05 ), Angle( 0, 0, 0 ), "visionslr_b" },
	[3] = { Vector( 8.02, 10.28, 2.05 ), Angle( 0, 0, 0 ), "visionslr_b" },

	[4] = { Vector( -16.03, 2.6, 2.05 ), Angle( 0, 90, 0 ), "visionslr_a" },
	[5] = { Vector( 16.03, 2.6, 2.05 ), Angle( 0, 90, 0 ), "visionslr_a" },

	[6] = { Vector( -24.13, -5.03, 2.05 ), Angle( 0, 180, 0 ), "visionslr_a" },
	[7] = { Vector( 24.13, -5.03, 2.05 ), Angle( 0, 180, 0 ), "visionslr_a" },

	[8] = { Vector( -15.48, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
	[9] = { Vector( 15.48, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

	[10] = { Vector( -9.35, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
	[11] = { Vector( 9.35, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

	[12] = { Vector( -3.18, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },
	[13] = { Vector( 3.18, -13.16, 0.03 ), Angle( 0, 0, 0 ), "visionslr_rear" },

	[14] = { Vector( -30.28, -8.11, 0.13 ), Angle( 0, 90, 11.7 ), "visionslr_side" },
	[15] = { Vector( 30.28, -8.11, 0.13 ), Angle( 0, -90, 11.7 ), "visionslr_side" },

}

COMPONENT.Sections = {
	["auto_fedsig_visionslr"] = {
		{
			{ 1, R },
			{ 2, W }, { 3, W },
			{ 4, R }, { 5, R },
			{ 6, RB }, { 7, RB },

			{ 8, A }, { 9, A },
			{ 10, A }, { 11, A },
			{ 12, A }, { 13, A },

			{ 14, W }, { 15, W },
		},
		{
			{ 1, R },
			{ 2, W }, { 3, W },
			{ 4, R }, { 5, R },
			{ 6, RB }, { 7, RB },
		}
	},
	["auto_fedsig_visionslr_traffic"] = {
		{ { 8, A }, { 9, A }, { 10, A }, { 11, A } },
		{ { 12, A }, { 13, A } },
	}
}

COMPONENT.Patterns = {
	["auto_fedsig_visionslr"] = {
		["all"] = { 1 },
		["code2"] = { 2 }
	},
	["auto_fedsig_visionslr_traffic"] = {
		["warn"] = { 1, 1, 1, 1, 0, 2, 2, 2, 2, 0 } 
	}
}

EMVU:AddAutoComponent( COMPONENT, name )