/*
	Author: IvosH
	
	Description:
		Script for manual selection AREA OF OPERATION
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\createAO.sqf";
*/
call
{
	if (missType == 0) exitWith {minDis = 500;}; //500 = zakladní délka
	if (missType == 1) exitWith {minDis = 600;};
	if (missType == 2) exitWith {minDis = 700;}; 
};

aCreated = 0;
bCreated = 0;
cCreated = 0;
fobWCreated = 0;
fobECreated = 0;
baseWCreated = 0;
baseECreated = 0;

//Alpha
hint parseText format ["SECTOR ALPHA<br/>(Device, UAV)<br/><br/>Select a position on land by left mouse button click (LMB)"];
["createA", "onMapSingleClick", 
	{
		if (AOcreated == 1) then
		{
			_mrks = ["mAo", "mAlpha", "mBravo", "mCenter", "mCenBlack1", "mAlphaBlack", "mBravoBlack", "mCharlie", "mFobWest", "mFobEastBlack", "mFobEast", "mCenBlack2", "mBaseWestBlack", "mBaseWest", "mBaseEastBlack", "mBaseEast"];
			{deleteMarkerLocal _x;} forEach _mrks;
			AOcreated = 0;
		};
		
		posAlpha = _pos;
		_mrkAlpha = createMarkerLocal ["mAlpha", _pos];
		_mrkAlpha setMarkerShapeLocal "ICON";
		_mrkAlpha setMarkerTypeLocal "select";
		_mrkAlpha setMarkerTextLocal "Alpha";
		_mrkAlpha setMarkerColorLocal "ColorBlack";

		aCreated = 1;
	}
] call BIS_fnc_addStackedEventHandler;
waitUntil {aCreated == 1;};
["createA", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//Bravo
if (secNo>0) then 
{
	hint parseText format ["SECTOR BRAVO<br/>(Vehicle wreck)<br/><br/>Select a position inside the outer ring, on land"];

	_mrkCenBlack1 = createMarkerLocal ["mCenBlack1", posAlpha];
	_mrkCenBlack1 setMarkerShapeLocal "ELLIPSE";
	_mrkCenBlack1 setMarkerSizeLocal [minDis,minDis]; //500,500
	_mrkCenBlack1 setMarkerColorLocal "ColorBlack";
	_mrkCenBlack1 setMarkerAlphaLocal 0.3;

	_mrkCenBlack2 = createMarkerLocal ["mCenBlack2", posAlpha];
	_mrkCenBlack2 setMarkerShapeLocal "ELLIPSE";
	_mrkCenBlack2 setMarkerSizeLocal [(minDis*2), (minDis*2)]; //1000,1000
	_mrkCenBlack2 setMarkerColorLocal "ColorBlack";
	_mrkCenBlack2 setMarkerAlphaLocal 0.3;
	
	mapAnimAdd [0.9, ((1/(worldsize/(minDis*2)))*1.8), posAlpha]; //0.1
	mapAnimCommit;
	sleep 1;
	
	["createB", "onMapSingleClick", 
		{
			posBravo = _pos;
			_mrkBravo = createMarkerLocal ["mBravo", _pos];
			_mrkBravo setMarkerShapeLocal "ICON";
			_mrkBravo setMarkerTypeLocal "select";
			_mrkBravo setMarkerTextLocal "Bravo";
			_mrkBravo setMarkerColorLocal "ColorBlack";

			dirAB = posAlpha getDir posBravo;
			dirBA = posBravo getDir posAlpha;
			
			bCreated = 1;
			bExist = 1;
		}
	] call BIS_fnc_addStackedEventHandler;
	
} else 
{
	bCreated = 1;
	bExist = 0;
};
openMap [true, true];
mapAnimAdd [0, ((1/(worldsize/(minDis*2)))*1.8), posAlpha]; //0.1
mapAnimCommit;
waitUntil {bCreated == 1;};
_distAB = 0;
if (secNo>0) then 
{
	["createB", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
	_distAB = posAlpha distance posBravo;
	_objAlpha = "Land_HelipadEmpty_F" createVehicle posAlpha;
	_objAlpha setDir dirAB;
	posCenter = _objAlpha getRelPos [(_distAB/2), 0];
	deleteVehicle _objAlpha;
} else
{
	posCenter = posAlpha;
};

//Charlie
if (secNo>1) then
{
	hint parseText format ["SECTOR CHARLIE<br/>(Supply crate, cargo house, antenna)<br/><br/>Select a position inside the circle, on land"];
			
	"mCenBlack1" setMarkerPosLocal posCenter;
	"mCenBlack1" setMarkerSizeLocal [((_distAB/2)+50),((_distAB/2)+50)];
	"mCenBlack2" setMarkerAlphaLocal 0;
	
	mapAnimAdd [1, ((1/(worldsize/(_distAB/2)))*1.8), posCenter]; //0.1
	mapAnimCommit;
	
	["createC", "onMapSingleClick", 
		{
			posCharlie = _pos;
			
			_mrkCharlie = createMarkerLocal ["mCharlie", _pos];
			_mrkCharlie setMarkerShapeLocal "ICON";
			_mrkCharlie setMarkerTypeLocal "select";
			_mrkCharlie setMarkerTextLocal "Charlie";
			_mrkCharlie setMarkerColorLocal "ColorBlack";

			cCreated = 1;
			cExist = 1;
		}
	] call BIS_fnc_addStackedEventHandler;
	
} else
{
	cCreated = 1;
	cExist = 0;
};
waitUntil {cCreated == 1;};
if (secNo>1) then {["createC", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;};

//FOB West
hint parseText format ["%1<br/><br/>Select a position inside the outer ring,<br/>on a flat land", fobW];

if (secNo==0) then 
{
	_mrkCenBlack1 = createMarkerLocal ["mCenBlack1", posCenter];
	_mrkCenBlack1 setMarkerShapeLocal "ELLIPSE";
	_mrkCenBlack2 = createMarkerLocal ["mCenBlack2", posAlpha];
	_mrkCenBlack2 setMarkerShapeLocal "ELLIPSE";
};
"mCenBlack1" setMarkerPosLocal posCenter;
"mCenBlack1" setMarkerSizeLocal [((_distAB/2) + minDis),((_distAB/2) + minDis)]; //500,500
"mCenBlack2" setMarkerPosLocal posCenter;
"mCenBlack2" setMarkerSizeLocal [((_distAB/2) + (minDis*2.4)),((_distAB/2) + (minDis*2.4))]; //1200,1200
"mCenBlack2" setMarkerColorLocal colorW;
"mCenBlack2" setMarkerAlphaLocal 0.3;

mapAnimAdd [1, ((1/(worldsize/((_distAB/2) + (minDis*2.4))))*1.8), posCenter]; //0.25
mapAnimCommit;

["createFobW", "onMapSingleClick", 
	{
		posFobWest = _pos;
		
		_mrkFobWest = createMarkerLocal ["mFobWest", _pos];
		_mrkFobWest setMarkerShapeLocal "ICON";
		_mrkFobWest setMarkerTypeLocal "select";
		_mrkFobWest setMarkerTextLocal fobW;
		_mrkFobWest setMarkerColorLocal colorW;

		fobWCreated = 1;
	}
] call BIS_fnc_addStackedEventHandler;
waitUntil {fobWCreated == 1;};
["createFobW", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//BASE West
hint parseText format ["%1<br/><br/>Select a position inside the outer ring,<br/>on a flat land, near the road", baseW];

_distCenFobW = posCenter distance posFobWest;
"mCenBlack1" setMarkerSizeLocal [((_distCenFobW) + minDis),((_distCenFobW) + minDis)]; //500,500
"mCenBlack2" setMarkerSizeLocal [((_distCenFobW) + (minDis*2)),((_distCenFobW) + (minDis*2))]; //1000,1000

mapAnimAdd [1, ((1/(worldsize/((_distCenFobW) + (minDis*2))))*1.8), posCenter]; //0.25
mapAnimCommit;

["createBaseW", "onMapSingleClick", 
	{
		posBaseWest = _pos;
		
		_mrkBaseWest = createMarkerLocal ["mBaseWest", _pos];
		_mrkBaseWest setMarkerShapeLocal "ICON";
		_mrkBaseWest setMarkerTypeLocal "select";
		_mrkBaseWest setMarkerTextLocal baseW; //independent
		_mrkBaseWest setMarkerColorLocal colorW;

		dirCenBaseWest = posCenter getDir posBaseWest;		
		baseWCreated = 1;
	}
] call BIS_fnc_addStackedEventHandler;
waitUntil {baseWCreated == 1;};
["createBaseW", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//FOB East
hint parseText format ["%1<br/><br/>Select a position inside the outer ring,<br/>on a flat land.<br/>Ideally on the opposite side to the %2", fobE, fobW];

"mCenBlack1" setMarkerSizeLocal [((_distAB/2) + minDis),((_distAB/2) + minDis)]; //500,500
"mCenBlack2" setMarkerSizeLocal [((_distAB/2) + (minDis*2.4)),((_distAB/2) + (minDis*2.4))]; //1200,1200
"mCenBlack2" setMarkerColorLocal colorE;

mapAnimAdd [1, ((1/(worldsize/((_distAB/2) + (minDis*2.4))))*1.8), posCenter]; //0.25
mapAnimCommit;

["createFobE", "onMapSingleClick", 
	{
		posFobEast = _pos;
		
		_mrkFobEast = createMarkerLocal ["mFobEast", _pos];
		_mrkFobEast setMarkerShapeLocal "ICON";
		_mrkFobEast setMarkerTypeLocal "select";
		_mrkFobEast setMarkerTextLocal fobE; //independent
		_mrkFobEast setMarkerColorLocal colorE;

		fobECreated = 1;
	}
] call BIS_fnc_addStackedEventHandler;
waitUntil {fobECreated == 1;};
["createFobE", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//BASE East
hint parseText format ["%1<br/><br/>Select a position inside the outer ring,<br/>on a flat land, near the road.<br/>Ideally on the opposite side to the %2", (composeText[baseE]), (composeText[baseW])];

_distCenFobE = posCenter distance posFobEast;
"mCenBlack1" setMarkerSizeLocal [((_distCenFobE) + minDis),((_distCenFobE) + minDis)]; //500,500
"mCenBlack2" setMarkerSizeLocal [((_distCenFobE) + (minDis*2)),((_distCenFobE) + (minDis*2))]; //1000,1000

mapAnimAdd [1, ((1/(worldsize/((_distCenFobE) + (minDis*2))))*1.8), posCenter]; //0.25
mapAnimCommit;

["createBaseE", "onMapSingleClick", 
	{
		posBaseEast = _pos;
		
		_mrkBaseEast = createMarkerLocal ["mBaseEast", _pos];
		_mrkBaseEast setMarkerShapeLocal "ICON";
		_mrkBaseEast setMarkerTypeLocal "select";
		_mrkBaseEast setMarkerTextLocal baseE; //independent
		_mrkBaseEast setMarkerColorLocal colorE;

		dirCenBaseEast = posCenter getDir posBaseEast;
		baseECreated = 1;	
	}
] call BIS_fnc_addStackedEventHandler;
waitUntil {baseECreated == 1;};
["createBaseE", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;

//End
"mCenBlack1" setMarkerAlphaLocal 0;
"mCenBlack2" setMarkerAlphaLocal 0;
dirCenFobWest = posCenter getDir posFobWest;
dirCenFobEast = posCenter getDir posFobEast;

_zDis = 0;
_zDisW = posCenter distance posBaseWest;
_zDisE = posCenter distance posBaseEast;
if (_zDisW > _zDisE) then {_zDis = _zDisW;} else {_zDis = _zDisE;};
_zoom = (1/(worldsize/_zDis))*1.8;
mapAnimAdd [1, _zoom, posCenter]; //0,25
mapAnimCommit;
sleep 1;
openMap [true, false];
mapAnimAdd [0, _zoom, posCenter]; //0,25
mapAnimCommit;

AOcreated = 1;
hint parseText format ["AO was created<br/><br/>press M or ESC<br/>To return to the Mission Generator menu"];