/*
	Author: IvosH
	
	Description:
		Push boat into the water. set position of the boat 15m in front of the player.
		Player must be group leader and boat can't be in the water.
		
	Parameter(s):
		0: OBJECT _boat
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		
	Execution:
		[] call wrm_fnc_pushBoat;
*/
if (!hasInterface) exitWith {};
_boat = _this select 0;

_boat addAction 
[
	"Push the boat", //title
	{
		(_this select 0) setPos ((_this select 1) getRelPos [15, 0]);
	}, //script
	nil, //arguments (Optional)
	6, //priority (Optional)
	false, //showWindow (Optional)
	true, //hideOnUse (Optional)
	"", //shortcut, (Optional) 
	"(((getPos _target isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo [])||(getPosAtl _target select 2 < 0.2)) && (_this == vehicle  _this))", //condition,  (Optional)
	10, //radius, (Optional) -1disable, 15max
	false, //unconscious, (Optional)
	"" //selection]; (Optional)
]; 