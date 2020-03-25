/*
	Author: IvosH
	
	Description:
		Preloads virtual arsenal, applies side restrictions
	
	Parameter(s):
		0: OBJECT ammobox
		1: SIDE	
		
	Returns:
		nothing
		
	Dependencies:
		init.sqf
		
	Execution:
		[] call wrm_fnc_arsInit;
*/
if (!hasInterface) exitWith {}; //run on the players only
_box=_this select 0;
_sde=_this select 1;

[_box,([_box] call BIS_fnc_getVirtualItemCargo)] call BIS_fnc_removeVirtualItemCargo; //remove items - side switch
[_box,([_box] call BIS_fnc_getVirtualBackpackCargo)] call BIS_fnc_removeVirtualBackpackCargo;
[_box,true,false,false] call BIS_fnc_addVirtualMagazineCargo; //add all Magazines to the arsenal
//check player's side
_uav=""; _unif=[]; _hlm=[]; _s1='';_s2='';_s3='';_s4='';
call
{
	if (_sde==west) exitWith 
	{
		_uav="B_UavTerminal";
		_cfgUn= "((str _x find 'U_B_' >= 0)&&(getText (_x >> 'displayName') find 'Ghillie' == -1))" configClasses (configFile>>"cfgWeapons");
		{
			_wp = configName (_x);
			_unif pushBack _wp;
		} forEach _cfgUn;
		_hlm=['HelmetB','Crew_B','Heli_B','Fighter_B','SpecB'];
		_s1='[CSAT]';_s2='[AAF]';_s3='[IDAP]';_s4='[LDF]';
	};
	if (_sde==east) exitWith 
	{
		_uav="O_UavTerminal";
		_cfgUn= "((str _x find 'U_O_' >= 0)&&(getText (_x >> 'displayName') find 'Ghillie' == -1))" configClasses (configFile>>"cfgWeapons");
		{
			_wp = configName (_x);
			_unif pushBack _wp;
		} forEach _cfgUn;
		_hlm=['HelmetO','Crew_O','Heli_O','Fighter_O','SpecO','LeaderO'];
		_s1='[NATO]';_s2='[AAF]';_s3='[IDAP]';_s4='[LDF]';
	};
	if (_sde==independent) exitWith 
	{
		if (factionE=="AAF") then
		{
			_uav="I_UavTerminal";
			_cfgUn= "((str _x find 'U_I_' >= 0)&&(str _x find '_C_' == -1)&&(str _x find '_G_' == -1)&&(getText (_x >> 'displayName') find 'Ghillie' == -1))" configClasses (configFile>>"cfgWeapons");
			{
				_wp = configName (_x);
				_unif pushBack _wp;
			} forEach _cfgUn;
			_hlm=['HelmetI','Crew_I','Heli_I','Fighter_I'];
			_s1='[CSAT]';_s2='[NATO]';_s3='[IDAP]';_s4='[LDF]';	
		};
		if (factionE=="LDF") then
		{
			_uav="I_E_UavTerminal";
			_cfgUn= "(str _x find 'U_I_E_' >= 0)" configClasses (configFile>>"cfgWeapons");
			{
				_wp = configName (_x);
				_unif pushBack _wp;
			} forEach _cfgUn;
			_hlm=['HelmetHBK','Crew_I_E','Heli_I_E','Fighter_I_E'];
			_s1='[CSAT]';_s2='[NATO]';_s3='[IDAP]';_s4='[AAF]';
		};
		
	};
};
//items
_itms=["Binocular","Medikit","FirstAidKit","ToolKit","MineDetector","ItemCompass","ItemGPS","ItemMap","ItemRadio","ItemWatch","Rangefinder",_uav];
{
	_cr=_x;
	_cfgIt= "(getText (_x >> '_generalMacro') find _cr >= 0)" configClasses (configFile>>"cfgWeapons");
	{
		_it = configName (_x);
		_itms pushBack _it;
	} forEach _cfgIt;
} forEach ['optic_','acc_','muzzle_','bipod_','NVGoggles','Laserdesignator','V_'];
_ggl=[]; //googles
_cfgGl= "true" configClasses (configFile>>"cfgGlasses");
{
	_wp = configName (_x);
	_ggl pushBack _wp;
} forEach _cfgGl;
_helm=[]; //helmets
{
	_tp=_x;
	_cfgHl= "((str _x find 'H_' >= 0)&&(str _x find _tp >= 0))" configClasses (configFile>>"cfgWeapons");
	{
		_wp = configName (_x);
		_helm pushBack _wp;
	} forEach _cfgHl;
} forEach _hlm;
_itms=_itms+_ggl+_unif+_helm;
[_box,_itms,false,false] call BIS_fnc_addVirtualItemCargo; //add Items to the arsenal
//backpacks
_back=[];
_cfgBp= "((getText (_x >> 'vehicleClass') == 'Backpacks')&&(getText (_x >> 'displayName') find _s1 ==-1)&&(getText (_x >> 'displayName') find _s2 ==-1)&&(getText (_x >> 'displayName') find _s3 ==-1)&&(getText (_x >> 'displayName') find _s4 ==-1))" configClasses (configFile>>"cfgVehicles");
{
	_wp = configName (_x);
	_back pushBack _wp;
} forEach _cfgBp;
[_box,_back,false,false] call BIS_fnc_addVirtualBackpackCargo; //add Backpacks to the arsenal