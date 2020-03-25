/*
Author: IvosH

Description:
	Add actions to build fortification
	
Parameter(s):
	none
	
Returns:
	nothing
	
Dependencies:
	fn_leaderActions.sqf
	
Execution:
	[] call wrm_fnc_fortification
*/

if(progress<2)exitWith{};

f1=[
	player, //target
	"+ Sandbags barricade high", //title
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", //idleIcon
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", //progressIcon
	"player==leader player&&fort1==0", //conditionShow
	"true", //conditionProgress
	{hint"Sandbags barricade will be build 2m in front of you";}, //codeStart
	{}, //codeProgress
	{
		_posZ = getPosAtl player;
		_bag = createVehicle ["Land_SandbagBarricade_01_hole_F", (player getRelPos [1.8, 0]), [], 0, "CAN_COLLIDE"]; //1.6
		_bag setDir (getDir player);
		_bag setPos [(getPos _bag select 0),(getPos _bag select 1),(_posZ select 2)];
		fort1 = 1;
		hint"Good job soldier";
	}, //codeCompleted
	{}, //codeInterrupted
	[], //arguments
	6, //duration
	0.3, //priority
	true, //removeCompleted
	false //showUnconscious
] call BIS_fnc_holdActionAdd;

f2=[
	player, //target
	"+ Sandbags fence low", //title
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", //idleIcon
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", //progressIcon
	"player==leader player&&fort2==0", //conditionShow
	"true", //conditionProgress
	{hint"Sandbags fence will be build 2m around you";}, //codeStart
	{}, //codeProgress
	{
		_posZ = getPosAtl player;
		_bag = createVehicle ["Land_BagFence_Round_F", (player getRelPos [1.9, 45]), [], 0, "CAN_COLLIDE"];
		_bag setDir ((getDir player)+225);
		_bag setPos [(getPos _bag select 0),(getPos _bag select 1),((_posZ select 2) - 0.1)];
		if(((getPos player)select 2)==((getPosAtl player)select 2))then{_bag setVectorUp surfaceNormal getPos _bag;};
			
		_bag = createVehicle ["Land_BagFence_Round_F", (player getRelPos [1.9, 315]), [], 0, "CAN_COLLIDE"];
		_bag setDir ((getDir player)+135);
		_bag setPos [(getPos _bag select 0),(getPos _bag select 1),((_posZ select 2) - 0.1)];
		if(((getPos player)select 2)==((getPosAtl player)select 2))then{_bag setVectorUp surfaceNormal getPos _bag;};
		
		fort2 = 1;
		hint"Good job soldier";
	}, //codeCompleted
	{}, //codeInterrupted
	[], //arguments
	6, //duration
	0.2, //priority
	true, //removeCompleted
	false //showUnconscious
] call BIS_fnc_holdActionAdd;

f3=[
	player, //target
	"+ Razorwire fence", //title
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", //idleIcon
	"\a3\ui_f\data\IGUI\Cfg\holdactions\holdAction_connect_ca.paa", //progressIcon
	"player==leader player&&fort3==0", //conditionShow
	"true", //conditionProgress
	{hint"Razorwire fence will be build 2m in front of you";}, //codeStart
	{}, //codeProgress
	{
		_posZ = getPosAtl player;
		_bag = createVehicle ["Land_razorwire_F", (player getRelPos [3, 0]), [], 0, "CAN_COLLIDE"];
		_bag setDir (getDir player);
		_bag setPos [(getPos _bag select 0),(getPos _bag select 1),(_posZ select 2)];
		if(((getPos player)select 2)==((getPosAtl player)select 2))then{_bag setVectorUp surfaceNormal getPos _bag;};
		fort3 = 1;
		hint"Good job soldier";
	}, //codeCompleted
	{}, //codeInterrupted
	[], //arguments
	6, //duration
	0.1, //priority
	true, //removeCompleted
	false //showUnconscious
] call BIS_fnc_holdActionAdd;