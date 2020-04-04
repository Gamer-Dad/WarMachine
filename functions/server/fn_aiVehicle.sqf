/*
	Author: IvosH
	
	Description:
		Continuously spawn AI vehicles
		
	Parameter(s):
		0: parameter number 
		
	Returns:
		nothing
		
	Dependencies:
		fn_aiVehUpdate.sqf
		aiStart.sqf
		fn_progress.sqf
		.....
		
	Execution:
		[0] call wrm_fnc_aiVehicle;
*/
_par = _this select 0;

call
{
	//aiVehW
	if(_par==1)exitWith
	{
		//check condition again
		sleep trTime; //3 min default
		_liv=true;
		call
		{
			if(!alive aiVehW)exitWith{_liv=false;};
			if(!canMove aiVehW)exitWith{_liv=false;};
			if(aiVehW getHitPointDamage "hitGun"==1)exitWith{_liv=false;};
			if(aiVehW getHitPointDamage "hitTurret"==1)exitWith{_liv=false;};
			if(({alive _x} count (crew aiVehW))==0)exitWith{_liv=false;};
		};
		if(_liv)exitWith{};

		//destroy
		aiVehW setDamage 1;

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
			
		if(coop==0 || coop==2) then
		{
			params [["_veh",[]]];
			if(missType==1)then{_veh=CarArW;}else{_veh=CarArW+ArmorW1+ArmorW2;};

			//west armed vehicle
			_vSel = selectRandom _veh;
			_typ="";_tex="";
			if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};	

			aiVehW = createVehicle [_typ, posW, [], 0, "NONE"];
			[aiVehW,[_tex,1]] call bis_fnc_initVehicle;
			createVehicleCrew aiVehW;
			z1 addCuratorEditableObjects [[aiVehW],true];
			{ _x addMPEventHandler
				["MPKilled",{[(_this select 0),west] spawn wrm_fnc_killedEH;}];
			} forEach (crew aiVehW);
			publicvariable "aiVehW";
			[] call wrm_fnc_aiMove;
		};
	};

	//aiVehE
	if(_par==2)exitWith
	{
		//check condition again
		sleep trTime; //3 min default
		_liv=true;
		call
		{
			if(!alive aiVehE)exitWith{_liv=false;};
			if(!canMove aiVehE)exitWith{_liv=false;};
			if(aiVehE getHitPointDamage "hitGun"==1)exitWith{_liv=false;};
			if(aiVehE getHitPointDamage "hitTurret"==1)exitWith{_liv=false;};
			if(({alive _x} count (crew aiVehE))==0)exitWith{_liv=false;};
		};
		if(_liv)exitWith{};

		//destroy
		aiVehE setDamage 1;
		
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
			
		if(coop==0 || coop==1) then
		{
			params [["_veh",[]]];
			if(missType==1)then{_veh=CarArE;}else{_veh=CarArE+ArmorE1+ArmorE2;};

			//west armed vehicle
			_vSel = selectRandom _veh;
			_typ="";_tex="";
			if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};	

			aiVehE = createVehicle [_typ, posE, [], 0, "NONE"];
			[aiVehE,[_tex,1]] call bis_fnc_initVehicle;
			createVehicleCrew aiVehE;
			z1 addCuratorEditableObjects [[aiVehE],true];
			{ _x addMPEventHandler
				["MPKilled",{[(_this select 0),east] spawn wrm_fnc_killedEH;}];
			} forEach (crew aiVehE);
			publicvariable "aiVehE";
			[] call wrm_fnc_aiMove;
		};
	};

	//aiCasW
	if(_par==3)exitWith
	{
		//check condition again
		sleep (trTime*2); //6 min default
		_liv=true;
		call
		{
			if(!alive aiCasW)exitWith{_liv=false;};
			if(!canMove aiCasW)exitWith{_liv=false;};
			if(({alive _x} count (crew aiCasW))==0)exitWith{_liv=false;};
		};
		if(_liv)exitWith{};

		//destroy
		aiCasW setDamage 1;
		{if(alive _x)then{_x setDamage 1;};} forEach pltW;
		
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
			
		if(coop==0 || coop==2) then
		{
			//west armed vehicle
			_vSel = selectRandom (HeliArW+PlaneW+HeliArW);
			_typ="";_tex="";
			if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};	

			aiCasW = createVehicle [_typ, plHW, [], 0, "FLY"];
			[aiCasW,[_tex,1]] call bis_fnc_initVehicle;
			createVehicleCrew aiCasW;
			z1 addCuratorEditableObjects [[aiCasW],true];
			{ _x addMPEventHandler
				["MPKilled",{[(_this select 0),west] spawn wrm_fnc_killedEH;}];
			} forEach (crew aiCasW);
			publicvariable "aiCasW";
			(group driver aiCasW) move posCenter;
			pltW = crew aiCasW;
		};
	};	
	
	//aiCasE
	if(_par==4)exitWith
	{
		//check condition again
		sleep (trTime*2); //6 min default
		_liv=true;
		call
		{
			if(!alive aiCasE)exitWith{_liv=false;};
			if(!canMove aiCasE)exitWith{_liv=false;};
			if(({alive _x} count (crew aiCasE))==0)exitWith{_liv=false;};
		};
		if(_liv)exitWith{};

		//destroy
		aiCasE setDamage 1;
		{if(alive _x)then{_x setDamage 1;};} forEach pltE;
		
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
			
		if(coop==0 || coop==1) then
		{
			//east armed vehicle
			_vSel = selectRandom (HeliArE+PlaneE+HeliArE);
			_typ="";_tex="";
			if (_vSel isEqualType [])then{_typ=_vSel select 0;_tex=_vSel select 1;}else{_typ=_vSel;};	

			aiCasE = createVehicle [_typ, plHe, [], 0, "FLY"];
			[aiCasE,[_tex,1]] call bis_fnc_initVehicle;
			createVehicleCrew aiCasE;
			z1 addCuratorEditableObjects [[aiCasE],true];
			{ _x addMPEventHandler
				["MPKilled",{[(_this select 0),east] spawn wrm_fnc_killedEH;}];
			} forEach (crew aiCasE);
			publicvariable "aiCasE";
			(group driver aiCasE) move posCenter;
			pltE = crew aiCasE;
		};
	};
};

