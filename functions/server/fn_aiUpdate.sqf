/*
	Author: IvosH
	
	Description:
		Runs loop for AI to attack objectives.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		start.sqf (BIS_fnc_addScriptedEventHandler, sectors "OnOwnerChange")
		fn_aiMove.sqf
		
	Execution:
		[] spawn wrm_fnc_aiUpdate;
*/

if !( isServer ) exitWith {}; //run on the dedicated server or server host
sleep 10;
//infinite loop
for "_i" from 0 to 1 step 0 do 
{
	[] call wrm_fnc_aiMove;
	sleep 181;
};