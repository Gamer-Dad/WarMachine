/*
	Author: IvosH
	
	Description:
		Create mission and run all needed schripts and functions
		
	Parameter(s):
		26 PARAMS set in the mission generator dialog
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		startButton.sqf
		
	Execution:
		[26 params] execVM "warmachine\start.sqf";
*/

if !(isServer) exitWith {};

[0] remoteExec ["closeDialog", 0, false];

posCenter = _this select 0;
posAlpha = _this select 1;
dirAB = _this select 2;
posBravo = _this select 3;
dirBA = _this select 4;
posCharlie = _this select 5;
posFobWest = _this select 6;
dirCenFobWest = _this select 7;
posFobEast = _this select 8;
dirCenFobEast = _this select 9;
posBaseWest = _this select 10;
dirCenBaseWest = _this select 11;
posBaseEast = _this select 12;
dirCenBaseEast = _this select 13;
cExist = _this select 14;
AOcreated = _this select 15;

missType = _this select 16;
day = _this select 17;
secNo = _this select 18;
weather = _this select 19;
support = _this select 20;
fogLevel = _this select 21;
resType = _this select 22;
resTime = _this select 23;
resTickets = _this select 24;
vehTime = _this select 25;
aoType = _this select 26;
minDis = _this select 27;
AIon = _this select 28;
revOn = _this select 29;
viewType = _this select 30;
ticBleed = _this select 31;
timeLim = _this select 32;

//CREATE AO----------------------------------------------------------------------------SERVER//
if (aoType == 0) then
{
	//select random location on the map
	AOcreated = 0;
	while {AOcreated == 0} do 
	{

		_middle = worldSize/2;
		_mapCen = [_middle,_middle,0];
		_locationsAlpha = nearestLocations [_mapCen, ["NameCity","NameCityCapital","NameMarine","NameVillage","NameLocal","Airport"], _middle];
		_locAlpha = locationPosition (_locationsAlpha select (floor (random (count _locationsAlpha))));
		[_locAlpha] execVM "warmachine\ao.sqf";
		sleep 1;
	};
};

waitUntil {AOcreated == 1;};

//SECTOR CHARLIE------------------------------------------------------------------------SERVER//
if (secNo == 2 && cExist == 0) then
{
	_mrkAlphaBlack = createMarkerLocal ["mAlphaBlack", posAlpha]; //plocha
	_mrkAlphaBlack setMarkerShapeLocal "ELLIPSE";
	_mrkAlphaBlack setMarkerSizeLocal [(minDis*0.45), (minDis*0.45)]; //200,200
	_mrkAlphaBlack setMarkerAlphaLocal 0; //0=invisible
	
	_mrkBravoBlack = createMarkerLocal ["mBravoBlack", posBravo]; //plocha
	_mrkBravoBlack setMarkerShapeLocal "ELLIPSE";
	_mrkBravoBlack setMarkerSizeLocal [(minDis*0.45), (minDis*0.45)]; //200,200
	_mrkBravoBlack setMarkerAlphaLocal 0; //0=invisible
	
	_objCenter = "Land_HelipadEmpty_F" createVehicle posCenter;
	_distAB = posAlpha distance posBravo;
	_posCharlieRan = _objCenter getRelPos [random (_distAB/2), random 360];
	posCharlie = [posCenter, 0, ((_distAB/2)+50), 5, 0, 0.2, 0, [_mrkAlphaBlack, _mrkBravoBlack], [_posCharlieRan, _posCharlieRan]] call BIS_fnc_findSafePos;
	deleteVehicle _objCenter;
	
	_mrkCharlie = createMarkerLocal ["mCharlie", posCharlie];
	_mrkCharlie setMarkerShapeLocal "ICON";
	_mrkCharlie setMarkerTypeLocal "select";
	_mrkCharlie setMarkerTextLocal "Charlie";
	_mrkCharlie setMarkerColorLocal "ColorBlack";
	
	cExist = 1; publicVariable "cExist";
};

//GLOBAL VARIABLES: broadcast dialog selections to all machines
publicVariable "posCenter";
publicVariable "posAlpha";
publicVariable "dirAB";
publicVariable "posBravo";
publicVariable "dirBA";
publicVariable "posCharlie";
publicVariable "posFobWest";
publicVariable "dirCenFobWest";
publicVariable "posFobEast";
publicVariable "dirCenFobEast";
publicVariable "posBaseWest";
publicVariable "dirCenBaseWest";
publicVariable "posBaseEast";
publicVariable "dirCenBaseEast";
publicVariable "cExist";
publicVariable "AOcreated";

publicVariable "missType";
publicVariable "day";
publicVariable "secNo";
publicVariable "weather";
publicVariable "support";
publicVariable "fogLevel";
publicVariable "resType";
publicVariable "resTime";
publicVariable "resTickets";
publicVariable "vehTime";
publicVariable "aoType";
publicVariable "minDis";
publicVariable "AIon";
publicVariable "revOn";
publicVariable "viewType";
publicVariable "ticBleed";
publicVariable "timeLim";

_unitsNo = 0;
_groups = [];
if (resTickets == 0) then 
{	
	if(AIon>0)then
	{
		{_groups pushBackUnique group _x} forEach playableUnits;
		{_unitsNo = _unitsNo + (count units _x)} forEach _groups;
		_unitsNo = _unitsNo + (count allPlayers);
	}else
	{
		{_groups pushBackUnique group _x} forEach allPlayers;
		{_unitsNo = _unitsNo + (count units _x)} forEach _groups;
		_unitsNo = _unitsNo + (count allPlayers);
	};
};

//TIME OF DAY-------------------------------------------------------------------------SERVER!//
call
{
	//random
	if (day == 0) exitWith {skiptime (((floor random 24) - daytime + 24) % 24);};
	//Dawn
	if (day == 1) exitWith {skiptime (((dawn select 1) - daytime + 24) % 24);};
	//Morning, 9:00
	if (day == 2) exitWith {skiptime ((9 - daytime + 24) % 24);};	
	//Noon, 12:00
	if (day == 3) exitWith {skiptime ((12 - daytime + 24) % 24);};
	//Afternoon, 16:00
	if (day == 4) exitWith {skiptime ((15 - daytime + 24) % 24);};	
	//Dusk
	if (day == 5) exitWith {skiptime (((dusk select 1) - daytime + 24) % 24);};
	//Night, 23:00
	if (day == 6) exitWith {skiptime ((23 - daytime + 24) % 24);};
};
systemChat "Time of day changed"; //debug

//RUN SCRIPTS AND FUNCTIONS-----------------------------------------------------------------------GLOBAL/SERVER//
"warmachine\markers.sqf" remoteExec ["execVM", 0, true]; //run on clients
remoteExec ["wrm_fnc_leaderUpdate", 0, true]; //run on clients (loop)
[] spawn wrm_fnc_resGrpsUpdate; //run on server (loop)
[missionNamespace, "respawnTicketsExhausted", {[] spawn wrm_fnc_progress;}] call BIS_fnc_addScriptedEventHandler;
[] spawn wrm_fnc_ticketBleed; //run on server (loop)
{[_x] spawn wrm_fnc_equipment;} forEach playableUnits;

