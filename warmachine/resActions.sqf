if (!hasInterface) exitWith {};
waitUntil {!isNull player}; //JIP
waitUntil {progress > 2}; //fight for FOB started
waitUntil {alive player}; //player has respawned

//reset player actions menu
if (lUpdate == 2) then {player removeAction LDRaction; [player, SupReq] remoteExec ["BIS_fnc_removeSupportLink", 0, false];};
if (lUpdate == 1) then {player removeAction LDRdown;};
if (carUsed==0) then {player removeAction carAction;};
if (truckUsed==0) then {player removeAction truckAction;};
if (boatArUsed==0 && boatsAr==1) then {player removeAction BoatArAction;};
if (boatTrUsed==0) then {player removeAction BoatTrAction;};
if (fort==0) then {player removeAction fortAction;};
if (fort==1&&fort1==0) then {[player,f1] call BIS_fnc_holdActionRemove;};
if (fort==1&&fort2==0) then {[player,f2] call BIS_fnc_holdActionRemove;};
if (fort==1&&fort3==0) then {[player,f3] call BIS_fnc_holdActionRemove;};

carUsed=0;
truckUsed=0;
boatArUsed=0;
boatTrUsed=0;
fort = 0;
fort1 = 0;
fort2 = 0;
fort3 = 0;
lUpdate = 0;

[] spawn wrm_fnc_leaderActions;