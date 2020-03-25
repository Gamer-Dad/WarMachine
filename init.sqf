//Author: IvosH
debug = false; //debug for testing
//VARIABLES SETUP
dSel = 0; //default dialog selection
AOcreated = 0; //area of operation is NOT selected
bExist = 0; //sector bravo is NOT created
cExist = 0; //sector charlie is NOT created
sideA = civilian;
sideD = civilian;

//VARIABLES----------------------------------------------------------------------------------------------------EDITABLE//
planes = 1; //0=No (no planes are used), 1=Yes (all "plH"s are airfields), 2=Yes(only 2 airfields available)
plH = 4; //number of AIRPORT MARKERS plH1 - plH5 (3min - 5max)
artillery = 1, //1=Yes (artillery exist for both factions) 0=No (mortars will be used, placed on the base)
boatsAr = 1, //1=Yes, 0=No (patrol boats request by Squad Leader)
diverG = 1, //1=Yes, 0=No (Add diving gear into the boats cargo)
dawn=["3:30h",3.5];dusk=["19:30h",19.5];fogs=[[0,0,0],[0.1,0.05,90],[0,0,0]]; //dawn, dusk time, fog parameters

//SIDES--------------------------------------------------------------------------------------------------------EDITABLE//
island = "ALTIS"; //map name
sideW = west; //independent
sideE = east; //independent
factionW = "NATO"; //name of the faction
factionE = "CSAT"; //name of the faction
flgW = "Flag_NATO_F"; //flag asset name  ("Flag_AAF_F")
flgE = "Flag_CSAT_F"; //flag asset name

//OBJECT POOLS-------------------------------------------------------------------------------------------------EDITABLE//
strAlpha = ["O_Truck_03_device_F","Land_Device_disassembled_F","Land_Device_assembled_F","B_UAV_02_F","O_UAV_02_F","B_UAV_05_F","B_T_UAV_03_F","O_T_UAV_04_CAS_F"]; //"I_UAV_02_F"
strBravo = ["Land_Wreck_Heli_Attack_01_F","Land_Wreck_Slammer_F","Land_Wreck_Hunter_F","Land_Wreck_Heli_Attack_02_F","Land_UWreck_MV22_F","Land_Wreck_LT_01_F","Land_Wreck_MBT_04_F","Land_Wreck_AFV_Wheeled_01_F"];
strCharlie = ["B_CargoNet_01_ammo_F","O_CargoNet_01_ammo_F","Land_TTowerBig_2_F","Land_Medevac_house_V1_F","Land_Research_house_V1_F","Land_RepairDepot_01_green_F","Land_RepairDepot_01_tan_F"]; //"I_CargoNet_01_ammo_F"
strFobWest = ["Land_Cargo_House_V1_F","Land_Cargo_Patrol_V1_F","Land_BagBunker_Tower_F","Land_Cargo_HQ_V1_F","Land_Cargo_Tower_V1_F","Land_BagBunker_Large_F","Land_BagBunker_Small_F","Land_HBarrierTower_F"];
strBaseWest = ["Land_Cargo_HQ_V1_F","Land_Cargo_Tower_V1_F","Land_BagBunker_Large_F"];
strFobEast = ["Land_Cargo_House_V3_F","Land_Cargo_Patrol_V3_F","Land_BagBunker_Tower_F","Land_Cargo_HQ_V3_F","Land_Cargo_Tower_V3_F","Land_BagBunker_Large_F","Land_BagBunker_Small_F","Land_HBarrierTower_F"];
strBaseEast = ["Land_Cargo_HQ_V3_F","Land_Cargo_Tower_V3_F","Land_BagBunker_Large_F"];
strFobC = "Land_HBarrierWall_corner_F";
strFob = ["Land_Razorwire_F", "Land_HBarrier_5_F", "Land_Barricade_01_10m_F"];