//CREATE OBJECTS AT SECTORS AND BASES
objectAlpha = selectRandom strAlpha createVehicle posAlpha;
publicVariable "objectAlpha";

//Respawn positions Alpha west (east)
RpAw=[]; RpAe=[]; 
objectAlpha setDir (posAlpha getDir posFobWest);
{
	_p = (objectAlpha getRelPos [125,_x]) findEmptyPosition [0, 25, "B_soldier_F"];
	if(count _p != 0)then{RpAw pushBackUnique _p;};
} forEach [330,345,0,15,30];
publicVariable "RpAw";

objectAlpha setDir (posAlpha getDir posFobEast);
{
	_p = (objectAlpha getRelPos [125,_x]) findEmptyPosition [0, 25, "B_soldier_F"];
	if(count _p != 0)then{RpAe pushBackUnique _p;};
} forEach [330,345,0,15,30];
publicVariable "RpAe";

if (secNo>0) then
{
	objectAlpha setDir dirAB;
	objectBravo = selectRandom strBravo createVehicle posBravo;
	publicVariable "objectBravo";
	
	//Respawn positions Bravo west (east)
	RpBw=[]; RpBe=[]; //Respawn positions Alpha west (east)
	objectBravo setDir (posBravo getDir posFobWest);
	{
		_p = (objectBravo getRelPos [125,_x]) findEmptyPosition [0, 25, "B_soldier_F"];
		if(count _p != 0)then{RpBw pushBackUnique _p;};
	} forEach [330,345,0,15,30];
	publicVariable "RpBw";

	objectBravo setDir (posBravo getDir posFobEast);
	{
		_p = (objectBravo getRelPos [125,_x]) findEmptyPosition [0, 25, "B_soldier_F"];
		if(count _p != 0)then{RpBe pushBackUnique _p;};
	} forEach [330,345,0,15,30];
	publicVariable "RpBe";	
	
	objectBravo setDir dirBA;
};
if (secNo>1) then
{
	objectCharlie = selectRandom strCharlie createVehicle posCharlie;
	publicVariable "objectCharlie";
	
	//Respawn positions Charlie west (east)
	RpCw=[]; RpCe=[]; //Respawn positions Alpha west (east)
	objectCharlie setDir (posCharlie getDir posFobWest);
	{
		_p = (objectCharlie getRelPos [125,_x]) findEmptyPosition [0, 25, "B_soldier_F"];
		if(count _p != 0)then{RpCw pushBackUnique _p;};
	} forEach [330,345,0,15,30];
	publicVariable "RpCw";

	objectCharlie setDir (posCharlie getDir posFobEast);
	{
		_p = (objectCharlie getRelPos [125,_x]) findEmptyPosition [0, 25, "B_soldier_F"];
		if(count _p != 0)then{RpCe pushBackUnique _p;};
	} forEach [330,345,0,15,30];
	publicVariable "RpCe";	
	
	objectCharlie setDir (random 360);
};
selFobWest = selectRandom strFobWest;
objectFobWest = selFobWest createVehicle posFobWest;
objectFobWest setDir dirCenFobWest;
publicVariable "objectFobWest";
selFobEast = selectRandom strFobEast;
objectFobEast = selFobEast createVehicle posFobEast;
objectFobEast setDir dirCenFobEast;
publicVariable "objectFobEast";
objectBaseWest = selectRandom strBaseWest createVehicle posBaseWest;
objectBaseWest setDir dirCenBaseWest;
publicVariable "objectBaseWest";
objectBaseEast = selectRandom strBaseEast createVehicle posBaseEast;
objectBaseEast setDir dirCenBaseEast;
publicVariable "objectBaseEast";

//CLEAR BASE SORROUNDINGS---------------------------------------------------------------SERVER//
_terObjW = nearestTerrainObjects [objectBaseWest, [], 30, false] - [objectBaseWest];
{
	_x hideObjectGlobal true;
} 
forEach _terObjW;

_terObjE = nearestTerrainObjects [objectBaseEast, [], 30, false] - [objectBaseEast];
{
	_x hideObjectGlobal true;
} 
forEach _terObjE;

//RESPAWN---------------------------------------------------------------SERVER//
[resStartW] remoteExec ["deleteMarker", 0, true];
[resStartE] remoteExec ["deleteMarker", 0, true];

//deleteMarker resStartE;

//Base respawn
_posRbaseW = (objectBaseWest getRelPos [25,0]) findEmptyPosition [0, 50, "B_soldier_F"]; 
if(count _posRbaseW==0)then{_posRbaseW=objectBaseWest getRelPos [25,0]};
_mrkRbaseW = createMarker [resBaseW, _posRbaseW];
_mrkRbaseW setMarkerShape "ELLIPSE";
_mrkRbaseW setMarkerSize  [10, 10];
_mrkRbaseW setMarkerAlpha  0;
_mrkRbaseW setMarkerText "BASE";

_posRbaseE = (objectBaseEast getRelPos [25,0]) findEmptyPosition [0, 50, "B_soldier_F"]; 
if(count _posRbaseE==0)then{_posRbaseE=objectBaseEast getRelPos [25,0]};
_mrkRbaseE = createMarker [resBaseE, _posRbaseE]; 
_mrkRbaseE setMarkerShape "ELLIPSE";
_mrkRbaseE setMarkerSize  [10, 10];
_mrkRbaseE setMarkerAlpha  0;
_mrkRbaseE setMarkerText "BASE";

//FOB respawn
_posRfW = (objectFobWest getRelPos [25,0]) findEmptyPosition [0, 50, "B_soldier_F"]; 
if(count _posRfW==0)then{_posRfW=objectFobWest getRelPos [25,0]};
_mrkRfW = createMarker [resFobW, _posRfW];
_mrkRfW setMarkerShape "ELLIPSE";
_mrkRfW setMarkerSize  [10, 10];
_mrkRfW setMarkerAlpha  0;
_mrkRfW setMarkerText "FOB";

_posRfE = (objectFobEast getRelPos [25,0]) findEmptyPosition [0, 50, "B_soldier_F"]; 
if(count _posRfE==0)then{_posRfE=objectFobEast getRelPos [25,0]};
_mrkRfE = createMarker [resFobE, _posRfE];
_mrkRfE setMarkerShape "ELLIPSE";
_mrkRfE setMarkerSize  [10, 10];
_mrkRfE setMarkerAlpha  0;
_mrkRfE setMarkerText "FOB";

//respawn positions for respawnEH.sqf
RpFoW=[_posRfW];
RpFoE=[_posRfE];
RpBsW=[_posRbaseW];
RpBsE=[_posRbaseE];
publicVariable "RpFoW";
publicVariable "RpFoE";
publicVariable "RpBsW";
publicVariable "RpBsE";

