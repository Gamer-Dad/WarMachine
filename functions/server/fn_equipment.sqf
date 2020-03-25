/*
	Author: IvosH
	
	Description:
		- add night vision goggles on the helmet, player, AI (A3, RHS)
		- add gps to the player (A3, RHS)
		- add ammo for the rocket launcher, player (RHS)	
		
	Parameter(s):
		0: VARIABLE respawned unit or allUnits
		
	Returns:
		nothing
		
	Dependencies:
		onPlayerRespawn.sqf (line 63)
		start.sqf (line 186)
		cfgFunctions.hpp
		fn_respawnEH (line 22)

	Execution:
		[_unit] spawn wrm_fnc_equipment;
*/
if(isClass(configFile >> "CfgPatches" >> "LIB_core"))exitWith{}; //stop if mission is WW2 (IFA3)
_unit = _this select 0;

if(isClass(configFile >> "CfgPatches" >> "rhs_main"))then //RHS mod
{
	//NVgoggles	
	if(sunOrMoon<1)then //0 night, 1 day
	{
		_nvgs = ["rhsusf_ANPVS_15","rhsusf_ANPVS_14","rhs_1PN138"];
		_nv=0;
		//has NVG on helmet?
		{
			_it=_x;
			{
				if(_it==_x)then{_nv=1;};
			} forEach _nvgs;
		} forEach (assignedItems _unit);
		if(_nv==1)exitWith{};
		//has NVG in the inventory? put it on the helmet
		{
			_it=_x;
			{	
				if(_it==_x)then{_unit assignItem _it;_nv=1;};
			} forEach _nvgs;
		} forEach (items _unit);
		//add NVG
		if(_nv==0)then
		{
			_n = selectRandom _nvgs;
			_unit addItem _n;
			_unit assignItem _n;
		};
	};
	//add ammo for the rocket launcher
	sleep 0.2;
	call
	{
		if((secondaryWeapon _unit=="rhs_weap_fgm148")&&(count secondaryWeaponMagazine _unit==0))
		exitWith{_unit addSecondaryWeaponItem "rhs_fgm148_magazine_AT";};
		if((secondaryWeapon _unit=="rhs_weap_fim92")&&(count secondaryWeaponMagazine _unit==0))
		exitWith{_unit addSecondaryWeaponItem "rhs_fim92_mag";};
		if((secondaryWeapon _unit=="rhs_weap_igla")&&(count secondaryWeaponMagazine _unit==0))
		exitWith{_unit addSecondaryWeaponItem "rhs_mag_9k38_rocket";};
	};
} else //default A3
{
	_nvg = ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP","NVGoggles_tna_F"];
	_nvgs = _nvg + ["O_NVGoggles_hex_F","O_NVGoggles_urb_F","O_NVGoggles_ghex_F","O_NVGoggles_grn_F","NVGogglesB_blk_F","NVGogglesB_grn_F","NVGogglesB_gry_F"];
	_hlm = ["H_HelmetO_ViperSP_ghex_F","H_HelmetO_ViperSP_hex_F"];
	//NVgoggles
	if(sunOrMoon<1)then //0
	{
		_nv=0;
		{if(headgear _unit==_x)then{_nv=1;};} forEach _hlm;
		if(_nv==1)exitWith{};
		{
			_it=_x;
			{
				if(_it==_x)then{_nv=1;};
			} forEach _nvgs;
		} forEach (assignedItems _unit);
		if(_nv==1)exitWith{};
		{
			_it=_x;
			{	
				if(_it==_x)then{_unit assignItem _it;_nv=1;};
			} forEach _nvgs;
		} forEach (items _unit);
		if(_nv==0)then
		{
			_n = selectRandom _nvg;
			_unit addItem _n;
			_unit assignItem _n;
		};
	};
};
//GPS
if(isPlayer _unit)then
{
	_gps = ["ItemGPS","B_UavTerminal","O_UavTerminal","I_UavTerminal","C_UavTerminal","I_E_UavTerminal"];
	_gp=0;
	{
		_it=_x;
		{
			if(_it==_x)then{_gp=1;};
		} forEach _gps;
	} forEach (assignedItems _unit);
	
	if(_gp==0)then
	{
		_unit addItem "ItemGPS";
		_unit assignItem "ItemGPS";
	};
};