//VEHICLE POOLS------------------------------------------------------------------------------------------------EDITABLE//
//NATO light vehicles
BikeW = ["B_Quadbike_01_F"];
CarW = ["B_MRAP_01_F"]; CarDlcW = ["B_LSV_01_unarmed_F"]; //apex
CarArW = ["B_MRAP_01_gmg_F", "B_MRAP_01_hmg_F"]; CarArDlcW = ["B_LSV_01_armed_F","B_LSV_01_AT_F"]; //apex
TruckW = ["B_Truck_01_transport_F", "B_Truck_01_covered_F"];
//NATO armors
ArmorW1 = ["B_APC_Wheeled_01_cannon_F", "B_APC_Tracked_01_rcws_F"];
ArmorW2 = ["B_MBT_01_TUSK_F"]; ArmorDlcW2 = ["B_AFV_Wheeled_01_cannon_F","B_AFV_Wheeled_01_up_cannon_F"]; //tanks
aaW = ["B_APC_Tracked_01_AA_F"]; //AA
//NATO air vehicles
HeliTrW = ["B_Heli_Transport_01_camo_F", "B_Heli_Light_01_F"]; //DLC// "B_Heli_Transport_03_F"
HeliArW = ["B_Heli_Attack_01_F"]; //AAF// "B_Heli_Light_01_armed_F"
PlaneW = ["B_Plane_CAS_01_F"]; PlaneDlcW = ["B_Plane_Fighter_01_F"]; //jets
//NATO boats
boatTrW = ["B_Boat_Transport_01_F"];
boatArW = ["B_Boat_Armed_01_minigun_F"];
divEw=["U_B_Wetsuit","V_RebreatherB","G_B_Diving"]; divWw="arifle_SDAR_F"; divMw="30Rnd_556x45_Stanag_red"; 

//CSAT light vehicles
BikeE = ["O_Quadbike_01_F"];
CarE = ["O_MRAP_02_F"]; CarDlcE = ["O_LSV_02_unarmed_F"]; //apex
CarArE = ["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F"]; CarArDlcE = ["O_LSV_02_armed_F","O_LSV_02_AT_F"]; //apex
TruckE = ["O_Truck_03_transport_F", "O_Truck_03_covered_F"];
//CSAT armors
ArmorE1 = ["O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_cannon_F"];
ArmorE2 = ["O_MBT_02_cannon_F"]; ArmorDlcE2 = ["O_MBT_04_command_F","O_MBT_04_cannon_F"]; //tanks
aaE = ["O_APC_Tracked_02_AA_F"]; //AA
//CSAT air vehicles
HeliTrE = ["O_Heli_Light_02_unarmed_F"]; HeliTrDlcE = ["O_Heli_Transport_04_bench_F","O_Heli_Transport_04_covered_F"]; //helicopters
HeliArE = ["O_Heli_Attack_02_F"]; //AAF// "O_Heli_Light_02_F"
PlaneE = ["O_Plane_CAS_02_F"]; PlaneDlcE = ["O_Plane_Fighter_02_F"]; //jets
//CSAT boats
boatTrE = ["O_Boat_Transport_01_F"];
boatArE = ["O_Boat_Armed_01_hmg_F"];
divEe=["U_O_Wetsuit","V_RebreatherIR","G_O_Diving"]; divWe="arifle_SDAR_F"; divMe="30Rnd_556x45_Stanag_green";

