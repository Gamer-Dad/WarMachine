/*
	Author: IvosH
	
	Description:
		Check if player is group leader add Actions. Update combat support and action menu available for the group leader.
		lUpdate: 0 = respawn, 1 = was leader in last update, 2 = wasn't leader last update
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		onPlayerRespawn.sqf
		fn_leaderUpdate.sqf
		
	Execution:
		[] spawn wrm_fnc_leaderActions;
*/

if (!hasInterface) exitWith {}; //run on all players include server host

divE=[]; divW=""; divM="";
call
{
	if (side player == sideW) exitWith {SupReq = SupReqW;};
	If (side player == sideE) exitWith {SupReq = SupReqE;};
};

//player IS leader
if (leader player == player) then 
{
	if (lUpdate != 1) then 
	{
		if (lUpdate == 2) then //remove "Become leader"
		{
			player removeAction LDRaction;
		};			
		[player, SupReq] remoteExec ["BIS_fnc_addSupportLink", 0, false]; //add support module
	
		LDRdown = player addAction
		[
			"Leave Leader position", //title
			{
					_grp=(units group player)-[player];
					if((count _grp)<2)exitWith{hint "You are alone";};
					//player become leader of his group
					[group player, (_grp select 0)] remoteExec ["selectLeader", 0, false];
					player removeAction LDRdown;
					hint "You are no longer a squad leader";
					sleep 0.5;
					lUpdate = 1;
					[] spawn wrm_fnc_leaderActions;

			}, //script
			nil, 0, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
		];		
	
		if(progress>1)then
		{			
			if(airDrop==0)then
			{
				if (suppUsed==0||carUsed==0||truckUsed==0||boatArUsed==0||boatTrUsed==0) then
				{
					dropAction = player addAction 
					[
						"Fortification", //title
						{
							[] call wrm_fnc_airDrop;
							player removeAction dropAction;
							airDrop=1;
						}, //script
						nil, //arguments (Optional)
						0.8, //priority (Optional)
						false, //showWindow (Optional)
						false, //hideOnUse (Optional)
						"", //shortcut, (Optional) 
						"", //condition,  (Optional)
						0, //radius, (Optional) -1disable, 15max
						false, //unconscious, (Optional)
						"" //selection]; (Optional)
					]; 
				};
			};
			
			if(fort==0)then
			{
				if (fort1==0||fort2==0||fort3==0) then
				{
					fortAction = player addAction 
					[
						"Fortification", //title
						{
							[] call wrm_fnc_fortification;
							player removeAction fortAction;
							fort=1;
						}, //script
						nil, //arguments (Optional)
						0.3, //priority (Optional)
						false, //showWindow (Optional)
						false, //hideOnUse (Optional)
						"", //shortcut, (Optional) 
						"", //condition,  (Optional)
						0, //radius, (Optional) -1disable, 15max
						false, //unconscious, (Optional)
						"" //selection]; (Optional)
					]; 
				};
			};			
/*
			if (carUsed==0) then
			{
				carAction = player addAction 
				[
					"Car airdrop", //title
					{
						_posB = [(player getRelPos [25,0]), 0, 25, 0, 0, 0, 0] call BIS_fnc_findSafePos;
						_car = createVehicle [selectRandom car, [_posB select 0, _posB select 1, 60], [], 0, "NONE"];
						[objNull, _car] call BIS_fnc_curatorObjectEdited;
						_car setDir (getPos player getDir _posB);
						[z1,[[_car],true]] remoteExec ["addCuratorEditableObjects", 2, false];
						carUsed = 1;
						player removeAction carAction;
					}, 
					nil, 0.4, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
				]; 
			};

			if (truckUsed==0) then
			{
				truckAction = player addAction 
				[
					"Truck airdrop", //title
					{
						_posB = [(player getRelPos [25,0]), 0, 25, 0, 0, 0, 0] call BIS_fnc_findSafePos;
						_car = createVehicle [selectRandom truck, [_posB select 0, _posB select 1, 60], [], 0, "NONE"];
						[objNull, _car] call BIS_fnc_curatorObjectEdited;
						_car setDir (getPos player getDir _posB);
						[z1,[[_car],true]] remoteExec ["addCuratorEditableObjects", 2, false];
						truckUsed = 1;
						player removeAction truckAction;
					}, 
					nil, 0.3, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
				]; 
			};

			if (boatArUsed==0 && boatsAr==1) then
			{
				BoatArAction = player addAction 
				[
					"Patrol boat airdrop", //title
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
					nil, 0.2, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
				]; 
			};

			if (boatTrUsed == 0) then
			{
				BoatTrAction = player addAction 
				[
					"Boat airdrop", //title
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
					0.1, //priority (Optional)
					false, //showWindow (Optional)
					true, //hideOnUse (Optional)
					"", //shortcut, (Optional) 
					"", //condition,  (Optional)
					0, //radius, (Optional) -1disable, 15max
					false, //unconscious, (Optional)
					"" //selection]; (Optional)
				]; 
			};
*/
		};
		lUpdate = 1;
	};
} else 

//player is NOT leader
{
	if (lUpdate != 2) then 
	{
		if (lUpdate == 1) then 
		{
			player removeAction LDRdown; //remove "Leave Leader position"
			if(progress>1)then
			{
				if(fort==0)then
				{
					if (fort1==0||fort2==0||fort3==0) then 
					{
						player removeAction fortAction;
					};
				}else
				{
					if(fort1==0)then{[player,f1] call BIS_fnc_holdActionRemove;};
					if(fort2==0)then{[player,f2] call BIS_fnc_holdActionRemove;};
					if(fort3==0)then{[player,f3] call BIS_fnc_holdActionRemove;};
					fort = 0;
				};
				if (carUsed==0) then {player removeAction carAction;};
				if (truckUsed==0) then {player removeAction truckAction;};
				if (boatTrUsed==0) then {player removeAction BoatTrAction;};		
				if (boatArUsed==0 && boatsAr==1) then {player removeAction BoatArAction;};
				
			};
		};
		
		[player, SupReq] remoteExec ["BIS_fnc_removeSupportLink", 0, false];
		LDRaction = player addAction 
		[
			"Become Squad leader", //title
			{
				//condition: if squad leader is controled by any player
				if (isPlayer leader player) then
				{
					//leader is not changed, hint is displayed
					hint "Command is available only if squad leader is controled by an AI";
				} else
				//if squad leader is controled by an AI code is executed
				{
					//player become leader of his group
					[group player, player] remoteExec ["selectLeader", 0, false];
					player removeAction LDRaction;
					_ldr = profileName;
					_grp = group player;
					[_ldr,_grp] remoteExec ["wrm_fnc_leaderHint", 0, false];
					sleep 0.5;
					lUpdate = 2;
					[] spawn wrm_fnc_leaderActions;
				};	
			}, //script
			nil, 0, false, true, "", "", -1, false, "" //arguments, priority, showWindow, hideOnUse, shortcut, condition, radius, unconscious, selection
		]; 
		lUpdate = 2;
	};
};