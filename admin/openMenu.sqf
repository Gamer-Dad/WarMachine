//null = [] execVM "admin\openMenu.sqf";
if ((serverCommandAvailable "#kick")||(count(allPlayers - entities "HeadlessClient_F")==1))
then {createDialog "adminMenu";};
