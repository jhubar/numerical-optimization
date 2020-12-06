using Printf
using JuMP
using Gurobi
#using MosekTools
using ImageView
using Images

include("utilities.jl")

#PATH = "/Users/julienhubar/Documents/#Master1/numerical-optimization/Tps/project/data/"
PATH = "/mnt/data2/uliege/optimisation/data/"

MEASUREMENTS = [1014] # 608 1014 1521 3042]

# #-------------------------------------------------------
# #       l_1 norm for all non-corrupted measurements
# #-------------------------------------------------------

# for measurement_id in MEASUREMENTS

#   reconstruct_name_base = "uncorrupted_$(measurement_id).png"
#   measurements = unpickler( string(PATH, "uncorrupted_measurements_M$(measurement_id).pickle"))
#   measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
#   sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

#   print("Working on $(reconstruct_name_base)")

#   print(size(sparsifying_matrix))
#   print(size(measurement_matrix))
#   print(size(measurements))

#   c_matrix = measurement_matrix * sparsifying_matrix
#   print(size(c_matrix))


#   R, C = size(c_matrix)

#   # L1 Norm ------------------------------------------------------------
#   LP_model = Model(Gurobi.Optimizer)

#   @variable(LP_model, x[i=1:C]) # The sparse vector we're looking for
#   @constraint(LP_model, matrix_c, c_matrix * x .== measurements)


#   @variable(LP_model, t[i=1:C] >= 0)
#   @constraint(LP_model, x .<= t) # . make comparing each x_i to each t_i
#   @constraint(LP_model, -x .<= t)
#   @variable(LP_model, t_sum >= 0)
#   @constraint(LP_model, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ... This is here 'cos stc wasn't able to put it directly in the objective function
#   @objective(LP_model, Min, t_sum)
#   optimize!(LP_model)

#   idata = reshape( sparsifying_matrix * value.(x), 78, 78)
#   save( string("L1_non_opt_",reconstruct_name_base), colorview(Gray,idata))
#   # imshow(idata)
# end

# #-------------------------------------------------------
# #       l_2norm for all non-corrupted measurements
# #-------------------------------------------------------

# for measurement_id in MEASUREMENTS

#   reconstruct_name_base = "uncorrupted_$(measurement_id).png"
#   measurements = unpickler( string(PATH, "uncorrupted_measurements_M$(measurement_id).pickle"))
#   measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
#   sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

#   print("Working on $(reconstruct_name_base)")

#   print(size(sparsifying_matrix))
#   print(size(measurement_matrix))
#   print(size(measurements))

#   c_matrix = measurement_matrix * sparsifying_matrix
#   print(size(c_matrix))


#   R, C = size(c_matrix)
#   # Closed-form solution to the l2-norm problem ------------------------

#   LP_model2 = Model(Gurobi.Optimizer)
#   @variable(LP_model2, x[i=1:C]) # The sparse vector we're looking for

#   # The sparse vector must satisfy the compressi ve sensing constraints:
#   @constraint(LP_model2, matrix_c, c_matrix * x .== measurements)

#   # The sparse vector must be minimized according to L2 norm
#   # To achieve that, we express the norm "into" a second order cone.
#   @variable(LP_model2, t >= 0)
#   @constraint(LP_model2, epigraph, vcat(t, x) in SecondOrderCone())

#   # By minimizing t_sum, we actually minimize the L2 norm
#   @objective(LP_model2, Min, t)

#   optimize!(LP_model2)

#   idata = reshape( sparsifying_matrix * value.(x), 78, 78)
#   imshow(idata)
#   save( string( "L2_",reconstruct_name_base), colorview(Gray,idata))
# end


#-------------------------------------------------------
#       First variant
#-------------------------------------------------------

# for EPSILON in [0.1 0.01 0.001]
#   for measurement_id in MEASUREMENTS

#     reconstruct_name_base = "noisy_$(measurement_id).png"
#     measurements = unpickler( string(PATH, "noisy_measurements_M$(measurement_id).pickle"))
#     measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
#     sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

#     print("Working on $(reconstruct_name_base)")

#     print(size(sparsifying_matrix))
#     print(size(measurement_matrix))
#     print(size(measurements))

#     c_matrix = measurement_matrix * sparsifying_matrix
#     print(size(c_matrix))


#     R, C = size(c_matrix)



#     LP_model3 = Model(Gurobi.Optimizer)

#     epsilon = [EPSILON for i in 1:R]
#     # epsilon = [0.5 for i in 1:R]


#     @variable(LP_model3, x[i=1:C]) # The sparse vector we're looking for

