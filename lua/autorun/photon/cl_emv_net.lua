AddCSLuaFile()

EMVU.Net = {}

timer.Simple(5,function()
	net.Start("photon_player_finished_loading")
	net.SendToServer()
end)

function EMVU.Net:Siren( arg )
	net.Start( "emvu_siren" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:Lights( arg )
	net.Start( "emvu_el" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:SirenSet( arg, ent, aux )
	if aux == nil then aux = false end
	if not ent then ent = LocalPlayer():GetVehicle() end
	if not IsValid( ent ) then return end
	net.Start( "emvu_sirenset" )
		net.WriteEntity( ent )
		net.WriteInt( arg, 8 )
		net.WriteBool( aux )
	net.SendToServer()
end

function Photon.Net:Signal( arg )
	net.Start( "photon_signal" )
		net.WriteInt( arg, 3 )
	net.SendToServer()
end

function EMVU.Net:Illuminate( arg )
	net.Start( "emvu_illum" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:Traffic( arg )
	net.Start( "emvu_traffic" )
		net.WriteString( arg )
	net.SendToServer()
end

function EMVU.Net:Blackout( arg )
	net.Start( "emvu_blackout" )
		net.WriteBit( arg )
	net.SendToServer()
end

function EMVU.Net:Horn( arg )
	net.Start( "emvu_horn" )
		net.WriteBit( arg )
	net.SendToServer()
end

function EMVU.Net:Manual( arg )
	net.Start( "emvu_manual" )
		net.WriteBit( arg )
	net.SendToServer()
end

function EMVU.Net:Preset( arg )
	net.Start( "emvu_preset" )
		net.WriteInt( arg, 8 )
	net.SendToServer()
end

local unitid_pref = GetConVar( "photon_emerg_unit" )

local function GenerateDefaultUnitID()
	return string.sub( tostring( LocalPlayer():SteamID64() ), 14 ) or "000" -- will use the last three digits of Steam64
end

function EMVU.Net:Livery( category, index )
	net.Start( "emvu_livery" )
		net.WriteString( category )
		net.WriteString( index )
		net.WriteString( unitid_pref:GetString() or GenerateDefaultUnitID() )
	net.SendToServer()
end

hook.Add( "Think", "PhotonCheckPVSFix", function()
	for k,ent in pairs(ents.GetAll()) do
		if ent:IsValid() and ent:IsVehicle() and ent.CphotonNetId != nil then
			if ent:GetPos():ToScreen().visible and ent:GetPos():Distance(LocalPlayer():GetPos()) < 5000 then
				if ent.fixed != true and ent.needToBeFixed == true then
					--print("fixing for car")
					--print(ent.CphotonNetId)
					ent.fixed = true
					Photon.AutoLivery.Apply( ent.CphotonNetId, ent.CphotonNetUnit, ent )
					needToBeFixed = false
				end
			else
				if ent:GetPos():ToScreen().visible == false or ent:GetPos():Distance(LocalPlayer():GetPos()) > 5000 then
					--print("will be fixed")
					ent.needToBeFixed = true
					ent.fixed = false
				end
			end
		end
	end
end )

function EMVU.Net:ReceiveLiveryUpdate( id, unit, ent )
	ent.CphotonNetId = id
	ent.CphotonNetUnit = unit
	Photon.AutoLivery.Apply( id, unit, ent )
end
net.Receive( "photon_liveryupdate", function()
	EMVU.Net:ReceiveLiveryUpdate( net.ReadString(), net.ReadString(), net.ReadEntity() )
end)

function EMVU.Net:Color( ent, col )
	net.Start( "emvu_color" )
		net.WriteEntity( ent )
		net.WriteColor( col )
	net.SendToServer()
end

function EMVU.Net:ReceiveUnitNumberRequest()
	net.Start( "photon_myunitnumber" )
		net.WriteString( unitid_pref:GetString() or GenerateDefaultUnitID() )
	net.SendToServer()
end
net.Receive( "photon_myunitnumber", function() EMVU.Net:ReceiveUnitNumberRequest() end)

function EMVU.Net.Selection( ent, category, option )
	net.Start( "emvu_selection" )
		net.WriteEntity( ent )
		net.WriteInt( category, 8 )
		net.WriteInt( option, 8)
	net.SendToServer()
end

function EMVU.Net.RequestAllSkins()
	net.Start( "photon_availableskins" )
	net.SendToServer()
end

function EMVU.Net.ReceiveAvailableSkins()
	local received = net.ReadTable()
	Photon.AutoSkins.Available = received
end
net.Receive( "photon_availableskins", function() EMVU.Net.ReceiveAvailableSkins() end)

function EMVU.Net.ApplyAutoSkin( ent, skin )
	local cnt = 0
	skin = tostring( skin )
	for i in string.gfind( skin, "/" ) do
		cnt = cnt + 1
	end
	if cnt < 2 then
		skin = string.Replace( skin, "/", "///" )
	end
	net.Start( "photon_setautoskin" )
		net.WriteEntity( ent )
		net.WriteString( skin )
	net.SendToServer()
end

function EMVU.Net.ApplyLicenseMaterial( ent, mat )
	local cnt = 0
	for i in string.gfind( mat, "/" ) do
		cnt = cnt + 1
	end
	if cnt < 2 then
		mat = string.Replace( mat, "/", "///" )
	end
	net.Start( "photon_license_mat" )
		net.WriteEntity( ent )
		net.WriteString( mat )
	net.SendToServer()
end

concommand.Add( "photon_debug_getbones", function()
	local ent = ply:GetEyeTrace().Entity
	if not IsValid( ent ) then return end
	print(tostring(ent:GetBoneCount()))
end)
