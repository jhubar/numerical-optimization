include("utilities.jl")


PATH = "/mnt/data2/uliege/optimisation/data/"

MEASUREMENTS = [608 1014 1521 3042]

for measurement_id in MEASUREMENTS

  local noisy = unpickler( string(PATH, "noisy_measurements_M$(measurement_id).pickle"))
  clean = unpickler( string(PATH, "uncorrupted_measurements_M$(measurement_id).pickle"))

  N = size(clean)[1]
  avg = sum(clean) / N
  std = sqrt( sum( clean .* clean) / (N-1))
  max = maximum( broadcast(abs,clean))

  print("MEASUREMENTS M$(measurement_id)\n")
  print("   Data  : avg=$(avg) std=$(std) max=$(max)\n")

  noise = noisy - clean
  N = size(noise)[1]

  avg = sum(noise) / N
  std = sqrt( sum(noise .* noise) / (N-1))
  max = maximum( broadcast(abs,noise))

  print("   Noise : avg=$(avg) std=$(std) max=$(max)\n")

  epsilon = sum(broadcast(abs,noise)) / N
  epsilon_l2 = sum(noise .* noise)
  print("   Expected epsilon: element-wise $(epsilon), L2 norm: $(epsilon_l2)")

  print("\n\n")

end
