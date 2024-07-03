%% Table 1 Disinflation under Smets & Wouters (2007)
% Generate results in Table. 2
% for Dynare version 5.5
%% Initialization
clear all
% close all
% clc

addpath("_functions");

%% Model Selection

% model_name = 'SW_SS_LTB';
model_name = 'SW_SS';

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);

addpath("SW_SS/metropolis");
load("SW_SS_mh1_blck1.mat");

%% Options
% Pegged regime
PARAMS.i_peg = 1;

% Plot
Plot = 0;

%% Setting the Parameters
% Set inflation target
PARAMS.CPIE = 1.005;

% Announcement period
PARAMS.Ta = 4;

% Implementation period
PARAMS.Tstar = 5;

% Taylor rule parameter
PARAMS.CRPI = 1.5;2.0443;

% Fiscal rule parameter
PARAMS.RR = 0.5;

% Fiscal response to inflation
PARAMS.CRPIS = 0.5;

% Length of Simulation
PARAMS.T = 150;

%% Command Output

disp(' ')

if PARAMS.CRPI > 1
    disp("Monetary-led regime")
else
    disp("Fiscal-led regime")
end

if model_name == "SW_SS_LTB"
    disp("Long-term debt")
else 
    disp("Short-term debt")
end

if PARAMS.i_peg == 1
    disp('Interest rate peg activated')
else 
    disp('No interest rate peg')
end

disp(['Announcement of ', num2str(PARAMS.Tstar - PARAMS.Ta), ' period ahead'])

disp(' ')
disp("Parameters:")
disp(['new inflation target = ', num2str(PARAMS.CPIE)])
disp(['phi_i = ', num2str(PARAMS.CRPI)])
disp(['phi_s = ', num2str(PARAMS.CRPIS)])
disp(['R = ', num2str(PARAMS.RR)])

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

%% Call the Disinflation function

for i_ = 1:100
    % randomly sample from posterior
    n = round(rand()*50000);
    x0 = x2(end-n,8:end)';

    % Set some options for Dynare
    options_.qz_criterium = 1-1e-6;
    options_.linear = 1;
    M_.params(estim_params_.param_vals(:,1)) = x0;

    y_non(:,:,i_) = disinf(PARAMS, BASE, options_, M_, oo_);
end

%% Sacrifice Ratio

for i_= 1:100
    SR_raw(:,i_) = -sum(y_non(BASE.variable.y,:,i_)-y_non(BASE.variable.yf,:,i_))/((BASE.base_inf-PARAMS.CPIE)*400);
end
SR_sd = round(std(SR_raw(:)),4);
SR = round(mean(SR_raw),4);

disp(' ')
disp(['Sacrifice Ratio = ', num2str(SR)])
disp(['Standard Deviation = ', num2str(SR_sd)])

%% Plot

