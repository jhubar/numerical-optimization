using JuMP
using Gurobi
#using MosekTools
using ImageView
using Images

include("utilities.jl")

PATH = "/Users/julienhubar/Documents/#Master1/numerical-optimization/Tps/project/data/"

# MEASUREMENTS = [608 1014 1521 3042]
MEASUREMENTS = [1014]

for measurement_id in MEASUREMENTS

  reconstruct_name_base = "noisy_$(measurement_id).png"
  measurements = unpickler( string(PATH, "noisy_measurements_M$(measurement_id).pickle"))
  measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
  sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

  print("Working on $(reconstruct_name_base)")

  print(size(sparsifying_matrix))
  print(size(measurement_matrix))
  print(size(measurements))

  c_matrix = measurement_matrix * sparsifying_matrix
  print(size(c_matrix))


  R, C = size(c_matrix)

  # From https://www2.ece.ohio-state.edu/~schniter/pdf/cs_primer.pdf

  # Eplsion = 0.1 works fine on 608, in 83 seconds, less contrast
  # Epsilon = 0.01 works fine, 52 seconds
  # Epsilon = 0.001 works fine, 52 seconds. Not much better than 0.01
  EPSILON = 0.001


  LP_model5 = Model(Gurobi.Optimizer)

  # The sparse vector we're looking for
  @variable(LP_model5, s[i=1:C])

  # Expressing L1 Norm over s
  @variable(LP_model5, t[i=1:C] >= 0)
  @constraint(LP_model5, s .<= t) # . make comparing each x_i to each t_i
  @constraint(LP_model5, -s .<= t)
  @variable(LP_model5, l1norm >= 0)
  @constraint(LP_model5, sum(t) == l1norm)

  # Expressing the boundary on the l2 norm of error
  @constraint(LP_model5, l2norm, vcat(EPSILON, c_matrix * s - measurements) in SecondOrderCone())

  @objective(LP_model5, Min, l1norm)

  #write_to_file(LP_model5, "model.mps")
  optimize!(LP_model5)

  idata = reshape( sparsifying_matrix * value.(s), 78, 78)
  save( string("L5_",reconstruct_name_base), colorview(Gray,idata))


  end
