# L1 Norm ------------------------------------------------------------
# LP_model = Model(Gurobi.Optimizer)
#
# @variable(LP_model, x[i=1:C]) # The sparse vector we're looking for
# @constraint(LP_model, matrix_c, c_matrix * x .== measurements)
#
# # Expressing objective function as L1 norm
# # https://support.gurobi.com/hc/en-us/community/posts/360056614871-L1-norm-in-objective-function
#
# @variable(LP_model, t[i=1:C] >= 0)
# @constraint(LP_model, x .<= t) # . make comparing each x_i to each t_i
# @constraint(LP_model, -x .<= t)
# @variable(LP_model, t_sum >= 0)
# @constraint(LP_model, sum(t) == t_sum) # sum(t) = t_0 + t_1 + t_2 + ... This is here 'cos stc wasn't able to put it directly in the objective function
#
# optimize!(LP_model)
#
# idata = reshape( sparsifying_matrix * value.(x), 78, 78)
# save( string("L1_",reconstruct_name_base), colorview(Gray,idata))
# imshow(idata)
