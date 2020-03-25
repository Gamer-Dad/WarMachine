/*
	Author: IvosH
	
	Description:
		Load weapons to virtual arsenal, applies role restrictions
	
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		onPlayerRespawn.sqf
		
	Execution:
		[] call wrm_fnc_arsenal;
*/
if (!hasInterface) exitWith {}; //run on the players only
//weapons
_box=AmmoW;
if(side player==sideE)then{_box=AmmoE;};

[_box,([_box] call BIS_fnc_getVirtualWeaponCargo)] call BIS_fnc_removeVirtualWeaponCargo; //clear previous weapons in the arsenal
_weap = []; //weapon array + pistols
_cfgWp= "(getText (_x >> 'cursor') == 'hgun')" configClasses (configFile>>"cfgWeapons");
{
	_wp = configName (_x);
	_weap pushBack _wp;
} forEach _cfgWp;
_sm = []; //submachineguns
_cfgSm= "(getText (_x >> 'cursor') == 'smg')" configClasses (configFile>>"cfgWeapons");
{
	_wp = configName (_x);
	_sm pushBack _wp;
} forEach _cfgSm;
_ar = []; //assault rifles
_cfgAr= "(getText (_x >> 'cursor') == 'arifle')" configClasses (configFile>>"cfgWeapons"); //get array of all weapons
{
	_wp = configName (_x);
	_ar pushBack _wp;
} forEach _cfgAr;
_mg = []; //machineguns
_cfgMg= "(getText (_x >> 'cursor') == 'mg')" configClasses (configFile>>"cfgWeapons");
{
	_wp = configName (_x);
	
	_mg pushBack _wp;
} forEach _cfgMg;
_sn = []; //sniper rifles
_cfgSn= "(getText (_x >> 'cursor') == 'srifle')" configClasses (configFile>>"cfgWeapons");
{
	_wp = configName (_x);
	_sn pushBack _wp;
} forEach _cfgSn;
_at = []; //missile launchers
_cfgAt= "(getText (_x >> 'cursor') == 'missile')||(getText (_x >> 'cursor') == 'rocket')" configClasses (configFile>>"cfgWeapons");
{
	_wp = configName (_x);
	_at pushBack _wp;
} forEach _cfgAt;
//uniforms
_unif=[]; _unf='';
call	
{
	if (side player==west) exitWith {_unf='U_B_';};
	if (side player==east) exitWith {_unf='U_O_';};
	if (side player==independent) exitWith {_unf='U_I_';};
	//if (side player==independent) exitWith {if (factionE=="AAF") then {_unf='U_I_';} else {_unf='XXX';};};
};
_cfgUn= "((str _x find _unf >= 0)&&(getText (_x >> 'displayName') find 'Ghillie' >= 0))" configClasses (configFile>>"cfgWeapons");
{
	_wp = configName (_x);
	_unif pushBack _wp;
} forEach _cfgUn;
//check player's role
_rl = 0;
call
{
	if (primaryWeapon player in _mg) exitWith {_rl = 1;};
	if (primaryWeapon player in _sn) exitWith {_rl = 2;};
	if (secondaryWeapon player in _at) exitWith {_rl = 3;};
};
call 
{
	if (_rl == 0) exitWith {_weap=_weap+_ar+_sm;[_box,_unif] call BIS_fnc_removeVirtualItemCargo;};
	if (_rl == 1) exitWith {_weap=_weap+_mg;[_box,_unif] call BIS_fnc_removeVirtualItemCargo;};
	if (_rl == 2) exitWith {_weap=_weap+_sn;[_box,_unif,false,false] call BIS_fnc_addVirtualItemCargo;};
	if (_rl == 3) exitWith {_weap=_weap+_ar+_sm+_at;[_box,_unif] call BIS_fnc_removeVirtualItemCargo;};
};
[_box,_weap,false,false] call BIS_fnc_addVirtualWeaponCargo; //add weapons to arsenal