/*
	Author: IvosH
	
	Description:
		Add actions to the flags. Teleports between flags
	
	Parameter(s):
		0: OBJECT, flgFobW
		1: OBJECT, flgBaseW
		2: OBJECT, flgJetW
		3: OBJECT, flgFobE
		4: OBJECT, flgBaseE
		5: OBJECT, flgJetE
		5: VARIABLE, missType
	
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		
	Execution:
		[flgFobW,flgBaseW,flgJetW,flgFobE,flgBaseE,flgJetE,missType] remoteExec ["wrm_fnc_flagActions", 0, true];
		[flgFobW,flgBaseW,flgJetW,flgFobE,flgBaseE,flgJetE,missType] call wrm_fnc_flagActions;
*/

if (!hasInterface) exitWith {}; //run on the players only

flgFobW = _this select 0;
flgBaseW = _this select 1;
flgJetW = _this select 2;
flgFobE = _this select 3;
flgBaseE = _this select 4;
flgJetE = _this select 5;
missType = _this select 6;
_flgs = [];
_act = [];

call
{
	if (side player == sideW) exitWith 
	{
		_flgs = [flgBaseW,flgFobW];
		_act = //[title, script, priority, condition],
		[
			["Teleport at the BASE",
			{
				if(player==leader player)then
				{
					_grp=[player];
					{if(((_x distance player)<50)&&(!isPlayer _x))then{_grp pushBackUnique _x;};}forEach units group player;
					{_x setPos (flgBaseW getRelPos [random [3,6,9],random [135,180,225]]);}forEach _grp;
				}
				else{player setPos (flgBaseW getRelPos [3,180]);};
			},6,""],
			["Teleport at the FOB",
			{
				if(player==leader player)then
				{
					_grp=[player];
					{if(((_x distance player)<50)&&(!isPlayer _x))then{_grp pushBackUnique _x;};}forEach units group player;
					{_x setPos (flgFobW getRelPos [random [3,6,9],random [135,180,225]]);}forEach _grp;
				}
				else{player setPos (flgFobW getRelPos [3,180]);};
			},5.5,"(flgDel==0||sideA == sideW)"]
		];
		if ((planes==1)||((planes==2)&&(plHW==plH1||plHW==plH2)&&(plHe==plH1||plHe==plH2))) then 
		{
			if (missType == 3) then 
			{
				_flgs pushBack flgJetW;
				_act pushBack ["Teleport at the Runway",{player setPos (flgJetW getRelPos [3,180]);},5,""];
			};
		};
	};
	
	if (side player == sideE) exitWith 
	{
		_flgs = [flgBaseE,flgFobE];
		_act = //[title, script, priority, condition],
		[
			["Teleport at the BASE",
			{
				if(player==leader player)then
				{
					_grp=[player];
					{if(((_x distance player)<50)&&(!isPlayer _x))then{_grp pushBackUnique _x;};}forEach units group player;
					{_x setPos (flgBaseE getRelPos [random [3,6,9],random [135,180,225]]);}forEach _grp;
				}
				else{player setPos (flgBaseE getRelPos [3,180]);};
			},6,""],
			["Teleport at the FOB",
			{
				if(player==leader player)then
				{
					_grp=[player];
					{if(((_x distance player)<50)&&(!isPlayer _x))then{_grp pushBackUnique _x;};}forEach units group player;
					{_x setPos (flgFobE getRelPos [random [3,6,9],random [135,180,225]]);}forEach _grp;
				}
				else{player setPos (flgFobE getRelPos [3,180]);};
			},5.5,"(flgDel==0||sideA == sideE)"]
		];
		if ((planes==1)||((planes==2)&&(plHW==plH1||plHW==plH2)&&(plHe==plH1||plHe==plH2))) then 
		{
			if (missType == 3) then 
			{
				_flgs pushBack flgJetE;
				_act pushBack ["Teleport at the Runway",{player setPos (flgJetE getRelPos [3,180]);},5,""];
			};
		};
	};
};

{
	_flg = _x;
	_indx = _forEachIndex; 
	{
		_flg addAction [
		_x select 0, //title
		_x select 1, //script
		nil, //arguments (Optional)
		_x select 2, //priority (Optional)
		true, //showWindow (Optional)
		true, //hideOnUse (Optional)
		"", //shortcut, (Optional) 
		_x select 3, //condition,  (Optional)
		5, //radius, (Optional)
		false, //unconscious, (Optional)
		""]; //selection]; (Optional)
	} forEach _act - [_act select _indx];
} forEach _flgs;