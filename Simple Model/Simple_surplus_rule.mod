// Fiscal Theory Model Example

var pi x i v s r;

varexo eps_s eps_i;

parameters sigma beta kappa R phi_pi pi_bar i_bar;

sigma   = 1;
beta    = 0.99;
kappa   = 0.5;
R       = 0.35; 
phi_pi  = 1.5;
pi_bar  = 0.08;
i_bar   = pi_bar - log(beta);

model(linear); 

x   = x(+1) - sigma*(i - i_bar - pi(+1) + pi_bar);

//pi  = (1-beta)*pi_bar + beta*pi(+1) + kappa* x;

pi = (1-beta)*pi_bar + 0.5*pi(-1) + 0.5*beta*pi(+1) + kappa*x;

//i   = 0.999*i(-1) + i_bar + phi_pi*(pi - pi_bar) + eps_i;

i   = i_bar + phi_pi*(pi - pi_bar) + eps_i;

v   = beta^(-1)*(v(-1) - (pi-pi_bar)) + (i-i_bar) - s;

r   = i - pi(+1);

s   = R*v(-1) - eps_s;

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
end;

shocks;
var eps_s;
stderr 1;
end;

stoch_simul(order = 1, irf = 30) ;