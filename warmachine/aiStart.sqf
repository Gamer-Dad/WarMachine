/*
	Author: IvosH
	
	Description:
		0 - Disabled (Only AI units lead by the player join the battle)
		1 - Infantry only (AI units don't use vehicles autonomously)
		2 - Vehicles & Infantry - Default (AI vehicles spawn on the mission start)
		3 - Continuous mechanized support (AI vehicles spawn continuously)
		4 - Vehicles & Infantry - 2 (AI vehicles spawn on the mission start. At the beginning AI units board the vehicles at the BASE)
		5 - Continuous mech. support - 2 (AI vehicles spawn continuously. At the beginning AI units board the vehicles at the BASE)
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		start.sqf

	Execution:
		[] execVM "warmachine\aiStart.sqf";
*/
if !(isServer) exitWith {}; //runs on the server/host

//sort groups
_grpsW=[];_grpsE=[];_grpsA= [];_grps= [];
{_grpsA pushBackUnique group _x} forEach playableUnits;
{if!(isPlayer leader _x)then{_grps pushBackUnique _x;};} forEach _grpsA;
{
	if(side _x==sideW)then{_grpsW pushBackUnique _x;};
	if(side _x==sideE)then{_grpsE pushBackUnique _x;};
} forEach _grps;

//replace units at the BASE at the mission start
if(AIon==0)then 
{
	{
		_un=units _x;
		{
			_posU = objectBaseWest getRelPos [20, random 360];
			_x setVehiclePosition [_posU, [], 0, "NONE"];
		} forEach _un;
	} forEach _grpsW;
	{
		_un=units _x;
		{
			_posU = objectBaseEast getRelPos [20, random 360];
			_x setVehiclePosition [_posU, [], 0, "NONE"];
		} forEach _un;
	} forEach _grpsE;
};

//replace units at the FOB at the mission start
if(AIon>0 && AIon<6)then
{
	{
		_un=units _x;
		{
			_posU = objectFobWest getRelPos [20, random 360];
			_x setVehiclePosition [_posU, [], 0, "NONE"];
		} forEach _un;
	} forEach _grpsW;
	{
		_un=units _x;
		{
			_posU = objectFobEast getRelPos [20, random 360];
			_x setVehiclePosition [_posU, [], 0, "NONE"];
		} forEach _un;
	} forEach _grpsE;
};

//add vehicles (BASE) to the groups at the mission start, and replace units
if(AIon>4)then
{
	//add vehicles
	if(count _grpsW>0)then //1.group APC west
	{
		if(missType>0)then
		{
			gArW=_grpsW select 0;
			gArW addVehicle armW;			
		};
	};
	if(count _grpsE>1)then //2.group APC east
	{
		if(missType>0)then
		{
			gArE=_grpsE select 1;
			gArE addVehicle armE;
		};
	};
	if(count _grpsW>1)then //2.group TRUCK west
	{
		gTrW=_grpsW select 1;
		gTrW addVehicle vehW;
	};
	if(count _grpsE>0)then //1.group TRUCK east
	{
		gTrE=_grpsE select 0;
		gTrE addVehicle vehE;
	};
	
	//replace units
	if(count _grpsW>0)then //1.group APC
	{
		if(missType>0)
		then
		{
			{
				_posU = objectBaseWest getRelPos [20, random 360];
				_x setVehiclePosition [_posU, [], 0, "NONE"];
			} forEach units (_grpsW select 0);
		}
		else
		{
			{
				_posU = objectFobWest getRelPos [20, random 360];
				_x setVehiclePosition [_posU, [], 0, "NONE"];
			} forEach units (_grpsW select 0);
		};
	};
	if(count _grpsW>1)then //2.group TRUCK
	{
		{
			_posU = objectBaseWest getRelPos [20, random 360];
			_x setVehiclePosition [_posU, [], 0, "NONE"];
		} forEach units (_grpsW select 1);
	};
	if(count _grpsW>2)then //3...group FOB
	{
		_gw = _grpsW-[(_grpsW select 0)]-[(_grpsW select 1)];
		{
			_un=units _x; 
			{
				_posU = objectFobWest getRelPos [20, random 360];
				_x setVehiclePosition [_posU, [], 0, "NONE"];				
			} forEach _un;
		} forEach _gw;
	};
	if(count _grpsE>0)then //1.group TRUCK
	{
		{
			_posU = objectBaseEast getRelPos [20, random 360];
			_x setVehiclePosition [_posU, [], 0, "NONE"];
		} forEach units (_grpsE select 0);
	};
	if(count _grpsE>1)then //2.group APC
	{
		if(missType>0)
		then
		{
			{
				_posU = objectBaseEast getRelPos [20, random 360];
				_x setVehiclePosition [_posU, [], 0, "NONE"];
			} forEach units (_grpsE select 1);
		}
		else
		{
			{
				_posU = objectFobEast getRelPos [20, random 360];
				_x setVehiclePosition [_posU, [], 0, "NONE"];
			} forEach units (_grpsE select 1);
		};
	};
	if(count _grpsE>2)then //3...group FOB
	{
		_ge = _grpsE-[(_grpsE select 0)]-[(_grpsE select 1)];
		{
			_un=units _x; 
			{
				_posU = objectFobEast getRelPos [20, random 360];
				_x setVehiclePosition [_posU, [], 0, "NONE"];
			} forEach _un;
		} forEach _ge;
	};
};

