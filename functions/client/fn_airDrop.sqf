/*
Author: IvosH

Description:
	Add actions for airdrop

Parameter(s):
	none

Returns:
	nothing

Dependencies:
	fn_leaderActions.sqf

Execution:
	[] call wrm_fnc_airDrop
*/

if(progress<2)exitWith{};

divE=[]; divW=""; divM="";
call
{
	if (side player == sideW) exitWith {supply=supplyW; car=CarW; truck=TruckW; boatAr = boatArW; boatTr = boatTrW; divE=divEw; divW=divWw; divM=divMw;};
	If (side player == sideE) exitWith {supply=supplyE; car=CarE; truck=TruckE; boatAr = boatArE; boatTr = boatTrE; divE=divEe; divW=divWe; divM=divMe;};
};

if (suppUsed==0) then
{
	supplyAction = player addAction 
	[
		"- Supply drop", //title
		{
			_posB = [(player getRelPos [25,0]), 0, 25, 0, 0, 0, 0] call BIS_fnc_findSafePos;
			_box = createVehicle [selectRandom supply, [_posB select 0, _posB select 1, 60], [], 0, "NONE"];
			[objNull, _box] call BIS_fnc_curatorObjectEdited;
			[z1,[[_box],true]] remoteExec ["addCuratorEditableObjects", 2, false];
			suppUsed = 1;
			player removeAction supplyAction;
		}, 
		nil, 0.8, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
	]; 
};

if (carUsed==0) then
{
	carAction = player addAction 
	[
		"- Car airdrop", //title
		{
			_posB = [(player getRelPos [25,0]), 0, 25, 0, 0, 0, 0] call BIS_fnc_findSafePos;
			_car = createVehicle [selectRandom car, [_posB select 0, _posB select 1, 60], [], 0, "NONE"];
			[objNull, _car] call BIS_fnc_curatorObjectEdited;
			_car setDir (getPos player getDir _posB);
			[z1,[[_car],true]] remoteExec ["addCuratorEditableObjects", 2, false];
			carUsed = 1;
			player removeAction carAction;
		}, 
		nil, 0.7, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
	]; 
};

if (truckUsed==0) then
{
	truckAction = player addAction 
	[
		"- Truck airdrop", //title
		{
			_posB = [(player getRelPos [25,0]), 0, 25, 0, 0, 0, 0] call BIS_fnc_findSafePos;
			_car = createVehicle [selectRandom truck, [_posB select 0, _posB select 1, 60], [], 0, "NONE"];
			[objNull, _car] call BIS_fnc_curatorObjectEdited;
			_car setDir (getPos player getDir _posB);
			[z1,[[_car],true]] remoteExec ["addCuratorEditableObjects", 2, false];
			truckUsed = 1;
			player removeAction truckAction;
		}, 
		nil, 0.6, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
	]; 
};

if (boatArUsed==0 && boatsAr==1) then
{
	BoatArAction = player addAction 
	[
		"- Patrol boat airdrop", //title
		{
			_overShore = !(position player isFlatEmpty  [-1, -1, -1, -1, 0, true] isEqualTo []);
			_overWater = !(position player isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
			if (_overShore || _overWater) then
			{
				_posB = [player, 20, 35, 0, 2, 0, 0] call BIS_fnc_findSafePos;
				_boat = createVehicle [selectRandom boatAr, [_posB select 0, _posB select 1, 60], [], 0, "NONE"];
				[objNull, _boat] call BIS_fnc_curatorObjectEdited;
				_boat setDir (getPos player getDir _posB);
				[z1,[[_boat],true]] remoteExec ["addCuratorEditableObjects", 2, false];
				if(diverG==1)then
				{
					clearItemCargo _boat;
					_boat addItemCargoGlobal ["FirstAidKit", 2];
					{_boat addItemCargoGlobal [_x, 1];} forEach divE; //add diving gear to cargo
					_boat addWeaponCargoGlobal [divW, 1];
					_boat addMagazineCargoGlobal [divM, 3];
				};
				//[_boat] remoteExec ["wrm_fnc_pushBoat", 0, true];
				boatArUsed = 1;
				player removeAction BoatArAction;
			} else 
			{
				hint "You are too far from the water";
			};
		}, 
		nil, 0.5, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
	]; 
};

if (boatTrUsed == 0) then
{
	BoatTrAction = player addAction 
	[
		"- Boat airdrop", //title
		{
			_overShore = !(position player isFlatEmpty  [-1, -1, -1, -1, 0, true] isEqualTo []);
			_overWater = !(position player isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo []);
			if (_overShore || _overWater) then
			{
				_posB = [player, 20, 35, 0, 2, 0, 0] call BIS_fnc_findSafePos;
				_boat = createVehicle [selectRandom boatTr, [_posB select 0, _posB select 1, 60], [], 0, "NONE"]; //create boat
				[objNull, _boat] call BIS_fnc_curatorObjectEdited;
				_boat setDir (getPos player getDir _posB);
				[z1,[[_boat],true]] remoteExec ["addCuratorEditableObjects", 2, false]; //add unit to zeus
				if(diverG==1)then
				{
					{_boat addItemCargoGlobal [_x, 1];} forEach divE; //add diving gear to cargo
					_boat addWeaponCargoGlobal [divW, 1];
					_boat addMagazineCargoGlobal [divM, 3];
				};
				//[_boat] remoteExec ["wrm_fnc_pushBoat", 0, true]; //add action to push boat to the water
				boatTrUsed = 1;
				player removeAction BoatTrAction;
			} else 
			{
				hint "You are too far from the water";
			};
		}, //script
		nil, //arguments (Optional)
		0.4, //priority (Optional)
		false, //showWindow (Optional)
		true, //hideOnUse (Optional)
		"", //shortcut, (Optional) 
		"", //condition,  (Optional)
		0, //radius, (Optional) -1disable, 15max
		false, //unconscious, (Optional)
		"" //selection]; (Optional)
	]; 
};