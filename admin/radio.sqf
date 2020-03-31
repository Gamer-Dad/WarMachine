//Enable/disable admin options (radio, loop)
//(initPlayerLocal.sqf) null = [] execVM "admin\radio.sqf";
for "_i" from 0 to 1 step 0 do
{
	sleep 7;
	_rd=0;
	call
	{
		if("param1" call BIS_fnc_getParamValue == 2)exitWith{_rd=1;}; //2
		if(serverCommandAvailable "#kick")exitWith{_rd=1;}; //0
		if(("param1" call BIS_fnc_getParamValue == 1)&&(count(allPlayers - entities "HeadlessClient_F")==1))exitWith{_rd=1;}; //1
	};
	if (_rd==1)
	//if (serverCommandAvailable "#kick") //DEDI
	then {10 setRadioMsg "Admin Menu";} 
	else {10 setRadioMsg "null";};
	sleep 59;
};