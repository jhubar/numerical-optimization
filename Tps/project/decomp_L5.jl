using JuMP
using Gurobi
#using MosekTools
using ImageView
using Images

include("utilities.jl")

PATH = "/mnt/data2/uliege/optimisation/data/"

measurements = unpickler( string(PATH, "noisy_measurements_M608.pickle"))
measurement_matrix = unpickler( string(PATH, "measurement_matrix_M608.pickle"))
sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))

# T = 10
# measurement_matrix = measurement_matrix[1:T,1:T]
# sparsifying_matrix = sparsifying_matrix[1:T,1:T]
# measurements = measurements[1:T]


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
save( "L4_test_noisy_608.png", colorview(Gray,idata))
imshow(idata)
