
using Printf
using Combinatorics
using LinearAlgebra
using MathProgBase
export simplex_method

mutable struct SimplexTableau
  z_c     ::Array{Float64} # z_j - c_j
  Y       ::Array{Float64} # inv(B) * A
  x_B     ::Array{Float64} # inv(B) * b
  obj     ::Float64 # cost function at current solution
  b_idx   ::Array{Int64} # indices of base columns of A
end

function isnonnegative(x::Array{Float64})
  return length( x[ x .< 0] ) == 0
end

function initial_BFS(A, b)
  m, n = size(A)

  # select m columns out of n, all possibilities
  comb = collect(combinations(1:n, m))
  for i in length(comb):-1:1
    b_idx = comb[i]
      B = A[:, b_idx]

      # Now we have picked B, we solve for x. That will
      # be a BFS.

      # B|N * x = B
      # we let x_N = 0 => B x_B = b => x_B = inv(B) b

    x_B = inv(B) * b
    if isnonnegative(x_B)
      return b_idx, x_B, B
    end
  end

  error("Infeasible")
end

function print_tableau(t::SimplexTableau)
  m, n = size(t.Y)

  hline0 = repeat("-", 6)
  hline1 = repeat("-", 7*n)
  hline2 = repeat("-", 7)
  hline = join([hline0, "+", hline1, "+", hline2])

  println(hline)

  @printf("%6s|", "")
  for j in 1:length(t.z_c)
    @printf("%6.2f ", t.z_c[j])
  end
  @printf("| %6.2f\n", t.obj)

  println(hline)

  for i in 1:m
    @printf("x[%2d] |", t.b_idx[i])
    for j in 1:n
      @printf("%6.2f ", t.Y[i,j])
    end
    @printf("| %6.2f\n", t.x_B[i])
  end

  println(hline)
end

function pivoting!(t::SimplexTableau)
  m, n = size(t.Y)

  entering, exiting = pivot_point(t)
  println("Pivoting: entering = x_$entering, exiting = x_$(t.b_idx[exiting])")

  print_tableau(t)

  # Pivoting: exiting-row, entering-column
  # updating exiting-row : row <- row / coef
  coef = t.Y[exiting, entering]
  t.Y[exiting, :] /= coef # So t.Y[exiting,entering] becomes 1
  t.x_B[exiting] /= coef

  print_tableau(t)

  # updating other rows of Y
  for i in setdiff(1:m, exiting)
    coef = t.Y[i, entering]

    # i-th row <- i-th row - coef*exiting row
    # note that on the entering column, Y[enter,exit] = 1
    # so the whole exit-column is set to zero
    t.Y[i, :] -= coef * t.Y[exiting, :]
    t.x_B[i] -= coef * t.x_B[exiting]
  end

  # updating the row for the reduced costs
  coef = t.z_c[entering]
  t.z_c -= coef * t.Y[exiting, :]'
  t.obj -= coef * t.x_B[exiting]

  # Updating b_idx
  #findall(fct, blabla)
  println("entering:  ", entering)
  println("t.b_idx: ", t.b_idx)
  println("t.b_idx[exiting]:  ",t.b_idx[exiting])
  println("hoihaihaz")
  println(  t.b_idx[findall(x->x == 5, [5 6 7] )])
  println("yesssss")

  f = findall(x->x == t.b_idx[exiting], t.b_idx )[1]

  t.b_idx[ f ] = entering
  println("yesssss")
end

function pivot_point(t::SimplexTableau)
  # Finding the entering variable index

  # find any k such as z_k - c_k > 0

  entering = findfirst(t.z_c .> 0)

  if entering == nothing
    error("Optimal")
  else
    entering = entering[2]
  end

  # min ratio test / finding the exiting variable index
  pos_idx = findall( t.Y[:, entering] .> 0 ) # feasible solution
  if pos_idx == nothing
    error("Unbounded")
  end

  # Y [row, col]

  println("find pivot point")
  println( pos_idx)

  println(t.x_B[pos_idx] ./ t.Y[pos_idx, entering])
  println(argmin(t.x_B[pos_idx] ./ t.Y[pos_idx, entering]))

  exiting = pos_idx[ argmin( t.x_B[pos_idx] ./ t.Y[pos_idx, entering] ) ]

  println("entering $entering")
  println( "exiting $exiting")

  return (entering, exiting)
end

function initialize(c, A, b)
  c = Array{Float64}(c)
  A = Array{Float64}(A)
  b = Array{Float64}(b)

  m, n = size(A)

  # Finding an initial BFS x_B, and a base
  # and list of column indices of that base in A
  b_idx, x_B, B = initial_BFS(A,b)

  Y = inv(B) * A

  # we keep the basic variables and set non basic variable to 0
  # in the cost function. => we express the cost function
  # in terms of (non zero) basic variables
  c_B = c[b_idx]

  # we compute the value of the objective function at the BFS
  obj = dot(c_B, x_B)


  # z_c is a row of 0
  z_c = zeros(1,n)
  n_idx = setdiff(1:n, b_idx) #indices of non basic variables

  # z_j - c_j
  k = c_B' * inv(B) * A[:,n_idx] - c[n_idx]'

  println(k)
  z_c[n_idx] = k

  return SimplexTableau(z_c, Y, x_B, obj, b_idx)
end

function isOptimal(tableau)
  return findfirst( tableau.z_c .> 0 ) == nothing
end

function simplex_method(c, A, b)
  tableau = initialize(c, A, b)
  print_tableau(tableau)

  while !isOptimal(tableau)
    pivoting!(tableau)
    print_tableau(tableau)
  end

  opt_x = zeros(length(c))
  opt_x[tableau.b_idx] = tableau.x_B

  return opt_x, tableau.obj
end


# c = [-3; -2; -1; -5; 0; 0; 0]
# A = [7 3 4 1 1 0 0 ;
#      2 1 1 5 0 1 0 ;
#      1 4 5 2 0 0 1 ]
# b = [7; 3; 8]

# simplex_method(c, A, b)



c = [-3; -2; 0; 0; 0]
A = [2 1 1 0 0;
     2 3 0 1 0;
     3 1 0 0 1 ]
b = [18; 42; 24]
simplex_method(c, A, b) # expectd result is 33 => good !
