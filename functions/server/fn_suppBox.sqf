/*
	Author: IvosH

	Description:
		Change supply box doped by supply drop module. Copy "Execution code" into "Crate init" field in support module (editor)

	Parameter(s):
		0: _this
		1: STRING, faction
		
	Returns:
		BOOL
		
	Dependencies:
		supply drop module (crate init)
		
	Execution:
		[_this,"USAF"] call wrm_fnc_suppBox; //RHS USAF
		[_this,"AFRF"] call wrm_fnc_suppBox; //RHS AFRF
*/
_sup=_this select 0;
_fac=_this select 1;
_typ="";
call
{
	if(_fac=="LDF")exitWith{_typ="I_E_CargoNet_01_ammo_F";};
	if(_fac=="USAF")exitWith{_typ="rhsusf_weapon_crate";};
	if(_fac=="AFRF")exitWith{_typ="rhs_weapon_crate";};
	if(_fac=="GER")exitWith{_typ="LIB_BasicWeaponsBox_GER";};
	if(_fac=="UK")exitWith{_typ="LIB_BasicWeaponsBox_UK";};
	if(_fac=="RUS")exitWith{_typ="LIB_BasicWeaponsBox_SU";};
	if(_fac=="USA")exitWith{_typ="LIB_BasicWeaponsBox_US";};
	
};
_posb = getPos _sup;
deleteVehicle  _sup;
_box = createVehicle [_typ, _posb, [], 0, "NONE"];
[objNull, _box] call BIS_fnc_curatorObjectEdited;