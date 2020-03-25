/*
	Author: IvosH

	Description:
		Controls tickets bleed

	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		
	Execution:
		[] spawn wrm_fnc_ticketBleed;
*/
if !( isServer ) exitWith {}; //run on the dedicated server or server host
for "_i" from 0 to 1 step 0 do 
{
	call
	{
		if (progress == 2) exitWith //captured sectors
		{
			if(ticBleed>0) then
			{
				_secW=0;_secE=0;_tic=0;
				if(getMarkerColor resAW!="")then{_secW=_secW+1;};
				if(getMarkerColor resBW!="")then{_secW=_secW+1;};
				if(getMarkerColor resCW!="")then{_secW=_secW+1;};
				if(getMarkerColor resAE!="")then{_secE=_secE+1;};
				if(getMarkerColor resBE!="")then{_secE=_secE+1;};
				if(getMarkerColor resCE!="")then{_secE=_secE+1;};
				if(_secW==_secE)exitWith{};
				if(_secW>_secE)then{[sideE,((_secW-_secE)*-1)] call BIS_fnc_respawnTickets;}else{[sideW,((_secE-_secW)*-1)] call BIS_fnc_respawnTickets;};
				sleep 11; //11
			};
		};

		if (progress == 4) exitWith //FOB captured by attackers
		{
			if ([sideA] call BIS_fnc_moduleSector > (noSA)) then {[sideD, -1] call BIS_fnc_respawnTickets;};
			sleep 3;
		};
	};
};
