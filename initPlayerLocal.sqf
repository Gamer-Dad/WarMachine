//Author: IvosH
waitUntil {!isNull player}; //JIP
//variables setup
lUpdate = 0;
suppUsed=0;
boatArUsed=0;
boatTrUsed=0;
carUsed=0;
truckUsed=0;
fort1 = 0;
fort2 = 0;
fort3 = 0;

//add all unit traits to every player
_trait = ["medic", "engineer", "explosiveSpecialist", "UAVHacker"];
{player setUnitTrait [_x, true];} forEach _trait;
//load wepons by role, disable save load buttons when Virtual Arsenal opens
if ("param2" call BIS_fnc_getParamValue == 1) then
{
	[missionNamespace, "arsenalOpened", 
		{
			disableSerialization;
			params ["_display"];
			_display displayAddEventHandler ["keydown", "_this select 3"];
			{(_display displayCtrl _x) ctrlShow false} forEach [44151, 44150, 44146, 44147, 44148, 44149, 44346];
		}
	] call BIS_fnc_addScriptedEventHandler;
};
//save gear when Virtual Arsenal closes
if ("param2" call BIS_fnc_getParamValue > 0) then
{
	[missionNamespace, "arsenalClosed", 
		{	
			[player, [player, "Custom Loadout"]] call BIS_fnc_saveInventory;
			[player,["player:Custom Loadout"]] call bis_fnc_setrespawninventory;
			hint parseText format ["CUSTOM LOADOUT SAVED<br/><br/>Available in the respawn menu<br/>Default > Custom Loadout"];
		}
	] call BIS_fnc_addScriptedEventHandler;
};
["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // Initializes the player/client side Dynamic Groups framework

//hint, informations for players
_a="Wait for the admin to create a mission";
call
{
	if("param1" call BIS_fnc_getParamValue == 2)exitWith{_a="MISSION GENERATOR<br/>is available in the action menu";}; //2
	if(serverCommandAvailable "#kick")exitWith{_a="MISSION GENERATOR<br/>is available in the action menu";}; //0
	if(("param1" call BIS_fnc_getParamValue == 1)&&(count(allPlayers - entities "HeadlessClient_F")==1))exitWith{_a="MISSION GENERATOR<br/>is available in the action menu";}; //1
};
_b="<br/><br/>VIRTUAL ARSENAL<br/>is accessible at the supply box";
if("param2" call BIS_fnc_getParamValue == 0)then{_b="";}; //2

hint parseText format ["%1%2",_a,_b];
/*
if (progress == 0) then
{
	call
	{
		if ((serverCommandAvailable "#kick" || "param1" call BIS_fnc_getParamValue == 1) && "param2" call BIS_fnc_getParamValue > 0) 
		then {hint parseText format ["MISSION GENERATOR<br/>is available in the action menu<br/><br/>VIRTUAL ARSENAL<br/>is accessible at the supply box"]};
		if (!(serverCommandAvailable "#kick" ||"param1" call BIS_fnc_getParamValue == 1) && "param2" call BIS_fnc_getParamValue > 0) 
		then {hint parseText format ["VIRTUAL ARSENAL<br/>is accessible at the supply box<br/><br/>Wait for the admin to create a mission"]};
		if ((serverCommandAvailable "#kick" || "param1" call BIS_fnc_getParamValue == 1) && "param2" call BIS_fnc_getParamValue == 0) 
		then {hint parseText format ["MISSION GENERATOR<br/>is available in the action menu"]};
		if (!(serverCommandAvailable "#kick" || "param1" call BIS_fnc_getParamValue == 1) && "param2" call BIS_fnc_getParamValue == 0) 
		then {hint format ["Wait for the admin to create a mission"]};
	};
};
*/
null = [] execVM "admin\radio.sqf";
setPlayerRespawnTime 1;