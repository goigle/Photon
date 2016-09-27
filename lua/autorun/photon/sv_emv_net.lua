util.AddNetworkString( "emvu_add" )
util.AddNetworkString( "emvu_siren" )
util.AddNetworkString( "emvu_el" )
util.AddNetworkString( "emvu_load" )
util.AddNetworkString( "emvu_sirenset" )
util.AddNetworkString( "emvu_illum" )
util.AddNetworkString( "emvu_blackout" )
util.AddNetworkString( "emvu_horn" )
util.AddNetworkString( "emvu_manual" )
util.AddNetworkString( "emvu_traffic" )
util.AddNetworkString( "photon_signal" )
util.AddNetworkString( "photon_menu" )
util.AddNetworkString( "emvu_preset" )
util.AddNetworkString( "emvu_livery" )
util.AddNetworkString( "photon_liveryupdate" )
util.AddNetworkString( "emvu_selection" )
util.AddNetworkString( "photon_myunitnumber" )
util.AddNetworkString( "photon_availableskins" )
util.AddNetworkString( "photon_setautoskin" )
util.AddNetworkString( "emvu_color" )
util.AddNetworkString( "photon_license_mat" )
util.AddNetworkString( "photon_player_finished_loading" )

local can_change_siren_model = GetConVar( "photon_emv_changesirens" )
local can_change_light_presets = GetConVar( "photon_emv_changepresets" )

EMVU.Net = {}

function EMVU.Net:Lights( ply, args )
	if not ply:InVehicle() then return end
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args == "on" then
		emv:ELS_LightsOn()
	elseif args == "off" then
		emv:ELS_LightsOff()
	elseif args == "tog" then
		emv:ELS_LightsToggle()
	end
end
net.Receive("emvu_el", function(len, ply)
	EMVU.Net:Lights( ply, net.ReadString() )
end)

function EMVU.Net:Siren( ply, args )
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	local argNum = tonumber( args )
	if args == "on" then
		emv:ELS_SirenOn()
	elseif args == "off" then
		emv:ELS_SirenOff()
	elseif args == "tog" then
		emv:ELS_SirenToggle()
	elseif args == "hon" then
		emv:ELS_HornOn()
	elseif args == "hoff" then
		emv:ELS_HornOff()
	elseif isnumber( argNum ) then
		emv:ELS_SirenToggle( argNum )
	end
end
net.Receive("emvu_siren", function( len, ply )
	EMVU.Net:Siren( ply, net.ReadString() )
end)

function EMVU.Net:Illumination( ply, args )
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args=="on" then
		emv:ELS_IllumOn()
	elseif args == "off" then
		emv:ELS_IllumOff()
	elseif args == "tog" then
		emv:ELS_IllumToggle()
	end
end
net.Receive("emvu_illum", function( len, ply )
	EMVU.Net:Illumination( ply, net.ReadString() )
end)

function EMVU.Net:Traffic( ply, args )
	local emv = ply:GetVehicle()
	if not emv:IsEMV() then return end
	if args == "on" then
		emv:ELS_TrafficOn()
	elseif args == "off" then
		emv:ELS_TrafficOff()
	elseif args == "tog" then
		emv:ELS_TrafficToggle()
	end
end
net.Receive( "emvu_traffic", function (len, ply )
	EMVU.Net:Traffic( ply, net.ReadString() )
end)

function EMVU.Net:SirenSet( ply )
	local emv = net.ReadEntity()
	local recv = net.ReadInt(8)
	local isAux = net.ReadBool()
	if not emv:IsEMV() or not can_change_siren_model:GetBool() then return end
	local modifyBlocked = hook.Call( "Photon.CanPlayerModify", GM, ply, emv )
	if modifyBlocked != false then
		if not isAux then
			if recv != 0 then emv:ELS_SetSirenSet(recv) end
		else
			emv:ELS_SetAuxSirenSet( recv )
		end
	end
end
net.Receive("emvu_sirenset", function( len, ply )
	EMVU.Net:SirenSet( ply )
end)

