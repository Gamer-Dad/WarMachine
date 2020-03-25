/*
	Author: IvosH
	
	Description:
		If player (leader) respawn on the FOB at the mission start all AI units are teleported to his position. 
	
	Parameter(s):
		NONE
	
	Returns:
		nothing
		
	Dependencies:
		start.sqf
		
	Execution:
		"warmachine\firstSpawn.sqf" remoteExec ["execVM", 0, true];
*/

if(!hasInterface)exitWith{}; //run on the players only
waitUntil {!isNull player}; //JIP
waitUntil {alive player}; //player has respawned
sleep 0.5;
if(player != leader player)exitWith{}; //run on the players only

_fob=objectFobWest; _posF=posFobWest;
if(side player == sideE)then{_fob=objectFobEast; _posF=posFobEast;};
if(player distance _fob>100)exitWith{}; //player is not on the FOB
_grp=[];
{if(!isPlayer _x)then{_grp pushBackUnique _x;};}forEach units group player;
{
	_posU = _fob getRelPos [20, random 360];
	_x setVehiclePosition [_posU, [], 0, "NONE"];
} forEach _grp;