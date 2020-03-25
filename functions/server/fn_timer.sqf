/*
	Author: IvosH
	
	Description:
		Game time limit, countdown. timer: 0= disabled, 1= 45 minutes, 2= 60 minutes, 3= 75 minutes, 4= 90 minutes
		
	Parameter(s):
		NONE
		
	Returns:
		BOOL
		
	Dependencies:
		timerStart.sqf
		
	Execution:
		timer=[]spawn wrm_fnc_timer;


*/

if !( isServer ) exitWith {}; //run on the dedicated server or server host
if (progress>4) exitWith {};

if (timeLim>3) then {["The game ends in 90 minutes"] remoteExec ["hint", 0, false]; sleep 900;}; //900
if (progress>4) exitWith {};

if (timeLim>2) then {["The game ends in 75 minutes"] remoteExec ["hint", 0, false]; sleep 900;}; //900
if (progress>4) exitWith {};

if (timeLim>1) then {["The game ends in 60 minutes"] remoteExec ["hint", 0, false]; sleep 900;}; //900
if (progress>4) exitWith {};

if (timeLim>0) then {["The game ends in 45 minutes"] remoteExec ["hint", 0, false]; sleep 900;}; //900
if (progress>4) exitWith {};

["The game ends in 30 minutes"] remoteExec ["hint", 0, false]; sleep 600; //600
if (progress>4) exitWith {};

["The game ends in 20 minutes"] remoteExec ["hint", 0, false]; sleep 600; //600
if (progress>4) exitWith {};

["The game ends in 10 minutes"] remoteExec ["hint", 0, false]; sleep 300; //300
if (progress>4) exitWith {};

["The game ends in 5 minutes"] remoteExec ["hint", 0, false]; sleep 240; //240
if (progress>4) exitWith {};

["The game ends in 1 minute"] remoteExec ["hint", 0, false]; sleep 60; //60
if (progress>4) exitWith {};

if(progress==2)then
{
	progress = 5; publicVariable "progress";
	_restW = [sideW] call BIS_fnc_respawnTickets; 
	_restE = [sideE] call BIS_fnc_respawnTickets;
	call
	{
		if (_restW == _restE) exitWith
		{
			[sideW,(_restE*-1)] call BIS_fnc_respawnTickets; 
			[sideE,(_restE*-1)] call BIS_fnc_respawnTickets;
			"End4" call BIS_fnc_endMissionServer;
		};
		if (_restW > _restE) exitWith 
		{
			[sideW,(_restE*-1)] call BIS_fnc_respawnTickets; 
			[sideE,(_restE*-1)] call BIS_fnc_respawnTickets;
			endW call BIS_fnc_endMissionServer;
		};
		if (_restE > _restW) exitWith 
		{
			[sideW,(_restW*-1)] call BIS_fnc_respawnTickets; 
			[sideE,(_restW*-1)] call BIS_fnc_respawnTickets;
			endE call BIS_fnc_endMissionServer;
		};
	};
};

if(progress==3||progress==4)then
{
	progress = 5; publicVariable "progress";
	_restA = [sideA] call BIS_fnc_respawnTickets; 
	_restD = [sideD] call BIS_fnc_respawnTickets;
	call
	{
		if (_restA == _restD) exitWith
		{
				[sideA,(_restD*-1)] call BIS_fnc_respawnTickets; 
				[sideD,(_restD*-1)] call BIS_fnc_respawnTickets;
				endA call BIS_fnc_endMissionServer;
		};
		if (_restA > _restD) exitWith 
		{
			[sideA,(_restD*-1)] call BIS_fnc_respawnTickets; 
			[sideD,(_restD*-1)] call BIS_fnc_respawnTickets;
			endA call BIS_fnc_endMissionServer;
		};
		if (_restD > _restA) exitWith 
		{
			[sideA,(_restA*-1)] call BIS_fnc_respawnTickets; 
			[sideD,(_restA*-1)] call BIS_fnc_respawnTickets;
			endD call BIS_fnc_endMissionServer;
		};
	};
};
true;