#     # Constraint + allowing a bit of room for errors
#     @constraint(LP_model3, matrix_c, (c_matrix * x - measurements) ./ measurements .<= epsilon )
#     @constraint(LP_model3, matrix_c_opposite, (c_matrix * x - measurements) ./ measurements .>= -epsilon )

#     # Expressing L1 Norm
#     @variable(LP_model3, t[i=1:C] >= 0)
#     @constraint(LP_model3, x .<= t) # . make comparing each x_i to each t_i
#     @constraint(LP_model3, -x .<= t)
#     @variable(LP_model3, t_sum >= 0)
#     @constraint(LP_model3, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ..
#     @objective(LP_model3, Min, t_sum)

#     optimize!(LP_model3)
#     idata = reshape( sparsifying_matrix * value.(x), 78, 78)
#     save( string("L1_ep_0_01_",reconstruct_name_base), colorview(Gray,idata))

#     save( string("L1_bis_ep_", replace( @sprintf( "%f", EPSILON), "." => "_"), reconstruct_name_base), colorview(Gray,idata))

#   end
# end


# #-------------------------------------------------------
# #       Second variant
# #-------------------------------------------------------

# for EPSILON in [0.1 0.01 0.001]
#   for measurement_id in MEASUREMENTS

#     reconstruct_name_base = "noisy_$(measurement_id).png"
#     measurements = unpickler( string(PATH, "noisy_measurements_M$(measurement_id).pickle"))
#     measurement_matrix = unpickler( string(PATH, "measurement_matrix_M$(measurement_id).pickle"))
#     sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

#     print("Working on $(reconstruct_name_base)")

#     print(size(sparsifying_matrix))
#     print(size(measurement_matrix))
#     print(size(measurements))

#     c_matrix = measurement_matrix * sparsifying_matrix
#     print(size(c_matrix))


#     R, C = size(c_matrix)


#     LP_model5 = Model(Gurobi.Optimizer)

#     # The sparse vector we're looking for
#     @variable(LP_model5, s[i=1:C])

#     # Expressing L1 Norm over s
#     @variable(LP_model5, t[i=1:C] >= 0)
#     @constraint(LP_model5, s .<= t) # . make comparing each x_i to each t_i
#     @constraint(LP_model5, -s .<= t)
#     @variable(LP_model5, l1norm >= 0)
#     @constraint(LP_model5, sum(t) == l1norm)

#     # Expressing the boundary on the l2 norm of error
#     @constraint(LP_model5, l2norm, vcat(EPSILON, c_matrix * s - measurements) in SecondOrderCone())

#     @objective(LP_model5, Min, l1norm)

#     #write_to_file(LP_model5, "model.mps")
#     start = time()
#     optimize!(LP_model5)
#     elapsed = time() - start

#     print("!!! Robust 2 $(reconstruct_name_base) epsilon=$(EPSILON) elpase=$(elapsed) seconds\n")

#     idata = reshape( sparsifying_matrix * value.(s), 78, 78)
#     save( string("L5_",reconstruct_name_base), colorview(Gray,idata))

#     save( string("Robust2_ep_", replace( @sprintf( "%f", EPSILON), "." => "_"), reconstruct_name_base), colorview(Gray,idata))

#   end
# end

#   #-------------------------------------------------------
#   #       Third variant
#   #-------------------------------------------------------

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

  tau_base = R

  for TAU in [tau_base*0.5 tau_base tau_base*2]


    LP_model4 = Model(Gurobi.Optimizer)

    @variable(LP_model4, s[i=1:C]) # The sparse vector we're looking for

    # Expressing L1 Norm
    @variable(LP_model4, t[i=1:C] >= 0)
    @constraint(LP_model4, s .<= t) # . make comparing each x_i to each t_i
    @constraint(LP_model4, -s .<= t)
    @constraint(LP_model4, sum(t) <= TAU)

    @variable(LP_model4, l2norm >= 0)
    # @constraint(LP_model4, sum( (c_matrix * s - measurements) .^ 2) <= l2norm)
    @constraint(LP_model4, norm2, vcat(l2norm, c_matrix * s - measurements) in SecondOrderCone())

    @objective(LP_model4, Min, l2norm)

    #write_to_file(LP_model4, "model.mps")
    optimize!(LP_model4)

    idata = reshape( sparsifying_matrix * value.(s), 78, 78)
    save( string("L1_new_robust_",reconstruct_name_base), colorview(Gray,idata))

    save( string("Robust3_tau_", replace( @sprintf( "%f", TAU), "." => "_"), reconstruct_name_base), colorview(Gray,idata))
  end
end
