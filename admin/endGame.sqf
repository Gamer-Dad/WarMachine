//terminates the mission
closeDialog 0;
if (progress<2) exitWith {hint "Hey buddy, start the mission first";};

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