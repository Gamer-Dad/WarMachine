/*
	Author: IvosH
	
	Description:
		Delete markers from AO creation
		Disable revive
		3rd person view
		Create local markers for players
		
	Parameter(s):
		none
		
	Returns:
		nothing
		
	Dependencies:
		WarMachine scripts
		start.sqf
		
	Execution:
		"warmachine\markers.sqf" remoteExec ["execVM", 0, true];
*/
//Delete markers from AO creation
_mrks = ["mAo", "mAlpha", "mBravo", "mCenter", "mCenBlack1", "mAlphaBlack", "mBravoBlack", "mCharlie", "mFobWest", "mFobEastBlack", "mFobEast", "mCenBlack2", "mBaseWestBlack", "mBaseWest", "mBaseEastBlack", "mBaseEast"];
{deleteMarkerLocal _x;} forEach _mrks;

if (!hasInterface) exitWith {};
//disable revive
if(revOn==1)then{[player] call bis_fnc_disableRevive;};

//3rd person view
if(difficultyOption "thirdPersonView"==1)then
{
	call
	{
		if(viewType==1)then
		{
			addMissionEventHandler ["EachFrame",
			{
				if(lifeState player=="HEALTHY"||lifeState player=="INJURED")then
				{
					if(vehicle player==player)then
					{
						if(cameraView == "External"||cameraView == "Group")
						then{vehicle player switchCamera "Internal";};
					}else
					{
						if(cameraView == "Group")
						then{vehicle player switchCamera "External";};
					};
				};
			}];
		};
		if(viewType==2)then
		{
			addMissionEventHandler ["EachFrame",
			{
				if(lifeState player=="HEALTHY"||lifeState player=="INJURED")then
				{
					if(cameraView == "External"||cameraView == "Group")
					then{vehicle player switchCamera "Internal";};
				};
			}];
		};
	};
};

//create local markers for players
call
{
	if (side player == sideW) exitWith 
	{
		_mrkFob = createMarkerLocal ["mFob", posFobWest];
		_mrkFob setMarkerShapeLocal "ICON";
		_mrkFob setMarkerTypeLocal iconW;
		_mrkFob setMarkerTextLocal fobW;

		_mrkBase = createMarkerLocal ["mBase", posBaseWest];
		_mrkBase setMarkerShapeLocal "ICON";
		_mrkBase setMarkerTypeLocal iconW;
		_mrkBase setMarkerTextLocal baseW;
	};
	if (side player == sideE) exitWith 
	{
		_mrkFob = createMarkerLocal ["mFob", posFobEast];
		_mrkFob setMarkerShapeLocal "ICON";
		_mrkFob setMarkerTypeLocal iconE;
		_mrkFob setMarkerTextLocal fobE;

		_mrkBase = createMarkerLocal ["mBase", posBaseEast];
		_mrkBase setMarkerShapeLocal "ICON";
		_mrkBase setMarkerTypeLocal iconE;
		_mrkBase setMarkerTextLocal baseE;
	};
};

//systemChat "Markers created"; //debug