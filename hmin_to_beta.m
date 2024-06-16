function beta = hmin_to_beta(h_min,D,psi,bd)

epsilon = hmin_to_epsilon(D,psi,h_min);
beta = epsilon_to_beta(epsilon,bd);
end