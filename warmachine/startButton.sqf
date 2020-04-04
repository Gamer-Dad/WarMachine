/*
	Author: IvosH
	
	Description:
		Script executed when Start button is pressed. Start creating the mission (run start.sqf).
		
	Parameter(s):
		dialog selections
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\startButton.sqf";
*/

//LOCAL VARIABLES: saves dialog selections-------------------------------------------LOCAL//
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

//control of DIALOG selections
if (progress >= 1) exitWith {};
if (aoType!=0 && AOcreated==0) exitWith {hint parseText format ["SELECT AREA OF OPERATION<br/><br/>Press button SELECT AREA OF OPERATION and select a position on the map"];};
if (aoType!=0 && minDis==500 && missType!=1) exitWith {hint parseText format ["Mission type was changed<br/><br/>Select INFANTRY MISSION<br/>in the Mission type menu<br/>or SELECT AREA OF OPERATION again"]};
if (aoType!=0 && minDis==600 && missType!=2) exitWith {hint parseText format ["Mission type was changed<br/><br/>Select COMBINED GROUND FORCES<br/>in the Mission type menu<br/>or SELECT AREA OF OPERATION again"]};
if (aoType!=0 && minDis==700 && missType!=3) exitWith {hint parseText format ["Mission type was changed<br/><br/>Select FULL SPECTRUM WARFARE<br/>in the Mission type menu<br/>or SELECT AREA OF OPERATION again"]};
if (aoType!=0 && secNo==0 && bExist==1) exitWith {hint parseText format ["Number of sectors was changed<br/><br/>Change number of sectors in the menu to 2 or 3<br/>or SELECT AREA OF OPERATION again"]};
if (aoType!=0 && secNo>0 && bExist==0) exitWith {hint parseText format ["Number of sectors was changed<br/><br/>Change number of sectors in the menu to 1<br/>or SELECT AREA OF OPERATION again"]};

progress = 1;  publicVariable "progress";
//close dialog window
[0] remoteExec ["closeDialog", 0, false]; //closeDialog 0;

if ("param2" call BIS_fnc_getParamValue > 0) then 
{ 
	for "_i" from 10 to 0 step -1 do //loop 10
	{
		[parseText format ["Mission started by %1<br/>START IN %2<br/><br/>(Close virtual arsenal to save your loadout)",profileName, _i]] remoteExec ["hint", 0, false];
		sleep 1;
	};
} else
{
	for "_i" from 10 to 0 step -1 do //loop
	{
		[parseText format ["Mission started by %1<br/>START IN %2",profileName, _i]] remoteExec ["hint", 0, false];
		sleep 1;
	};
};

[""] remoteExec ["hint", 0, false];
[["CREATING MISSION", "BLACK", 3]] remoteExec ["titleText", 0, false];
sleep 3;

[[posCenter, posAlpha, dirAB, posBravo, dirBA, posCharlie, posFobWest, dirCenFobWest, posFobEast, dirCenFobEast, posBaseWest, dirCenBaseWest, posBaseEast, dirCenBaseEast, cExist, AOcreated, missType, day, secNo, weather, support, fogLevel, resType, resTime, resTickets, vehTime, aoType, minDis, AIon, revOn, viewType, ticBleed, timeLim], "warmachine\start.sqf"] remoteExec ["execVM", 0, false];