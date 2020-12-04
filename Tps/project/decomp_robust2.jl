using JuMP
using Gurobi
#using MosekTools
using ImageView
using Images

include("utilities.jl")

PATH = "/Users/julienhubar/Documents/#Master1/numerical-optimization/Tps/project/data/"

MEASUREMENTS = [608 1014 1521 3042]


for measurement_id in MEASUREMENTS

  reconstruct_name_base = "noisy_$(measurement_id).png"
  measurements = unpickler( string(PATH, "noisy_measurements_M$(measurement_id).pickle"))
  measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
  sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

    # T = 10
    # measurement_matrix = measurement_matrix[1:T,1:T]
    # sparsifying_matrix = sparsifying_matrix[1:T,1:T]
    # measurements = measurements[1:T]


    c_matrix = measurement_matrix * sparsifying_matrix
    print(size(c_matrix))


    R, C = size(c_matrix)
    TAU = measurement_id
    # 608 : bof
    # 2000 = null

    LP_model4 = Model(Gurobi.Optimizer)

    @variable(LP_model4, s[i=1:C]) # The sparse vector we're looking for

    # Expressing L1 Norm
    @variable(LP_model4, t[i=1:C] >= 0)
    @constraint(LP_model4, s .<= t) # . make comparing each x_i to each t_i
    @constraint(LP_model4, -s .<= t)
    @constraint(LP_model4, sum(t) <= TAU) # sum(t) = t_0 + t_1 + t_2 + ..

    @variable(LP_model4, l2norm >= 0)
    #@constraint(LP_model4, sum( (c_matrix * s - measurements) .^ 2) <= l2norm)

    @constraint(LP_model4, epigraph, vcat(l2norm, c_matrix * s - measurements) in SecondOrderCone())

    @objective(LP_model4, Min, l2norm)

    #write_to_file(LP_model4, "model.mps")
    optimize!(LP_model4)

    idata = reshape( sparsifying_matrix * value.(s), 78, 78)
    save( string("L1_new_robust2_",reconstruct_name_base), colorview(Gray,idata))

end