//replace ammoboxes
if ("param2" call BIS_fnc_getParamValue > 0) then
{
	_posAmmoW = (objectBaseWest getRelPos [20,0]) findEmptyPosition [0, 50, "B_supplyCrate_F"]; 
	if(count _posAmmoW==0)then{_posAmmoW=objectBaseWest getRelPos [20,0]};
	AmmoW setPos _posAmmoW;
	_posAmmoE = (objectBaseEast getRelPos [20,0]) findEmptyPosition [0, 50, "B_supplyCrate_F"]; 
	if(count _posAmmoE==0)then{_posAmmoE=objectBaseEast getRelPos [20,0]};
	AmmoE setPos _posAmmoE;
};

//CREATE STRUCTURES AT FOBs------------------------------------------------------------SERVER//
//FOB west
//corners
_posFW1 = objectFobWest getRelPos [15, 45];
_objFW1 = strFobC createVehicle _posFW1;
_objFW1 setDir dirCenFobWest;

_posFW2 = objectFobWest getRelPos [15, 135];
_objFW2 = strFobC createVehicle _posFW2;
_objFW2 setDir (dirCenFobWest+90);

_posFW3 = objectFobWest getRelPos [15, 225];
_objFW3 = strFobC createVehicle _posFW3;
_objFW3 setDir (dirCenFobWest+180);

_posFW4 = objectFobWest getRelPos [15, 315];
_objFW4 = strFobC createVehicle _posFW4;
_objFW4 setDir (dirCenFobWest+270);
//barriers
_posSW1 = objectFobWest getRelPos [12, 0];
_objSW1 = selectRandom strFob createVehicle _posSW1;
_objSW1 setDir dirCenFobWest;
_objSW1 setVectorUp surfaceNormal position _objSW1;

_posSW2 = objectFobWest getRelPos [12, 90];
_objSW2 = selectRandom strFob createVehicle _posSW2;
_objSW2 setDir (dirCenFobWest+90);
_objSW2 setVectorUp surfaceNormal position _objSW2;

_posSW3 = objectFobWest getRelPos [12, 180];
_objSW3 = selectRandom strFob createVehicle _posSW3;
_objSW3 setDir (dirCenFobWest+180);
_objSW3 setVectorUp surfaceNormal position _objSW3;

_posSW4 = objectFobWest getRelPos [12, 270];
_objSW4 = selectRandom strFob createVehicle _posSW4;
_objSW4 setDir (dirCenFobWest+270);
_objSW4 setVectorUp surfaceNormal position _objSW4;

//buildings
_selAW1 = selectRandom (strFobWest - [selFobWest]);
_posAW1Ran = objectFobWest getRelPos [30, random 360];
_posAW1 = [posFobWest, 15, 60, 5, 0, 0.2, 0, [], [_posAW1Ran,_posAW1Ran]] call BIS_fnc_findSafePos;
_objAW1 = _selAW1 createVehicle _posAW1;
if(!isNull roadAt _objAW1)then
{
	_objAW1 setDir (getdir (roadAt _objAW1)); 
	_objAW1 setPos (_objAW1 getRelPos [40,45]);
};
_objAW1 setDir dirCenFobWest;

//FOB east
//corners
_posFE1 = objectFobEast getRelPos [15, 45];
_objFE1 = strFobC createVehicle _posFE1;
_objFE1 setDir dirCenFobEast;

_posFE2 = objectFobEast getRelPos [15, 135];
_objFE2 = strFobC createVehicle _posFE2;
_objFE2 setDir (dirCenFobEast+90);

_posFE3 = objectFobEast getRelPos [15, 225];
_objFE3 = strFobC createVehicle _posFE3;
_objFE3 setDir (dirCenFobEast+180);

_posFE4 = objectFobEast getRelPos [15, 315];
_objFE4 = strFobC createVehicle _posFE4;
_objFE4 setDir (dirCenFobEast+270);
//barriers
_posSE1 = objectFobEast getRelPos [12, 0];
_objSE1 = selectRandom strFob createVehicle _posSE1;
_objSE1 setDir dirCenFobEast;
_objSE1 setVectorUp surfaceNormal position _objSE1;

_posSE2 = objectFobEast getRelPos [12, 90];
_objSE2 = selectRandom strFob createVehicle _posSE2;
_objSE2 setDir (dirCenFobEast+90);
_objSE2 setVectorUp surfaceNormal position _objSE2;

_posSE3 = objectFobEast getRelPos [12, 180];
_objSE3 = selectRandom strFob createVehicle _posSE3;
_objSE3 setDir (dirCenFobEast+180);
_objSE3 setVectorUp surfaceNormal position _objSE3;

_posSE4 = objectFobEast getRelPos [12, 270];
_objSE4 = selectRandom strFob createVehicle _posSE4;
_objSE4 setDir (dirCenFobEast+270);
_objSE4 setVectorUp surfaceNormal position _objSE4;

//buildings
_selAE1 = selectRandom (strFobEast - [selFobEast]);
_posAE1Ran = objectFobEast getRelPos [30, random 360];
_posAE1 = [posFobEast, 15, 60, 5, 0, 0.2, 0, [], [_posAE1Ran,_posAE1Ran]] call BIS_fnc_findSafePos;
_objAE1 = _selAE1 createVehicle _posAE1;
if(!isNull roadAt _objAE1)then
{
	_objAE1 setDir (getdir (roadAt _objAE1)); 
	_objAE1 setPos (_objAE1 getRelPos [40,45]);
};
_objAE1 setDir dirCenFobEast;

systemChat "Structures created"; //debug

//WEATHER ----------------------------------------------------------------------------SERVER//
_overcast = [0, 0.5, 0.7, 1];
call //overcast
{
	//Random
	if (weather == 0) exitWith {0 setOvercast selectRandom _overcast;};
	//Clear
	if (weather == 1) exitWith {0 setOvercast (_overcast select 0);};
	//Cloudy
	if (weather == 2) exitWith {0 setOvercast (_overcast select 1);};
	//Rain
	if (weather == 3) exitWith {0 setOvercast (_overcast select 2);};
	//Stormy
	if (weather == 4) exitWith {0 setOvercast (_overcast select 3);};
};

call //fog
{
	//Random
	if (fogLevel == 0) exitWith {0 setFog selectRandom fogs;};
	//Yes
	if (fogLevel == 1) exitWith {0 setFog (fogs select 1);};
	//No
	if (fogLevel == 2) exitWith {0 setFog (fogs select 0);};
};

_rain = [0, 0.5, 1, 0];
call //rain
{
	//Random
	if (weather == 0) exitWith {0 setRain selectRandom _rain;};
	//Clear
	if (weather == 1) exitWith {0 setRain (_rain select 0);};
	//Cloudy
	if (weather == 2) exitWith {0 setRain (_rain select 0);};
	//Rain
	if (weather == 3) exitWith {0 setRain (_rain select 1);};
	//Stormy
	if (weather == 4) exitWith {0 setRain (_rain select 2);};
};

forceWeatherChange;

systemChat "Weather generated"; //debug

