/*
	[("autoStart" call BIS_fnc_getParamValue)] execVM "warmachine\autoStart.sqf"
*/
_a = _this select 0;
if !(isServer) exitWith {}; //runs on the server/host
aStart=1; publicVariable "aStart";
//wait until any player conect
_t=0;
while {_t==0} do
{
	{
		if(count allPlayers == 0)exitWith{};
		_t=1;
	} forEach allPlayers;
	sleep 1;
};
//JIP
_j=0;
while {_j==0} do
{
	{
		if(isNull _x)exitWith{};
		_j=1;
	} forEach allPlayers;
	sleep 1;
};
//player has respawned
_p=0;
while {_p==0} do
{
	{
		if(!alive _x)exitWith{};
		_p=1;
	} forEach allPlayers;
	sleep 1;
};
sleep 5;
_tx1="";
call
{
	if("param1" call BIS_fnc_getParamValue == 2)exitWith{_tx1="<br/><br/>Or you can create your own mission in the <br/>MISSION GENERATOR<br/>(actions menu)<br/><br/>STOP COUNTDOWN<br/>(actions menu)";}; //2
	if(serverCommandAvailable "#kick")exitWith{_tx1="<br/><br/>Or you can create your own mission in the <br/>MISSION GENERATOR<br/>(actions menu)<br/><br/>STOP COUNTDOWN<br/>(actions menu)";}; //0
	if(("param1" call BIS_fnc_getParamValue == 1)&&(count(allPlayers - entities "HeadlessClient_F")==1))exitWith{_tx1="<br/><br/>Or you can create your own mission in the <br/>MISSION GENERATOR<br/>(actions menu)<br/><br/>STOP COUNTDOWN<br/>(actions menu)";}; //1
};
if (_a==1) then
{
	if (aStart==0) exitWith {};
	if (progress>0) exitWith {};
	[parseText format ["Mission will start in 3 min. automatically%1",_tx1]] remoteExec ["hint", 0, false];
	sleep 60;
	if (aStart==0) exitWith {};
	if (progress>0) exitWith {};
	[parseText format ["Mission will start in 2 min. automatically%1",_tx1]] remoteExec ["hint", 0, false];
	sleep 60;
	if (aStart==0) exitWith {};
	if (progress>0) exitWith {};
	[parseText format ["Mission will start in 1 min. automatically%1",_tx1]] remoteExec ["hint", 0, false];
	sleep 60;
	if (aStart==0) exitWith {};
	if (progress>0) exitWith {};
};
if (aStart==0) exitWith {["Countdown canceled"] remoteExec ["hint", 0, false];};
if (progress>0) exitWith {};
//close dialog window
[0] remoteExec ["closeDialog", 0, false]; //closeDialog 0;
//countdown
for "_i" from 10 to 0 step -1 do //loop 10
{
	[parseText format ["MISSION START IN %1%2", _i,_tx1]] remoteExec ["hint", 0, false];
	sleep 1;
};
if (aStart==0) exitWith {["Countdown canceled"] remoteExec ["hint", 0, false];};
if (progress>0) exitWith {};
progress = 1;  publicVariable "progress";
[""] remoteExec ["hint", 0, false];
[["CREATING MISSION", "BLACK", 3]] remoteExec ["titleText", 0, false];
sleep 3;

posCenter=[]; 
posAlpha=[]; 
dirAB=[]; 
posBravo=[];  
dirBA=[];  
posCharlie=[]; 
posFobWest=[]; 
dirCenFobWest=[]; 
posFobEast=[]; 
dirCenFobEast=[]; 
posBaseWest=[]; 
dirCenBaseWest=[]; 
posBaseEast=[]; 
dirCenBaseEast=[];
cExist=0, 
AOcreated=0,
aoType=0; //AO selection method
minDis = 500; //500 zakladní délka

missType=("asp1" call BIS_fnc_getParamValue); //Mission type
if (missType == 0) then {missType = selectRandom [1,2,3]};
call
{
	if (missType==1) exitWith {minDis = 500;}; 
	if (missType==2) exitWith {minDis = 600;};
	if (missType==3) exitWith {minDis = 700;}; 
};
secNo=("asp2" call BIS_fnc_getParamValue); //Number of sectors
support=("asp3" call BIS_fnc_getParamValue); //Combat support
ticBleed=("asp4" call BIS_fnc_getParamValue); //Ticket bleed
AIon=("asp5" call BIS_fnc_getParamValue); //Autonomous AI
timeLim=("asp6" call BIS_fnc_getParamValue); //Time limit
day=("asp7" call BIS_fnc_getParamValue); //Time of day
weather=("asp8" call BIS_fnc_getParamValue); //Weather
fogLevel=("asp9" call BIS_fnc_getParamValue); //Fog
viewType=("asp10" call BIS_fnc_getParamValue); //3rd person view
revOn=("asp11" call BIS_fnc_getParamValue); //Revive
resType=("asp12" call BIS_fnc_getParamValue); //Respawn type
resTickets=("asp13" call BIS_fnc_getParamValue); //Respawn tickets
resTime=("asp14" call BIS_fnc_getParamValue); //Player respawn time
vehTime=("asp15" call BIS_fnc_getParamValue); //Vehicles respawn time

[[posCenter, posAlpha, dirAB, posBravo, dirBA, posCharlie, posFobWest, dirCenFobWest, posFobEast, dirCenFobEast, posBaseWest, dirCenBaseWest, posBaseEast, dirCenBaseEast, cExist, AOcreated, missType, day, secNo, weather, support, fogLevel, resType, resTime, resTickets, vehTime, aoType, minDis, AIon, revOn, viewType, ticBleed, timeLim], "warmachine\start.sqf"] remoteExec ["execVM", 0, false];