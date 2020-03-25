/*
Run this in the serverInit.sqf
execVM "warmachine\autoStart.sqf"
*/
if !(isServer) exitWith {}; //runs on the server/host
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

sleep 30;
if (progress>0) exitWith {};
[parseText format ["Mission will start in 3 min. automatically<br/><br/>Or you can create your own mission in the <br/>MISSION GENERATOR<br/>(actions menu)"]] remoteExec ["hint", 0, false];
sleep 60;
if (progress>0) exitWith {};
[parseText format ["Mission will start in 2 min. automatically<br/><br/>Or you can create your own mission in the <br/>MISSION GENERATOR<br/>(actions menu)"]] remoteExec ["hint", 0, false];
sleep 60;
if (progress>0) exitWith {};
[parseText format ["Mission will start in 1 min. automatically<br/><br/>Or you can create your own mission in the <br/>MISSION GENERATOR<br/>(actions menu)"]] remoteExec ["hint", 0, false];
sleep 60;
if (progress>0) exitWith {};

//close dialog window
[0] remoteExec ["closeDialog", 0, false]; //closeDialog 0;
//countdown
for "_i" from 10 to 0 step -1 do //loop 10
{
	[parseText format ["MISSION START IN %1", _i]] remoteExec ["hint", 0, false];
	sleep 1;
};
if (progress>0) exitWith {};
progress = 1;  publicVariable "progress";
[""] remoteExec ["hint", 0, false];
[["CREATING MISSION", "BLACK", 3]] remoteExec ["titleText", 0, false];
sleep 3;

[[
[], //posCenter, 
[], //posAlpha, 
[], //dirAB, 
[], //posBravo, 
[], //dirBA, 
[], //posCharlie, 
[], //posFobWest, 
[], //dirCenFobWest, 
[], //posFobEast, 
[], //dirCenFobEast, 
[], //posBaseWest, 
[], //dirCenBaseWest, 
[], //posBaseEast, 
[], //dirCenBaseEast, 
0, //cExist, 
0, //AOcreated, 
2, //missType, (if (missType==0) then {minDis = 500;}; missType/minDis, 0/500, 1/600, 2/700)
0, //day, 
2, //secNo, 
0, //weather, 
0, //support, 
0, //fogLevel, 
2, //resType, 
1, //resTime, 
0, //resTickets, 
2, //vehTime, 
0, //aoType, 
700, //minDis, (if (missType==0) then {minDis = 500;}; missType/minDis, 0/500, 1/600, 2/700)
3, //AIon, 
0, //revOn, 
1, //viewType, 
1, //ticBleed, 
0 //timeLim
], "warmachine\start.sqf"] remoteExec ["execVM", 0, false];