/*
	Author: IvosH
	
	Description:
		Control condition of the cotinuously spawn AI vehicles
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		aiStart.sqf
		fn_aiVehicles.sqf
		
	Execution:
		[] spawn wrm_fnc_aiVehUpdate;
*/

if !( isServer ) exitWith {}; //run on the dedicated server or server host
//infinite loop
for "_i" from 0 to 1 step 0 do 
{
	sleep trTime; //3 min default
	
	call
	{
		if(!alive aiVehW)exitWith{[1] spawn wrm_fnc_aiVehicle;};
		if(!canMove aiVehW)exitWith{[1] spawn wrm_fnc_aiVehicle;};
		if(aiVehW getHitPointDamage "hitGun"==1)exitWith{[1] spawn wrm_fnc_aiVehicle;};
		if(aiVehW getHitPointDamage "hitTurret"==1)exitWith{[1] spawn wrm_fnc_aiVehicle;};
		if(({alive _x} count (crew aiVehW))==0)exitWith{[1] spawn wrm_fnc_aiVehicle;};
	};
	
	call
	{
		if(!alive aiVehE)exitWith{[2] spawn wrm_fnc_aiVehicle;};
		if(!canMove aiVehE)exitWith{[2] spawn wrm_fnc_aiVehicle;};
		if(aiVehE getHitPointDamage "hitGun"==1)exitWith{[2] spawn wrm_fnc_aiVehicle;};
		if(aiVehE getHitPointDamage "hitTurret"==1)exitWith{[2] spawn wrm_fnc_aiVehicle;};
		if(({alive _x} count (crew aiVehE))==0)exitWith{[2] spawn wrm_fnc_aiVehicle;};
	};

	if(missType==3)then
	{
		call
		{
			if(!alive aiCasW)exitWith{[3] spawn wrm_fnc_aiVehicle;};
			if(!canMove aiCasW)exitWith{[3] spawn wrm_fnc_aiVehicle;};
		};
		
		call
		{
			if(!alive aiCasE)exitWith{[4] spawn wrm_fnc_aiVehicle;};
			if(!canMove aiCasE)exitWith{[4] spawn wrm_fnc_aiVehicle;};
		};
	};
};