//Author: IvosH

//variables setup
lUpdate = 0;
airDrop=0;
fort = 0;

//respawn at the sector, random position around the sector
if (progress>1) then 
{
	if (resType>0) then
	{
		sleep 0.015;
		_r=0;
		if((player distance posAlpha)<50)then{_r=1;};
		if(secNo>0)then{if((player distance posBravo)<50)then{_r=2;};};
		if(secNo>1)then{if((player distance posCharlie)<50)then{_r=3;};};
		if(_r==0)exitWith{};
		_posR=[];
		call
		{
			if(_r==1)exitWith{if(side player==sideW)then{_posR=RpAw;}else{_posR=RpAe;};};
			if(_r==2)exitWith{if(side player==sideW)then{_posR=RpBw;}else{_posR=RpBe;};};
			if(_r==3)exitWith{if(side player==sideW)then{_posR=RpCw;}else{_posR=RpCe;};};
		};
		player setVehiclePosition [(selectRandom _posR), [], 0, "NONE"];
	};
};

//add action to the action menu (Mission generator)
if (progress < 1) then
{
	if (serverCommandAvailable "#kick" || "Param1" call BIS_fnc_getParamValue == 1||(count(allPlayers - entities "HeadlessClient_F")==1)) then
	{
		MGaction = player addAction 
		[
			"Open Mission generator", //title
			{
				if (progress < 1) then {dialogOpen = createDialog "missionsGenerator"};
			}, //script
			nil, //arguments (Optional)
			6, //priority (Optional)
			true, //showWindow (Optional)
			true, //hideOnUse (Optional)
			"", //shortcut, (Optional) 
			"", //condition,  (Optional)
			-1, //radius, (Optional)
			false, //unconscious, (Optional)
			"" //selection]; (Optional)
		]; 
	};
};

sleep 1;
[] spawn wrm_fnc_leaderActions;

flipAction = player addAction 
[
	"Flip vehicle", //title
	{[] spawn wrm_fnc_flipVeh;}, //script 
	nil, 6, true, true, "", //arguments, priority, showWindow, hideOnUse, shortcut, 
	"(cursorTarget isKindOf ""LandVehicle"")&&(cursorTarget distance player<7)&&(vectorUP cursorTarget select 2 < 0.95)", //condition,
	-1, false, "" //radius, unconscious, selection
];

pushAction = player addAction 
[
	"Push boat", //title
	{[] spawn wrm_fnc_pushVeh;}, //script
	nil, 6, true, true, "", //arguments, priority, showWindow, hideOnUse, shortcut,
	"(cursorTarget isKindOf ""ship"") && (cursorTarget distance player<7) && ((getPos _target isFlatEmpty  [-1, -1, -1, -1, 2, false] isEqualTo [])||(getPosAtl _target select 2 < 0.2))", //condition,
	-1, false, "" //radius, unconscious, selection
];

if !(isPlayer leader player) then 
{
	if (progress>1) then
	{
		if (AIon==0)
		then {hint parseText format ["BECOME SQUAD LEADER<br/>(actions menu)<br/><br/>AI units need to be led by the player. Squad will follow you. Allows access to: Squad command | Artillery | CAS | Supply drop | Boat transport | Build fortifications"];}
		else {hint parseText format ["BECOME SQUAD LEADER<br/>(actions menu)<br/><br/>Recommended. Squad will follow you. Allows access to: Squad command | Artillery | CAS | Supply drop | Boat transport | Build fortifications"];};
	} else {hint parseText format ["BECOME SQUAD LEADER<br/>(actions menu)<br/><br/>Recommended. Squad will follow you. Allows access to: Squad command | Artillery | CAS | Supply drop | Boat transport | Build fortifications"];};
};
if ("Param2" call BIS_fnc_getParamValue == 1) then{[] call wrm_fnc_arsenal;};
[player] spawn wrm_fnc_equipment;
