// Fiscal Theory Model Example

var pi x i b s r;

varexo eps_s eps_i;

parameters sigma beta kappa R phi_pi pi_bar i_bar;

sigma   = 1;
beta    = 0.99;
kappa   = 0.5;
R       = 1/1.5;
phi_pi  = 1.5;
pi_bar  = 0.08;
i_bar   = pi_bar - log(beta);

model(linear); 

x   = x(+1) - sigma*(i - i_bar - pi(+1) + pi_bar);

//pi  = (1-beta)*pi_bar + beta*pi(+1) + kappa* x;

pi = (1-beta)*pi_bar + 0.5*pi(-1) + 0.5*beta*pi(+1) + kappa*x;

//i   = 0.999*i(-1) + i_bar + phi_pi*(pi - pi_bar) + eps_i;

i   = i_bar + phi_pi*(pi - pi_bar) + eps_i;

b   = R*b(-1);

r   = i - pi(+1);

s   = 0.5*s(-1) - eps_s;

end;

steady;
check;

initval;
x   = 0;
pi  = pi_bar;
b   = 0;
i   = i_bar;
s   = 0;
r   = -log(beta);
end;

shocks;
var eps_i;
stderr 1;
end;

stoch_simul(order = 1, irf = 30, nograph) ;