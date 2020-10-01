
# include("/Users/julienhubar/Documents/#Master1/numerical-optimization/Tps/SimplexeExoSup/simplex_method.jl")
#
# using Main.SimplexMethod
# using LinearAlgebra
c = [-3; -2; -1; -5; 0; 0; 0]
A = [7 3 4 1 1 0 0 ;
     2 1 1 5 0 1 0 ;
     1 4 5 2 0 0 1 ]
b = [7; 3; 8]
simplex_method(c, A, b)
