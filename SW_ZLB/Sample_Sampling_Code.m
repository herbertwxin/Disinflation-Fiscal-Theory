%% How to sample from the posterior
clear all
clc
close all


dynare SW_LTB_RR nostrict
addpath("SW_LTB_RR\metropolis")
load("SW_LTB_RR_mh1_blck1.mat")

SET.param_crosswalk = estim_params_.param_vals(:,1);

% Initialize the matrix for storing IRFs
irfs_n = zeros(46, 30, 100);

for i_ = 1:100
    % randomly sample from posterior
    n = round(rand()*50000);
    x0 = x2(end-n,8:end)';

    % Set some options for Dynare
    options_.qz_criterium = 1-1e-6;
    options_.linear = 1;
    M_.params(SET.param_crosswalk) = x0;

    [oo_.dr,info,M_,options_,oo_]  = resol(0,M_,options_,oo_);
    irfs_n(:,:,i_) = irf(oo_.dr, [1,0,0,0,0,0,0,0], 30, [],[],1);
end

% Compute the mean and percentiles of the IRFs
test_mean = mean(squeeze(irfs_n(1,:,:)),2);
test_95 = prctile(squeeze(irfs_n(1,:,:)),95,2);
test_5 = prctile(squeeze(irfs_n(1,:,:)),5,2);

% Plot the shaded region between 5th and 95th percentiles
x = 1:length(test_mean); % Assuming the x-axis is just the indices
fill([x, fliplr(x)], [test_5', fliplr(test_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none'); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot(irfs_n(1,:,i_)', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(test_mean, 'r', 'LineWidth', 3)
hold on

% Plot the 95th and 5th percentiles in blue
plot(test_95, 'b--', 'LineWidth', 3)
plot(test_5, 'b--', 'LineWidth', 3)



% for i_ = 1:100
% % randomly sample from posterior
% % n = round(rand()*50000); % sample from the last 50,000 draws
% n = round(1 + (49999-1)*rand());  % random integer between 1 and 49999
%     % if ~exist('x2', 'var') || isempty(x2)
%     %     error('x2 matrix does not exist or is empty.');
%     % end
% x0 = x2(end-n,8:end)';
% 
% % Set some options for Dynare
% options_.qz_criterium = 1-1e-6;
% options_.linear = 1;
% M_.params(SET.param_crosswalk) = x0;
% 
% [oo_.dr,info,M_,options_,oo_]  = resol(0,M_,options_,oo_) ;
% irfs_n(:,:,i_) = irf(oo_.dr, [1,0,0,0,0,0,0,0], 30, [],[],1);
% plot(irfs_n(1,:,i_)')
% hold on
% end
% 
% test_mean = mean(squeeze(irfs_n(1,:,:)),2);
% test_95 = prctile(squeeze(irfs_n(1,:,:)),95,2);
% test_5 = prctile(squeeze(irfs_n(1,:,:)),5,2);
% plot(test_mean,'k','LineWidth',3)
% hold on
% plot(test_95)
% plot(test_5)