//SIDE SPECIFICATION (do not edit)
call
{
	if (sideW == west) exitWith 
	{
		numW = 0; colorW = "colorBLUFOR"; iconW = "b_hq"; resStartW = "respawn_west_start"; resBaseW = "respawn_west_base"; resFobW = "respawn_west_fob"; resAW = "respawn_west_a"; resBW = "respawn_west_b"; resCW = "respawn_west_c"; endW = "End1"; AmmoW = wAmmo;
		SupReqW = wSupReq; SupDropW = wSupDrop; SupHeliW = wSupHeli; SupArtyW = wSupArty; SupCasHW = wSupCasH; SupCasBW = wSupCasB;
	};
	if (sideW == east) exitWith 
	{
		numW = 1; colorW = "colorOPFOR"; iconW = "o_hq"; resStartW = "respawn_east_start"; resBaseW = "respawn_east_base"; resFobW = "respawn_east_fob"; resAW = "respawn_east_a"; resBW = "respawn_east_b"; resCW = "respawn_east_c"; endW = "End2"; AmmoW = eAmmo;
		SupReqW = eSupReq; SupDropW = eSupDrop; SupHeliW = eSupHeli; SupArtyW = eSupArty; SupCasHW = eSupCasH; SupCasBW = eSupCasB;
	};
	if (sideW == independent) exitWith 
	{
		numW = 2; colorW = "colorIndependent"; iconW = "n_hq"; resStartW = "respawn_guerrila_start"; resBaseW = "respawn_guerrila_base"; resFobW = "respawn_guerrila_fob"; resAW = "respawn_guerrila_a"; resBW = "respawn_guerrila_b"; resCW = "respawn_guerrila_c"; endW = "End3"; AmmoW = iAmmo;
		SupReqW = iSupReq; SupDropW = iSupDrop; SupHeliW = iSupHeli; SupArtyW = iSupArty; SupCasHW = iSupCasH; SupCasBW = iSupCasB;
	};
};
call
{
	if (sideE == west) exitWith 
	{
		numE = 0; colorE = "colorBLUFOR"; iconE = "b_hq"; resStartE = "respawn_west_start"; resBaseE = "respawn_west_base"; resFobE = "respawn_west_fob"; resAE = "respawn_west_a"; resBE = "respawn_west_b"; resCE = "respawn_west_c"; endE = "End1"; AmmoE = wAmmo;
		SupReqE = wSupReq; SupDropE = wSupDrop; SupHeliE = wSupHeli; SupArtyE = wSupArty; SupCasHE = wSupCasH; SupCasBE = wSupCasB;
	};
	if (sideE == east) exitWith 
	{
		numE = 1; colorE = "colorOPFOR"; iconE = "o_hq"; resStartE = "respawn_east_start"; resBaseE = "respawn_east_base"; resFobE = "respawn_east_fob"; resAE = "respawn_east_a"; resBE = "respawn_east_b"; resCE = "respawn_east_c"; endE = "End2"; AmmoE = eAmmo;
		SupReqE = eSupReq; SupDropE = eSupDrop; SupHeliE = eSupHeli; SupArtyE = eSupArty; SupCasHE = eSupCasH; SupCasBE = eSupCasB;
	};
	if (sideE == independent) exitWith 
	{
		numE = 2; colorE = "colorIndependent"; iconE = "n_hq"; resStartE = "respawn_guerrila_start"; resBaseE = "respawn_guerrila_base"; resFobE = "respawn_guerrila_fob"; resAE = "respawn_guerrila_a"; resBE = "respawn_guerrila_b"; resCE = "respawn_guerrila_c"; endE = "End3"; AmmoE = iAmmo;
		SupReqE = iSupReq; SupDropE = iSupDrop; SupHeliE = iSupHeli; SupArtyE = iSupArty; SupCasHE = iSupCasH; SupCasBE = iSupCasB;
	};
};
fobW = format ["FOB %1", factionW];
fobE = format ["FOB %1", factionE];
baseW = format ["BASE %1", factionW];
baseE = format ["BASE %1", factionE];
taskW = format ["Secure %1 forward operating base", factionW];
taskE = format ["Secure %1 forward operating base", factionE];

//LOBBY PARAMETERS
if ("Param2" call BIS_fnc_getParamValue == 1) then
{
	[AmmoW,sideW] call wrm_fnc_arsInit; //preload arsenal
	[AmmoE,sideE] call wrm_fnc_arsInit;
};

if ("apexOn" call BIS_fnc_getParamValue == 0) then 
{
	CarW = CarW + CarDlcW;
	CarArW = CarArW + CarArDlcW;
	CarE = CarE + CarDlcE;
	CarArE = CarArE + CarArDlcE;
};

if ("heliOn" call BIS_fnc_getParamValue == 0) then 
{
	HeliTrE = HeliTrE + HeliTrDlcE;
};

if ("jetsOn" call BIS_fnc_getParamValue == 0) then 
{
	PlaneW = PlaneW + PlaneDlcW;
	PlaneE = PlaneE + PlaneDlcE;
};
if ("TankOn" call BIS_fnc_getParamValue == 0) then 
{
	ArmorW2 = ArmorW2 + ArmorDlcW2;
	ArmorE2 = ArmorE2 + ArmorDlcE2;
};

//ADD BRIEFING [briefing.sqf]
call compile preProcessFileLineNumbers "diary.sqf";