//spawn AI vehicles
if(AIon>1)then
{	
	sleep 60; //60
	//wait until any player is close to the sector
	_t=0;
	while {_t==0} do
	{
		{
			if(!alive _x)exitWith{};
			if(_x distance posAlpha < minDis)then{_t=1;};
			if(secNo>0)then{if(_x distance posBravo < minDis)then{_t=1;};};
			if(secNo>1)then{if(_x distance posCharlie < minDis)then{_t=1;};};
		} forEach allPlayers;
		sleep 11;
	};
	//count players
	_plw=sideW countSide allPlayers;
	_ple=sideE countSide allPlayers;
	call
	{
		if(AIon==3||AIon==6)exitWith{coop=0; publicvariable "coop";};
		if((_plw>0)&&(_ple>0))exitWith{coop=0; publicvariable "coop";};
		if((_plw==0)&&(_ple==0))exitWith{coop=0; publicvariable "coop";};
		if(_plw>0)exitWith{coop=1; publicvariable "coop";};
		if(_ple>0)exitWith{coop=2; publicvariable "coop";};
	};
	
	//create vehicles at the sectors
	if(missType>0)then
	{
		call
		{
			if(coop==0)exitWith //PvP
			{
				if(secNo>0)then
				{
					_posS = [[posAlpha,objectAlpha],[posBravo,objectBravo]];
					_posS call BIS_fnc_arrayShuffle;
					
					//west vehicle
					_type = (selectRandom(selectRandom [CarArW,ArmorW1,ArmorW2])); _typ=""; _tex="";
					if (_type isEqualType [])then{_typ=_type select 0;_tex=_type select 1;}else{_typ=_type;};
					_posV = ((_posS select 0) select 0) findEmptyPosition [10, 50, _typ];
					if(count _posV==0)then{_posV = ((_posS select 0) select 1) getRelPos [20, random 360];};
					_veh = createVehicle [_typ, _posV, [], 0, "NONE"];
					[_veh,[_tex,1]] call bis_fnc_initVehicle;
					createVehicleCrew _veh;
					z1 addCuratorEditableObjects [[_veh],true];
					{ _x addMPEventHandler
						["MPKilled",{[(_this select 0),west] spawn wrm_fnc_killedEH;}];
					} forEach (crew _veh);
					gApcW = group driver _veh;
					_veh setdir (_veh getdir posFobEast);
					AIapcW=1; publicvariable "AIapcW";
					
					//east vehicle
					_type = (selectRandom(selectRandom [CarArE,ArmorE1,ArmorE2])); _typ=""; _tex="";
					if (_type isEqualType [])then{_typ=_type select 0;_tex=_type select 1;}else{_typ=_type;};
					_posV = ((_posS select 1) select 0) findEmptyPosition [10, 50, _typ];
					if(count _posV==0)then{_posV = ((_posS select 1) select 1) getRelPos [20, random 360];};
					_veh = createVehicle [_typ, _posV, [], 0, "NONE"];
					[_veh,[_tex,1]] call bis_fnc_initVehicle;
					createVehicleCrew _veh;
					z1 addCuratorEditableObjects [[_veh],true];
					{ _x addMPEventHandler
						["MPKilled",{[(_this select 0),east] spawn wrm_fnc_killedEH;}];
					} forEach (crew _veh);
					gApcE = group driver _veh;
					_veh setdir (_veh getdir posFobWest);					
					AIapcE=1; publicvariable "AIapcE";
				};				
			};
			
			if(coop==1)exitWith //players only on sideW
			{
				_posE=[];
				if(secNo>0)then
				{	
					if(secNo>1)
					then{_posE = [[posAlpha,objectAlpha],[posBravo,objectBravo],[posCharlie,objectCharlie]];}
					else{_posE = [[posAlpha,objectAlpha],[posBravo,objectBravo]];};
				}else{_posE = [[posAlpha,objectAlpha]];};
				_posS= selectRandom _posE;

				//east vehicle
				_type = (selectRandom(selectRandom [CarArE,ArmorE1,ArmorE2])); _typ=""; _tex="";
				if (_type isEqualType [])then{_typ=_type select 0;_tex=_type select 1;}else{_typ=_type;};
				_posV = (_posS select 0) findEmptyPosition [10, 50, _typ];
				if(count _posV==0)then{_posV = (_posS select 1) getRelPos [20, random 360];};
				_veh = createVehicle [_typ, _posV, [], 0, "NONE"];
				[_veh,[_tex,1]] call bis_fnc_initVehicle;
				createVehicleCrew _veh;
				z1 addCuratorEditableObjects [[_veh],true];
				{ _x addMPEventHandler
					["MPKilled",{[(_this select 0),east] spawn wrm_fnc_killedEH;}];
				} forEach (crew _veh);
				gApcE = group driver _veh;
				_veh setdir (_veh getdir posFobWest);
				AIapcE=1; publicvariable "AIapcE";
			};
			
			if(coop==2)exitWith //players only on sideE
			{
				_posW=[];
				if(secNo>0)then
				{	
					if(secNo>1)
					then{_posW = [[posAlpha,objectAlpha],[posBravo,objectBravo],[posCharlie,objectCharlie]];}
					else{_posW = [[posAlpha,objectAlpha],[posBravo,objectBravo]];};
				}else{_posW = [[posAlpha,objectAlpha]];};
				_posS= selectRandom _posW;

				//west vehicle
				_type = (selectRandom(selectRandom [CarArW,ArmorW1,ArmorW2])); _typ=""; _tex="";
				if (_type isEqualType [])then{_typ=_type select 0;_tex=_type select 1;}else{_typ=_type;};
				_posV = (_posS select 0) findEmptyPosition [10, 50, _typ];
				if(count _posV==0)then{_posV = (_posS select 1) getRelPos [20, random 360];};
				_veh = createVehicle [_typ, _posV, [], 0, "NONE"];
				[_veh,[_tex,1]] call bis_fnc_initVehicle;
				createVehicleCrew _veh;
				z1 addCuratorEditableObjects [[_veh],true];
				{ _x addMPEventHandler
					["MPKilled",{[(_this select 0),west] spawn wrm_fnc_killedEH;}];
				} forEach (crew _veh);
				gApcW = group driver _veh;
				_veh setdir (_veh getdir posFobEast);
				AIapcW=1; publicvariable "AIapcW";
			};
		};
	};
	
	//Continuous mechanized support (respawn positions)
	if(AIon==3||AIon==4||AIon==6||AIon==7)then
	{
		posW=[]; posE=[];
		//find FOB west respawn position
		_roadW = [posFobWest,(minDis/2),(posFobWest nearRoads 30)] call BIS_fnc_nearestRoad;
		if(isNull _roadW)then
		{
			_prW=objectFobWest getRelPos [25,random 324];
			posW = _prW findEmptyPosition [0, 50, "B_APC_Tracked_01_rcws_F"];
			if(count posW==0)then{posW=_prW;};
		}else
		{posW= getPosATL _roadW;};
		publicvariable "posW";
		
		//find FOB east respawn position
		_roadE = [posFobEast,(minDis/2),(posFobEast nearRoads 30)] call BIS_fnc_nearestRoad;
		if(isNull _roadE)then
		{
			_prE=objectFobEast getRelPos [25,random 324];
			posE = _prE findEmptyPosition [0, 50, "B_APC_Tracked_01_rcws_F"];
			if(count posE==0)then{posE=_prE;};
		}else
		{posE= getPosATL _roadE;};
		
		publicvariable "posE";
		[] spawn wrm_fnc_aiVehUpdate;
	};	
};