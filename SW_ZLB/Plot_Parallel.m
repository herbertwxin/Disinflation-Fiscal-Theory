%% IRF for Disinflation under Fiscal/Monetary-led Regime (Plot in Parallel)
clear all
close all
clc
%% Initialization
parpool('local', 4)

% model_name = 'SW_CS_LTB';
% model_name = 'SW_SS_LTB';
% model_name = 'SW_CS';
model_name = 'SW_SS';
% model_name = 'SW_LTB_RR';

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);

folder_path = fullfile(pwd, model_name); % 'pwd' ensures an absolute path from the current working directory
if ~exist(folder_path, 'dir')
   mkdir(folder_path);
end

% Load the estimated posterior paramters from Dynare
addpath("SW_CS_LTB/metropolis");
load("SW_CS_LTB_mh1_blck1.mat");

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

% Assuming you've started a parallel pool somewhere before this
% e.g., parpool('local', numWorkers); where numWorkers is the number of parallel workers you want.

%Fiscal Regime
parfor T = 4:6
    fig = figure; % Create a new figure for this iteration
    
    if T - 4 > 0
        message = sprintf('Calculating & Plotting Sacrifice ratio for fiscal-led disinflation with announcement %d period ahead', T-4);
        disp(message)
    else
        disp("Calculating & Plotting Sacrifice ratio for cold turkey fiscal-led disinflation")
    end
    [fig_fis{T-3}, SR_fis{T-3}] = autoplot(x2, estim_params_, options_,M_,oo_, inflation_target, CRPI_fis, R_fis, 4, T);
    set(fig, 'Position', [100, 100, 1000, 600]);
    if T - 4 > 0
        graphTitle = sprintf('IRFs for fiscal-led disinflation with announcement %d period ahead', T-4);
    else
        graphTitle = 'IRFs for cold turkey fiscal-led disinflation';
    end
    suptitle(fig, graphTitle); % Pass the figure handle to suptitle

    filename = fullfile(folder_path, sprintf('An%d_Fis.png', T-4));
    saveas(fig, filename);
    close(fig); % Close the figure
end

%Monetary Regime
parfor T = 4:6
    fig = figure; % Create a new figure for this iteration
    
    if T - 4 > 0
        message = sprintf('Calculating & Plotting Sacrifice ratio for monetary-led disinflation with announcement %d period ahead', T-4);
        disp(message)
    else
        disp("Calculating & Plotting Sacrifice ratio for cold turkey monetary-led disinflation")
    end
    [fig_mon{T-3}, SR_mon{T-3}] = autoplot(x2, estim_params_, options_,M_,oo_, inflation_target, CRPI_mon, R_mon, 4, T);
    set(fig, 'Position', [100, 100, 1000, 600]);
    if T - 4 > 0
        graphTitle = sprintf('IRFs for monetary-led disinflation with announcement %d period ahead', T-4);
    else
        graphTitle = 'IRFs for cold turkey monetary-led disinflation';
    end
    suptitle(fig, graphTitle); % Pass the figure handle to suptitle

    filename = fullfile(folder_path, sprintf('An%d_Mon.png', T-4));
    saveas(fig, filename);
    close(fig); % Close the figure
end

%% Generate Table for Sacrifice Ratio
SR_fis_table = table([SR_fis{:}]', 'VariableNames', {'SR_fis'});
SR_mon_table = table([SR_mon{:}]', 'VariableNames', {'SR_mon'});

% Create the status variable
status = {'Cold-turkey'; 'Announced 1'; 'Announced 2'};

% Create a table from the status variable
status_table = table(status, 'VariableNames', {'Status'});

% Concatenate the tables horizontally
combined_table = [status_table, SR_fis_table, SR_mon_table]