//VEHICLES RESPAWN TIME---------------------------------------------------------------SERVER//
call
{
	//30/90 sec, Unarmed/Armed
	if (vehTime == 0) exitWith
	{
		trTime = 30; publicvariable "trTime"; //30
		arTime = 90; publicvariable "arTime"; //90
	};
	//1/3 min
	if (vehTime == 1) exitWith
	{
		trTime = 60; publicvariable "trTime";
		arTime = 180; publicvariable "arTime";
	};
	//3/9 min
	if (vehTime == 2) exitWith
	{
		trTime = 180; publicvariable "trTime";
		arTime = 540; publicvariable "arTime";
	};
	//5/15 min
	if (vehTime == 3) exitWith
	{
		trTime = 300; publicvariable "trTime";
		arTime = 900; publicvariable "arTime";
	};
	//10/30 min
	if (vehTime == 4) exitWith
	{
		trTime = 600; publicvariable "trTime";
		arTime = 1800; publicvariable "arTime";
	};
};
systemChat "Vehicle respawn time set"; //debug

//CREATE VEHICLES (MISSION TYPE+RESPAWN TYPE == 2)-------------------------------------------------------------------------SERVER//

//POSITION OF PLANES AND SUPPORT MODULES
//distance of the airfields to the center of AO
_disCenH4 = 0;
_disBaseWh4 = 0;
_disBaseEh4 = 0;
_disCenH5 = 0;
_disBaseWh5 = 0;
_disBaseEh5 = 0;
//distances to airfields
_disCenBaseW = posCenter distance posBaseWest;
_disCenBaseE = posCenter distance posBaseEast;
call //min distance to AO
{
	if (_disCenBaseW > _disCenBaseE) exitWith {disMin = (_disCenBaseW + 500);};
	if (_disCenBaseW < _disCenBaseE) exitWith {disMin = (_disCenBaseE + 500);};
};
//1
_disCenH1 = posCenter distance plH1;
_disBaseWh1 = posBaseWest distance plH1;
_disBaseEh1 = posBaseEast distance plH1;
//2
_disCenH2 = posCenter distance plH2;
_disBaseWh2 = posBaseWest distance plH2;
_disBaseEh2 = posBaseEast distance plH2;
//3
_disCenH3 = posCenter distance plH3;
_disBaseWh3 = posBaseWest distance plH3;
_disBaseEh3 = posBaseEast distance plH3;
//4
if (plH >= 4) then
{
_disCenH4 = posCenter distance plH4;
_disBaseWh4 = posBaseWest distance plH4;
_disBaseEh4 = posBaseEast distance plH4;
};
//5
if (plH >= 5) then
{
_disCenH5 = posCenter distance plH5;
_disBaseWh5 = posBaseWest distance plH5;
_disBaseEh5 = posBaseEast distance plH5;
};
//arrays setup, how many airfields will be used
_distW = [_disBaseWh1, _disBaseWh2, _disBaseWh3];
_distE = [_disBaseEh1, _disBaseEh2, _disBaseEh3];
_plHsW = [plH1, plH2, plH3];
_plHsE = [plH1, plH2, plH3];
if (plH >= 4) then
{
	_distW = _distW + [_disBaseWh4];
	_distE = _distE + [_disBaseEh4];
	_plHsW = _plHsW + [plH4];
	_plHsE = _plHsE + [plH4];
};
if (plH >= 5) then
{
	_distW = _distW + [_disBaseWh5];
	_distE = _distE + [_disBaseEh5];
	_plHsW = _plHsW + [plH5];
	_plHsE = _plHsE + [plH5];
};
//arrays filter, remove unsuitable airfields
//1
if (_disCenH1 > disMin) then
{
	if (_disBaseWh1 < _disBaseEh1) 
	//west is closer 
	then {_plHsE = _plHsE - [plH1]; _distE = _distE - [_disBaseEh1];} 
	//east is closer 
	else {_plHsW = _plHsW - [plH1]; _distW = _distW - [_disBaseWh1];};
} else
{
	_plHsE = _plHsE - [plH1]; _distE = _distE - [_disBaseEh1];
	_plHsW = _plHsW - [plH1]; _distW = _distW - [_disBaseWh1];
};
//2
if (_disCenH2 > disMin) then
{
	if (_disBaseWh2 < _disBaseEh2) 
	then {_plHsE = _plHsE - [plH2]; _distE = _distE - [_disBaseEh2];} 
	else {_plHsW = _plHsW - [plH2]; _distW = _distW - [_disBaseWh2];};
} else
{
	_plHsE = _plHsE - [plH2]; _distE = _distE - [_disBaseEh2];
	_plHsW = _plHsW - [plH2]; _distW = _distW - [_disBaseWh2];
};
//3
if (_disCenH3 > disMin) then
{
	if (_disBaseWh3 < _disBaseEh3) 
	then {_plHsE = _plHsE - [plH3]; _distE = _distE - [_disBaseEh3];} 
	else {_plHsW = _plHsW - [plH3]; _distW = _distW - [_disBaseWh3];};
} else
{
	_plHsE = _plHsE - [plH3]; _distE = _distE - [_disBaseEh3];
	_plHsW = _plHsW - [plH3]; _distW = _distW - [_disBaseWh3];
};
//4
if (plH >= 4) then
{
	if (_disCenH4 > disMin) then
	{
		if (_disBaseWh4 < _disBaseEh4) 
		then {_plHsE = _plHsE - [plH4]; _distE = _distE - [_disBaseEh4];} 
		else {_plHsW = _plHsW - [plH4]; _distW = _distW - [_disBaseWh4];};
	} else
	{
		_plHsE = _plHsE - [plH4]; _distE = _distE - [_disBaseEh4];
		_plHsW = _plHsW - [plH4]; _distW = _distW - [_disBaseWh4];
	};
};
//5
if (plH >= 5) then
{
	if (_disCenH5 > disMin) then
	{
		if (_disBaseWh5 < _disBaseEh5) 
		then {_plHsE = _plHsE - [plH5]; _distE = _distE - [_disBaseEh5];} 
		else {_plHsW = _plHsW - [plH5]; _distW = _distW - [_disBaseWh5];};
	} else
	{
		_plHsE = _plHsE - [plH5]; _distE = _distE - [_disBaseEh5];
		_plHsW = _plHsW - [plH5]; _distW = _distW - [_disBaseWh5];
	};
};
//selection, select an airfield with the best position
if (count _plHsW > 0) then 
{
	minW = selectMin _distW;
	{if (_x == minW) then {indexW = _forEachIndex};} forEach _distW;
	plHW = _plHsW select indexW;
};
if (count _plHsE > 0) then 
{
	minE = selectMin _distE;
	{if (_x == minE) then {indexE = _forEachIndex};} forEach _distE;
	plHE = _plHsE select indexE;
};
if (count _plHsW <= 0) then 
{
	_plHsW = _plHsE - [plHE];
	_distW = _distE - [minE];
	minW = selectMin _distW;
	{if (_x == minW) then {indexW = _forEachIndex};} forEach _distW;
	plHW = _plHsW select indexW;
};
if (count _plHsE <= 0) then 
{
	_plHsE = _plHsW - [plHW];
	_distE = _distW - [minW];
	minE = selectMin _distE;
	{if (_x == minE) then {indexE = _forEachIndex};} forEach _distE;
	plHE = _plHsE select indexE;
};

