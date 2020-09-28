using JuMP
using Gurobi
using MosekTools


MILK_LITERS_PER_WEEK = 80
HOURS_PER_WEEK = 6
FRIDGE_LITERS = 20

BUTTER_LITER = 7 # liters of milk for 1kg butter
BUTTER_PRICE_PER_KILO = 7
BUTTER_HOUR_PER_KILO = 1

ICE_CREAM_LITER = 3
ICE_CREAM_PRICE_PER_KILO = 2
ICE_CREAM_HOUR_PER_KILO = 1/15


LP_model = Model(Gurobi.Optimizer)

@variable(LP_model, 0 <= butter_kilo)
@variable(LP_model, 0 <= ice_cream_liter)

@constraint(LP_model, max_fridge, ice_cream_liter <= FRIDGE_LITERS)
@constraint(LP_model, max_prod, butter_kilo * BUTTER_HOUR_PER_KILO + ice_cream_liter * ICE_CREAM_HOUR_PER_KILO <= HOURS_PER_WEEK)

@objective(LP_model, Max, butter_kilo + ice_cream_liter)

optimize!(LP_model)


println("Kilos of butter per week = $(value(butter_kilo)), liters of icecream per week = $(value( ice_cream_liter))")
