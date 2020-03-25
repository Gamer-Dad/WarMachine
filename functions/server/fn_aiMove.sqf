/*
	Author: IvosH
	
	Description:
		Tels to all groups without player leadership what sectors/fob capture
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		fn_aiUpdate.sqf
		fnc_aiDrive.sqf
		
	Execution:
		[] call wrm_fnc_aiMove;
*/
if !(isServer) exitWith {}; //runs on the server/host
if(AIon==0)exitWith{}; //autonomous AI disabled
//sort groups
_grpsW=[];
_grpsE=[];
_grpsA= [];
_grps= [];
{if(count units _x>1)then{_grpsA pushBackUnique _x};} forEach allGroups;
//remove spawned vehicles from groups
if(progress<3)then
{
		if(AIapcE==1)then{_grpsA=_grpsA-[gApcE];};
		if(AIapcW==1)then{_grpsA=_grpsA-[gApcW];};
}else
{
	_un=[]; _t=0;
	if (sideA countSide allPlayers>0) 
	then {{if ((side _x == sideA)&&(_x distance posF < minDis)) then {_t=1;};} forEach allPlayers;} 
	else {_t=1;};

	if(_t==0)then
	{
		call
		{
			if(sideA==sideW)exitWith //west attack
			{
				if(AIapcW==1)then{_grpsA=_grpsA-[gApcW];};	
				if(AIapcD==1)then{_grpsA=_grpsA-[gApcD];};
				if(alive aiVehW)then{_grpsA=_grpsA-[(group driver aiVehW)];};
				if(alive aiCasW)then{_grpsA=_grpsA-[(group driver aiCasW)];};
			};
			
			if(sideA==sideW)exitWith //east attack
			{
				if(AIapcE==1)then{_grpsA=_grpsA-[gApcE];};	
				if(AIapcD==1)then{_grpsA=_grpsA-[gApcD];};
				if(alive aiVehE)then{_grpsA=_grpsA-[(group driver aiVehE)];};
				if(alive aiCasE)then{_grpsA=_grpsA-[(group driver aiCasE)];};
			};
		};
	}else
	{
		if(AIapcD==1)then{_grpsA=_grpsA-[gApcD];};
	};
};

if(missType==2)then
{
	if(alive aiCasW)then{_grpsA=_grpsA+[(group driver aiCasW)];};
	if(alive aiCasE)then{_grpsA=_grpsA+[(group driver aiCasE)];};	
};


{if!(isPlayer leader _x)then{_grps pushBackUnique _x;};} forEach _grpsA;
{
	if(side _x==sideW)then{_grpsW pushBackUnique _x;};
	if(side _x==sideE)then{_grpsE pushBackUnique _x;};
} forEach _grps;

//fight for sectors
if(progress<3)then
{
	//sort sectors
	_sec0=[]; _secW=[]; _secE=[];
	call
	{
		if (getMarkerColor resAW!="") then {_secW pushBackUnique posAlpha;};
		if (getMarkerColor resAE!="") then {_secE pushBackUnique posAlpha;};
		if (getMarkerColor resAW=="" && getMarkerColor resAE=="") then {_sec0 pushBackUnique posAlpha;};
	};
	if(secNo>0)then
	{
		call
		{
			if (getMarkerColor resBW!="") then {_secW pushBackUnique posBravo;};
			if (getMarkerColor resBE!="") then {_secE pushBackUnique posBravo;};
			if (getMarkerColor resBW=="" && getMarkerColor resBE=="") then {_sec0 pushBackUnique posBravo;};
		};
	};
	if(secNo>1)then
	{
		call
		{
			if (getMarkerColor resCW!="") then {_secW pushBackUnique posCharlie;};
			if (getMarkerColor resCE!="") then {_secE pushBackUnique posCharlie;};
			if (getMarkerColor resCW=="" && getMarkerColor resCE=="") then {_sec0 pushBackUnique posCharlie;};
		};
	};
	//give orders to the groups
	{
		_secS=[];
		{
			_grp=_x;
			if(count _secS<1)then
			{
				if(side _grp==sideW)then{_secS=_sec0+_secE+_secW;}else{_secS=_sec0+_secW+_secE;};
			};
			_sec=_secS select 0;
			_grp move _sec;
			//force drivers to drive
			if (AIon>4&&aiDrive==0) then
			{
				if (_grp==gTrW||_grp==gTrE) then {[_grp,_sec] execVM "warmachine\aiDrive.sqf";};
				if (missType>0) then
				{
					if (_grp==gArW||_grp==gArE) then {[_grp,_sec] execVM "warmachine\aiDrive.sqf";};
				};
			};
			if(count _secS>0)then{_secS=_secS-[_sec];}; //remove used sector from array
		} forEach _x;
	} forEach [_grpsW,_grpsE];
}
//fight for FOB
else{{_x move posF;} forEach _grps;};