//create flags (teleports) 
_fpos=(objectFobWest getRelPos [25,0]) findEmptyPosition [0, 50, "B_soldier_F"];
if(count _fpos==0)then{_fpos=objectFobWest getRelPos [25,0];};
flgFobW = flgW createVehicle _fpos;

_fpos=(objectBaseWest getRelPos [25,324]) findEmptyPosition [0, 50, "B_soldier_F"];
if(count _fpos==0)then{_fpos=objectBaseWest getRelPos [25,324];};
flgBaseW = flgW createVehicle _fpos;

_fpos=(objectFobEast getRelPos [25,0]) findEmptyPosition [0, 50, "B_soldier_F"];
if(count _fpos==0)then{_fpos=objectFobEast getRelPos [25,0];};
flgFobE = flgE createVehicle _fpos;

_fpos=(objectBaseEast getRelPos [25,324]) findEmptyPosition [0, 50, "B_soldier_F"];
if(count _fpos==0)then{_fpos=objectBaseEast getRelPos [25,324];};
flgBaseE = flgE createVehicle _fpos;

if ((planes==1)||((planes==2)&&(plHW==plH1||plHW==plH2)&&(plHe==plH1||plHe==plH2))) then
{
	if (missType == 3) then 
	{
		flgJetW = flgW createVehicle (plHW getRelPos [30, 270]);
		flgJetE = flgE createVehicle (plHE getRelPos [30, 270]);
	} else {flgJetW = ""; flgJetE = "";};
} else {flgJetW = ""; flgJetE = "";};
[flgFobW,flgBaseW,flgJetW,flgFobE,flgBaseE,flgJetE,missType] remoteExec ["wrm_fnc_flagActions", 0, true]; 

