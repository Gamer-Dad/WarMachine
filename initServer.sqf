//Author: IvosH

//VARIABLES SETUP
progress = 0; publicVariable "progress";
posCenter = []; publicVariable "posCenter";
posAlpha = []; publicVariable "posAlpha";
dirAB = 0; publicVariable "dirAB";
posBravo = []; publicVariable "posBravo";
dirBA = 180; publicVariable "dirBA";
posCharlie = []; publicVariable "posCharlie";
posFobWest = []; publicVariable "posFobWest";
dirCenFobWest = 0; publicVariable "dirCenFobWest";
posFobEast = []; publicVariable "posFobEast";
dirCenFobEast = 180; publicVariable "dirCenFobEast";
posBaseWest = []; publicVariable "posBaseWest";
dirCenBaseWest = 0; publicVariable "dirCenBaseWest";
posBaseEast = []; publicVariable "posBaseEast";
dirCenBaseEast = 180; publicVariable "dirCenBaseEast";
minDis = 500; publicVariable "minDis";
flgDel = 0; publicVariable "flgDel";
aiDrive=0; publicVariable "aiDrive";
AIapcW=0; publicvariable "AIapcW";
AIapcE=0; publicvariable "AIapcE";
AIapcD=0; publicvariable "AIapcD";
coop=0; publicvariable "coop";
aiVehW=objNull; publicvariable "aiVehW";
aiVehE=objNull; publicvariable "aiVehE";
aiCasW=objNull; publicvariable "aiCasW";
aiCasE=objNull; publicvariable "aiCasE";
pltW=[]; publicvariable "pltW";
pltE=[]; publicvariable "pltE";

//RESPAWN LOADOUTS-----------------------------------------------EDITABLE//
for "_i" from 1 to 41 step 1 do 
{[west, [format ["WEST%1", _i],0,6]] call BIS_fnc_addRespawnInventory;};
for "_i" from 1 to 41 step 1 do 
{[east, [format ["EAST%1", _i],0,6]] call BIS_fnc_addRespawnInventory;};

//LOBBY PARAMETERS
//arsenal
call
{
	if ("Param2" call BIS_fnc_getParamValue == 0) 
	exitWith {deleteVehicle wAmmo; deleteVehicle eAmmo;};
	if ("Param2" call BIS_fnc_getParamValue == 1) 
	exitWith{["AmmoboxInit",wAmmo] spawn BIS_fnc_arsenal; ["AmmoboxInit",eAmmo] spawn BIS_fnc_arsenal;};
	if ("Param2" call BIS_fnc_getParamValue == 2) 
	exitWith{["AmmoboxInit",[wAmmo,true]] spawn BIS_fnc_arsenal; ["AmmoboxInit",[eAmmo,true]] spawn BIS_fnc_arsenal;};
};
//use it for defauld Arma 3 desert camo, NO Tanoa (altis, stratis a malden)
//marksmen DLC
if ("markOn" call BIS_fnc_getParamValue == 0) then 
{
	for "_i" from 42 to 47 step 1 do 
	{[west, [format ["WEST%1", _i],0,6]] call BIS_fnc_addRespawnInventory;};
	for "_i" from 42 to 47 step 1 do 
	{[east, [format ["EAST%1", _i],0,6]] call BIS_fnc_addRespawnInventory;};
};
//tanks DLC
if ("TankOn" call BIS_fnc_getParamValue == 0) then 
{
	for "_i" from 48 to 48 step 1 do 
	{[west, [format ["WEST%1", _i],0,6]] call BIS_fnc_addRespawnInventory;};
	for "_i" from 48 to 49 step 1 do 
	{[east, [format ["EAST%1", _i],0,6]] call BIS_fnc_addRespawnInventory;};
};

//ZEUS 
z1 addCuratorEditableObjects [allplayers+playableUnits]; //all players and playable units will be editable by Zeus
["Initialize"] call BIS_fnc_dynamicGroups; // Initializes the Dynamic Groups framework

//killed event handler
_unW=[]; _unE=[]; 
{
	call
	{
		if(side _x==west)exitWith{_unW pushBackUnique _x;};
		if(side _x==east)exitWith{_unE pushBackUnique _x;};
	};
} forEach playableunits;

{ _x addMPEventHandler
	["MPKilled",{[(_this select 0),west] spawn wrm_fnc_killedEH;}];
} forEach _unW;

{ _x addMPEventHandler
	["MPKilled",{[(_this select 0),east] spawn wrm_fnc_killedEH;}];
} forEach _unE;

//RESPAWN EVENT HANDLER, tels what will playable unit do after respawn 
{_x addMPEventHandler
	["MPRespawn", 
		{
			_unit = _this select 0; //defines variable taken from the eventHandler, _this = unit which respawns
			[_unit] spawn wrm_fnc_respawnEH; //call function 
		}
	];
} forEach playableunits;

execVM "warmachine\autoStart.sqf" //DEDI use it for dedicated server, if you want mission start automatically