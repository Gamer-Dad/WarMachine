/*
	Author: IvosH
	
	Description:
		Protect player / AI to be killed when in base
		
	Parameter(s):
		0: VARIABLE respawned unit
		
	Returns:
		nothing
		
	Dependencies:
		fn_respawnEH.sqf
		onPlayerRespawn.sqf
		aiStart.sqf
		
	Execution:
		[_unit] spawn wrm_fnc_safeZone;
*/

_unit = _this select 0; //_this = unit which respawns
if(progress<2)exitWith{};
//BASE respawn
_posB=[];
if (side _unit==sideW) 
then {_posB=posBaseWest;} 
else {_posB=posBaseEast;};
if((_unit distance _posB) > 100)exitWith{};
if(isPlayer _unit)then{systemChat "You are invulnerable";};
_unit allowDammage false; 
while {(_unit distance _posB) < 100} do {sleep 7;};
_unit allowDammage true;
if(isPlayer _unit)then{systemChat "You are now vulnerable";};