/*
	Author: IvosH
	
	Description:
		Script for selection AREA OF OPERATION. Automatically generate markers for Sectors, Fobs and Bases.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\ao.sqf";
*/
_poss = _this select 0;
if (missType == 0) then {missType = selectRandom [1,2,3]};

call
{
	if (missType == 1) exitWith {minDis = 500;}; //500 zakladní délka
	if (missType == 2) exitWith {minDis = 600;};
	if (missType == 3) exitWith {minDis = 700;}; 
};

_mrks = ["mAo", "mAlpha", "mBravo", "mCenter", "mCenBlack1", "mAlphaBlack", "mBravoBlack", "mCharlie", "mFobWest", "mFobEastBlack", "mFobEast", "mCenBlack2", "mBaseWestBlack", "mBaseWest", "mBaseEastBlack", "mBaseEast"];
{deleteMarkerLocal _x;} forEach _mrks;
AOcreated = 0;

//1
//create marker
_mrkAo = createMarkerLocal ["mAo", _poss];
_mrkAo setMarkerShapeLocal "ICON";
_mrkAo setMarkerTypeLocal "empty";

//ALPHA
_posAlphaAo = getMarkerPos _mrkAo;

//2
posAlpha = [_posAlphaAo, 0, 200, 5, 0, 0.2, 0, [], [_posAlphaAo, _posAlphaAo]] call BIS_fnc_findSafePos;

//3
_mrkAlpha = createMarkerLocal ["mAlpha", posAlpha];
_mrkAlpha setMarkerShapeLocal "ICON";
_mrkAlpha setMarkerTypeLocal "select";
_mrkAlpha setMarkerTextLocal "Alpha";
_mrkAlpha setMarkerColorLocal "ColorBlack";

_objAlpha = "Land_HelipadEmpty_F" createVehicle posAlpha;

//4 BRAVO
_distAB = 0;
if (secNo>0) then 
{
	_posBravoRan = _objAlpha getRelPos [minDis, random 360]; //500
	_posBravoSafe = [posAlpha, minDis, (minDis*2), 5, 0, 0.2, 0, [], [_posBravoRan, _posBravoRan]] call BIS_fnc_findSafePos; //500,1000

	//5
	_locationsBravo = nearestLocations [posAlpha, ["NameCity","NameCityCapital","NameMarine","NameVillage","NameLocal","Hill","Airport"], (minDis*1.6)]; //800

	//6
	if (count _locationsBravo > 0) then
	{
		//6
		_posBravoLoc = locationPosition (_locationsBravo select ((count _locationsBravo) - 1));
		if (posAlpha distance _posBravoLoc >= minDis) then //500
		{
			//7
			posBravo = [_posBravoLoc, 0, (minDis*0.4), 5, 0, 0.2, 0, [], [_posBravoSafe, _posBravoSafe]] call BIS_fnc_findSafePos; //200
		} else
		{
			//7
			posBravo = _posBravoSafe;
		};
	} else
	{
		//7
		posBravo = _posBravoSafe;
	};

	//8
	_mrkBravo = createMarkerLocal ["mBravo", posBravo];
	_mrkBravo setMarkerShapeLocal "ICON";
	_mrkBravo setMarkerTypeLocal "select";
	_mrkBravo setMarkerTextLocal "Bravo";
	_mrkBravo setMarkerColorLocal "ColorBlack";
	bExist = 1;
	
	//9 
	_distAB = posAlpha distance posBravo;
	dirAB = posAlpha getDir posBravo;
	dirBA = posBravo getDir posAlpha;
	_objAlpha setDir dirAB;

	//10
	posCenter = _objAlpha getRelPos [(_distAB/2), 0];
} else
{
	posCenter = posAlpha;
	dirAB = 0;
	dirBA = 180;
	bExist = 0;
};

//11
_mrkCenBlack1 = createMarkerLocal ["mCenBlack1", posCenter]; //plocha, jen grafika
_mrkCenBlack1 setMarkerShapeLocal "ELLIPSE";
_mrkCenBlack1 setMarkerSizeLocal [((_distAB/2)+minDis),((_distAB/2)+minDis)]; //500
_mrkCenBlack1 setMarkerColorLocal "ColorBlack";
_mrkCenBlack1 setMarkerAlphaLocal 0; //0.3

_objCenter = "Land_HelipadEmpty_F" createVehicle posCenter;

