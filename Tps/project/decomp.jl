using JuMP
using Gurobi
#using MosekTools
using ImageView
using Images


include("utilities.jl")


PATH = "/Users/julienhubar/Documents/#Master1/numerical-optimization/Tps/project/data/"
reconstruct_name_base = "uncorrupted_M608.png"
measurements = unpickler( string(PATH, "uncorrupted_measurements_M608.pickle"))
measurement_matrix = unpickler( string(PATH, "measurement_matrix_M608.pickle"))
sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))


c_matrix = measurement_matrix * sparsifying_matrix
print(size(c_matrix))


R, C = size(c_matrix)

LP_model3 = Model(Gurobi.Optimizer)

epsilon = [0.01 for i in 1:R]

@variable(LP_model3, x[i=1:C]) # The sparse vector we're looking for

# Constraint + allowing a bit of room for errors
@constraint(LP_model3, matrix_c, (c_matrix * x - measurements) ./ measurements .<= epsilon )
#@constraint(LP_model3, matrix_c, c_matrix * x .== measurements )

# Expressing L1 Norm
@variable(LP_model3, t[i=1:C] >= 0)
@constraint(LP_model3, x .<= t) # . make comparing each x_i to each t_i
@constraint(LP_model3, -x .<= t)
@variable(LP_model3, t_sum >= 0)
@constraint(LP_model3, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ..
@objective(LP_model3, Min, t_sum)

optimize!(LP_model3)
idata = reshape( sparsifying_matrix * value.(x), 78, 78)
save( string("L1_",reconstruct_name_base), colorview(Gray,idata))

reconstruct_name_base = "noisy_M608.png"
measurements = unpickler( string(PATH, "noisy_measurements_M608.pickle"))
measurement_matrix = unpickler( string(PATH, "measurement_matrix_M608.pickle"))
sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))


c_matrix = measurement_matrix * sparsifying_matrix
print(size(c_matrix))


R, C = size(c_matrix)

LP_model3 = Model(Gurobi.Optimizer)

epsilon = [0.01 for i in 1:R]

@variable(LP_model3, x[i=1:C]) # The sparse vector we're looking for

# Constraint + allowing a bit of room for errors
@constraint(LP_model3, matrix_c, (c_matrix * x - measurements) ./ measurements .<= epsilon )
#@constraint(LP_model3, matrix_c, c_matrix * x .== measurements )

# Expressing L1 Norm
@variable(LP_model3, t[i=1:C] >= 0)
@constraint(LP_model3, x .<= t) # . make comparing each x_i to each t_i
@constraint(LP_model3, -x .<= t)
@variable(LP_model3, t_sum >= 0)
@constraint(LP_model3, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ..
@objective(LP_model3, Min, t_sum)

optimize!(LP_model3)
idata = reshape( sparsifying_matrix * value.(x), 78, 78)
save( string("L1_",reconstruct_name_base), colorview(Gray,idata))
