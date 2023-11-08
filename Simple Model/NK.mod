// Fiscal Theory in NK framework (Simple & No friction)

var pi x i v s r; //vstar rn q us;

varexo eps_s eps_i;

parameters sigma beta kappa R phi_i phi_s pi_bar i_bar; //alpha etas omega

sigma   = 1;
beta    = 0.99;
kappa   = 0.5;
R       = 0.35;
phi_i   = 1.5;
phi_s   = 0.4;0.5;
pi_bar  = 0.08;
i_bar   = pi_bar - log(beta);
//etas    = 0.7;
//omega   = 0.85;
//alpha   = 0.1;


model(linear); 

// Canonical NK-equations

x   = x(+1) - sigma*(i - i_bar - pi(+1) + pi_bar);

pi  = (1-beta)*pi_bar + beta*pi(+1) + kappa* x;

//pi = (1-beta)*pi_bar + 0.5*beta*pi(-1) + 0.5*beta*pi(+1) + kappa*x;

//i   = 0.999*i(-1) + i_bar + phi_pi*(pi - pi_bar) + eps_i;

i   = i_bar + phi_i*(pi - pi_bar) + eps_i;

r  = (i - i_bar) - (pi(+1) - pi_bar);

// Fiscal sector
// Surplus rule

//s = alpha*vstar + R*v + us;

s  = R*v(-1) + phi_s*(pi - pi_bar) + eps_s;

//s = alpha*vstar(-1) + R*v(-1) + us;

// Debt and latent debt

//beta* vstar = vstar(-1) - s;

v = beta^(-1)*v(-1) + (i - i_bar) - (pi - pi_bar) - s;

// Long-term debt

//beta* v = v(-1) - (rn - i_bar) - (pi - pi_bar) -s;

//beta*v   = v(-1) - (pi-pi_bar) + (rn-i_bar) - s;

//us = etas * us(-1) + eps_s;

//(rn - i_bar) = omega*q - q(-1); 

//rn(+1)  = i; 




end;

steady;
check;

initval;
x   = 0;
pi  = pi_bar;
v   = 0;
i   = i_bar;
s   = 0;
r   = -log(beta);
//rn  = i;
end;

shocks;
var eps_i;
stderr 1;
var eps_s;
stderr 1;
end;

stoch_simul(order = 1, irf = 30, nograph) ;