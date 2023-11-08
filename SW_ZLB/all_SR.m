%% IRF for Disinflation under Fiscal/Monetary-led Regime
clear all
close all
clc

%% Initialization
warning('off', 'MATLAB:singularMatrix');
model_names = {'SW_CS_LTB', 'SW_SS_LTB', 'SW_CS', 'SW_SS', 'SW_LTB_RR'};
num_models = length(model_names);
addpath("SW_CS_LTB/metropolis");
load("SW_CS_LTB_mh1_blck1.mat");

% Define arrays to store results for all models
mean_fis_all_models = zeros(3, num_models); % Since we have 3 announcement periods and multiple models
std_fis_all_models = zeros(3, num_models);
mean_mon_all_models = zeros(3, num_models);
std_mon_all_models = zeros(3, num_models);

%% Setting the Parameters
inflation_target = 1.005;
Tstar = 6; %default Ta = 4

% Fiscal-led regime
CRPI_fis = 0.5;
R_fis = 0;
% R_fis = 2.0443;

% Monetary-led regime
CRPI_mon = 2.0443;
R_mon = 0.35;

TT = 1200;

% Loop through each model
for m = 1:num_models
    model_name = model_names{m};
    disp(['Processing model: ', model_name]);

    % Run Dynare for the current model
    eval(['dynare ', model_name, '.mod nostrict nolog']);

    % Loop to Plot IRFs for both Fiscal and Monetary Regimes
    for announcementPeriod = 4:6
        % Define the fiscal and monetary policy parameters for the current model
        % Define the variables for each regime
        variables = {'SR', 'NIR', 'RIR', 'INF', 'OG', 'DEBT', 'SURP'};

        % Initialize structures to hold calculated statistics
        stats_fis = struct();
        stats_mon = struct();

        % Call irf_raw function for both fiscal and monetary regimes
        [stats_fis.SR_raw, stats_fis.NIR_raw, stats_fis.RIR_raw, stats_fis.INF_raw, stats_fis.OG_raw, stats_fis.DEBT_raw, stats_fis.SURP_raw] = irf_raw(x2, estim_params_, options_, M_, oo_, TT, inflation_target, CRPI_fis, R_fis, 4, announcementPeriod);
        [stats_mon.SR_raw, stats_mon.NIR_raw, stats_mon.RIR_raw, stats_mon.INF_raw, stats_mon.OG_raw, stats_mon.DEBT_raw, stats_mon.SURP_raw] = irf_raw(x2, estim_params_, options_, M_, oo_, TT, inflation_target, CRPI_mon, R_mon, 4, announcementPeriod);

        % Loop through each variable to calculate statistics
        for i = 1:length(variables)
            var = variables{i};

            % Fiscal statistics
            stats_fis.(sprintf('%s_mean', var)) = mean(squeeze(stats_fis.(sprintf('%s_raw', var))), 2);
            stats_fis.(sprintf('%s_95', var)) = prctile(squeeze(stats_fis.(sprintf('%s_raw', var))), 95, 2);
            stats_fis.(sprintf('%s_5', var)) = prctile(squeeze(stats_fis.(sprintf('%s_raw', var))), 5, 2);

            % Monetary statistics
            stats_mon.(sprintf('%s_mean', var)) = mean(squeeze(stats_mon.(sprintf('%s_raw', var))), 2);
            stats_mon.(sprintf('%s_95', var)) = prctile(squeeze(stats_mon.(sprintf('%s_raw', var))), 95, 2);
            stats_mon.(sprintf('%s_5', var)) = prctile(squeeze(stats_mon.(sprintf('%s_raw', var))), 5, 2);
        end

        % Collect the means and standard deviations for the current period
        SR_fis = stats_fis.SR_raw; % SR for Fiscal-led Regime
        SR_mon = stats_mon.SR_raw; % SR for Monetary-led Regime

        % Store the means and standard deviations for the current period and model
        mean_fis_all_models(announcementPeriod-3, m) = mean(SR_fis);
        std_fis_all_models(announcementPeriod-3, m) = std(SR_fis);
        mean_mon_all_models(announcementPeriod-3, m) = mean(SR_mon);
        std_mon_all_models(announcementPeriod-3, m) = std(SR_mon);
    end

    % Remove the Dynare generated path
    % rmpath([model_name, '/metropolis']);
end

% Create the result table
TAB = array2table(zeros(3*num_models, 6), 'VariableNames', ...
    {'Model_Name', 'Announcement_Period', 'Mean_SR_Fiscal', 'Std_SR_Fiscal', 'Mean_SR_Monetary', 'Std_SR_Monetary'});

% Fill the table with results
for m = 1:num_models
    for p = 1:3
        idx = (m-1)*3 + p;
        TAB.Model_Name(idx) = model_names(m);
        TAB.Announcement_Period(idx) = p + 3; % since the announcement period starts from 4
        TAB.Mean_SR_Fiscal(idx) = mean_fis_all_models(p, m);
        TAB.Std_SR_Fiscal(idx) = std_fis_all_models(p, m);
        TAB.Mean_SR_Monetary(idx) = mean_mon_all_models(p, m);
        TAB.Std_SR_Monetary(idx) = std_mon_all_models(p, m);
    end
end

% Display the table
disp(TAB)

% Clean up the environment
% close all;
