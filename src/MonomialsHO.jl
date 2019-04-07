
using LinearAlgebra

DIM = 10
LB = -5 #left boundary
UB = 5 #right boundary

S = zeros(Float32, (DIM, DIM)) #julia arrays start at 1
for i = 0:(DIM - 1)
    for j = 0:(DIM - 1)
        S[i + 1, j + 1] = 1/(i + j + 1)*(UB^(i + j + 1) - LB^(i + j + 1))
    end
end

V = zeros(Float32, (DIM, DIM))
for i = 0:(DIM - 1)
    for j = 0:(DIM - 1)
        V[i + 1, j + 1] = 1/(i + j + 3) * (UB^(i + j + 3) - LB^(i + j + 3))
    end
end

T = zeros(Float32, (DIM, DIM))
for i = 0:(DIM - 1)
    for j = 0:(DIM - 1)
        if i == 0 || j == 0
            T[i + 1, j + 1] = 0
        else
            T[i + 1, j + 1] = (i*j)/(i + j - 1) * (UB^(i + j - 1) - LB^(i + j - 1))
        end
    end
end

H = 0.5 * (T + V)

print(stdout, eigvals(H, S))
