//Enable/disable admin options (radio, loop)
//(initPlayerLocal.sqf) null = [] execVM "admin\radio.sqf";
for "_i" from 0 to 1 step 0 do
{
	sleep 7;
	if ((serverCommandAvailable "#kick")||(count(allPlayers - entities "HeadlessClient_F")==1))
	then {10 setRadioMsg "Admin Menu";} 
	else {10 setRadioMsg "null";};
	sleep 60;
};