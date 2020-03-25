/*
	Author: IvosH

	Description:
		Delete flag and respawn position at defenders FOB, when attackers get closer then 300m

	Parameter(s):
		none
		
	Returns:
		BOOL
		
	Dependencies:
		WarMachine scripts
		
	Execution:
		[] spawn wrm_fnc_flagDelete;
*/
if !( isServer ) exitWith {}; //run on the dedicated server or server host

while {flgDel==0;} do
{
	_un=[];
	{if (side _x == sideA) then {_un pushBack _x};} forEach playableUnits;
	{
		if (_x distance flgD < 300) then
		{
			deleteMarker resFobD; //remove respawn position at defenders FOB
			deleteVehicle flgD; //delete defenders FOB flag
			flgDel=1; publicVariable "flgDel";
		};
	} forEach _un;
	sleep 29;
};