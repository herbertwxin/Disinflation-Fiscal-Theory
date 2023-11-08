// Fiscal Theory Model Example

var pi x v s rn i q r us vstar;

varexo eps_s eps_i;

parameters sigma beta kappa phi_pi pi_bar i_bar omega alpha etas R;

sigma   = 1;
beta    = 0.99;
kappa   = 0.5;
phi_pi  = 0.8;
pi_bar  = 0.08;
i_bar   = pi_bar - log(beta);
omega  = 0.85;
R = 0.1;
alpha = 0.2;
etas = 0.7;


model(linear); 

x   = x(+1) - sigma*(i - i_bar - pi(+1) + pi_bar);

//pi  = (1-beta)*pi_bar + beta*pi(+1) + kappa* x;

pi = (1-beta)*pi_bar + 0.5*beta*pi(-1) + 0.5*beta*pi(+1) + kappa*x;

//i   = 0.999*i(-1) + i_bar + phi_pi*(pi - pi_bar) + eps_i;

i   = i_bar + phi_pi*(pi - pi_bar) + eps_i;

//v   = beta^(-1)*(v(-1) + (rn-i_bar) - (pi-pi_bar) - s);

rn(+1)  = i; 

(rn - i_bar) = omega*q - q(-1); 

// Simple fiscal rule
//s   = R*v(-1) - eps_s;

r  = i - i_bar - pi(+1) + pi_bar;

// S-shaped rule
//s = alpha*vstar + R*v + us;
s = alpha*vstar(-1) + R*v(-1) + us;
beta* vstar = vstar(-1) - s;
//beta* v = v(-1) - (rn - i_bar) - (pi - pi_bar) -s;
beta* v = v(-1) + (rn - i_bar) - (pi - pi_bar) -s;
us = etas * us(-1) + eps_s;

 

end;


steady;
check;

initval;
x   = 0;
pi  = pi_bar;
v   = 0;
i   = i_bar;
s   = 0;
rn  = i;
end;

shocks;
//var eps_i;
//stderr 1;
var eps_s;
stderr 1;
end;

stoch_simul(order = 1, irf = 30) ;