//CHARLIE
if (secNo>1) then 
{
	_mrkAlphaBlack = createMarkerLocal ["mAlphaBlack", posAlpha]; //plocha
	_mrkAlphaBlack setMarkerShapeLocal "ELLIPSE";
	_mrkAlphaBlack setMarkerSizeLocal [(minDis*0.45), (minDis*0.45)]; //200,200
	_mrkAlphaBlack setMarkerAlphaLocal 0;
	
	_mrkBravoBlack = createMarkerLocal ["mBravoBlack", posBravo]; //plocha
	_mrkBravoBlack setMarkerShapeLocal "ELLIPSE";
	_mrkBravoBlack setMarkerSizeLocal [(minDis*0.45), (minDis*0.45)]; //200,200
	_mrkBravoBlack setMarkerAlphaLocal 0;
	
	_posCharlieRan = _objCenter getRelPos [random (_distAB/2), random 360];
	posCharlie = [posCenter, 0, ((_distAB/2)+50), 5, 0, 0.2, 0, [_mrkAlphaBlack, _mrkBravoBlack], [_posCharlieRan, _posCharlieRan]] call BIS_fnc_findSafePos;
	
	_mrkCharlie = createMarkerLocal ["mCharlie", posCharlie];
	_mrkCharlie setMarkerShapeLocal "ICON";
	_mrkCharlie setMarkerTypeLocal "select";
	_mrkCharlie setMarkerTextLocal "Charlie";
	_mrkCharlie setMarkerColorLocal "ColorBlack";

	cExist = 1;
} else {cExist = 0;};

//12 FOB WEST
_posFobWestRan = _objCenter getRelPos [((_distAB/2) + minDis), random 360]; //500
_posFobWestSafe = [posCenter, ((_distAB/2) + minDis), ((_distAB/2) + (minDis*2.4)), 7, 0, 0.2, 0, [], [_posFobWestRan, _posFobWestRan]] call BIS_fnc_findSafePos; //500,1200

//13
_locationsFobWest = nearestLocations [posCenter, ["NameCity","NameCityCapital","NameMarine","NameVillage","NameLocal","Airport"],((_distAB/2) + (minDis*2))]; //1000

//14
if (count _locationsFobWest > 0) then
{
	//15
	_posFobWestLoc = locationPosition (_locationsFobWest select ((count _locationsFobWest) - 1));
	if (posCenter distance _posFobWestLoc >= ((_distAB/2) + (minDis*1.4))) then //700
	{
		//16
		posFobWest = [_posFobWestLoc, 0, (minDis*0.4), 7, 0, 0.2, 0, [], [_posFobWestSafe, _posFobWestSafe]] call BIS_fnc_findSafePos; //200
	} else
	{
		//16
		posFobWest = _posFobWestSafe;
	};
} else
{
	posFobWest = _posFobWestSafe;
};

//17
_mrkFobWest = createMarkerLocal ["mFobWest", posFobWest];
_mrkFobWest setMarkerShapeLocal "ICON";
_mrkFobWest setMarkerTypeLocal "select";
_mrkFobWest setMarkerTextLocal fobW;
_mrkFobWest setMarkerColorLocal colorW;

//check if is on he road > move to the side
_objFobWest = "Land_HelipadEmpty_F" createVehicle posFobWest;
if(!isNull roadAt _objFobWest)then
{
	_objFobWest setDir (getdir (roadAt _objFobWest)); 
	_objFobWest setPos (_objFobWest getRelPos [40,45]);
	posFobWest = getPos _objFobWest;
	_mrkFobWest setMarkerPosLocal posFobWest;
};

//18 FOB EAST
_dirCenFobWest = posCenter getDir posFobWest;
_objCenter setDir _dirCenFobWest;
_posFobEastBlack = _objCenter getRelPos [((_distAB/2)+(minDis*2.4)), 0]; //1200

_mrkFobEastBlack = createMarkerLocal ["mFobEastBlack", _posFobEastBlack];
_mrkFobEastBlack setMarkerShapeLocal "RECTANGLE";
_mrkFobEastBlack setMarkerSizeLocal [((_distAB/2)+(minDis*2.4)), ((_distAB/2)+(minDis*2.4))]; //1200,1200
_mrkFobEastBlack setMarkerDirLocal _dirCenFobWest;
_mrkFobEastBlack setMarkerAlphaLocal 0;

//19
_distCenFobWest = posCenter distance posFobWest;
_posFobEastRan = _objCenter getRelPos [_distCenFobWest, 180];
posFobEast = [posCenter, ((_distAB/2) + minDis), ((_distAB/2) + (minDis*2.4)), 7, 0, 0.2, 0, [_mrkFobEastBlack], [_posFobEastRan, _posFobEastRan]] call BIS_fnc_findSafePos; //500,1200

//20
_mrkFobEast = createMarkerLocal ["mFobEast", posFobEast];
_mrkFobEast setMarkerShapeLocal "ICON";
_mrkFobEast setMarkerTypeLocal "select";
_mrkFobEast setMarkerTextLocal fobE;
_mrkFobEast setMarkerColorLocal colorE;

//check if is on he road > move to the side
_objFobEast = "Land_HelipadEmpty_F" createVehicle posFobEast;
if(!isNull roadAt _objFobEast)then
{
	_objFobEast setDir (getdir (roadAt _objFobEast)); 
	_objFobEast setPos (_objFobEast getRelPos [40,45]);
	posFobEast = getPos _objFobEast;
	_mrkFobEast setMarkerPosLocal posFobEast;
};

