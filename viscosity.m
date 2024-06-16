function eta = viscosity(theta)
%η = f(theta), theta: temperature in ℃ 来源：R/M p91

VG = 320; % ISO-Viskositätsklasse
K = 0.18*10^(-3); % [Pa*s]
ln_2 = log(rho(theta)*VG*10^(-6)/K);
ln_1 = (159.56/(theta+95) - 0.1819)*ln_2; 
eta = K*exp(1)^ln_1;

end

function rho = rho(theta) % theta: temperature in ℃
rho_15 = 856;
rho = rho_15*(1-65*10^(-5)*(theta-15)); % 单位：kg/m^3

end