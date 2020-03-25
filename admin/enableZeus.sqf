//close dialog window
closeDialog 0;
//condition: if player is admin (server host) or if command is available for everybody
if ((serverCommandAvailable "#kick")||(count(allPlayers - entities "HeadlessClient_F")==1)) then
{
	//player become Zeus
	[player, z1] remoteExec ["assignCurator", 0, true];
	//all players and playable units will be editable by Zeus
	z1 addCuratorEditableObjects [allplayers+playableUnits];
	hint "ZEUS Enabled";
} else
//if player is client and command is available only for admin (server host)
{
	//player does not become Zeus, hint is displayed
	hint "Command is available only for admin";
};