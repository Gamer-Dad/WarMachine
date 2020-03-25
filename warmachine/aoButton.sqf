/*
	Author: IvosH
	
	Description:
		Script executed when SELECT AREA OF OPERATION button is pressed
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\aoButton.sqf";
*/

//LOCAL VARIABLES: saves dialog selections
missType = lbCurSel 311;
day = lbCurSel 312;
secNo = lbCurSel 321;
weather = lbCurSel 322;
support = lbCurSel 331;
fogLevel = lbCurSel 332;
AIon = lbCurSel 341;
resType = lbCurSel 342;
revOn = lbCurSel 351;
resTickets = lbCurSel 352;
viewType = lbCurSel 361;
ticBleed = lbCurSel 362;
timeLim = lbCurSel 371;
resTime = lbCurSel 372;
aoType = lbCurSel 381;
vehTime = lbCurSel 382;
//enable loading of dialog selections
dSel = 1;

if (aoType == 0) exitWith 
{
	hint parseText format ["if you want to select AO position, please select different option from the drop-down menu<br /><br />Select AO<br />Create AO"];
};

//close dialog window
closeDialog 0;
//open map
openMap [true, false];

waitUntil {dSel == 1;};

call
{
	if (lbCurSel 381 == 1) exitWith 
	{
		[] execVM "warmachine\selectAO.sqf";
		waitUntil {!visibleMap};
		["AOselect", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		if (AOcreated == 1) then {hint "AO was selected";} else {hint "AO wasn't selected";};
		dialogOpen = createDialog "missionsGenerator";
	};
	if (lbCurSel 381 == 2) exitWith 
	{
		[] execVM "warmachine\createAO.sqf";
		waitUntil {!visibleMap};
		if (aCreated == 0) then
		{
			["createA", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
		};
		if (AOcreated == 1) then {hint "AO was created";} else {hint "AO wasn't created";};
		dialogOpen = createDialog "missionsGenerator";	
	};
};