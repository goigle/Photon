AddCSLuaFile()

local key_primary_toggle = true
local key_primary_alt = true
local key_siren_toggle = true
local key_siren_alt = true
local key_auxiliary = true
local key_blackout = true
local key_horn = true
local key_manual = true
local key_illum = true

hook.Add( "InitPostEntity", "Photon.SetupLocalKeyBinds", function()
	key_primary_toggle = GetConVar( "photon_key_primary_toggle" )
	key_primary_alt = GetConVar( "photon_key_primary_alt" )
	key_siren_toggle = GetConVar( "photon_key_siren_toggle" )
	key_siren_alt = GetConVar( "photon_key_siren_alt" )
	key_auxiliary = GetConVar( "photon_key_auxiliary" )
	key_blackout = GetConVar( "photon_key_blackout" )
	key_horn = GetConVar( "photon_key_horn" )
	key_manual = GetConVar( "photon_key_manual" )
	key_illum = GetConVar( "photon_key_illum" )
end)

function EMVU:Listener( ply, bind, press )
	if not ply:InVehicle() or not ply:GetVehicle():Photon() then return end
	local emv = ply:GetVehicle()
	if not IsValid( emv ) then return false end
	if string.find(bind, "+attack") and not string.find(bind, "+attack2") then
		if LocalPlayer():KeyDown( IN_MOVELEFT ) then
			Photon:CarSignal( "left" )
		elseif LocalPlayer():KeyDown( IN_MOVERIGHT ) then
			Photon:CarSignal( "right" )
		elseif LocalPlayer():KeyDown( IN_BACK ) then
			Photon:CarSignal( "hazard" )
		else
			Photon:CarSignal( "none" )
		end
	elseif LocalPlayer():KeyDown( IN_ATTACK ) then
		if string.find(bind, "+moveleft" ) then
			Photon:CarSignal( "left" )
		elseif string.find(bind, "+moveright") then
			Photon:CarSignal( "right" )
		elseif string.find(bind, "+back") then
			Photon:CarSignal( "hazard" )
		elseif string.find(bind, "+forward") then
			Photon:CarSignal( "none" )
		end
	end

end
hook.Add("PlayerBindPress", "EMVU.Listener", function( pl, b, p )
	EMVU:Listener( pl, b, p )
end)

local inputKeyDown = input.IsKeyDown
local inputMouseDown = input.IsMouseDown

local function keyDown( key )
	if (key > 0 and key < 107) then
		return inputKeyDown( tonumber( key ) )
	end
	if (key > 107 and key < 114) then
		return inputMouseDown( tonumber( key ) )
	end
	return false
end

