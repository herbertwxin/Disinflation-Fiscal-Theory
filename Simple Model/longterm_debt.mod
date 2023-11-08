// Fiscal Theory Model Example

var pi x v s rn i q r;

varexo eps_s eps_i;

parameters sigma beta kappa R phi_pi pi_bar i_bar omega;

sigma   = 1;
beta    = 0.99;
kappa   = 0.5;
R       = 1.01;
phi_pi  = 0.8;
pi_bar  = 0.1;
i_bar   = pi_bar - log(beta);
omega  = 0.85;

model(linear); 

x   = x(+1) - sigma*(i - i_bar - pi(+1) + pi_bar);

//pi  = (1-beta)*pi_bar + beta*pi(+1) + kappa* x;

pi = (1-beta)*pi_bar + 0.5*beta*pi(-1) + 0.5*beta*pi(+1) + kappa*x;

//i   = 0.999*i(-1) + i_bar + phi_pi*(pi - pi_bar) + eps_i;

i   = i_bar + phi_pi*(pi - pi_bar) + eps_i;

//b   = R*(b(-1) - (pi-pi_bar) - s) + (i-i_bar);

//v   = R*(v(-1) + rn - (pi-pi_bar) -s) + (i-i_bar);

v   = R*(v(-1) + (rn-i_bar) - (pi-pi_bar) - s);

rn(+1)  = i; 

(rn - i_bar) = omega*q - q(-1); 

//s   = 0.2*v(-1) + x + 0.25*(pi - pi_bar) - eps_s - 0.5*eps_s(-1);

s   = 0.5*s(-1) - eps_s;

r  = i - i_bar - pi(+1) + pi_bar;



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
var eps_i;
stderr 1;
var eps_s;
stderr 1;
end;

stoch_simul(order = 1, irf = 10, nograph) ;