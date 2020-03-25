/*
	Author: IvosH
	
	Description:
		Admin menu dialog layout.
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		admin scripts
		description.ext (#include "admin\adminMenu.hpp")
		defines.hpp
		
	Execution:
		Place trigger - repeatable
		Text: Administrator menu
		Activation: Radio Juliet
		On activation: aMenu = createDialog "adminMenu";
*/
class adminMenu
{
	idd = 2019;
	movingEnable = false;
	enableSimulation = 1;

	class controlsBackground // Background controls (placed behind Controls)
	{
		class IGUIBack_2200: IGUIBack
		{
			idc = 2201;
			x = 0.419792 * safezoneW + safezoneX;
			y = 0.247099 * safezoneH + safezoneY;
			w = 0.160417 * safezoneW;
			h = 0.263897 * safezoneH;
		};
	};
	
	class controls  // Main controls
	{
		class RscStructuredText_1100: RscStructuredText
		{
			idc = 501;
			text = "Administrator menu"; //--- ToDo: Localize;
			x = 0.419792 * safezoneW + safezoneX;
			y = 0.247099 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
		};
		class button1: RscButton
		{
			idc = 502;
			text = "Teleport"; //--- ToDo: Localize;
			x = 0.43125 * safezoneW + safezoneX;
			y = 0.291081 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Moves you to the selected location"; //--- ToDo: Localize;
			action = "[] execVM ""admin\teleport.sqf"";";
		};
		class button2: RscButton
		{
			idc = 503;
			text = "Enable ZEUS"; //--- ToDo: Localize;
			x = 0.43125 * safezoneW + safezoneX;
			y = 0.335064 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Zeus ON"; //--- ToDo: Localize;
			action = "[] execVM ""admin\enableZeus.sqf"";";
		};
		class button3: RscButton
		{
			idc = 504;
			text = "Disable ZEUS"; //--- ToDo: Localize;
			x = 0.43125 * safezoneW + safezoneX;
			y = 0.379047 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Zeus OFF"; //--- ToDo: Localize;
			action = "[] execVM ""admin\disableZeus.sqf"";";
		};
		class button4: RscButton
		{
			idc = 505;
			text = "Start 2nd phase"; //--- ToDo: Localize;
			x = 0.43125 * safezoneW + safezoneX;
			y = 0.42303 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Starts fight for the FOB"; //--- ToDo: Localize;
			action = "[] execVM ""admin\startFob.sqf"";";
		};
		class button5: RscButton
		{
			idc = 506;
			text = "Mission End"; //--- ToDo: Localize;
			x = 0.43125 * safezoneW + safezoneX;
			y = 0.467013 * safezoneH + safezoneY;
			w = 0.1375 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Terminates the mission"; //--- ToDo: Localize;
			action = "[] execVM ""admin\endGame.sqf"";";
		};
		class buttonClose: RscButton
		{
			idc = 507;
			text = "X"; //--- ToDo: Localize;
			x = 0.56875 * safezoneW + safezoneX;
			y = 0.247099 * safezoneH + safezoneY;
			w = 0.0114583 * safezoneW;
			h = 0.0219914 * safezoneH;
			tooltip = "Close admin menu"; //--- ToDo: Localize;
			action = "closeDialog 0;";
		};
	};
};