//PLANES
if ((planes==1)||((planes==2)&&(plHW==plH1||plHW==plH2)&&(plHe==plH1||plHe==plH2))) then
{	
	if (missType == 3) then
	{	
		//plane west
		_pSelW = selectRandom PlaneW;
		_pPosW = getPos plHw;
		_pVehW = _pSelW createVehicle _pPosW;
		_pVehW setDir getDir plHw;
		[_pVehW,arTime,arTime,-1,[{
			params ["_veh"];
			_veh allowDammage false;
			_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];
		},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
		["pArW",0,_pPosW,"plane"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
		[sideW, (plHW getRelPos [25, 270]), "Runway"] call BIS_fnc_addRespawnPosition; 
		z1 addCuratorEditableObjects [[_pVehW],true];	
		_pVehW allowDammage false;
		_pVehW addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];
		
		//plane east
		_pSelE = selectRandom PlaneE;
		_pPosE = getPos plHe;
		_pVehE = _pSelE createVehicle _pPosE;
		_pVehE setDir getDir plHe;
		[_pVehE,arTime,arTime,-1,[{
			params ["_veh"];
			_veh allowDammage false;
			_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];		
		},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
		["pArE",0,_pPosE,"plane"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
		[sideE, (plHE getRelPos [25, 270]), "Runway"] call BIS_fnc_addRespawnPosition; 
		z1 addCuratorEditableObjects [[_pVehE],true];
		_pVehE allowDammage false;
		_pVehE addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];
	};
};
//TRANSPORT
//create BASE west heliport + helicopter
if (count HeliTrW>0) then
{
	_mrkBW = createMarkerLocal ["mbw", posBaseWest];
	_mrkBW setMarkerShapeLocal "ELLIPSE";
	_mrkBW setMarkerSizeLocal  [16, 16];

	_hSelW = selectRandom HeliTrW;
	_hPosW = [(objectBaseWest getRelPos [25,180]),0,150,9,0,0.2,0,["mbw"],[(objectBaseWest getRelPos [25,180]),(objectBaseWest getRelPos [25,180])]] call BIS_fnc_findSafePos; 
	_hPadW = "Land_HelipadCircle_F" createVehicle _hPosW;
	_hPadW setDir (dirCenBaseWest+180);
	_hVehW = _hSelW createVehicle _hPosW;
	_hVehW setDir (dirCenBaseWest+180);
	_hVehW setVectorUp surfaceNormal position _hVehW;
	[_hVehW,trTime,trTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];	
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["hTrW",0,_hPosW,"air"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
	z1 addCuratorEditableObjects [[_hVehW],true];
	_hVehW allowDammage false;
	_hVehW addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];
	deleteMarkerLocal "mbw";
};
//attack heli
if (missType == 3) then
{
	if (count HeliArW>0) then
	{
		_mrkBW = createMarkerLocal ["mbw", posBaseWest];
		_mrkBW setMarkerShapeLocal "ELLIPSE";
		_mrkBW setMarkerSizeLocal  [16, 16];
		
		_hSelW = selectRandom HeliArW;
		_hPosW = [(objectBaseWest getRelPos [25,288]),0,150,9,0,0.2,0,["mbw"],[(objectBaseWest getRelPos [25,288]),(objectBaseWest getRelPos [25,288])]] call BIS_fnc_findSafePos; 
		_hPadW = "Land_HelipadCircle_F" createVehicle _hPosW;
		_hPadW setDir (dirCenBaseWest+180);
		_hVehW = _hSelW createVehicle _hPosW;
		_hVehW setDir (dirCenBaseWest+180);
		_hVehW setVectorUp surfaceNormal position _hVehW;
		[_hVehW,arTime,arTime,-1,[{
			params ["_veh"];
			_veh allowDammage false;
			_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];
		},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
		["hArW",0,_hPosW,"air"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
		z1 addCuratorEditableObjects [[_hVehW],true];
		_hVehW allowDammage false;
		_hVehW addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];
		deleteMarkerLocal "mbw";
	};
};
//create BASE east heliport + helicopter
if (count HeliTrE>0) then
{
	_mrkBE = createMarkerLocal ["mbe", posBaseEast];
	_mrkBE setMarkerShapeLocal "ELLIPSE";
	_mrkBE setMarkerSizeLocal  [16, 16];

	_hSelE = selectRandom HeliTrE;
	_hPosE = [(objectBaseEast getRelPos [25,180]),0,150,9,0,0.2,0,["mbe"],[(objectBaseEast getRelPos [25,180]),(objectBaseEast getRelPos [25,180])]] call BIS_fnc_findSafePos; 
	_hPadE = "Land_HelipadCircle_F" createVehicle _hPosE;
	_hPadE setDir (dirCenBaseEast+180);
	_hVehE = _hSelE createVehicle _hPosE;
	_hVehE setDir (dirCenBaseEast+180);
	_hVehE setVectorUp surfaceNormal _hPosE;
	[_hVehE,trTime,trTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["hTrE",0,_hPosE,"air"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
	z1 addCuratorEditableObjects [[_hVehE],true];
	_hVehE allowDammage false;
	_hVehE addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];
	deleteMarkerLocal "mbe";
};
//attack heli
if (missType == 3) then
{
	if (count HeliArE>0) then
	{
		_mrkBE = createMarkerLocal ["mbe", posBaseEast];
		_mrkBE setMarkerShapeLocal "ELLIPSE";
		_mrkBE setMarkerSizeLocal  [16, 16];
		
		_hSelE = selectRandom HeliArE;
		_hPosE = [(objectBaseEast getRelPos [25,288]),0,150,9,0,0.2,0,["mbe"],[(objectBaseEast getRelPos [25,288]),(objectBaseEast getRelPos [25,288])]] call BIS_fnc_findSafePos; 
		_hPadE = "Land_HelipadCircle_F" createVehicle _hPosE;
		_hPadE setDir (dirCenBaseEast+180);
		_hVehE = _hSelE createVehicle _hPosE;
		_hVehE setDir (dirCenBaseEast+180);
		_hVehE setVectorUp surfaceNormal _hPosE;
		[_hVehE,arTime,arTime,-1,[{
			params ["_veh"];
			_veh allowDammage false;
			_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];		
		},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
		["hArE",0,_hPosE,"air"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
		z1 addCuratorEditableObjects [[_hVehE],true];
		_hVehE allowDammage false;
		_hVehE addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];		
		deleteMarkerLocal "mbe";
	};
};

//FOB vehicles
_vehFobW = [BikeW, CarW];
_vehFobE = [BikeE, CarE];
//BASE vehicles
_vehBaseTrW = [BikeW, CarW, CarArW, TruckW];
_vehBaseTrE = [BikeE, CarE, CarArE, TruckE];

//create FOB west vehicles
{
	_indx = _forEachIndex;
	_vSel = selectRandom _x;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};	
	_vPos = (objectFobWest getRelPos [25,(36+(36*_indx))]) findEmptyPosition [0, 50, _typ];
	if(count _vPos==0)then{_vPos = objectFobWest getRelPos [25,(36+(36*_indx))];};
	_veh = _typ createVehicle _vPos;
	[_veh,[_tex,1]] call bis_fnc_initVehicle;
	_veh setDir (dirCenFobWest+180);
	_veh setVectorUp surfaceNormal _vPos;
	[_veh,trTime,trTime,-1,[{},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vFoW",_indx,_vPos,"unknown"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
	z1 addCuratorEditableObjects [[_veh],true];
} forEach _vehFobW;

//create BASE west vehicles
{
	_indx = _forEachIndex;
	_vSel = selectRandom _x;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectBaseWest getRelPos [25,(36+(36*_indx))]) findEmptyPosition [0, 50, _typ];	
	if(count _vPos==0)then{_vPos = objectBaseWest getRelPos [25,(36+(36*_indx))];};
	vehW = _typ createVehicle _vPos;
	[vehW,[_tex,1]] call bis_fnc_initVehicle;
	vehW setDir (dirCenBaseWest+180);
	vehW setVectorUp surfaceNormal _vPos;
	[vehW,trTime,trTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh}];
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vBaW",_indx,_vPos,"unknown"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
	z1 addCuratorEditableObjects [[vehW],true];
	vehW allowDammage false;
	vehW addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];
} forEach _vehBaseTrW;
	
//create FOB east vehicles
{
	_indx = _forEachIndex;
	_vSel = selectRandom _x;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectFobEast getRelPos [25,(36+(36*_indx))]) findEmptyPosition [0, 50, _typ];
	if(count _vPos==0)then{_vPos = objectFobEast getRelPos [25,(36+(36*_indx))];};
	_veh = _typ createVehicle _vPos;
	[_veh,[_tex,1]] call bis_fnc_initVehicle;
	_veh setDir (dirCenFobEast+180);
	_veh setVectorUp surfaceNormal _vPos;
	[_veh,trTime,trTime,-1,[{},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vFoE",_indx,_vPos,"unknown"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
	z1 addCuratorEditableObjects [[_veh],true];
} forEach _vehFobE;

//create BASE east  vehicles
{
	_indx = _forEachIndex;
	_vSel = selectRandom _x;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectBaseEast getRelPos [25,(36+(36*_indx))]) findEmptyPosition [0, 50, _typ];
	if(count _vPos==0)then{_vPos = objectBaseEast getRelPos [25,(36+(36*_indx))];};
	vehE = _typ createVehicle _vPos;
	[vehE,[_tex,1]] call bis_fnc_initVehicle;
	vehE setDir (dirCenBaseEast+180);
	vehE setVectorUp surfaceNormal _vPos;
	[vehE,trTime,trTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];	
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vBaE",_indx,_vPos,"unknown"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
	z1 addCuratorEditableObjects [[vehE],true];
	vehE allowDammage false;
	vehE addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];	
} forEach _vehBaseTrE;

//ARMORS
if (missType>1) then
{
	//BASE armors
	if(missType>2)then{ArmorW2=ArmorW2+aaW; ArmorE2=ArmorE2+aaE;};
	//APC west
	_vSel = selectRandom ArmorW1;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectBaseWest getRelPos [25,216]) findEmptyPosition [0, 50, _typ]; 
	if(count _vPos==0)then{_vPos = objectBaseWest getRelPos [25,216];};
	armW = _typ createVehicle _vPos;
	[armW,[_tex,1]] call bis_fnc_initVehicle;
	armW setDir (dirCenBaseWest+180);
	armW setVectorUp surfaceNormal _vPos;
	[armW,arTime,arTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];	
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vArW",1,_vPos,"armor"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
	z1 addCuratorEditableObjects [[armW],true];
		armW allowDammage false;
		armW addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];	
	
	//TANK west
	_vSel = selectRandom ArmorW2;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectBaseWest getRelPos [25,252]) findEmptyPosition [0, 50, _typ]; 
	if(count _vPos==0)then{_vPos = objectBaseWest getRelPos [25,252];};
	_veh = _typ createVehicle _vPos;
	[_veh,[_tex,1]] call bis_fnc_initVehicle;
	_veh setDir (dirCenBaseWest+180);
	_veh setVectorUp surfaceNormal _vPos;
	[_veh,arTime,arTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];	
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vArW",0,_vPos,"armor"] remoteExec ["wrm_fnc_vehMrkW", 0, true];
	z1 addCuratorEditableObjects [[_veh],true];
	_veh allowDammage false;
	_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseWest] spawn wrm_fnc_safeZoneVeh;}];	
	
	//APC east
	_vSel = selectRandom ArmorE1;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectBaseEast getRelPos [25,216]) findEmptyPosition [0, 50, _typ]; 
	if(count _vPos==0)then{_vPos = objectBaseEast getRelPos [25,216];};
	armE = _typ createVehicle _vPos;
	[armE,[_tex,1]] call bis_fnc_initVehicle;
	armE setDir (dirCenBaseEast+180);
	armE setVectorUp surfaceNormal _vPos;
	[armE,arTime,arTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];	
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vArE",1,_vPos,"armor"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
	z1 addCuratorEditableObjects [[armE],true];
	armE allowDammage false;
	armE addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];	
	
	//TANK east
	_vSel = selectRandom ArmorE2;
	_typ="";_tex="";
	if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};
	_vPos = (objectBaseEast getRelPos [25,252]) findEmptyPosition [0, 50, _typ]; 
	if(count _vPos==0)then{_vPos = objectBaseEast getRelPos [25,252];};
	_veh = _typ createVehicle _vPos;
	[_veh,[_tex,1]] call bis_fnc_initVehicle;
	_veh setDir (dirCenBaseEast+180);
	_veh setVectorUp surfaceNormal _vPos;
	[_veh,arTime,arTime,-1,[{
		params ["_veh"];
		_veh allowDammage false;
		_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];	
	},[]],0,1,1,true] call BIS_fnc_moduleRespawnVehicle;
	["vArE",0,_vPos,"armor"] remoteExec ["wrm_fnc_vehMrkE", 0, true];
	z1 addCuratorEditableObjects [[_veh],true];
	_veh allowDammage false;
	_veh addEventHandler ["GetIn", {params ["_veh"]; [_veh,posBaseEast] spawn wrm_fnc_safeZoneVeh;}];	
};

