NAME          
ROWS
 N  OBJ
 L  solar_PV_production[1]
 L  solar_PV_production[2]
 L  solar_PV_production[3]
 L  solar_PV_production[4]
 L  solar_PV_production[5]
 L  battery_max_state_of_charge[1]
 L  battery_max_state_of_charge[2]
 L  battery_max_state_of_charge[3]
 L  battery_max_state_of_charge[4]
 L  battery_max_state_of_charge[5]
 E  power_balance[1]
 E  power_balance[2]
 E  power_balance[3]
 E  power_balance[4]
 E  power_balance[5]
 E  battery_storage_dynamics[1]
 E  battery_storage_dynamics[2]
 E  battery_storage_dynamics[3]
 E  battery_storage_dynamics[4]
 E  hydrogen_storage_dynamics[1]
 E  hydrogen_storage_dynamics[2]
 E  hydrogen_storage_dynamics[3]
 E  hydrogen_storage_dynamics[4]
 L  hydrogen_storage_max_power[1]
 L  hydrogen_storage_max_power[2]
 L  hydrogen_storage_max_power[3]
 L  hydrogen_storage_max_power[4]
COLUMNS
     P_I[1]   power_balance[1] 1
     P_I[1]   OBJ      1
     P_I[2]   power_balance[2] 1
     P_I[2]   OBJ      1
     P_I[3]   power_balance[3] 1
     P_I[3]   OBJ      1
     P_I[4]   power_balance[4] 1
     P_I[4]   OBJ      1
     P_I[5]   power_balance[5] 1
     P_I[5]   OBJ      1
     P_S[1]   solar_PV_production[1] 1
     P_S[1]   power_balance[1] 1
     P_S[2]   solar_PV_production[2] 1
     P_S[2]   power_balance[2] 1
     P_S[3]   solar_PV_production[3] 1
     P_S[3]   power_balance[3] 1
     P_S[4]   solar_PV_production[4] 1
     P_S[4]   power_balance[4] 1
     P_S[5]   solar_PV_production[5] 1
     P_S[5]   power_balance[5] 1
     E_B[1]   battery_max_state_of_charge[1] 1
     E_B[1]   battery_storage_dynamics[1] -1
     E_B[2]   battery_max_state_of_charge[2] 1
     E_B[2]   battery_storage_dynamics[1] 1
     E_B[2]   battery_storage_dynamics[2] -1
     E_B[3]   battery_max_state_of_charge[3] 1
     E_B[3]   battery_storage_dynamics[2] 1
     E_B[3]   battery_storage_dynamics[3] -1
     E_B[4]   battery_max_state_of_charge[4] 1
     E_B[4]   battery_storage_dynamics[3] 1
     E_B[4]   battery_storage_dynamics[4] -1
     E_B[5]   battery_max_state_of_charge[5] 1
     E_B[5]   battery_storage_dynamics[4] 1
     E_H2[1]  hydrogen_storage_dynamics[1] -1
     E_H2[2]  hydrogen_storage_dynamics[1] 1
     E_H2[2]  hydrogen_storage_dynamics[2] -1
     E_H2[3]  hydrogen_storage_dynamics[2] 1
     E_H2[3]  hydrogen_storage_dynamics[3] -1
     E_H2[4]  hydrogen_storage_dynamics[3] 1
     E_H2[4]  hydrogen_storage_dynamics[4] -1
     E_H2[5]  hydrogen_storage_dynamics[4] 1
     P_B[1]   power_balance[1] 1
     P_B[1]   battery_storage_dynamics[1] 1
     P_B[2]   power_balance[2] 1
     P_B[2]   battery_storage_dynamics[2] 1
     P_B[3]   power_balance[3] 1
     P_B[3]   battery_storage_dynamics[3] 1
     P_B[4]   power_balance[4] 1
     P_B[4]   battery_storage_dynamics[4] 1
     P_B[5]   power_balance[5] 1
     P_H2[1]  power_balance[1] 1
     P_H2[1]  hydrogen_storage_dynamics[1] 1
     P_H2[1]  hydrogen_storage_max_power[1] 1
     P_H2[2]  power_balance[2] 1
     P_H2[2]  hydrogen_storage_dynamics[2] 1
     P_H2[2]  hydrogen_storage_max_power[2] 1
     P_H2[3]  power_balance[3] 1
     P_H2[3]  hydrogen_storage_dynamics[3] 1
     P_H2[3]  hydrogen_storage_max_power[3] 1
     P_H2[4]  power_balance[4] 1
     P_H2[4]  hydrogen_storage_dynamics[4] 1
     P_H2[4]  hydrogen_storage_max_power[4] 1
     P_H2[5]  power_balance[5] 1
