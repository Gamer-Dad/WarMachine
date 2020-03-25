/*
	Author: IvosH
	
	Description:
		Script executed when CANCEL button is pressed. save current selection
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\cancel.sqf";
*/

//LOCAL VARIABLES: saves dialog selections
missType = lbCurSel 311;
day = lbCurSel 312;
secNo = lbCurSel 321;
weather = lbCurSel 322;
support = lbCurSel 331;
fogLevel = lbCurSel 332;
AIon = lbCurSel 341;
resType = lbCurSel 342;
revOn = lbCurSel 351;
resTickets = lbCurSel 352;
viewType = lbCurSel 361;
ticBleed = lbCurSel 362;
timeLim = lbCurSel 371;
resTime = lbCurSel 372;
aoType = lbCurSel 381;
vehTime = lbCurSel 382;
//enable loading of dialog selections
dSel = 1;

waitUntil {dSel == 1;};
//close dialog window
closeDialog 0;