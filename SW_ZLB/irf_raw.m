function [sacrifice_ratio_raw, nominal_interest_rate, real_interest_rate, inflation, output_gap, debt, surplus] = irf_raw(x2, estim_params_, options_,M_,oo_, T,CPIE, CRPI, RR, Ta, Tstar)
%AUTORUN Summary of this function goes here
%   Detailed explanation goes here


%(options_,M_,oo_)
SET = create_struct(options_, M_, oo_);

% Extract estimated variable index
SET.param_crosswalk = estim_params_.param_vals(:,1);


for i_ = 1:100
    % randomly sample from posterior
    n = round(rand()*50000);
    x0 = x2(end-n,8:end)';

    % Set some options for Dynare
    options_.qz_criterium = 1-1e-6;
    options_.linear = 1;
    M_.params(SET.param_crosswalk) = x0;

    %(SET, T,options_,M_,oo_,CPIE,CRPI,RR,Ta,Tstar)
    [y_non(:,:,i_), MM] = disinflation(SET, T, options_, M_, oo_, CPIE, CRPI, RR, Ta, Tstar);

    sacrifice_ratio_raw(:,i_) = -sum((y_non(SET.variable.y,:,i_))/(10-2));
end

nominal_interest_rate = y_non(SET.variable.robs,:,:);

real_interest_rate = y_non(SET.variable.rr,:,:);

inflation = y_non(SET.variable.pinfobs,:,:);

output_gap = y_non(SET.variable.y,:,:)-y_non(SET.variable.yf,:,:);

debt = y_non(SET.variable.v,:,:);

surplus = y_non(SET.variable.s,:,:);

end

