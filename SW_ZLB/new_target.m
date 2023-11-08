function [SET1] = new_target(cpie,crpi,R)
%NEW_TARGET Summary of this function goes here
%   Detailed explanation goes here
% cpie = 1; 1.005;
cr=cpie/(M_.params(SET.param_names.cbeta)*M_.params(SET.param_names.cgamma)^(-M_.params(SET.param_names.csigma)));

M_.params(SET.param_names.cpie) = cpie;
M_.params(SET.param_names.cr) = cr;
M_.params(SET.param_names.conster) = (cr-1)*100;
M_.params(SET.param_names.constepinf) = (cpie-1)*100;
M_.params(SET.param_names.crpi) = crpi; %0.5; 2.0443;
M_.params(SET.param_names.R) = R; %2.0443; 0.5;

[oo_.dr,info,M_,options_,oo_]  = resol(0,M_,options_,oo_) ;

dyn_in.options_ = options_ ;

dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

SET1.M_ = dyn_in.M_ ;
SET1.oo_ = dyn_in.oo_ ;
SET1.options_ = options_ ;

out = dyn_to_str(dyn_in) ;

SET1.mats.Q = out.mats.Q ; Q = SET1.mats.Q ;
SET1.mats.G = out.mats.G ; G = SET1.mats.G ;

SET1.str_mats.A0 = out.mats.A ;
SET1.str_mats.A1 = out.mats.B ;
SET1.str_mats.B0 = out.mats.D ;
SET1.str_mats.D0 = out.mats.E ;
SET1.str_mats.D2 = out.mats.D2 ;
SET1.str_mats.Gamma = out.mats.Gamma ;

return SET1
end

