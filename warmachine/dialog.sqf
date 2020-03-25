/*
	Author: IvosH
	
	Description:
		Content of the MISSIONS GENERATOR dialog.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\dialog.sqf";
*/

disableSerialization;
//CONTENT: variables for RscCombo: _menuXX = [["text","tooltip"],["",""]];
//Mission type
_menu11 = 
[
	["Infantry mission","Infantry, light vehicles - AO small"],
	["Combined ground forces","Infantry, light vehicles, armors, transport helicopter - AO medium"],
	["Full spectrum warfare","Infantry, light vehicles, armors, transport helicopter, gunship, jet - AO large"]
];
//Time of day
_menu12 = 
[
	["Random","Time of day is selected randomly"],
	["Dawn",(dawn select 0)],
	["Morning","9:00h"],
	["Noon","12:00h"],
	["Afternoon","15:00h"],
	["Dusk",(dusk select 0)],
	["Night","23:00h"]
];
//Number of sectors
_menu21 = 
[
	["1 - Alpha","1 sector"],
	["2 - Alpha, Bravo","2 sectors"],
	["3 - Alpha, Bravo, Charlie","3 sectors"]
];
//Weather
_menu22 = 
[
	["Random","Weather is selected randomly"],
	["Clear","Clear sky, no rain"],
	["Cloudy","Overcast, probability of rain"],
	["Rain","Overcast and rain"],
	["Storm","Overcast and storm"]
];
//Combat support
_menu31 = 
[
	["Supply Artillery CAS","Supply drop available every 5 minutes. Artillery or CAS after capturing a sector. Available every 20 minutes."],
	["Supply","Supply drop available every 5 minutes"],
	["None","No combat support"]
];
//Fog
_menu32 = 
[
	["Random","Fog is selected randomly"],
	["Yes","Lower visibility"],
	["No","Good visibility"]
];
//Autonomous AI
_menu41 = 
[
	["Disabled","Only AI units lead by the player join the battle"], //0
	["Infantry only","AI units don't use vehicles autonomously"], //1
	["Vehicles & Infantry","AI vehicles spawn on the mission start"], //2
	["Continuous support-balanced","AI vehicles spawn continuously for both sides"], //3
	["Continuous support-challenging","In coop AI vehicles spawn continuously on the enemy side"], //4
	["Vehicles & Infantry-2","AI vehicles spawn on the mission start. At the beginning AI units board the vehicles at the BASE"], //5
	["Continuous support 2-balanced","AI vehicles spawn continuously for both sides. At the beginning AI units board the vehicles at the BASE"], //6
	["Continuous support 2-challenging","In coop AI vehicles spawn continuously. At the beginning AI units board the vehicles at the BASE"] //7
];
//Respawn type
_menu42 = 
[
	["Base, Fob","Respawn is available only on the BASE and FOB"],
	["Base, Fob, Sectors","Respawn is available on the BASE, FOB and on the captured SECTORS"],
	["Base, Fob, Sectors, Squad,","Respawn is available on the BASE, FOB, captured SECTORS and SQUAD position"]
];
//Revive
_menu51 = 
[
	["Enabled","Players can be revived, FAK or Medkit is required"],
	["Disabled","No revive"]
];
//Respawn tickets
_menu52 = 
[
	["Auto adjust","Based on the number of players and AI"], 
	["50",""], 
	["100",""], 
	["150",""], 
	["200",""],
	["250",""],
	["300",""],
	["400",""],
	["500",""],
	["600",""]
];
//3rd person view
_menu61=[];
if(difficultyOption "thirdPersonView"==1)then
{
	_menu61 = 
	[
		["Enabled","Third person view available"],
		["Only in the vehicle","Battlefield style"],
		["Disabled","Recommended for tough guys"]
	];
}else
{
	_menu61 = [["Disabled by the server","Third person view is not allowed"]];
};
//Ticket bleed
_menu62 = 
[
	["Disabled","Relax, make a plan"],
	["Enabled","Hurry up, rush for the objectives"]
];
//Time limit
_menu71 = 
[
	["Disabled","Recommended to enable Ticket bleed"],
	["45 min","45m"],
	["60 min","1h"],
	["75 min","1h 15m"],
	["90 min","1h 30m"]
];
//Player respawn time
_menu72 =
[
	["5 sec","Instant respawn"],
	["30 sec - Default","Default"],
	["60 sec","Normal"],
	["120 sec","Long respawn"],
	["180 sec","Go for a coffee"]
];
//AO selection method
_menu81 =
[
	["Random AO","Location is selected randomly. Mission is generated automatically."],
	["Select AO","Select area of operation on the map. Mission is generated automatically. Recommended"],
	["Create AO manually","Select manually position of all sectors, fobs and bases."]
];
//Vehicles respawn time
_menu82 =
[
	["30/90 sec","Armor madness"],
	["1/3 min","Fast respawn"],
	["3/9 min - Default","Default"],
	["5/15 min","Long respawn"],
	["10/30 min","Once upon a time, there was a tank"]
];


