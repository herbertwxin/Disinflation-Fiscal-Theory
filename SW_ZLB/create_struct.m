function SET = create_struct(options_,M_,oo_)
% DISINFLATION is a function that utilizes the Kulish-Pagan method to
% compute the structural change with Smets&Wouters (2007) model under both fiscal and monetary-led regime.
%   The function takes in the length of simulation T, output from DYNARE
%   [options_,M_,oo_], new regime sepcfication [CPIE,CRPI,RR], time of
%   announcement Ta and time of implementation Tstar.
%   Author: Christopher Gibbs
%   Modified by Wei Xin


% dyn_to_str input struct
dyn_in.options_ = options_ ;
dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

% Struct for KP process
SET.M_ = dyn_in.M_ ;
SET.oo_ = dyn_in.oo_ ;
SET.options_ = options_ ;

% Output from dyn_to_str
out = dyn_to_str(dyn_in) ;

SET.mats.Q = out.mats.Q ; 
Q = SET.mats.Q ;
SET.mats.G = out.mats.G ; 
G = SET.mats.G ;

SET.str_mats.A0 = out.mats.A ;
SET.str_mats.A1 = out.mats.B ;
SET.str_mats.B0 = out.mats.D ;
SET.str_mats.D0 = out.mats.E ;
SET.str_mats.D2 = out.mats.D2 ;
SET.str_mats.Gamma = out.mats.Gamma ;

%Extract variable details from Dynare output
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
% n_ = n_+1 ;        % Constant

SET.variable.n_ = n_ ; 
SET.variable.l_ = l_ ; 
SET.nparam      = M_.param_nbr ;

var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;
exo_var_names = cellstr(M_.exo_names) ;

for ii=1:n_-1
    eval(['SET.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:l_
    eval(['SET.variable.shock.',exo_var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:M_.param_nbr
    eval(['SET.param_names.',param_names{ii},'=',int2str(ii),';']) ;
end

SET.y_ss = (eye(n_-1) - Q(1:n_-1,1:n_-1)) \ Q(1:n_-1,end)  ;
SET.y_ss = [SET.y_ss ; 1] ; % Constant

end
