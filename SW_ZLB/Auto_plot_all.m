%% IRF for Disinflation under Fiscal/Monetary-led Regime
clear all
close all
clc
%% Initialization
warning('off', 'MATLAB:singularMatrix');
% model_name = 'SW_CS_LTB';
% model_name = 'SW_SS_LTB';
% model_name = 'SW_CS';
% model_name = 'SW_SS';
model_name = 'SW_LTB_RR';

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);


% Load the estimated posterior paramters from Dynare
addpath("SW_CS_LTB/metropolis");
load("SW_CS_LTB_mh1_blck1.mat");

%% Setting the Parameters
inflation_target = 1.005;
Tstar = 6; %default Ta = 4

% Fiscal-led regime
CRPI_fis = 0.5;
R_fis = 1.5;
% R_fis = 2.0443;

% Monetary-led regime
CRPI_mon = 2.0443;
R_mon = 0.5;

TT = 50;
%% 
% Initialize arrays to store the results
mean_fis_array = zeros(3, 1); % Since you're looping from 4 to 6
std_fis_array = zeros(3, 1);
mean_mon_array = zeros(3, 1);
std_mon_array = zeros(3, 1);
periods_array = (4:6)' - 4; % Adjusted periods for human-readable format


% Loop to Plot IRFs for both Fiscal and Monetary Regimes
for announcementPeriod = 4:6
    if announcementPeriod - 4 > 0
        message = sprintf('Calculating & Plotting Sacrifice ratio for disinflation with announcement %d period ahead', announcementPeriod - 4);
        disp(message)
    else
        disp("Calculating & Plotting Sacrifice ratio for cold turkey disinflation")
    end
    addpath("SW_CS_LTB/metropolis");
    load("SW_CS_LTB_mh1_blck1.mat");

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

    mean_fis_array(announcementPeriod-3) = mean(SR_fis);
    std_fis_array(announcementPeriod-3) = std(SR_fis);
    mean_mon_array(announcementPeriod-3) = mean(SR_mon);
    std_mon_array(announcementPeriod-3) = std(SR_mon);
%% 

    % Define the time axis (adjust this as needed for your specific data)
    x = 1:TT; % Assuming T is the number of time points for plotting

    % Plotting all the IRFs in subplots
    % Define colors for fiscal and monetary
    fiscal_color = '#C2444E';
    monetary_color = '#005092';
    fill_alpha = 0.5; % Set transparency level
    nIRFs = 100; % Number of IRFs, adjust as necessary
    fig = figure;

    dark_grey  = [0.5, 0.5, 0.5];
    grey_color = [0.7, 0.7, 0.7];  % Color for individual IRFs
    light_grey = [0.9, 0.9, 0.9];

    for i = 2:numel(variables) % Start loop from second variable
        subplot(ceil((numel(variables)-1)/2),2,i-1); % Adjust subplot index since we skip the first variable

        var = variables{i}; % Current variable name

        % Custom labels for each variable
        ylabel_text = {'Nominal Interest Rate', 'Real Interest Rate', 'Inflation', 'Output Gap', 'Debt', 'Surplus'};

        % Fiscal shaded area between 5th and 95th percentiles
        fill([x, fliplr(x)], [stats_fis.(sprintf('%s_5', var))', fliplr(stats_fis.(sprintf('%s_95', var))')], grey_color, 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);
        hold on;

        % Monetary shaded area between 5th and 95th percentiles
        fill([x, fliplr(x)], [stats_mon.(sprintf('%s_5', var))', fliplr(stats_mon.(sprintf('%s_95', var))')], light_grey, 'EdgeColor', 'none', 'FaceAlpha', fill_alpha);

        % Plot IRFs for fiscal data in grey
        for j = 1:nIRFs
            plot(x, squeeze(stats_fis.(sprintf('%s_raw', var))(:,j)), 'Color', grey_color, 'LineStyle', ':', 'LineWidth', 0.5);
        end

        % Plot IRFs for monetary data in grey
        for j = 1:nIRFs
            plot(x, squeeze(stats_mon.(sprintf('%s_raw', var))(:,j)), 'Color', grey_color, 'LineStyle', ':', 'LineWidth', 0.5);
        end

        % Plot fiscal mean with a display name for the legend
        fiscal_mean_line = plot(x, stats_fis.(sprintf('%s_mean', var)), 'Color', fiscal_color, 'LineWidth', 2, 'DisplayName', [var ' Fiscal']);

        % Plot monetary mean with a display name for the legend
        monetary_mean_line = plot(x, stats_mon.(sprintf('%s_mean', var)), 'Color', monetary_color, 'LineWidth', 2, 'DisplayName', [var ' Monetary']);


        ylabel(ylabel_text{i-1}); % Custom label for the current variable

        % Add the legend for every subplot
        legend([fiscal_mean_line, monetary_mean_line], 'Location', 'best');

        hold off;
    end


    % Adjust subplot spacing if necessary
    set(gcf, 'Position', [100, 100, 1000, 600]); % Example to adjust figure size
    % tight_layout(); % May need to install this function or create your own




    if announcementPeriod - 4 > 0
        graphTitle = sprintf('IRFs for disinflation with announcement %d period ahead', announcementPeriod-4);
    else
        graphTitle = 'IRFs for cold turkey disinflation';
    end
    suptitle(graphTitle);

    % Ensure the folder path exists or create it
    % folder_path = 'SW_Output'; % Define your folder path here
    % if ~exist(folder_path, 'dir')
    %     mkdir(folder_path);
    % end

    % Generate a customized filename and save the figure
    % filename = fullfile(folder_path, sprintf('Combined_An%d.png', announcementPeriod-4));
    % saveas(fig, filename);
    % print(fig, filename, '-dpng', '-r200');
    clearvars -except announcementPeriod mean_fis_array std_fis_array mean_mon_array std_mon_array periods_array folder_path inflation_target x2 estim_params_ options_ M_ oo_ TT inflation_target CRPI_fis R_fis CRPI_mon R_mon
end

TAB = table(periods_array, mean_fis_array, std_fis_array, mean_mon_array, std_mon_array,...
    'VariableNames', {'Announcement_Period', 'Mean_SR_Fiscal', 'Std_SR_Fiscal', 'Mean_SR_Monetary', 'Std_SR_Monetary'})



% Clean up the environment
% close all;





