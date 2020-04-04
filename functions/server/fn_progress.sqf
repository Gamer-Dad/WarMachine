/*
	Author: IvosH
	
	Description:
		Control game progress.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		
	Execution:
		[] spawn wrm_fnc_progress;
*/
if !( isServer ) exitWith {}; //run on the dedicated server or server host

if (progress == 2) then //fight for SECTORS
{
	call 
	{
		if([sideW] call BIS_fnc_respawnTickets<=0 && [sideE] call BIS_fnc_respawnTickets<=0)exitWith
		{"End4" call BIS_fnc_endMissionServer; progress = 5; publicVariable "progress";};
		if ([sideE] call BIS_fnc_respawnTickets<=0) exitWith //WEST ATTACKS
		{
			posF = posFobEast; publicVariable "posF"; ownerF = numE; nameF = fobE; taskF = taskE; 
			sideA = sideW; sideD = sideE; factionA = factionW; factionD = factionE; endA = endW; endD = endE; 
			noSA = [sideW] call BIS_fnc_moduleSector; noSD = [sideE] call BIS_fnc_moduleSector; 
			resFobA = resFobW; resFobD = resFobE; resBaseA = resBaseW; resBaseD = resBaseE; flgD = flgFobE; 
			publicVariable "taskF"; progress = 3; publicVariable "progress";
			deleteMarker resAE; deleteMarker resBE; deleteMarker resCE;
		};
		if ([sideW] call BIS_fnc_respawnTickets<=0) exitWith //EAST ATTACKS
		{
			posF = posFobWest; publicVariable "posF"; ownerF = numW; nameF = fobW; taskF = taskW;
			sideA = sideE; sideD = sideW; factionA = factionE; factionD = factionW; endA = endE; endD = endW; 
			noSA = [sideE] call BIS_fnc_moduleSector; noSD = [sideW] call BIS_fnc_moduleSector;
			resFobA = resFobE; resFobD = resFobW; resBaseA = resBaseE; resBaseD = resBaseW; flgD = flgFobW; 
			publicVariable "taskF"; progress = 3; publicVariable "progress";
			deleteMarker resAW; deleteMarker resBW; deleteMarker resCW;
		};
	};
	
	waitUntil {progress == 3;};
	//delete sectors
	deleteVehicle sectorA;
	if (secNo>0) then {deleteVehicle sectorB;};
	if (secNo>1) then {deleteVehicle sectorC;};
	
	//CREATE NEW SECTOR
	"ModuleSector_F" createUnit [posF,createGroup sideLogic,format
	["
		sectorF=this;
		this setvariable ['BIS_fnc_initModules_disableAutoActivation',false];
		this setVariable ['name',nameF];
		this setVariable ['Designation','F'];
		this setVariable ['OwnerLimit','1'];
		this setVariable ['OnOwnerChange','[] call wrm_fnc_aiMove;'];
		this setVariable ['CaptureCoef','0.05']; 	
		this setVariable ['CostInfantry','0.2'];
		this setVariable ['CostWheeled','0.2'];
		this setVariable ['CostTracked','0.2'];
		this setVariable ['CostWater','0.2'];
		this setVariable ['CostAir','0.2'];
		this setVariable ['CostPlayers','0.2'];
		this setVariable ['DefaultOwner','-1'];
		this setVariable ['TaskOwner','3'];
		this setVariable ['TaskTitle',nameF];
		this setVariable ['taskDescription',taskF];
		this setVariable ['ScoreReward','0'];
		this setVariable ['Sides',[sideE,sideW]];
		this setVariable ['objectArea',[50,50,0,false ]];
	"]];

	//reset tickets for both sides
	if (resTickets == 0) then 
	{	
		_unitsNo = 0;
		_groups = [];
		if (resTickets == 0) then 
		{	
			if(AIon>0)then
			{
				{_groups pushBackUnique group _x} forEach playableUnits;
				{_unitsNo = _unitsNo + (count units _x)} forEach _groups;
				_unitsNo = _unitsNo + (count allPlayers);
			}else
			{
				{_groups pushBackUnique group _x} forEach allPlayers;
				{_unitsNo = _unitsNo + (count units _x)} forEach _groups;
				_unitsNo = _unitsNo + (count allPlayers);
			};
		};
		if (_unitsNo > 16)
		then {tic = round (_unitsNo*3);} 
		else {tic = 50;};
		if (AIon==3||Aion==5)then
		{
			_n=3;
			if(missType==3)then{_n=4;};
			call
			{
				if(vehTime==0)exitWith{tic=tic+(60*_n);};
				if(vehTime==1)exitWith{tic=tic+(30*_n);};
				if(vehTime==2)exitWith{tic=tic+(10*_n);};
				if(vehTime==3)exitWith{tic=tic+(6*_n);};
				if(vehTime==4)exitWith{tic=tic+(3*_n);};
			};
		};
		
	};
	_restW = [sideA] call BIS_fnc_respawnTickets; 
	_restE = [sideD] call BIS_fnc_respawnTickets;
	[sideA, (tic - _restW)] call BIS_fnc_respawnTickets; //Attackers have advantage
	[sideD, ((tic*0.5) - _restE)] call BIS_fnc_respawnTickets;

	[sectorF, sideD] call BIS_fnc_moduleSector; //initialize sector
	["mFob"] remoteExec ["deleteMarkerLocal", 0, true]; //delete local marker for FOB

	publicVariable "sideA";
	publicVariable "sideD";
	publicVariable "factionA";
	publicVariable "factionD";
	publicVariable "resBaseA";
	publicVariable "resFobA";
	publicVariable "resAo";
	publicVariable "resBaseD";
	
	//create tank at the FOB
	if(AIon>1)then
	{
		//create tank at the FOB
		_plw=sideW countSide allPlayers;
		_ple=sideE countSide allPlayers;
		call
		{		
			if((_plw>0)&&(_ple>0))exitWith{coop=0;publicvariable "coop";}; //PvP
			if((_plw==0)&&(_ple==0))exitWith{if(sideD==sideW)then{coop=2;}else{coop=1;};publicvariable "coop";}; //no players
			if(_plw>0)exitWith{coop=1; publicvariable "coop";};
			if(_ple>0)exitWith{coop=2; publicvariable "coop";};

		};
		
		if(sideD==sideW && coop==2)
		then
		{
			if((AIon==3||AIon==4||AIon==6||AIon==7)&&(alive (leader gApcW))&&((vehicle leader gApcW)!=(leader gApcW)))exitWith{};
			_types=[];
			if(missType>1)
			then{_types = selectRandom [ArmorW1,ArmorW2];}
			else{_types = CarArW;};
			
			_type = selectRandom _types; _typ=""; _tex="";
			if (_type isEqualType [])then{_typ=_type select 0;_tex=_type select 1;}else{_typ=_type;};
			_posV = posF findEmptyPosition [20, 70, _typ];
			if(count _posV==0)then{_posV = objectFobWest getRelPos [30, random 360];};
			_veh = createVehicle [_typ, _posV, [], 0, "NONE"];
			[_veh,[_tex,1]] call bis_fnc_initVehicle;
			createVehicleCrew _veh;
			z1 addCuratorEditableObjects [[_veh],true];
			_veh setdir (_veh getdir posCenter);
			gApcD = group driver _veh;
			AIapcD=1; publicvariable "AIapcD";
		};
		
		if(sideD==sideE && coop==1)
		then
		{
			if((AIon==3||AIon==4||AIon==6||AIon==7)&&(alive (leader gApcE))&&((vehicle leader gApcE)!=(leader gApcE)))exitWith{};
			_types=[];
			if(missType>1)
			then{_types = selectRandom [ArmorE1,ArmorE2];}
			else{_types = CarArE;};
			
			_type = selectRandom _types; _typ=""; _tex="";
			if (_type isEqualType [])then{_typ=_type select 0;_tex=_type select 1;}else{_typ=_type;};
			_posV = posF findEmptyPosition [20, 70, _typ];
			if(count _posV==0)then{_posV = objectFobEast getRelPos [30, random 360];};
			_veh = createVehicle [_typ, _posV, [], 0, "NONE"];
			[_veh,[_tex,1]] call bis_fnc_initVehicle;
			createVehicleCrew _veh;
			z1 addCuratorEditableObjects [[_veh],true];
			_veh setdir (_veh getdir posCenter);
			gApcD = group driver _veh;
			AIapcD=1; publicvariable "AIapcD";
		};
		
		//Continuous mechanized support (change respawn positions)
		if(AIon==3||AIon==4||AIon==6||AIon==7)then
		{
			//find BASE west respawn position
			if(sideD==sideW)then
			{
				_roadW = [posBaseWest,(minDis/2),(posBaseWest nearRoads 30)] call BIS_fnc_nearestRoad;
				if(isNull _roadW)then
				{
					_prW=objectBaseWest getRelPos [25,random 324];
					posW = posW findEmptyPosition [0, 50, "B_APC_Tracked_01_rcws_F"];
					if(count _vPos==0)then{posW=_prW;};
				}else
				{posW= getPosATL _roadW;};
				publicvariable "posW";
			};
			//find BASE east respawn position
			if(sideD==sideE)then
			{
				_roadE = [posBaseEast,(minDis/2),(posBaseEast nearRoads 30)] call BIS_fnc_nearestRoad;
				if(isNull _roadE)then
				{
					_prE=objectBaseEast getRelPos [25,random 324];
					posE = _prE findEmptyPosition [0, 50, "B_APC_Tracked_01_rcws_F"];
					if(count posE==0)then{posE=_prE;};
				}else
				{posE= getPosATL _roadE;};
				publicvariable "posE";
			};
		};
	};
	
	"warmachine\resActions.sqf" remoteExec ["execVM", 0, false]; //hint for all players	
	sleep 30; //30
	"warmachine\hint2.sqf" remoteExec ["execVM", 0, false]; //hint for all players
	sleep 180; //120
	[] spawn wrm_fnc_flagDelete;
	progress = 4; publicVariable "progress";	
};

if (progress == 4) then //fight for FOB
{
	call
	{
		if([sideW] call BIS_fnc_respawnTickets<=0 && [sideE] call BIS_fnc_respawnTickets<=0) exitWith {"End4" call BIS_fnc_endMissionServer; progress = 5; publicVariable "progress";};
		if ([sideA] call BIS_fnc_respawnTickets<=0) exitWith {endD call BIS_fnc_endMissionServer; progress = 5; publicVariable "progress";};
		if ([sideD] call BIS_fnc_respawnTickets<=0) exitWith {endA call BIS_fnc_endMissionServer; progress = 5; publicVariable "progress";};
	};
}; 