using JuMP
using Gurobi
#using MosekTools


model = Model(Gurobi.Optimizer)

# T is the size of the grid on which the villages are set
# (so T horizontal positions x T vertical positions)
T = 5

# We're going to have a collection of x_i,y_j variables.
# x_i = 1 if the antenna is on the x_i coordinate, 0 else.
# For that to work, sum(x_i) must be equal to 1 (only one antenna).
# idem for y_i.

# The goal of the optimizer is to find the one correct x_i
# and the one correct y_i to minimize the goal.

# Now, we precompute all the distances x² and y² on
# each axis between the (x_i,y_i) position and a given village

DV1X = Dict( [ (i,(i-1)*(i-1)) for i in 1:T ])
DV1Y = Dict( [ (i,(i-1)*(i-1)) for i in 1:T ])

DV2X = Dict( [ (i,(i-2)*(i-2)) for i in 1:T ])
DV2Y = Dict( [ (i,(i-5)*(i-5)) for i in 1:T ])

DV3X = Dict( [ (i,(i-1)*(i-1)) for i in 1:T ])
DV3Y = Dict( [ (i,(i-5)*(i-5)) for i in 1:T ])


@variable(model, 0 <= m)

@variable(model, 0 <= X_I[1:T])
@variable(model, 0 <= Y_I[1:T])

@constraint(model, sum(X_I) == 1)
@constraint(model, sum(Y_I) == 1)


# We build the m = max(D1,D2,...) (where D1 is distance from x_i,y_i to village 1).
# We do so by noting that m = max(D1,D2,...) iff m >= Di for all i.
@constraint(model,
           m >= sum( X_I[i]*DV1X[i] + Y_I[j]*DV1Y[j] for i in 1:T for j in 1:T))


@constraint(model,
           m >= sum( X_I[i]*DV2X[i] + Y_I[j]*DV2Y[j] for i in 1:T for j in 1:T))


@constraint(model,
           m >= sum( X_I[i]*DV3X[i] + Y_I[j]*DV3Y[j] for i in 1:T for j in 1:T))


@objective(model, Min, m)

optimize!(model)

x = findall( x -> x > 0, value.(X_I))[1]
y = findall( y -> y > 0, value.(Y_I))[1]

println( "position x=$x, y=$y")

write_to_file(model, "/tmp/model.mps")
