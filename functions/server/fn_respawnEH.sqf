/*
	Author: IvosH
	
	Description:
		Event handler for MPrespawn. Set position of the respawned AI unit. Depends on the position of the _men (group leader or another group member). Simulates squad respawn for AI.
		
	Parameter(s):
		0: VARIABLE respawned unit
		
	Returns:
		BOOL
		
	Dependencies:
		fn_resGrpsUpdate.sqf
		fn_aiMove.sqf

	Execution:
		[_unit] spawn wrm_fnc_respawnEH;
*/
_unit = _this select 0; //_this = unit which respawns
[z1,[[_unit],true]] remoteExec ["addCuratorEditableObjects", 2, false]; //add unit to zeus
if(progress<2)exitWith{};
if (isPlayer _unit) exitWith {}; //unit is player script stops here
if (side _unit==civilian) exitWith {};

//unit is AI
[_unit] spawn wrm_fnc_equipment;

params [["_posR",[]],["_posF",[]],["_posB",[]],["_type",[]],["_tar",[]],["_ldrPl",[]],["_players",[]],["_ldrAI",[]],["_AIs",[]],["_grp",[]],["_secS",[]],["_posS",[]]];
_placed=false;

//BASE respawn
if (side _unit==sideW) 
then {_posR=RpBsW;_posF=posFobWest;_posB=posBaseWest;} 
else {_posR=RpBsE;_posF=posFobEast;_posB=posBaseEast;};

//FOB respawn
if(progress<3) then
{
	if (side _unit==sideW) then {_posR=RpFoW;} else {_posR=RpFoE;};
} else
{
	if (side _unit==sideD && (getMarkerColor resFobD!="")) then 
	{
		if (side _unit==sideW) 
		then {_posR=RpFoW;} 
		else {_posR=RpFoE;};
	};
};

//sector respawn
if(resType>0)then
{
	params [["_resS",[]],["_dist",[]],["_min",0],["_inx",0]];
	_resS=[]; _dist=[]; 
	//find available sectors
	call 
	{
		
		if(side _unit==sideW)exitWith
		{
			if(getMarkerColor resAW!="")then{_secS pushBackUnique (getMarkerPos resAW); _resS pushBackUnique RpAw;};
			if(getMarkerColor resBW!="")then{_secS pushBackUnique (getMarkerPos resBW); _resS pushBackUnique RpBw;};
			if(getMarkerColor resCW!="")then{_secS pushBackUnique (getMarkerPos resCW); _resS pushBackUnique RpCw;};
		};
		if(side _unit==sideE)exitWith
		{
			if(getMarkerColor resAE!="")then{_secS pushBackUnique (getMarkerPos resAE); _resS pushBackUnique RpAe;};
			if(getMarkerColor resBE!="")then{_secS pushBackUnique (getMarkerPos resBE); _resS pushBackUnique RpBe;};
			if(getMarkerColor resCE!="")then{_secS pushBackUnique (getMarkerPos resCE); _resS pushBackUnique RpCe;};
		};
	};
	if(count _secS==0)exitWith{};
	//choose the best sector
	if(progress<3)then 
	{
		if(alive leader _unit)
		then{_tar=getPos leader _unit;}
		else{_tar=selectRandom _secS;};
	}else{_tar=posF;};

	{_dist pushBackUnique (_tar distance _x);}forEach _secS;
	_min=selectMin _dist; 
	{if(_x==_min)then{_inx=_forEachIndex;};}forEach _dist;
	_posS = _secS select _inx;
	_posR = _resS select _inx;
};

