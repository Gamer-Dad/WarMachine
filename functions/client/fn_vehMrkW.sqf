/*
	Author: IvosH
	
	Description:
		Create local marker for the vehicle at the respawn position
	
	Parameter(s):
		0: ARRAY, _mPos (position of the vehicle)
		1: STRING, second part of the name of the marker type
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		
	Execution:
		[_hVehW,"air"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
		[_veh] call wrm_fnc_vehMrkW;
*/
if (!hasInterface) exitWith {}; //run on the players only
if (side player != sideW) exitWith {}; //run on the players of sideW

_mNm = _this select 0;
_mIx = _this select 1;
_mPos = _this select 2;
_mTp = _this select 3;
_mSd = "";

call
{
	if (side player == west) exitWith {_mSd = "b_";};
	if (side player == east) exitWith {_mSd = "o_";};
	if (side player == independent) exitWith {_mSd = "n_";};
};

_mName = [_mNm,_mIx] joinString "";
_mType = [_mSd,_mTp] joinString "";

_mrkVeh = createMarkerLocal [_mName, _mPos];
_mrkVeh setMarkerShapeLocal "ICON";
_mrkVeh setMarkerTypeLocal _mType;