hook.Add( "Think", "Photon.ButtonPress", function()
	if not LocalPlayer():InVehicle() or not IsValid( LocalPlayer():GetVehicle() ) or not LocalPlayer():GetVehicle():IsEMV() then return end
	local emv = LocalPlayer():GetVehicle()
	if input.IsKeyTrapping() then return end
	if vgui.CursorVisible() then return end
	
	if not X_DOWN then
		if keyDown( key_illum:GetInt() ) then
			if emv:Photon_Illumination() then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
			X_DOWN = true
			X_PRESS = CurTime()
		end
	elseif X_DOWN and not keyDown ( key_illum:GetInt() ) then
		local cmd = "on"
		if emv:Photon_Illumination() and X_PRESS + .25 > CurTime() then 
			cmd = "off"
		elseif emv:Photon_Illumination() then
			cmd = "tog"
		end
		if cmd == "on" or cmd == "tog" then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
		EMVU.Net:Illuminate( cmd )
		X_DOWN = false
	end

	if emv:Photon_HasTrafficAdvisor() then 
		if not PHOTON_B_DOWN then
			if keyDown( key_auxiliary:GetInt() ) then
				if emv:Photon_TrafficAdvisor() then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
				PHOTON_B_DOWN = true
				PHOTON_B_PRESS = CurTime()
			end
		elseif PHOTON_B_DOWN and not keyDown ( key_auxiliary:GetInt() ) then
			local cmd = "on"
			if emv:Photon_TrafficAdvisor() and PHOTON_B_PRESS + .25 > CurTime() then 
				cmd = "off"
			elseif emv:Photon_TrafficAdvisor() then
				cmd = "tog"
			end
			if cmd == "on" or cmd == "tog" then surface.PlaySound( EMVU.Sounds.Up ) else surface.PlaySound( EMVU.Sounds.Down ) end
			EMVU.Net:Traffic( cmd )
			PHOTON_B_DOWN = false
		end
	end

	if not LIGHTON_DOWN and keyDown( key_primary_toggle:GetInt() ) then
		if emv:Photon_Lights() then 
			surface.PlaySound( EMVU.Sounds.Up )
		else
			surface.PlaySound( EMVU.Sounds.Down )
		end
		LIGHTON_DOWN = true
	elseif LIGHTON_DOWN and not keyDown( key_primary_toggle:GetInt() ) then
		if emv:Photon_Lights() then
			surface.PlaySound( EMVU.Sounds.Down )
			EMVU.Net:Lights( "off" )
		else
			surface.PlaySound( EMVU.Sounds.Up )
			EMVU.Net:Lights( "on" )
		end
		LIGHTON_DOWN = false
	end

	if not SIRENON_DOWN and keyDown( key_siren_toggle:GetInt() ) then
		SIRENON_DOWN = true
		if emv:Photon_Siren() then
			EMVU.Net:Siren( "off" )
		else
			EMVU.Net:Siren( "on" )
		end
	elseif SIRENON_DOWN and not keyDown( key_siren_toggle:GetInt() ) then
		SIRENON_DOWN = false
	end

	if not LIGHTTOG_DOWN and keyDown( key_primary_alt:GetInt() ) then
		if emv:Photon_Lights() then
			surface.PlaySound( EMVU.Sounds.Up )
		else
			surface.PlaySound( EMVU.Sounds.Down )
		end
		EMVU.Net:Lights("tog")
		LIGHTTOG_DOWN = true
	elseif LIGHTTOG_DOWN and not keyDown( key_primary_alt:GetInt() ) then
		LIGHTTOG_DOWN = false
	end

	if not SIRENTOGGLE_DOWN and keyDown( key_siren_alt:GetInt() ) then
		if emv:Photon_Lights() then
			surface.PlaySound( EMVU.Sounds.Up )
		else
			surface.PlaySound( EMVU.Sounds.Down )
		end
		EMVU.Net:Siren("tog")
		SIRENTOGGLE_DOWN = true
	elseif SIRENTOGGLE_DOWN and not keyDown( key_siren_alt:GetInt() ) then
		SIRENTOGGLE_DOWN = false
	end

	if not BLKOUTON_DOWN and keyDown( key_blackout:GetInt() ) then
		if emv:Photon_IsRunning() then 
			surface.PlaySound( EMVU.Sounds.Down )
		else
			surface.PlaySound( EMVU.Sounds.Up )
		end
		BLKOUTON_DOWN = true
	elseif BLKOUTON_DOWN and not keyDown( key_blackout:GetInt() ) then
		if emv:Photon_IsRunning() then
			surface.PlaySound( EMVU.Sounds.Up )
			EMVU.Net:Blackout( true )
		else
			surface.PlaySound( EMVU.Sounds.Down )
			EMVU.Net:Blackout( false )
		end
		BLKOUTON_DOWN = false
	end

	if not HORNTOG_DOWN and keyDown( key_horn:GetInt() ) then
		EMVU.Net:Horn( true )
		HORNTOG_DOWN = true
	elseif HORNTOG_DOWN and not keyDown( key_horn:GetInt() ) then
		EMVU.Net:Horn( false )
		HORNTOG_DOWN = false
	end

	if not MANUALTOG_DOWN and keyDown( key_manual:GetInt() ) then
		EMVU.Net:Manual( true )
		MANUALTOG_DOWN = true
	elseif MANUALTOG_DOWN and not keyDown( key_manual:GetInt() ) then
		EMVU.Net:Manual( false )
		MANUALTOG_DOWN = false
	end

end)



local function SirenSuggestions( cmd, args )

	args = string.Trim( args )
	args = string.lower( args )

	local result = {}

	local i = 1
	for k,v in pairs( EMVU.Sirens ) do

		table.insert( result, "emv_siren " .. k .. " \"" .. v.Name .. "\"")

	end

	return result

end

concommand.Add("emv_siren", function(ply, cmd, args)
	if not args[1] then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local set = 0
	local max = #EMVU.Sirens
	local val = tonumber(args[1])
	if val and isnumber(val) and val <= max then set = val end
	EMVU.Net:SirenSet( set )
end, SirenSuggestions, "[Photon] Overrides the default siren on an Emergency Vehicle.")

concommand.Add("car_signal", function(ply, cmd, args)
	if not ply:InVehicle() or not ply:GetVehicle():Photon() or not args[1] then return end
	Photon:CarSignal( args[1] )
end)

concommand.Add( "emv_illum", function( ply, cmd, args ) 
	if not args[1] then return end
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	EMVU.Net:Illuminate( args[1] )
end)

function Photon:CarSignal( arg )
	if not LocalPlayer():InVehicle() or not LocalPlayer():GetVehicle():Photon() or not arg then return end
	local car = LocalPlayer():GetVehicle()
	if arg == "left" then 
		Photon.Net:Signal( CAR_TURNING_LEFT )
		if not car:Photon_TurningLeft() then surface.PlaySound( EMVU.Sounds.SignalOn ) else surface.PlaySound( EMVU.Sounds.SignalOff ) end
		return
	end
	if arg == "right" then 
		Photon.Net:Signal( CAR_TURNING_RIGHT )
		if not car:Photon_TurningRight() then surface.PlaySound( EMVU.Sounds.SignalOn ) else surface.PlaySound( EMVU.Sounds.SignalOff ) end
		return
	end
	if arg == "hazard" then Photon.Net:Signal( CAR_HAZARD ) return end
	if arg == "none" and (car:Photon_BlinkState() != 0) then Photon.Net:Signal( 0 ); surface.PlaySound( EMVU.Sounds.SignalOff ) return end
end