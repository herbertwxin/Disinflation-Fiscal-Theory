%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

tic0 = tic;
% Save empty dates and dseries objects in memory.
dates('initialize');
dseries('initialize');
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'longterm_debt';
M_.dynare_version = '4.5.6';
oo_.dynare_version = '4.5.6';
options_.dynare_version = '4.5.6';
%
% Some global variables initialization
%
global_initialization;
diary off;
diary('longterm_debt.log');
M_.exo_names = 'eps_s';
M_.exo_names_tex = 'eps\_s';
M_.exo_names_long = 'eps_s';
M_.exo_names = char(M_.exo_names, 'eps_i');
M_.exo_names_tex = char(M_.exo_names_tex, 'eps\_i');
M_.exo_names_long = char(M_.exo_names_long, 'eps_i');
M_.endo_names = 'pi';
M_.endo_names_tex = 'pi';
M_.endo_names_long = 'pi';
M_.endo_names = char(M_.endo_names, 'x');
M_.endo_names_tex = char(M_.endo_names_tex, 'x');
M_.endo_names_long = char(M_.endo_names_long, 'x');
M_.endo_names = char(M_.endo_names, 'v');
M_.endo_names_tex = char(M_.endo_names_tex, 'v');
M_.endo_names_long = char(M_.endo_names_long, 'v');
M_.endo_names = char(M_.endo_names, 's');
M_.endo_names_tex = char(M_.endo_names_tex, 's');
M_.endo_names_long = char(M_.endo_names_long, 's');
M_.endo_names = char(M_.endo_names, 'rn');
M_.endo_names_tex = char(M_.endo_names_tex, 'rn');
M_.endo_names_long = char(M_.endo_names_long, 'rn');
M_.endo_names = char(M_.endo_names, 'i');
M_.endo_names_tex = char(M_.endo_names_tex, 'i');
M_.endo_names_long = char(M_.endo_names_long, 'i');
M_.endo_names = char(M_.endo_names, 'q');
M_.endo_names_tex = char(M_.endo_names_tex, 'q');
M_.endo_names_long = char(M_.endo_names_long, 'q');
M_.endo_names = char(M_.endo_names, 'r');
M_.endo_names_tex = char(M_.endo_names_tex, 'r');
M_.endo_names_long = char(M_.endo_names_long, 'r');
M_.endo_names = char(M_.endo_names, 'AUX_EXO_LAG_8_0');
M_.endo_names_tex = char(M_.endo_names_tex, 'AUX\_EXO\_LAG\_8\_0');
M_.endo_names_long = char(M_.endo_names_long, 'AUX_EXO_LAG_8_0');
M_.endo_partitions = struct();
M_.param_names = 'sigma';
M_.param_names_tex = 'sigma';
M_.param_names_long = 'sigma';
M_.param_names = char(M_.param_names, 'beta');
M_.param_names_tex = char(M_.param_names_tex, 'beta');
M_.param_names_long = char(M_.param_names_long, 'beta');
M_.param_names = char(M_.param_names, 'kappa');
M_.param_names_tex = char(M_.param_names_tex, 'kappa');
M_.param_names_long = char(M_.param_names_long, 'kappa');
M_.param_names = char(M_.param_names, 'R');
M_.param_names_tex = char(M_.param_names_tex, 'R');
M_.param_names_long = char(M_.param_names_long, 'R');
M_.param_names = char(M_.param_names, 'phi_pi');
M_.param_names_tex = char(M_.param_names_tex, 'phi\_pi');
M_.param_names_long = char(M_.param_names_long, 'phi_pi');
M_.param_names = char(M_.param_names, 'pi_bar');
M_.param_names_tex = char(M_.param_names_tex, 'pi\_bar');
M_.param_names_long = char(M_.param_names_long, 'pi_bar');
M_.param_names = char(M_.param_names, 'i_bar');
M_.param_names_tex = char(M_.param_names_tex, 'i\_bar');
M_.param_names_long = char(M_.param_names_long, 'i_bar');
M_.param_names = char(M_.param_names, 'omega');
M_.param_names_tex = char(M_.param_names_tex, 'omega');
M_.param_names_long = char(M_.param_names_long, 'omega');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 2;
M_.endo_nbr = 9;
M_.param_nbr = 8;
M_.orig_endo_nbr = 8;
M_.aux_vars(1).endo_index = 9;
M_.aux_vars(1).type = 3;
M_.aux_vars(1).orig_index = 1;
M_.aux_vars(1).orig_lead_lag = 0;
M_.Sigma_e = zeros(2, 2);
M_.Correlation_matrix = eye(2, 2);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = 1;
M_.det_shocks = [];
options_.linear = 1;
options_.block=0;
options_.bytecode=0;
options_.use_dll=0;
M_.hessian_eq_zero = 1;
erase_compiled_function('longterm_debt_static');
erase_compiled_function('longterm_debt_dynamic');
M_.orig_eq_nbr = 8;
M_.eq_nbr = 9;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./' M_.fname '_set_auxiliary_variables.m'], 'file') == 2;
M_.lead_lag_incidence = [
 1 5 14;
 0 6 15;
 2 7 0;
 0 8 0;
 0 9 16;
 0 10 0;
 3 11 0;
 0 12 0;
 4 13 0;]';
M_.nstatic = 3;
M_.nfwrd   = 2;
M_.npred   = 3;
M_.nboth   = 1;
M_.nsfwrd   = 3;
M_.nspred   = 4;
M_.ndynamic   = 6;
M_.equations_tags = {
};
M_.static_and_dynamic_models_differ = 0;
M_.exo_names_orig_ord = [1:2];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(9, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(2, 1);
M_.params = NaN(8, 1);
M_.NNZDerivatives = [32; -1; -1];
M_.params( 1 ) = 1;
sigma = M_.params( 1 );
M_.params( 2 ) = 0.99;
beta = M_.params( 2 );
M_.params( 3 ) = 0.5;
kappa = M_.params( 3 );
M_.params( 4 ) = 1.5;
R = M_.params( 4 );
M_.params( 5 ) = 0.8;
phi_pi = M_.params( 5 );
M_.params( 6 ) = 0.1;
pi_bar = M_.params( 6 );
M_.params( 7 ) = M_.params(6)-log(M_.params(2));
i_bar = M_.params( 7 );
M_.params( 8 ) = 0.85;
omega = M_.params( 8 );
steady;
oo_.dr.eigval = check(M_,options_,oo_);
%
% INITVAL instructions
%
options_.initval_file = 0;
oo_.steady_state( 2 ) = 0;
oo_.steady_state( 1 ) = M_.params(6);
oo_.steady_state( 3 ) = 0;
oo_.steady_state( 6 ) = M_.params(7);
oo_.steady_state( 4 ) = 0;
oo_.steady_state( 5 ) = oo_.steady_state(6);
oo_.steady_state(9)=oo_.exo_steady_state(1);
if M_.exo_nbr > 0
	oo_.exo_simul = ones(M_.maximum_lag,1)*oo_.exo_steady_state';
end
if M_.exo_det_nbr > 0
	oo_.exo_det_simul = ones(M_.maximum_lag,1)*oo_.exo_det_steady_state';
end
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(1, 1) = (1)^2;
M_.Sigma_e(2, 2) = (1)^2;
options_.irf = 10;
options_.nograph = 1;
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
save('longterm_debt_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('longterm_debt_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('longterm_debt_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('longterm_debt_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('longterm_debt_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('longterm_debt_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('longterm_debt_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
diary off