//21 BASE WEST
_mrkCenBlack2 = createMarkerLocal ["mCenBlack2", posCenter]; //script i grafika
_mrkCenBlack2 setMarkerShapeLocal "ELLIPSE";
_mrkCenBlack2 setMarkerSizeLocal [((_distAB/2) + (minDis*2.4)),((_distAB/2) + (minDis*2.4))]; //1200,1200
_mrkCenBlack2 setMarkerColorLocal "ColorBlack";
_mrkCenBlack2 setMarkerAlphaLocal 0; //0.3

_dirEW = posFobEast getDir posFobWest;
_objFobWest setDir _dirEW;
_posBaseWestBlack = _objFobWest getRelPos [(minDis*2), 180]; //1000

_mrkBaseWestBlack = createMarkerLocal ["mBaseWestBlack", _posBaseWestBlack];
_mrkBaseWestBlack setMarkerShapeLocal "RECTANGLE";
_mrkBaseWestBlack setMarkerSizeLocal [(minDis*2), (minDis*2)]; //1000,1000
_mrkBaseWestBlack setMarkerAlphaLocal 0;
_mrkBaseWestBlack setMarkerDirLocal _dirEW;

//22
_posBaseWestRan = _objFobWest getRelPos [minDis, 0]; //500
posBaseWest = [posFobWest, minDis, (minDis*2), 7, 0, 0.2, 0, [_mrkCenBlack2, _mrkBaseWestBlack], [_posBaseWestRan, _posBaseWestRan]] call BIS_fnc_findSafePos; //500,1000

//23
dirCenBaseWest = posCenter getDir posBaseWest;

_mrkBaseWest = createMarkerLocal ["mBaseWest", posBaseWest];
_mrkBaseWest setMarkerShapeLocal "ICON";
_mrkBaseWest setMarkerTypeLocal "select";
_mrkBaseWest setMarkerTextLocal baseW;
_mrkBaseWest setMarkerColorLocal colorW;

//24 BASE EAST
_dirWE = posFobWest getDir posFobEast;
_objFobEast setDir _dirWE;
_posBaseEastBlack = _objFobEast getRelPos [(minDis*2), 180]; //1000

_mrkBaseEastBlack = createMarkerLocal ["mBaseEastBlack", _posBaseEastBlack];
_mrkBaseEastBlack setMarkerShapeLocal "RECTANGLE";
_mrkBaseEastBlack setMarkerSizeLocal [(minDis*2),(minDis*2)]; //1000,1000
_mrkBaseEastBlack setMarkerAlphaLocal 0;
_mrkBaseEastBlack setMarkerDirLocal _dirWE;

//25
_posBaseEastRan = _objFobEast getRelPos [minDis, 0]; //500
posBaseEast = [posFobEast, minDis, (minDis*2), 7, 0, 0.2, 0, [_mrkCenBlack2, _mrkBaseEastBlack], [_posBaseEastRan, _posBaseEastRan]] call BIS_fnc_findSafePos; //500,1000

//26
dirCenBaseEast = posCenter getDir posBaseEast;

_mrkBaseEast = createMarkerLocal ["mBaseEast", posBaseEast];
_mrkBaseEast setMarkerShapeLocal "ICON";
_mrkBaseEast setMarkerTypeLocal "select";
_mrkBaseEast setMarkerTextLocal baseE;
_mrkBaseEast setMarkerColorLocal colorE;

dirCenFobWest = posCenter getDir posFobWest;
dirCenFobEast = posCenter getDir posFobEast;

_objs = [_objAlpha, _objCenter, _objFobWest, _objFobEast];
{deleteVehicle _x;} forEach _objs;
AOcreated = 1;

//zoom map
_zDis = 0;
_zDisW = posCenter distance posBaseWest;
_zDisE = posCenter distance posBaseEast;
if (_zDisW > _zDisE) then {_zDis = _zDisW;} else {_zDis = _zDisE;};
_zoom = (1/(worldsize/_zDis))*1.8;
mapAnimAdd [0.8, _zoom, posCenter]; //0,25
mapAnimCommit;

{if (!(_x isFlatEmpty [-1, -1, -1, -1, 2, false] isEqualTo [])) then {AOcreated = 0;};} forEach [posFobWest,posFobEast,posBaseWest,posBaseEast];
if (aoType > 0) then
{
	if (AOcreated == 1) then 
	{
		hint parseText format ["
		AO was selected SUCCESSFULLY<br/><br/>
		press M or ESC<br/>
		To return to the Mission Generator menu<br/><br/>
		CLICK AGAIN<br/>
		If you want to change a position <br/>
		or layout of the area"];
	} else
	{
		hint parseText format ["
		AO selection ERROR<br/>
		Some of the FOB or BASE is over water<br/><br/>
		CLICK AGAIN<br/>
		To change layout of the AO,<br/>
		or select another location<br/><br/>
		press M or ESC<br/>
		To return to the Mission Generator menu"];
	};
};