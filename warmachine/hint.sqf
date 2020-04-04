/*
	Author: IvosH
	
	Description:
		hint displays for all players after mission is created 
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		start.sqf
		
	Execution:
		[] execVM "warmachine\hint.sqf";
		"warmachine\hint.sqf" remoteExec ["execVM", 0, true];
*/
if (!hasInterface) exitWith {};

waitUntil {!isNull player}; //JIP
waitUntil {progress > 1}; //mission is created and started
titleFadeOut 3;
sleep 5;

boatArUsed = 0;
loc = text (nearestLocations [posCenter, ["NameCity","NameCityCapital","NameMarine","NameVillage","NameLocal","Airport"],2500] select 0);
_mType="";
_sec="";
_supp="";
_ai="";
_rev="";
_viw="";
_tLim="";
_resTp = "";
_tic = format ["%1", [sideW] call BIS_fnc_respawnTickets]; //Tickets
_bleed = "";
_resPl = format ["%1", rTime]; //Respawn time player
_resTr = format ["%1", trTime/60]; //Respawn time transport vehicles
_resAr = format ["%1", arTime/60]; //Respawn time armed vehicles
_hour = floor daytime;
_minute = floor ((daytime - _hour) * 60);
_second = floor (((((daytime) - (_hour))*60) - _minute)*60);
_time = format ["%1:%2:%3",_hour,_minute,_second];
_wthr = "";
_rain = "";
_fog = "";
_ars = "";

call //Mission type
{
	if (missType == 1) exitWith {_mType = "INFANTRY MISSION";};
	if (missType == 2) exitWith {_mType = "COMBINED GROUND FORCES";};
	if (missType == 3) exitWith {_mType = "FULL SPECTRUM WARFARE";};
};

if (progress < 3) //progress
then {_c = count ([true] call BIS_fnc_moduleSector); if (_c==1) then {_sec = format ["Capture %1 sector", _c];} else {_sec = format ["Capture %1 sectors", _c];};}
else {_sec = taskF;};

if (support == 0) //Combat support
then {_supp = "available";}
else {_supp = "unavailable";};

call //Autonomous AI
{
	if(AIon==0)exitWith{_ai="disabled";};
	if(AIon==1)exitWith{_ai="infantry only";};
	if(AIon==2)exitWith{_ai="vehicles and Infantry";};
	if(AIon==3)exitWith{_ai="continuous support - balanced";};
	if(AIon==4)exitWith{_ai="continuous support - challenging";};
	if(AIon==5)exitWith{_ai="vehicles and Infantry";};
	if(AIon==6)exitWith{_ai="continuous support - balanced";};
	if(AIon==7)exitWith{_ai="continuous support - challenging";};
};

if(revOn < 1) //Revive
then{_rev="enabled";}
else{_rev="disabled";};

if(difficultyOption "thirdPersonView"==1)then //3rd person view
{
	call
	{
		if (viewType == 0) exitWith {_viw = "enabled";};
		if (viewType == 1) exitWith {_viw = "available only in the vehicle";};
		if (viewType == 2) exitWith {_viw = "disabled";};
	};
}else{_viw = "disabled";};

call //Time limit
{
	if (timeLim==0) exitWith {_tLim = "disabled";};
	if (timeLim==1) exitWith {_tLim = "45 minutes";};
	if (timeLim==2) exitWith {_tLim = "60 minutes";};
	if (timeLim==3) exitWith {_tLim = "75 minutes";};
	if (timeLim==4) exitWith {_tLim = "90 minutes";};
};

call //Respawn type
{
	if (resType == 0) exitWith {_resTp = "Base, Fob";};
	if (resType == 1) exitWith {_resTp = "Base, Fob and Sectors";};
	if (resType == 2) exitWith {_resTp = "Base, Fob, Sectors and Squad";};
};

if (ticBleed == 0) //Ticket bleed
then {_bleed = "disabled";}
else {_bleed = "enabled";};

if (Overcast < 0.2) //Overcast
then {_wthr = "Clear sky";} 
else 
{
	if (Overcast < 0.7) 
	then {_wthr = "Partly cloudy";} 
	else {_wthr = "Overcast";};
};

if (rain > 0.05) //Rain
then {_rain = " and rain";}  
else {_rain = ", no rain";};

if (fog > 0.05) //Fog
then {_fog = ", fog";} 
else {_fog = ", no fog";};

if ("Param2" call BIS_fnc_getParamValue > 0) //Arsenal
then {_ars = "<br/><br/>VIRTUAL ARSENAL<br/>is accessible at the supply box on the BASE";}
else {_ars = "";};

_text = ["VARMACHINE ",island,"<br/>Operation ",loc,"<br/>Time ", _time,"<br/>",_wthr,_rain,_fog,"<br/><br/>",_mType,"<br/>",_sec,"<br/>","Combat support ",_supp,"<br/>Autonomous AI ",_ai,"<br/>Revive ",_rev,"<br/>3rd person view ",_viw,"<br/>Time limit ",_tLim,"<br/><br/>RESPAWN<br/>",_resTp,"<br/>",_tic," Tickets<br/>Ticket bleed ",_bleed,"<br/>Respawn time<br/>","Players: ",_resPl," sec<br/>Transport vehicles: ",_resTr," min<br/>Armed vehicles: ",_resAr," min",_ars] joinString "";
hint parseText format ["%1", _text];

player createDiaryRecord 
["Diary",["Mission",_text]];

waitUntil {alive player}; //player has respawned
sleep 10;
[[[["Operation ",loc] joinString ""]]] spawn BIS_fnc_typeText;