systemChat "Vehicles created"; //debug
systemChat "Respawn type set"; //debug

//COMBAT SUPPORT-------------------------------------------------------------------------GLOBAL//
_supportW = [];
_supportE = [];
if(artillery==1)then //artillery
{
	_supportW = [SupArtyW, SupCasHW, SupCasBW]; //SupDropW, SupHeliW, 
	_supportE = [SupArtyE, SupCasHE, SupCasBE];
} else //mortars
{
	_supportW = [SupCasHW, SupCasBW];
	_supportE = [SupCasHE, SupCasBE];
	_posArtyW = posBaseWest findEmptyPosition [10, 50, "B_MRAP_01_F"];
	if(count _posArtyW==0)then{_posArtyW=objectBaseWest getRelPos [30,90];};
	SupArtyW setPos _posArtyW;
	_posArtyE = posBaseEast findEmptyPosition [10, 50, "B_MRAP_01_F"];
	if(count _posArtyE==0)then{_posArtyE=objectBaseWest getRelPos [30,90];};
	SupArtyE setPos _posArtyE;
};
//replace modules
_posSuppW = plHW getRelPos [20, 90];
_posSuppE = plHE getRelPos [20, 90];
{_x setPos _posSuppW;} forEach _supportW;
{_x setPos _posSuppE;} forEach _supportE;
sleep 1;

//teleports playable units to the BASE, players will respawn------------------------------SERVER//
{
	_unit = _x; 
	if (isPlayer leader _unit) then
	{
		call
		{
			if (side _unit == sideW) exitWith
			{
				_posU=objectBaseWest getRelPos [20, random 360];
				_unit setVehiclePosition [_posU, [], 0, "NONE"];
			};
			if (side _unit == sideE) exitWith 
			{
				_posU=objectBaseEast getRelPos [20, random 360];
				_unit setVehiclePosition [_posU, [], 0, "NONE"];				
			};
		};
	};
	if (isPlayer _unit)then{[_unit] remoteExec ["forceRespawn", 0, false];};
} forEach playableunits;
sleep 1;
[] execVM "warmachine\aiStart.sqf";
if (AIon>0) then 
{
	[] spawn wrm_fnc_aiUpdate;
};
//RESPAWN TIME-------------------------------------------------------------------------SERVER//
call
{
	//5sec
	if (resTime == 0) exitWith {rTime = 5; publicvariable "rTime";};
	//30sec
	if (resTime == 1) exitWith {rTime = 30; publicvariable "rTime";};
	//60sec
	if (resTime == 2) exitWith {rTime = 60; publicvariable "rTime";};
	//120sec
	if (resTime == 3) exitWith {rTime = 120; publicvariable "rTime";};
	//180sec
	if (resTime == 4) exitWith {rTime = 180; publicvariable "rTime";};
};

systemChat "Respawn time set"; //debug