//any group members alive
if(({alive _x} count units group _unit) > 1)then
{ 
	//sort group members
	{
		if(_unit!=_x)then{ //is not unit it self
			if(alive _x)then{ //is alive
				call
				{
					if(isPlayer _x && leader _unit==_x)exitWith{_ldrPl pushBackUnique _x}; //is player and leader
					if(isPlayer _x && leader _unit!=_x)exitWith{_players pushBackUnique _x}; //another players
					if(!(isPlayer _x) && leader _unit==_x)exitWith{_ldrAI pushBackUnique _x}; //is AI and leader
					if(!(isPlayer _x) && leader _unit!=_x)exitWith{_AIs pushBackUnique _x}; //another Ai units
				};
			};
		};
	}forEach units group _unit;
	
	//respawn in the vehicle
	_grp=_ldrPl+_players+_ldrAI+_AIs;
	{
		if(_placed)exitWith{};
		_man=_x;
		if(vehicle _man != _man)then //is in the vehicle
		{
			_inBase=false; //check distance from base
			if(resType<2)then
			{
				{if((_x distance _man)<100)then{_inBase=true;};}forEach [_posF,_posB];
			}else{_inBase=true;};
			if(!_inBase)exitWith{};

			_seat=["Driver","Gunner","Commander"];//check if cargo will be used
			if(isPlayer _man)then 
			{
				if(_man==leader _man)then
				{

					if(progress<3)then
					{
						if(count _secS==0)then
						{
							if((_posF distance posCenter)>(_man distance posCenter))then
							{
								_seat=["Driver","Gunner","Commander","Cargo"];
							};
						};
					}else
					{
						if(count _secS==0)then
						{
							if((_posF distance posF)>(_man distance posF))then
							{
								_seat=["Driver","Gunner","Commander","Cargo"];
							};
						}else
						{
							if((_posS distance posF)>(_man distance posF))then
							{
								_seat=["Driver","Gunner","Commander","Cargo"];
							};
						};
					};
				};
			};
			//check for seat
			{
				if(_placed)exitWith{};
				if (vehicle _man emptyPositions _x > 0) 
				then {_unit moveInAny vehicle _man;_placed = true;}; //respawn in the vehicle
			} forEach _seat;
		};
	}forEach _grp;
	if(_placed)exitWith{};
	
	//squad respawn
	if(resType==2)then
	{
		_inFob=false;
		if(progress>2)then{if((side _unit==sideD) && (getMarkerColor resFobD!=""))then{_inFob=true;};};
		if(_inFob)exitWith{};
		
		_grp=_ldrPl+_ldrAI+_players+_AIs;
		_man=_grp select 0;
		_or=[];
		
		if(progress<3)then
		{
			_tar=posCenter;
			if(count _secS==0)then{_or=_posF;}else{_or=_posS;};
		}else
		{
			_tar=posF;
			if(side _unit==sideD)
			then{_or=_posB;}
			else{if(count _secS==0)then{_or=_posF;}else{_or=_posS;};};
		};
		if((_or distance _tar)>(_man distance _tar))then
		{
			_pR = _man getRelPos [100,random [135,180,225]];	
			_pE = _pR findEmptyPosition [0,30,(typeOf vehicle _unit)];
			if(count _pE == 0) then {_pE=_pR;};
			
			//check if respawn position not colide with sector zones			
			_r=0;
			if((_pE distance posAlpha)<50)then{_r=1;};
			if(secNo>0)then{if((_pE distance posBravo)<50)then{_r=2;};};
			if(secNo>1)then{if((_pE distance posCharlie)<50)then{_r=3;};};
			call
			{
				if(_r==1)exitWith{if(side _unit==sideW)then{_pE=selectRandom RpAw;}else{_pE=selectRandom RpAe;};};
				if(_r==2)exitWith{if(side _unit==sideW)then{_pE=selectRandom RpBw;}else{_pE=selectRandom RpBe;};};
				if(_r==3)exitWith{if(side _unit==sideW)then{_pE=selectRandom RpCw;}else{_pE=selectRandom RpCe;};};
			};
			_unit setVehiclePosition [_pE, [], 0, "NONE"]; //place _unit
			_placed = true;
		};
	};
};

if(!_placed)then
{
	_unit setVehiclePosition [(selectRandom _posR), [], 0, "NONE"]; //place _unit
};
sleep 0.1;if(_unit==leader _unit)then{[] call wrm_fnc_aiMove;};
[_unit] spawn wrm_fnc_safeZone;
true; //return value BOOLEAN