function EMVU.Net:Color( ply )
	local ent = net.ReadEntity()
	local newCol = net.ReadColor()
	if not ent:IsEMV() then return false end
	local modifyBlocked = hook.Call( "Photon.CanPlayerModify", GM, ply, ent )
	if modifyBlocked != false then
		ent:SetColor( newCol )
	end
end
net.Receive( "emvu_color", function( len, ply )
	EMVU.Net:Color( ply )
end)

function EMVU.Net:Preset( ply, args )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() or not can_change_light_presets:GetBool() then return end
	local emv = ply:GetVehicle()
	local recv = net.ReadInt(8)
	if recv != 0 then emv:ELS_PresetOption( recv ) return end
end
net.Receive( "emvu_preset", function( len, ply )
	EMVU.Net:Preset( ply )
end)

function EMVU.Net.Selection( ply )
	local ent = net.ReadEntity()
	local category = net.ReadInt(8)
	local option = net.ReadInt(8)
	if not ent:IsEMV() then return end
	local modifyBlocked = hook.Call( "Photon.CanPlayerModify", GM, ply, ent )
	if modifyBlocked != false then
		ent:Photon_SetSelection( category, option )
	end
end
net.Receive( "emvu_selection", function( len, ply )
	EMVU.Net.Selection( ply )
end)

function EMVU.Net:Blackout( ply, arg )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	emv:ELS_Blackout( arg )
end
net.Receive( "emvu_blackout", function( len, ply )
	EMVU.Net:Blackout( ply, tobool( net.ReadBit() ) )
end)

function EMVU.Net:Horn( ply, arg )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	emv:ELS_Horn( arg )
end
net.Receive( "emvu_horn", function( len, ply )
	EMVU.Net:Horn( ply, tobool( net.ReadBit() ))
end)

function EMVU.Net:Manual( ply, arg )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	local emv = ply:GetVehicle()
	emv:ELS_ManualSiren( arg )
end
net.Receive( "emvu_manual", function( len, ply )
	EMVU.Net:Manual( ply, tobool( net.ReadBit() ))
end)

function EMVU.Net:Livery( ply, category, skin, unit )
	if not ply:InVehicle() or not ply:GetVehicle():IsEMV() then return end
	if game.SinglePlayer() == false then
		if not ply.LastLiveryChange then ply.LastLiveryChange = 0 end
		if RealTime() < ply.LastLiveryChange + PHOTON_LIVERY_COOLDOWN then
			ply:ChatPrint( "[Photon] Please wait a few seconds before changing the vehicle livery again." );
			ply.LastLiveryChange = RealTime();
			return
		end
	end
	ply.LastLiveryChange = RealTime();
	local emv = ply:GetVehicle()
	emv:Photon_ApplyLivery( category, skin, unit )
end
net.Receive( "emvu_livery", function( len, ply )
	EMVU.Net:Livery( ply, tostring( net.ReadString() ), tostring( net.ReadString() ), tostring( net.ReadString() ) )
end)

function Photon.Net:Signal( ply )
	if not ply:InVehicle() or not ply:GetVehicle():Photon() then return end
	local car = ply:GetVehicle()
	local signal = net.ReadInt(3)
	if not signal == CAR_TURNING_LEFT or not signal == CAR_TURNING_RIGHT or not signal == CAR_HAZARD then return false end
	if signal == car:CAR_Signal() then car:CAR_StopSignals() return end
	car:CAR_Signal( signal )
end
net.Receive("photon_signal", function( l,p )
	Photon.Net:Signal( p )
end)

function Photon.Net:OpenMenu( ply )
	if not IsValid( ply ) then return end
	net.Start( "photon_menu" )
	net.Send( ply )
end

local function PhotonMenuCheck( ply, txt )
	if txt=="!photon" then Photon.Net:OpenMenu( ply ); return "" end
end
hook.Add( "PlayerSay", "Photon.MenuCheck", PhotonMenuCheck )

concommand.Add( "photon_stick", function( ply, cmd, args )
	if not IsValid( ply ) or not ply:IsAdmin() then return end
	local car = ply:GetVehicle()
	if not IsValid( car ) or not car:Photon() then return end
	car:StayOn( !car:StayOn() )
end )