//CREATE SECTORS-----------------------------------------------------------------------SERVER//
//sector ALPHA
_pos = objectAlpha call BIS_fnc_position;
"ModuleSector_F" createUnit [_pos,createGroup sideLogic,format
["
	
	sectorA=this;
	this setvariable ['BIS_fnc_initModules_disableAutoActivation',false];
	this setVariable ['name','ALPHA'];
	this setVariable ['Designation','A'];
	this setVariable ['OwnerLimit','1'];
	this setVariable ['OnOwnerChange','
		call
		{
			 if ((_this select 1) == sideW) exitWith 
			 {
				if (support == 0) then
				{
					[SupReqW, SupArtyW] remoteExec [''BIS_fnc_addSupportLink'', 0, true];
					[SupReqE, SupArtyE] remoteExec [''BIS_fnc_removeSupportLink'', 0, true];
				};
				if (resType>0) then
				{
					_mrkRaW = createMarker [resAW, posAlpha];
					_mrkRaW setMarkerShape ''ICON'';
					_mrkRaW setMarkerType ''empty'';
					_mrkRaW setMarkerText ''ALPHA'';
					deleteMarker resAE;
				};
			 };
			 if ((_this select 1) == sideE) exitWith  
			 {
				if (support == 0) then
				{
					[SupReqE, SupArtyE] remoteExec [''BIS_fnc_addSupportLink'', 0, true];
					[SupReqW, SupArtyW] remoteExec [''BIS_fnc_removeSupportLink'', 0, true];
				};
				if (resType>0) then
				{
					_mrkRaE = createMarker [resAE, posAlpha];
					_mrkRaE setMarkerShape ''ICON'';
					_mrkRaE setMarkerType ''empty'';
					_mrkRaE setMarkerText ''ALPHA'';
					deleteMarker resAW;
				};
			 };
		};
		if (AIon>0) then {[] call wrm_fnc_aiMove;};		
	'];
	this setVariable ['CaptureCoef','0.05']; 	
	this setVariable ['CostInfantry','0.2'];
	this setVariable ['CostWheeled','0.2'];
	this setVariable ['CostTracked','0.2'];
	this setVariable ['CostWater','0.2'];
	this setVariable ['CostAir','0.2'];
	this setVariable ['CostPlayers','0.2'];
	this setVariable ['DefaultOwner','-1'];
	this setVariable ['TaskOwner','3'];
	this setVariable ['TaskTitle','ALPHA'];
	this setVariable ['taskDescription','Capture sector ALPHA'];
	this setVariable ['ScoreReward','0'];
	this setVariable ['Sides',[sideE,sideW]];
	this setVariable ['objectArea',[50,50,0,false]];
"]];

//sector BRAVO
if (secNo>0) then
{
	_pos = objectBravo call BIS_fnc_position;
	"ModuleSector_F" createUnit [_pos,createGroup sideLogic,format
	["
		sectorB=this;
		this setvariable ['BIS_fnc_initModules_disableAutoActivation',false];
		this setVariable ['name','BRAVO'];
		this setVariable ['Designation','B'];
		this setVariable ['OwnerLimit','1'];
		this setVariable ['OnOwnerChange','
			call
			{
				 if ((_this select 1) == sideW) exitWith 
				 {
					if (support == 0) then
					{
						[SupReqW, SupCasBW] remoteExec [''BIS_fnc_addSupportLink'', 0, true];
						[SupReqE, SupCasBE] remoteExec [''BIS_fnc_removeSupportLink'', 0, true];
					};
					if (resType>0) then
					{
						_mrkRbW = createMarker [resBW, posBravo];
						_mrkRbW setMarkerShape ''ICON'';
						_mrkRbW setMarkerType ''empty'';
						_mrkRbW setMarkerText ''BRAVO'';
						deleteMarker resBE;
					};
				 };
				 if ((_this select 1) == sideE) exitWith  
				 {
					if (support == 0) then
					{
						[SupReqE, SupCasBE] remoteExec [''BIS_fnc_addSupportLink'', 0, true];
						[SupReqW, SupCasBW] remoteExec [''BIS_fnc_removeSupportLink'', 0, true];
					};
					if (resType>0) then
					{
						_mrkRbE = createMarker [resBE, posBravo];
						_mrkRbE setMarkerShape ''ICON'';
						_mrkRbE setMarkerType ''empty'';
						_mrkRbE setMarkerText ''BRAVO'';
						deleteMarker resBW;
					};
				 };
			};
			if (AIon>0) then {[] call wrm_fnc_aiMove;};
		'];
		this setVariable ['CaptureCoef','0.05']; 	
		this setVariable ['CostInfantry','0.2'];
		this setVariable ['CostWheeled','0.2'];
		this setVariable ['CostTracked','0.2'];
		this setVariable ['CostWater','0.2'];
		this setVariable ['CostAir','0.2'];
		this setVariable ['CostPlayers','0.2'];
		this setVariable ['DefaultOwner','-1'];
		this setVariable ['TaskOwner','3'];
		this setVariable ['TaskTitle','BRAVO'];
		this setVariable ['taskDescription','Capture sector BRAVO'];
		this setVariable ['ScoreReward','0'];
		this setVariable ['Sides',[sideE,sideW]];
		this setVariable ['objectArea',[50,50,0,false]];
	"]];
};

//sector CHARLIE
if (secNo>1) then
{
	_pos = objectCharlie call BIS_fnc_position;
	"ModuleSector_F" createUnit [_pos,createGroup sideLogic,format
	["
		sectorC=this;
		this setvariable ['BIS_fnc_initModules_disableAutoActivation',false];
		this setVariable ['name','CHARLIE'];
		this setVariable ['Designation','C'];
		this setVariable ['OwnerLimit','1'];
		this setVariable ['OnOwnerChange','
			call
			{
				 if ((_this select 1) == sideW) exitWith 
				 {
					if (support == 0 && (!isClass(configFile >> ''CfgPatches'' >> ''LIB_core''))) then
					{
						[SupReqW, SupCasHW] remoteExec [''BIS_fnc_addSupportLink'', 0, true];
						[SupReqE, SupCasHE] remoteExec [''BIS_fnc_removeSupportLink'', 0, true];
					};
					if (resType>0) then
					{
						_mrkRcW = createMarker [resCW, posCharlie];
						_mrkRcW setMarkerShape ''ICON'';
						_mrkRcW setMarkerType ''empty'';
						_mrkRcW setMarkerText ''CHARLIE'';
						deleteMarker resCE;
					};
				 };
				 if ((_this select 1) == sideE) exitWith  
				 {
					if (support == 0 && (!isClass(configFile >> ''CfgPatches'' >> ''LIB_core''))) then
					{
						[SupReqE, SupCasHE] remoteExec [''BIS_fnc_addSupportLink'', 0, true];
						[SupReqW, SupCasHW] remoteExec [''BIS_fnc_removeSupportLink'', 0, true];
					};
					if (resType>0) then
					{
						_mrkRcE = createMarker [resCE, posCharlie];
						_mrkRcE setMarkerShape ''ICON'';
						_mrkRcE setMarkerType ''empty'';
						_mrkRcE setMarkerText ''CHARLIE'';
						deleteMarker resCW;
					};
				 };
			};
			if (AIon>0) then {[] call wrm_fnc_aiMove;};
		'];
		this setVariable ['CaptureCoef','0.05']; 	
		this setVariable ['CostInfantry','0.2'];
		this setVariable ['CostWheeled','0.2'];
		this setVariable ['CostTracked','0.2'];
		this setVariable ['CostWater','0.2'];
		this setVariable ['CostAir','0.2'];
		this setVariable ['CostPlayers','0.2'];
		this setVariable ['DefaultOwner','-1'];
		this setVariable ['TaskOwner','3'];
		this setVariable ['TaskTitle','CHARLIE'];
		this setVariable ['taskDescription','Capture sector CHARLIE'];
		this setVariable ['ScoreReward','0'];
		this setVariable ['Sides',[sideE,sideW]];
		this setVariable ['objectArea',[50,50,0,false]];
	"]];
};
systemChat "Sectors created";

//RESPAWN TICKETS-------------------------------------------------------------------------SERVER//
call
{
	if (resTickets == 0) exitWith 
	{
		_m=3;
		if(ticBleed==0)then{_m=2;};
		if (_unitsNo > 16)
		then {tic = round (_unitsNo*_m);} 
		else {tic = 50;};
		if (AIon==3||Aion==5)then
		{
			_n=3;
			if(missType==3)then{_n=4;};
			call
			{
				if(vehTime==0)exitWith{tic=tic+(60*_n);};
				if(vehTime==1)exitWith{tic=tic+(30*_n);};
				if(vehTime==2)exitWith{tic=tic+(10*_n);};
				if(vehTime==3)exitWith{tic=tic+(6*_n);};
				if(vehTime==4)exitWith{tic=tic+(3*_n);};
			};
		};
		
	};
	if (resTickets == 1) exitWith {tic = 50;};
	if (resTickets == 2) exitWith {tic = 100;};
	if (resTickets == 3) exitWith {tic = 150;};
	if (resTickets == 4) exitWith {tic = 200;};
	if (resTickets == 5) exitWith {tic = 250;};
	if (resTickets == 6) exitWith {tic = 300;};
	if (resTickets == 7) exitWith {tic = 400;};
	if (resTickets == 8) exitWith {tic = 500;};
	if (resTickets == 9) exitWith {tic = 600;};
};

[sideW, tic] call BIS_fnc_respawnTickets; 
[sideE, tic] call BIS_fnc_respawnTickets;
systemChat "Respawn tickets set";

progress = 2; publicVariable "progress";
"warmachine\hint.sqf" remoteExec ["execVM", 0, true];
if(timeLim>0) then {[] execVM "warmachine\timerStart.sqf";}; //server
"warmachine\firstSpawn.sqf" remoteExec ["execVM", 0, true];

systemChat "Mission was generated";