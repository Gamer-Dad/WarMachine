/*
	Author: IvosH
	
	Description:
		Add missiom briefing 
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		init.sqf
		
	Execution:
		call compile preProcessFileLineNumbers "diary.sqf";
*/

if (!hasInterface) exitWith {};
waitUntil {!isNull player};

/*
unitName createDiarySubject [subject, displayName, picture-optional];
unitName createDiaryRecord [subject, [title, text], task-optional, state-optional];

modifiers, links, and font options
<marker name='marker_name'>text with link</marker>
<img image='Image file name jpeg or paa' />
<font color='#FF0000' size='14' face='vbs2_digital'>Text you want in this font</font>
<br/> New Line

http://www.w3schools.com/colors/colors_picker.asp
https://community.bistudio.com/wikidata/images/archive/0/0e/20140217182059%21Arma3Fonts.png
*/

player createDiaryRecord 
["Diary",["Credits","
Author:<br/>
IvosH<br/><br/>
Thanks to:<br/>
Bohemia Interactive<br/>
For Arma 3 and community support<br/><br/>
Feuerex<br/>
Killzone Kid<br/>
Larrow<br/>
Ud1e<br/>
Majkl<br/>
Flash-Ranger<br/>
kju<br/>
Libor<br/>
Lucie 
"]];

player createDiaryRecord 
["Diary",["Admin options","
Zeus is available for admin, server host and if player is on the server alone <br/><br/>
LOBBY PARAMETERS<br/>
Mission generator can be available for anyone, or only for admin.<br/> 
Virtual arsenal can be disabled.<br/>
Enable DLC content.<br/><br/>
ADMIN MENU (accessible via radio)<br/>
To access Administrator menu - Press 0-0-0
"]];

player createDiaryRecord 
["Diary",["Features","
MISSION GENERATOR (Actions menu) - Create mission. Opens setup dialog window. Select area of operation, set up mission parameters, start mission.<br/><br/>
SECTORS - The capture area of the Sectors (Fob) has a radius of 50 meters. Holding majority of the sectors reduces opponents respawn tickets. Capturing speed depends on the number of players and AI units present in the area. More players / AI units = faster capturing. Reward: respawn position, combat support.<br/><br/>
COMBAT SUPPORT - Every squad leader can access combat support by pressing 0-8-(support type). CAS and artillery is obtained as a reward after capturing a sector. (every 20 minutes)<br/><br/>
FLAGS - Serve as a teleports for fast travel between Base, Fob and Runway.<br/><br/>
MARKERS - Represent position of the Base, Fob and respawn positions of the vehicles.<br/><br/>
CUSTOM LOADOUT - You can create custom loadout in the virtual arsenal, supply box on the base. Custom Loadout is available in the respawn menu: Default > Custom Loadout<br/><br/>
EQUIPMENT - Appropriate equipment is required for special actions. No role restrictions. | Medkit, First aid kit - revive teammates | Toolkit - repair vehicles and defuse explosives | UAV terminal – hack and operate UAV<br/><br/>
BECOME SQUAD LEADER (Actions menu) - You can become leader of your squad.<br/><br/>
LEAVE LEADER POSITION (Actions menu) - To leave the squad leader position.<br/><br/>
AIR DROP (Actions menu) -  Squad leader can request an airdrop. Supplybox | Car | Truck | Patrol boat | Small boat.<br/><br/>
FORTIFICATION (Actions menu) - As a squad leader, you can build fortifications.<br/><br/>
FLIP VEHICLE (Actions menu) - Turn vehicle back on the wheels.<br/><br/>
PUSH THE BOAT (Actions menu) - Player can push the boat into the water (Boat will be moved 15m in front of the player)
"]];

player createDiaryRecord 
["Diary",["SP, Coop","
To play mission as Singleplayer or Coop, enable autonomous AI in the mission generator, or use ZEUS. If autonomous AI is enabled, all AI units will join the battle and attack objectives. All playable units and vehicles are editable by Zeus. Zeus is available for administrator and server host. Tickets are reduced when player or AI unit dies. Tickets bleed by holding majority of the sectors (1st. phase), or if Attackers capture enemy FOB (2nd phase). Do not delete any of the playable units or vehicles created by the mission generator. New units created by Zeus don't affect tickets.
"]];

player createDiaryRecord 
["Diary",["PvE, PvP","
It's recommended to be a squad leader. If autonomous AI is disabled, AI units need to be led by the player. Occupy the squad leader positions first in the lobby, or select BECOME SQUAD LEADER in the actions menu. For pure PvP disable AI in the lobby.
"]];

player createDiaryRecord 
["Diary",["Gameplay","
Advance And Secure game mode consists of two phases. First phase of the scenario is a sector control game, second phase is an attack/defend game.<br/><br/>
<img image='plot1.paa' width='368' height='184'/><br/><br/>
SECTOR CONTROL<br/>
Both teams fight for 1-3 sectors. If your team holds more sectors than enemy, then opponent’s tickets start bleeding. You win first phase, if enemy runs out of tickets.<br/><br/>
<img image='plot2.paa' width='368' height='92'/><br/><br/>
ATTACK/DEFEND<br/>
Team, that won the first phase, attacks the enemy FOB (forward operating base). Enemy team has to defend. If attackers  capture enemy FOB, then defender’s tickets start bleeding. You win, if enemy tickets are depleted.
"]];

player createDiaryRecord 
["Diary",["WarMachine","
WARMACHINE ALTIS<br/><br/>
<img image='lobby.paa' width='368' height='184'/><br/><br/>
WARMACHINE <br/>
Advance And Secure game mode for Arma 3, with dynamically generated missions. Inspired by the Battlefield games, combining conquest and rush game modes. Multiplayer scenario can be played as SP / Coop / PvP. Game mode is playable from 1 to 48 players. <br/><br/>
VARIABILITY <br/>
Every created mission is unique. In the mission generator, you can select any place on the map, set up mission parameters, or leave it randomized. You can easily create missions from small scale infantry combat to battlefield style scenario with all the vehicles, artillery and close air support. Mission layout is every time different. <br/><br/>
IN ACTION <br/>
Autonomous AI and advanced respawn system is designed to populate battlefield with low number of players. AI units respawn on the best position closest to the fight and ready to attack. If autonomous AI is enabled, all AI units will join the battle and attack objectives. It's recommended to be a squad leader. Occupy the squad leader positions first in the lobby, or select BECOME SQUAD LEADER in the actions menu. <br/><br/>
FOCUSED ON COMBAT <br/>
Your main task is to fight with your team for victory. All weapons and vehicles are available from start. No restrictions to unlock equipment. No complicated logistics. Choose your favorite weapon and fight.
"]];