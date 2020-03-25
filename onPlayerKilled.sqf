//Author: IvosH

//Set respawn time for player
if (progress > 1) then 
{
	setPlayerRespawnTime rTime;
} else
{
	setPlayerRespawnTime 1;
};
removeAllActions player;