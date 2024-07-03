function [BASE] = const_struct(PARAMS, options_, M_, oo_)
%CONST_STRUCT Summary of this function goes here
%   Detailed explanation goes here
%% Generate Struct for Base model

% Take in the specified crpis, crpi, rr
M_.params(find(strcmp(M_.param_names, 'crpis'))) = PARAMS.CRPIS;
M_.params(find(strcmp(M_.param_names, 'crpi'))) = PARAMS.CRPI;
M_.params(find(strcmp(M_.param_names, 'R'))) = PARAMS.RR;

[oo_.dr,info,M_,oo_]  = resol(0,M_,options_,oo_) ;

% dyn_to_str input struct
dyn_in.options_ = options_ ;
dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

% Uses BASE to indicate for the base model
BASE.M_ = dyn_in.M_ ;
BASE.oo_ = dyn_in.oo_ ;
BASE.options_ = options_ ;

% Output from dyn_to_str
out = dyn_to_str(dyn_in) ;

BASE.mats.Q = out.mats.Q ;
Q = BASE.mats.Q ;
BASE.mats.G = out.mats.G ;
G = BASE.mats.G ;

% Assign struct mat to BASE
BASE.str_mats.A0 = out.mats.A ;
BASE.str_mats.A1 = out.mats.B ;
BASE.str_mats.B0 = out.mats.D ;
BASE.str_mats.D0 = out.mats.E ;
BASE.str_mats.D2 = out.mats.D2 ;
BASE.str_mats.Gamma = out.mats.Gamma ;

% Number of variables
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables


BASE.variable.n_ = n_ ;
BASE.variable.l_ = l_ ;
BASE.nparam      = M_.param_nbr ;

var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;
exo_var_names = cellstr(M_.exo_names) ;

for ii=1:n_-1
    eval(['BASE.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:l_
    eval(['BASE.variable.shock.',exo_var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:M_.param_nbr
    eval(['BASE.param_names.',param_names{ii},'=',int2str(ii),';']) ;
end

BASE.y_ss = (eye(n_-1) - Q(1:n_-1,1:n_-1)) \ Q(1:n_-1,end)  ;
BASE.y_ss = [BASE.y_ss ; 1] ; % Constant

BASE.base_inf = M_.params(BASE.param_names.cpie);
end

