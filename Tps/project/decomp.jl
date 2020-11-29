using JuMP
using Gurobi
#using MosekTools
using ImageView

include("utilities.jl")


PATH = "/mnt/data2/uliege/optimisation/data/"
measurements = unpickler( string(PATH, "uncorrupted_measurements_M1014.pickle"))
measurement_matrix = unpickler( string(PATH, "measurement_matrix_M1014.pickle"))
sparsifying_matrix = unpickler( string(PATH, "basis_matrix.pickle"))



print(size(sparsifying_matrix))
print(size(measurement_matrix))
print(size(measurements))

c_matrix = measurement_matrix * sparsifying_matrix
print(size(c_matrix))


R, C = size(c_matrix)

# https://jump.dev/JuMP.jl/stable/constraints/#Vectorized-constraints-1

LP_model = Model(Gurobi.Optimizer)


@variable(LP_model, x[i=1:C])
@constraint(LP_model, matrix_c, c_matrix * x .== measurements)

# Expressing objective function as L1 norm
# https://support.gurobi.com/hc/en-us/community/posts/360056614871-L1-norm-in-objective-function

@variable(LP_model, t[i=1:C] >= 0)
@constraint(LP_model, x .<= t)
@constraint(LP_model, -x .<= t)
@variable(LP_model, t_sum >= 0)
@constraint(LP_model, sum(t) == t_sum)

@objective(LP_model, Min, t_sum)

optimize!(LP_model)
idata = reshape( sparsifying_matrix * value.(x), 78, 78)

imshow(idata)
