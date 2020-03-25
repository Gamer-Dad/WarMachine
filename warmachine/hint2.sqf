/*
Author: IvosH 9.6.2017
reset actions menu, hint displays for all players at begining of second phase (fight for FOB)
[] execVM "warmachine\hint2.sqf";
"warmachine\hint2.sqf" remoteExec ["execVM", 0, false];
*/
/*
	Author: IvosH
	
	Description:
		hint displays for all players at begining of second phase (fight for FOB) 
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		fn_progress
		
	Execution:
		[] execVM "warmachine\hint.sqf";
		"warmachine\hint2.sqf" remoteExec ["execVM", 0, true];
*/

if (!hasInterface) exitWith {};
waitUntil {!isNull player}; //JIP
waitUntil {progress > 2}; //fight for FOB started
waitUntil {alive player}; //player has respawned

call
{
	if (side player == sideA) then
	{
		[[
			["ATTACK ENEMY FOB"],
			["ADVANCE"]
		]] spawn BIS_fnc_typeText;
		sleep 10;
		_tx=["ADVANCE<br/><br/>",factionA," captured ",loc,"<br/>ATTACK ",factionD," FOB"] joinString "";
		hint parseText format ["%1", _tx];
	};
	if (side player == sideD) then
	{
		[[
			["DEFEND YOUR FOB"],
			["RETREAT"]
		]] spawn BIS_fnc_typeText;
		sleep 10;
		_tx=["RETREAT<br/><br/>",factionD," lost ",loc,"<br/>DEFEND ",factionD," FOB"] joinString "";
		hint parseText format ["%1", _tx];
	};
};