function epsilon = hmin_to_epsilon(D,psi_1000,h_min)
% D in [mm], psi*1000   e.g. psi = 1.6667
epsilon = 1 - 2/(D*psi_1000) * h_min;
end