_menu = [_menu11, _menu12, _menu21, _menu22, _menu31, _menu32, _menu41, _menu42, _menu51, _menu52, _menu61, _menu62, _menu71, _menu72, _menu81, _menu82];
  
//VARIABLES: defines display and controls
_display = findDisplay 2017;
//controls
_cmb11 = _display displayCtrl 311;
_cmb12 = _display displayCtrl 312;
_cmb21 = _display displayCtrl 321;
_cmb22 = _display displayCtrl 322;
_cmb31 = _display displayCtrl 331;
_cmb32 = _display displayCtrl 332;
_cmb41 = _display displayCtrl 341;
_cmb42 = _display displayCtrl 342;
_cmb51 = _display displayCtrl 351;
_cmb52 = _display displayCtrl 352;
_cmb61 = _display displayCtrl 361;
_cmb62 = _display displayCtrl 362;
_cmb71 = _display displayCtrl 371;
_cmb72 = _display displayCtrl 372;
_cmb81 = _display displayCtrl 381;
_cmb82 = _display displayCtrl 382;

_cmb = [_cmb11, _cmb12, _cmb21, _cmb22, _cmb31, _cmb32, _cmb41, _cmb42, _cmb51, _cmb52, _cmb61, _cmb62, _cmb71, _cmb72, _cmb81, _cmb82];

//ADD CONTENT TO THE DIALOG
{
	_cmbx = _x;
	_index = _forEachIndex;
	{
		_menux = _x;
		_cmbx lbAdd (_menux select 0);
		_cmbx lbSetTooltip [_forEachIndex, (_menux select 1)];
	} forEach (_menu select _index);
} forEach _cmb;

//SET DEFAULT VALUES at first opening of the dialog
if (dSel == 0) then
{
	_vi="";
	_groups = [];
	{_groups pushBackUnique group _x} forEach allPlayers;
	_grpNoW = sideW countSide _groups;
	_grpNoE = sideE countSide _groups;
	_plrNoW = sideW countSide allPlayers;
	_plrNoE = sideE countSide allPlayers;

	//3rd person view
	if(difficultyOption "thirdPersonView"==1)then
	{
		if(_plrNoW==0 || _plrNoE==0)
		then{_cmb61 lbSetCurSel 0;_vi="<br/>3rd person view enabled";}
		else{_cmb61 lbSetCurSel 1;_vi="<br/>3rd person view available only in the vehicle";};
	}else{_cmb61 lbSetCurSel 0;};

	_cmb11 lbSetCurSel 2; //Mission type
	_cmb12 lbSetCurSel 0; //Time of day
	_cmb21 lbSetCurSel 2; //Number of sectors
	_cmb22 lbSetCurSel 0; //Weather
	_cmb31 lbSetCurSel 0; //Combat support
	_cmb32 lbSetCurSel 0; //Fog
	_cmb41 lbSetCurSel 3; //Autonomous AI 
	_cmb42 lbSetCurSel 2; //Respawn type
	_cmb51 lbSetCurSel 0; //Revive
	_cmb52 lbSetCurSel 0; //Respawn tickets
	_cmb62 lbSetCurSel 1; //Ticket bleed
	_cmb71 lbSetCurSel 0; //Time limit
	_cmb72 lbSetCurSel 1; //Player respawn time
	_cmb81 lbSetCurSel 1; //AO selection method
	_cmb82 lbSetCurSel 2; //Vehicles respawn time

	//Hint
	_text = ["Players: ",_plrNoW," vs. ",_plrNoE,"<br/>Squads: ",_grpNoW," vs. ",_grpNoE,"<br/><br/>RECOMMENDED PARAMETERS<br/>","Mission type: ","Full spectrum warfare<br/>Number of sectors: 3","<br/>Autonomous AI enabled",_vi,"<br/><br/>Zeus is available for administrator<br/>and server host"] joinString "";
	hint parseText format ["%1", _text];
};

//LOAD SELECTED VALUES when dialog is reopened
if (dSel != 0) then
{
	_cmb11 lbSetCurSel missType; //Mission type
	_cmb12 lbSetCurSel day; //Time of day
	_cmb21 lbSetCurSel secNo; //Number of sectors
	_cmb22 lbSetCurSel weather; //Weather
	_cmb31 lbSetCurSel support; //Combat support
	_cmb32 lbSetCurSel fogLevel; //Fog
	_cmb41 lbSetCurSel AIon; //Autonomous AI
	_cmb42 lbSetCurSel resType; //Respawn type
	_cmb51 lbSetCurSel revOn; //Revive
	_cmb52 lbSetCurSel resTickets; //Respawn tickets
	_cmb61 lbSetCurSel viewType; //3rd person view
	_cmb62 lbSetCurSel ticBleed; //Ticket bleed
	_cmb71 lbSetCurSel timeLim; //Time limit
	_cmb72 lbSetCurSel resTime; //Player respawn time
	_cmb81 lbSetCurSel aoType; //AO selection method
	_cmb82 lbSetCurSel vehTime; //Vehicles respawn time
};