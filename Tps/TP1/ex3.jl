using JuMP
using Gurobi
using MosekTools

# DEFINE PARAMETERS

T = 5
dT = 1
S_B = 20
F_H2 = 2
C = Dict([(1,8), (2,12), (3,15), (4,20), (5,15)])
pi_S = Dict([(1,0), (2,5), (3,20), (4,15), (5,3)])

# CREATE EMPTY MODEL

LP_model = Model(Gurobi.Optimizer)

# ADD VARIABLES

@variable(LP_model, 0 <= P_I[1:T])
@variable(LP_model, 0 <= P_S[1:T])
@variable(LP_model, P_B[1:T])
@variable(LP_model, P_H2[1:T])
@variable(LP_model, 0 <= E_B[1:T])
@variable(LP_model, 0 <= E_H2[1:T])

# ADD CONSTRAINTS

@constraint(LP_model, power_balance[t = 1:T], P_I[t] + P_S[t] + P_B[t] + P_H2[t] == C[t])
@constraint(LP_model, solar_PV_production[t = 1:T], P_S[t] <= pi_S[t])
@constraint(LP_model, battery_storage_dynamics[t = 1:T-1], E_B[t+1] == E_B[t] - P_B[t]*dT)
@constraint(LP_model, battery_max_state_of_charge[t = 1:T], E_B[t] <= S_B)
@constraint(LP_model, hydrogen_storage_dynamics[t = 1:T-1], E_H2[t+1] == E_H2[t] - P_H2[t]*dT)
@constraint(LP_model, hydrogen_storage_max_power[t = 1:T-1], -F_H2 <= P_H2[t] <= F_H2)

# ADD OBJECTIVE

@objective(LP_model, Min, sum(P_I))

# WRITE MODEL TO FILE

write_to_file(LP_model, "model.mps")

# SOLVE MODEL

optimize!(LP_model)

# RETRIEVE SOLUTIONS

battery_state_of_charge = value.(E_B)
