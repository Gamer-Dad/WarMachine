/*
	Author: IvosH
	
	Description:
		MISSIONS GENERATOR dialog layout.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		description.ext
		defines.hpp
		
	Execution:
		#include "warmachine\dialog.hpp"
		dialogOpen = createDialog "warmachine"; publicVariable "dialogOpen";
*/
class missionsGenerator
{
	idd = 2017;
	movingEnable = false;
	enableSimulation = 1;
	onLoad = "execVM ""warmachine\dialog.sqf"";";

	class controlsBackground // Background controls (placed behind Controls)
	{
		class IGUIBack_2200: IGUIBack
		{
			idc = 2200;
			x = 0.345313 * safezoneW + safezoneX;
			y = 0.203116 * safezoneH + safezoneY;
			w = 0.309375 * safezoneW;
			h = 0.604764 * safezoneH;
		};
	};
	
	class controls  // Main controls
	{
		class headerName: RscStructuredText
		{
			idc = 101;
			text = "Missions generator"; //--- ToDo: Localize;
			x = 0.345313 * safezoneW + safezoneX;
			y = 0.181124 * safezoneH + safezoneY;
			w = 0.252083 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class headerGame: RscStructuredText
		{
			idc = 102;
			text = "WarMachine"; //--- ToDo: Localize;
			x = 0.597396 * safezoneW + safezoneX;
			y = 0.181124 * safezoneH + safezoneY;
			w = 0.0572917 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class text11: RscText
		{
			idc = 211;
			text = "Mission type"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.214111 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "What types of the vehicles will be avliable - AO size"; //--- ToDo: Localize;
		};
		class text12: RscText
		{
			idc = 212;
			text = "Time of day"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.214111 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class text21: RscText
		{
			idc = 221;
			text = "Number of sectors"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Holding majority of the sectors reduces opponents respawn tickets"; //--- ToDo: Localize;
		};
		class text22: RscText
		{
			idc = 222;
			text = "Weather"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.280086 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class text31: RscText
		{
			idc = 231;
			text = "Combat support"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.34606 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Combat support available for the squad leaders. Supply drop on the start. CAS and artilery as reward after capturing a sector"; //--- ToDo: Localize;
		};
		class taxt32: RscText
		{
			idc = 232;
			text = "Fog"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.34606 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class text41: RscText
		{
			idc = 241;
			text = "Autonomous AI"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.412034 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "All AI units will join the battle and attack objectives"; //--- ToDo: Localize;
		};
		class text42: RscText
		{
			idc = 242;
			text = "Respawn type"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.412034 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Where player can respawn"; //--- ToDo: Localize;
		};
		class text51: RscText
		{
			idc = 251;
			text = "Revive"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.478009 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Possibility to revive player"; //--- ToDo: Localize;
		};
		class text52: RscText
		{
			idc = 252;
			text = "Respawn tickets"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.478009 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Amount of the available respawns fo each side"; //--- ToDo: Localize;
		};
		class text61: RscText
		{
			idc = 261;
			text = "3rd person view"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.543983 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Third person view for player"; //--- ToDo: Localize;
		};
		class text62: RscText
		{
			idc = 262;
			text = "Ticket bleed"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.543983 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Reduces enemy tickets by holding majority of the sectors / capturing FOB"; //--- ToDo: Localize;
		};	
		class text71: RscText
		{
			idc = 271;
			text = "Time limit"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.609957 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Maximal duration of the game"; //--- ToDo: Localize;
		};
		class text72: RscText
		{
			idc = 272;
			text = "Player respawn time"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.609957 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class text81: RscText
		{
			idc = 281;
			text = "AO selection method"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.675931 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Random / By one click / Manually"; //--- ToDo: Localize;
		};
		class text82: RscText
		{
			idc = 282;
			text = "Vehicles respawn time"; //--- ToDo: Localize;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.675931 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Unarmed tansport vehicles / Armed vehicles"; //--- ToDo: Localize;
		};
		class combo11: RscCombo
		{
			idc = 311;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.247099 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo12: RscCombo
		{
			idc = 312;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.247099 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo21: RscCombo
		{
			idc = 321;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.313073 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo22: RscCombo
		{
			idc = 322;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.313073 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo31: RscCombo
		{
			idc = 331;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.379047 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo32: RscCombo
		{
			idc = 332;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.379047 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo41: RscCombo
		{
			idc = 341;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.445021 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo42: RscCombo
		{
			idc = 342;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.445021 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo51: RscCombo
		{
			idc = 351;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.510996 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo52: RscCombo
		{
			idc = 352;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.510996 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo61: RscCombo
		{
			idc = 361;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.57697 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo62: RscCombo
		{
			idc = 362;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.57697 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo71: RscCombo
		{
			idc = 371;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.642944 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo72: RscCombo
		{
			idc = 372;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.642944 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo81: RscCombo
		{
			idc = 381;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.708919 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class combo82: RscCombo
		{
			idc = 382;
			x = 0.505729 * safezoneW + safezoneX;
			y = 0.708919 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class buttonStart: RscButton
		{
			idc = 401;
			text = "Start mission"; //--- ToDo: Localize;
			x = 0.356771 * safezoneW + safezoneX;
			y = 0.741906 * safezoneH + safezoneY;
			w = 0.0630208 * safezoneW;
			h = 0.0439828 * safezoneH;
			tooltip = "Close dialog window and start the mission"; //--- ToDo: Localize;
			action = "[] execVM ""warmachine\startButton.sqf"";";
		};
		class buttonMap: RscButton
		{
			idc = 402;
			text = "Select Area of operation"; //--- ToDo: Localize;
			x = 0.43125 * safezoneW + safezoneX;
			y = 0.741906 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0439828 * safezoneH;
			tooltip = "Opens map to select area of operation"; //--- ToDo: Localize;
			action = "[] execVM ""warmachine\aoButton.sqf"";";
		};
		class ButtonCancel: RscButton
		{
			idc = 403;
			text = "Cancel"; //--- ToDo: Localize;
			x = 0.580208 * safezoneW + safezoneX;
			y = 0.741906 * safezoneH + safezoneY;
			w = 0.0630208 * safezoneW;
			h = 0.0439828 * safezoneH;
			tooltip = "Close dialog window, keeps current parameters"; //--- ToDo: Localize;
			action = "[] execVM ""warmachine\cancelButton.sqf"";";
		};
	};
};