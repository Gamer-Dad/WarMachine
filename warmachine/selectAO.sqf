/*
	Author: IvosH
	
	Description:
		Script for selection AREA OF OPERATION. Automatically generate markers for Sectors, Fobs and Bases.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		dialog.hpp
		
	Execution:
		[] execVM "warmachine\selectAO.sqf";
*/

hint parseText format ["SELECT AREA OF OPERATION<br/>on the map by left mouse button click (LMB).<br/><br/>Selected area will be the position of sector Alpha . Sector Bravo, Fobs and Bases will be generated automatically"];

["AOselect", "onMapSingleClick", {[_pos] execVM "warmachine\ao.sqf";}] call BIS_fnc_addStackedEventHandler;