# Photon
![Photon Taurus](https://photon.lighting/images/police-taurus.png)

Garry's Mod Lighting Engine

This is the unofficial GitHub page for the Photon Lighting Engine. Code is licensed under a Creative Commons Non-Commercial Attribution agreement.

Schmal appears to have gone AWOL, and Photon features are slowly breaking. This repository aims to fix any broken features and add new content when possible.
We have a fix for liveries in this repository, however it is not a full fix as the number generator on Schmal's site is not functioning.

Pull requests are welcome, but code may be adjusted before publish. Anyone who contributes will not be appropriately credited on the official addon page because this isn't the official addon.

Additionally, many lighting patterns in this fork will change from vanilla Photon. The main reason for this is because certain patterns look gnarly at a lower FPS. If you would like to access the old patterns, they will still be there under the phase O. Here's an example:
```lua
[9] = {
  ID = "Whelen 700 Trio",
  Scale = 1.1,
  Pos = Vector( 41, -68, 65),
  Ang = Angle( 0, -90, -90 ),
  AutoPatterns = true,
  Phase = "O"
},
```