RHS
    rhs       solar_PV_production[1]  0
    rhs       solar_PV_production[2]  5
    rhs       solar_PV_production[3]  20
    rhs       solar_PV_production[4]  15
    rhs       solar_PV_production[5]  3
    rhs       battery_max_state_of_charge[1]  20
    rhs       battery_max_state_of_charge[2]  20
    rhs       battery_max_state_of_charge[3]  20
    rhs       battery_max_state_of_charge[4]  20
    rhs       battery_max_state_of_charge[5]  20
    rhs       power_balance[1]  8
    rhs       power_balance[2]  12
    rhs       power_balance[3]  15
    rhs       power_balance[4]  20
    rhs       power_balance[5]  15
    rhs       battery_storage_dynamics[1]  0
    rhs       battery_storage_dynamics[2]  0
    rhs       battery_storage_dynamics[3]  0
    rhs       battery_storage_dynamics[4]  0
    rhs       hydrogen_storage_dynamics[1]  0
    rhs       hydrogen_storage_dynamics[2]  0
    rhs       hydrogen_storage_dynamics[3]  0
    rhs       hydrogen_storage_dynamics[4]  0
    rhs       hydrogen_storage_max_power[1]  2
    rhs       hydrogen_storage_max_power[2]  2
    rhs       hydrogen_storage_max_power[3]  2
    rhs       hydrogen_storage_max_power[4]  2
RANGES
    rhs       hydrogen_storage_max_power[1]  4
    rhs       hydrogen_storage_max_power[2]  4
    rhs       hydrogen_storage_max_power[3]  4
    rhs       hydrogen_storage_max_power[4]  4
BOUNDS
 LO bounds    P_I[1]   0
 PL bounds    P_I[1]  
 LO bounds    P_I[2]   0
 PL bounds    P_I[2]  
 LO bounds    P_I[3]   0
 PL bounds    P_I[3]  
 LO bounds    P_I[4]   0
 PL bounds    P_I[4]  
 LO bounds    P_I[5]   0
 PL bounds    P_I[5]  
 LO bounds    P_S[1]   0
 PL bounds    P_S[1]  
 LO bounds    P_S[2]   0
 PL bounds    P_S[2]  
 LO bounds    P_S[3]   0
 PL bounds    P_S[3]  
 LO bounds    P_S[4]   0
 PL bounds    P_S[4]  
 LO bounds    P_S[5]   0
 PL bounds    P_S[5]  
 LO bounds    E_B[1]   0
 PL bounds    E_B[1]  
 LO bounds    E_B[2]   0
 PL bounds    E_B[2]  
 LO bounds    E_B[3]   0
 PL bounds    E_B[3]  
 LO bounds    E_B[4]   0
 PL bounds    E_B[4]  
 LO bounds    E_B[5]   0
 PL bounds    E_B[5]  
 LO bounds    E_H2[1]  0
 PL bounds    E_H2[1] 
 LO bounds    E_H2[2]  0
 PL bounds    E_H2[2] 
 LO bounds    E_H2[3]  0
 PL bounds    E_H2[3] 
 LO bounds    E_H2[4]  0
 PL bounds    E_H2[4] 
 LO bounds    E_H2[5]  0
 PL bounds    E_H2[5] 
 FR bounds    P_B[1]
 FR bounds    P_B[2]
 FR bounds    P_B[3]
 FR bounds    P_B[4]
 FR bounds    P_B[5]
 FR bounds    P_H2[1]
 FR bounds    P_H2[2]
 FR bounds    P_H2[3]
 FR bounds    P_H2[4]
 FR bounds    P_H2[5]
ENDATA
