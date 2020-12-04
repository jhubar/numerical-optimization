using JuMP
using Gurobi
#using MosekTools
using ImageView
using Images

include("utilities.jl")


PATH = "/Users/julienhubar/Documents/#Master1/numerical-optimization/Tps/project/data/"

MEASUREMENTS = [608 1521 3042] #  608 1014 1521 3042]


# measurements = unpickler( string(PATH, "uncorrupted_measurements_M608.pickle"))
# measurement_matrix = unpickler( string(PATH, "measurement_matrix_M608.pickle"))
# sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))


# c_matrix = measurement_matrix * sparsifying_matrix
# print(size(c_matrix))


# R, C = size(c_matrix)

# LP_model3 = Model(Gurobi.Optimizer)

# epsilon = [0.01 for i in 1:R]

# @variable(LP_model3, x[i=1:C]) # The sparse vector we're looking for

# # Constraint + allowing a bit of room for errors
# @constraint(LP_model3, matrix_c, (c_matrix * x - measurements) ./ measurements .<= epsilon )
# #@constraint(LP_model3, matrix_c, c_matrix * x .== measurements )

# # Expressing L1 Norm
# @variable(LP_model3, t[i=1:C] >= 0)
# @constraint(LP_model3, x .<= t) # . make comparing each x_i to each t_i
# @constraint(LP_model3, -x .<= t)
# @variable(LP_model3, t_sum >= 0)
# @constraint(LP_model3, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ..
# @objective(LP_model3, Min, t_sum)

# optimize!(LP_model3)


for measurement_id in MEASUREMENTS

  reconstruct_name_base = "uncorrupted_$(measurement_id).png"
  measurements = unpickler( string(PATH, "uncorrupted_measurements_M$(measurement_id).pickle"))
  measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
  sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

  print("Working on $(reconstruct_name_base)")

  print(size(sparsifying_matrix))
  print(size(measurement_matrix))
  print(size(measurements))

  c_matrix = measurement_matrix * sparsifying_matrix
  print(size(c_matrix))


  R, C = size(c_matrix)

  # https://jump.dev/JuMP.jl/stable/constraints/#Vectorized-constraints-1

  # L1 Norm ------------------------------------------------------------
  LP_model = Model(Gurobi.Optimizer)

  @variable(LP_model, x[i=1:C]) # The sparse vector we're looking for
  @constraint(LP_model, matrix_c, c_matrix * x .== measurements)

  # Expressing objective function as L1 norm
  # https://support.gurobi.com/hc/en-us/community/posts/360056614871-L1-norm-in-objective-function

  @variable(LP_model, t[i=1:C] >= 0)
  @constraint(LP_model, x .<= t) # . make comparing each x_i to each t_i
  @constraint(LP_model, -x .<= t)
  @variable(LP_model, t_sum >= 0)
  @constraint(LP_model, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ... This is here 'cos stc wasn't able to put it directly in the objective function
  @objective(LP_model, Min, t_sum)
  optimize!(LP_model)

  idata = reshape( sparsifying_matrix * value.(x), 78, 78)
  save( string("L1_new",reconstruct_name_base), colorview(Gray,idata))
  # imshow(idata)



  # Closed-form solution to the l2-norm problem ------------------------

  # LP_model2 = Model(Gurobi.Optimizer)
  # @variable(LP_model2, x[i=1:C]) # The sparse vector we're looking for

  # # The sparse vector must satisfy the compressi ve sensing constraints:
  # @constraint(LP_model2, matrix_c, c_matrix * x .== measurements)

  # # The sparse vector must be minimized according to L2 norm
  # # To achieve that, we express the norm "into" a second order cone.
  # @variable(LP_model2, t >= 0)
  # @constraint(LP_model2, epigraph, vcat(t, x) in SecondOrderCone())

  # # By minimizing t_sum, we actually minimize the L2 norm
  # @objective(LP_model2, Min, t)

  # optimize!(LP_model2)

  # idata = reshape( sparsifying_matrix * value.(x), 78, 78)
  # imshow(idata)
  # save( string( "L2_",reconstruct_name_base), colorview(Gray,idata))


  # Expressing as Robust L1 norm -------------------------------------

  # LP_model3 = Model(Gurobi.Optimizer)

  # epsilon = [0.01 for i in 1:C]

  # @variable(LP_model3, x[i=1:C]) # The sparse vector we're looking for

  # # Constraint + allowing a bit of room for errors
  # @constraint(LP_model3, matrix_c, (c_matrix * x - measurements) / measurements .<= epsilon )

  # # Expressing L1 Norm
  # @variable(LP_model3, t[i=1:C] >= 0)
  # @constraint(LP_model3, x .<= t) # . make comparing each x_i to each t_i
  # @constraint(LP_model3, -x .<= t)
  # @variable(LP_model3, t_sum >= 0)
  # @constraint(LP_model3, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ..
  # @objective(LP_model3, Min, t)

  # optimize!(LP_model3)

end
