_veh=cursortarget;
_veh allowDammage false;
_veh setPos [(getPos _veh select 0),(getPos _veh select 1),0.2];
[objNull, _veh] call BIS_fnc_curatorObjectEdited;
sleep 1;
_veh allowDammage true;
