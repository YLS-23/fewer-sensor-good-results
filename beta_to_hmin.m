function h_min = beta_to_hmin(beta,D,psi_1000,bd)
% D in [mm], psi*1000   e.g. 1.6667/1000 -> 1.6667
epsilon = beta_to_epsilon(beta,bd);
h_min = epsilon_to_hmin(D,psi_1000,epsilon);
end