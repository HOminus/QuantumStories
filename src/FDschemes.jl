

using LinearAlgebra
using Plots
gr()

DIM = 100
LENGTH = 10
PLOT_LENGTH = 6 #only the interesing parts are plotted

function FinitePotentialWell(x)
    if abs(x) > 1
        return 50
    end
    0
end
function HarmonicOscillator(x)
    x^2
end

#Change function here to change the potential
function Potential(x)
    HarmonicOscillator(x)
end

function Kinetic(fd)
    KineticEnergy = zeros(Float32, (DIM, DIM))
    for i=1:DIM
        for j = 1:length(fd)
            if i - j + 1 >= 1
                KineticEnergy[i, i - j + 1] = (DIM/LENGTH)^2 * fd[j]
            end
        end
        for j=1:length(fd)
            if i + j - 1 <= DIM
                KineticEnergy[i, i + j - 1] = (DIM/LENGTH)^2 * fd[j]
            end
        end
    end
    return KineticEnergy
end

PotentialEnergy = zeros(Float32, (DIM, DIM))
for i = 1:DIM
    PotentialEnergy[i, i] = Potential((-LENGTH/2 + (i - 1)*LENGTH/(DIM - 1)))
end

#8th order FD scheme from wikipedia: https://en.wikipedia.org/wiki/Finite_difference_coefficient
Hamiltonian = 0.5 * (Kinetic(- 1 * [-205/72, 8/5, -1/5, 8/315, -1/560]) + PotentialEnergy)
egs = eigen(Hamiltonian)

function PlotPotential()
    return plot(range(-PLOT_LENGTH/2, PLOT_LENGTH/2, length = DIM),
                [Potential((-PLOT_LENGTH/2 + (i - 1)* PLOT_LENGTH/(DIM - 1))) for i=1:DIM], label="Potential")
end

function PlotProbabilityDensity(state, energy)
    prob_density = (DIM/LENGTH) * (abs.(state) .^2) .+ energy #rescale to density!
    plot!([-PLOT_LENGTH/2, PLOT_LENGTH/2], [energy, energy], label="") #Draw energy offset
    lb = trunc(Int, DIM/2 - PLOT_LENGTH/LENGTH * DIM/2) + 1
    ub = trunc(Int, DIM/2 + PLOT_LENGTH/LENGTH * DIM/2)
    plot!(range(-LENGTH/2, LENGTH/2, length = DIM)[lb:ub],
        prob_density[lb:ub], label="")
end

plt = PlotPotential()
PlotProbabilityDensity(egs.vectors[:, 1], egs.values[1])
PlotProbabilityDensity(egs.vectors[:, 2], egs.values[2])
PlotProbabilityDensity(egs.vectors[:, 3], egs.values[3])
PlotProbabilityDensity(egs.vectors[:, 4], egs.values[4])
display(plt)

read(stdin, Char)

savefig("img/HO_fd.png")

