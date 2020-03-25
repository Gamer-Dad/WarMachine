/*
	Author: IvosH
	
	Description:
		Force driver of the APC, Truck to move (drive) to the sector
		
	Parameter(s):
		0: GROUP with assigned APC
		1: POSITION, sector to attack
		
	Returns:
		nothing
		
	Dependencies:
		fn_aiMove.sqf
		
	Execution:
		[_grp,_sec] execVM "warmachine\aiDrive.sqf";
*/
_grp=_this select 0;
_sec=_this select 1;

waitUntil {vehicle leader _grp != leader _grp}; //Leader boarded vehicle
_veh= vehicle leader _grp;
waitUntil {count crew _veh >= count units _grp}; //Whole group is in the vehicle
while {speed _veh<=0} do //while vehicle is not moving
{
	driver _veh doMove _sec; //driver ride to sector
	sleep 3;
};
aiDrive=1;