function Photon.Net:NotifyLiveryUpdate( id, unit, ent )
	ent.photonLiverySet = true
	ent.photonNetId = id
	ent.photonNetUnit = unit
	net.Start( "photon_liveryupdate" )
		net.WriteString( id )
		net.WriteString( unit )
		net.WriteEntity( ent )
	net.Broadcast()
end

--reloading liveries when player connect
net.Receive("photon_player_finished_loading", function(len, ply) SendLiveriesToClient(ply) end)
hook.Add( "Move", "photon_liveryupdate_first", function(ply, mv)
	if ply.SentPhotonStuff == nil then
		ply.SentPhotonStuff = true
		SendLiveriesToClient(ply)
	end
end )
function SendLiveriesToClient(ply)
	for k,ent in pairs(ents.GetAll()) do
		if ent:IsVehicle() and ent.photonLiverySet != nil and ent.photonLiverySet == true then
			net.Start( "photon_liveryupdate" )
			net.WriteString( ent.photonNetId )
			net.WriteString( ent.photonNetUnit )
			net.WriteEntity( ent )
			net.Send( ply )
		end
	end
end

function Photon.Net:ReceiveUnitNumber( ply, unit )
	if not IsValid( ply ) or not IsValid( ply:GetVehicle() ) or not ( ply:GetVehicle():IsEMV() ) then return end
	local ent = ply:GetVehicle()
	ent:Photon_SetUnitNumber( unit )
end
net.Receive( "photon_myunitnumber", function( len, ply )
	Photon.Net:ReceiveUnitNumber( ply, net.ReadString() )
end )

function Photon.Net:RequestUnitNumber( ply )
	net.Start( "photon_myunitnumber" )
	net.Send( ply )
end

function Photon.Net.SendAvailableLiveries( ply )
	net.Start( "photon_availableskins" )
		net.WriteTable( Photon.AutoSkins.Available )
	net.Send( ply )
end
net.Receive( "photon_availableskins", function( len, ply ) Photon.Net.SendAvailableLiveries( ply ) end )

function Photon.Net.ReceiveSkinChangeRequest( len, ply )
	local ent = net.ReadEntity()
	local skinName = net.ReadString()
	local modifyBlocked = hook.Call( "Photon.CanPlayerModify", GM, ply, ent )
	if modifyBlocked != false then
		ent:Photon_SetAutoSkin( skinName )
	end
end
net.Receive( "photon_setautoskin", function( len, ply ) Photon.Net.ReceiveSkinChangeRequest( len, ply ) end )

function Photon.Net.SetLicenseMaterial( len, ply )
	local ent = net.ReadEntity()
	local mat = net.ReadString()
	local modifyBlocked = hook.Call( "Photon.CanPlayerModify", GM, ply, ent )
	if modifyBlocked != false then
		ent:Photon_SetLicenseMaterial( mat )
	end
end
net.Receive( "photon_license_mat", function( len, ply ) Photon.Net.SetLicenseMaterial( len, ply ) end )

local cintargent = nil

concommand.Add( "photon_settarg", function( ply )
	local ent = ply:GetEyeTrace().Entity
	if not IsValid( ent ) then return end
	cintargent = ent
	print("TARGET SET")
end )

concommand.Add( "photon_cin", function( ply )
	for k,v in pairs( ents.GetAll() ) do
		if v:IsEMV() then
			-- v:ELS_TrafficOn()
			-- v:ELS_LightsOn()
			-- v:ELS_IllumOn()
			-- v:CAR_Running( true )
		end
	end
end )


local targIndex = -30
concommand.Add( "photon_materialt", function( ply )
	local targ = ply:GetEyeTrace().Entity
	if IsValid( targ ) then
		print( tostring( targ ) )
		print( tostring( "Index: " .. targIndex ) )
		print( tostring( targ:GetSubMaterial( targIndex ) ) )
		targ:SetSubMaterial( targIndex, "sprites/emv/fs_valor")
		print( tostring( targ:GetSubMaterial( targIndex ) ) )
		targIndex = targIndex + 1
	end
end )