if Plot == 1
    Plot_range = 1:20;

    fill_alpha = 0.4; % Set transparency level

    COLOR_RED = '#C2444E';
    COLOR_BLUE = '#024b79';
    COLOR_GREEN = '#3b3b3b';

    % Calculate mean and 95% CI for each variable
    robs_mean_raw = mean(squeeze(y_non(BASE.variable.robs,:,:)),2);
    robs_95_raw = prctile(squeeze(y_non(BASE.variable.robs,:,:)),95,2);
    robs_5_raw = prctile(squeeze(y_non(BASE.variable.robs,:,:)),5,2);

    robs_mean = robs_mean_raw(Plot_range);
    robs_95 = robs_95_raw(Plot_range);
    robs_5 = robs_5_raw(Plot_range);

    % For pinfobs
    pinfobs_mean_raw = mean(squeeze(y_non(BASE.variable.pinfobs,:,:)),2);
    pinfobs_95_raw = prctile(squeeze(y_non(BASE.variable.pinfobs,:,:)),95,2);
    pinfobs_5_raw = prctile(squeeze(y_non(BASE.variable.pinfobs,:,:)),5,2);

    % Trim pinfobs raw to only Plot_range for plot
    pinfobs_mean = pinfobs_mean_raw(Plot_range);
    pinfobs_95 = pinfobs_95_raw(Plot_range);
    pinfobs_5 = pinfobs_5_raw(Plot_range);

    % For rr
    rr_mean_raw = mean(squeeze(y_non(BASE.variable.rr,:,:)),2);
    rr_95_raw = prctile(squeeze(y_non(BASE.variable.rr,:,:)),95,2);
    rr_5_raw = prctile(squeeze(y_non(BASE.variable.rr,:,:)),5,2);

    % Trim rr raw to only Plot_range for plot
    rr_mean = rr_mean_raw(Plot_range);
    rr_95 = rr_95_raw(Plot_range);
    rr_5 = rr_5_raw(Plot_range);

    % For v
    v_mean_raw = mean(squeeze(y_non(BASE.variable.v,:,:)),2);
    v_95_raw = prctile(squeeze(y_non(BASE.variable.v,:,:)),95,2);
    v_5_raw = prctile(squeeze(y_non(BASE.variable.v,:,:)),5,2);

    % Trim v raw to only Plot_range for plot
    v_mean = v_mean_raw(Plot_range);
    v_95 = v_95_raw(Plot_range);
    v_5 = v_5_raw(Plot_range);

    % For s
    s_mean_raw = mean(squeeze(y_non(BASE.variable.s,:,:)),2);
    s_95_raw = prctile(squeeze(y_non(BASE.variable.s,:,:)),95,2);
    s_5_raw = prctile(squeeze(y_non(BASE.variable.s,:,:)),5,2);

    % Trim s raw to only Plot_range for plot
    s_mean = s_mean_raw(Plot_range);
    s_95 = s_95_raw(Plot_range);
    s_5 = s_5_raw(Plot_range);

    % For the difference between y and yf
    x_mean_raw = mean(squeeze(y_non(BASE.variable.y,:,:)-y_non(BASE.variable.yf,:,:)),2);
    x_95_raw = prctile(squeeze(y_non(BASE.variable.y,:,:)-y_non(BASE.variable.yf,:,:)),95,2);
    x_5_raw = prctile(squeeze(y_non(BASE.variable.y,:,:)-y_non(BASE.variable.yf,:,:)),5,2);

    % Trim the raw data of the difference between y and yf to only Plot_range for plot
    x_mean = x_mean_raw(Plot_range);
    x_95 = x_95_raw(Plot_range);
    x_5 = x_5_raw(Plot_range);

    if model_name == "SW_SS_LTB"
        rn_mean_raw = mean(squeeze(y_non(BASE.variable.rn,:,:)),2);
        rn_95_raw = prctile(squeeze(y_non(BASE.variable.rn,:,:)),95,2);
        rn_5_raw = prctile(squeeze(y_non(BASE.variable.rn,:,:)),5,2);

        % Trim the raw data of the difference between y and yf to only Plot_range for plot
        rn_mean = rn_mean_raw(Plot_range);
        rn_95 = rn_95_raw(Plot_range);
        rn_5 = rn_5_raw(Plot_range);
    end

    % The acutal plot
    subplot(2,2,1)
    fill([Plot_range, fliplr(Plot_range)], [robs_5', fliplr(robs_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);
    hold on
    fill([Plot_range, fliplr(Plot_range)], [rr_5', fliplr(rr_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);


    rr_line = plot(rr_mean, 'Color', COLOR_RED, 'LineWidth', 2.5);
    robs_line = plot(robs_mean, 'Color', COLOR_BLUE, 'LineWidth', 2.5);


    hold on

    plot(robs_95, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')
    plot(robs_5, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')
    plot(rr_95, 'Color', COLOR_RED, 'LineWidth', 1, 'LineStyle', '--')
    plot(rr_5, 'Color', COLOR_RED, 'LineWidth', 1, 'LineStyle', '--')

    if model_name == "SW_SS_LTB"
        fill([Plot_range, fliplr(Plot_range)], [rn_5', fliplr(rn_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);
        rn_line = plot(rn_mean,'Color', COLOR_GREEN, 'LineWidth', 2.5);
        plot(rn_95, 'Color', COLOR_GREEN, 'LineWidth', 1, 'LineStyle', '--')
        plot(rn_5, 'Color', COLOR_GREEN, 'LineWidth', 1, 'LineStyle', '--')

        legend([robs_line, rr_line, rn_line], {'nominal rate','real rate', 'bond return'});
    else
        legend([robs_line, rr_line], {'nominal rate','real rate'});
    end

    hold on

    ylabel('Interest rate')

    subplot(2,2,2)

    fill([Plot_range, fliplr(Plot_range)], [pinfobs_5', fliplr(pinfobs_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
    hold on

    % Plot the mean in red
    plot(pinfobs_mean, 'Color', COLOR_BLUE, 'LineWidth',2.5)

    % Plot the 95th and 5th percentiles in blue
    plot(pinfobs_95, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')
    plot(pinfobs_5, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')

    ylabel('Inflation')
    hold on

    subplot(2,2,3)
    fill([Plot_range, fliplr(Plot_range)], [x_5', fliplr(x_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
    hold on


    % Plot the mean in red
    plot(x_mean, 'Color', COLOR_BLUE, 'LineWidth', 2.5)

    hold on

    plot(x_95, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')
    plot(x_5, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')

    hold on

    ylabel('Output gap')


    subplot(2,2,4)
    fill([Plot_range, fliplr(Plot_range)], [s_5', fliplr(s_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);
    hold on
    fill([Plot_range, fliplr(Plot_range)], [v_5', fliplr(v_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);
    hold on

    v_line = plot(v_mean, 'Color', COLOR_BLUE, 'LineWidth', 2.5);
    s_line = plot(s_mean, 'Color', COLOR_RED, 'LineWidth', 2.5);

    plot(v_95, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')
    plot(v_5, 'Color', COLOR_BLUE, 'LineWidth', 1, 'LineStyle', '--')
    plot(s_95, 'Color', COLOR_RED, 'LineWidth', 1, 'LineStyle', '--')
    plot(s_5, 'Color', COLOR_RED, 'LineWidth', 1, 'LineStyle', '--')


    ylabel('Debt/Surplus')

    legend([v_line, s_line], {'debt', 'surplus'});

    set(gcf, 'Position', [100, 100, 800, 600]);
end