%% Disinflation IRFs with Simple NK-Model
clear all
close all
clc
%% Select the Model for Dynare


% model_name = 'NK';
% model_name = 'NK_SS';
model_name = 'NK_SS_LTB';
% model_name = 'NK_CS';
% model_name = 'NK_CS_LTB';


eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);
warning('off', 'MATLAB:singularMatrix');

folder_path = fullfile(pwd, model_name); % 'pwd' ensures an absolute path from the current working directory
if ~exist(folder_path, 'dir')
   mkdir(folder_path);
end


%% Setting the Parameters
inflation_target = 0.02;0;0.06;
Tstar = 6; %default Ta = 4

% Fiscal-led regime
CRPI_fis = 0.5;
R_fis = 0;

% Monetary-led regime
CRPI_mon = 1.5;
R_mon = 0.35;
%% Loop for plotting IRFs for both fiscal and monetary led disinflation
% Assuming T is defined somewhere above
for T = 4:Tstar
    % Fiscal-led disinflation
    [sr_fis, nir_fis, rir_fis, infl_fis, ogap_fis, debt_fis, surp_fis] = ...
        disinflation(model_name, options_, M_, oo_, inflation_target, CRPI_fis, R_fis, 4, T);
    
    % Monetary-led disinflation
    [sr_mon, nir_mon, rir_mon, infl_mon, ogap_mon, debt_mon, surp_mon] = ...
        disinflation(model_name, options_, M_, oo_, inflation_target, CRPI_mon, R_mon, 4, T);
    
    % Create a new figure for combined plots
    figure_combined = figure;
    
    % Interest rate and real rate subplot
    subplot(2, 2, 1);
    hold on;
    plot(nir_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal nominal interest rate
    plot(rir_fis, 'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5); % Fiscal real interest rate
    plot(nir_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary nominal interest rate
    plot(rir_mon, 'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5); % Monetary real interest rate
    ylabel('Interest rate/real rate');
    legend('Nominal IR (Fiscal)', 'Real IR (Fiscal)', 'Nominal IR (Monetary)', 'Real IR (Monetary)');
    hold off;
    
    % Inflation subplot
    subplot(2, 2, 2);
    hold on;
    plot(infl_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal inflation
    plot(infl_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary inflation
    ylabel('Inflation');
    legend('Inflation (Fiscal)', 'Inflation (Monetary)');
    hold off;
    
    % Output gap subplot
    subplot(2, 2, 3);
    hold on;
    plot(ogap_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal output gap
    plot(ogap_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary output gap
    ylabel('Output gap');
    legend('Output Gap (Fiscal)', 'Output Gap (Monetary)', 'Location','southeast');
    hold off;
    
    % Government debt and surplus subplot
    subplot(2, 2, 4);
    hold on;
    plot(debt_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal government debt
    plot(surp_fis, 'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5); % Fiscal government surplus
    plot(debt_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary government debt
    plot(surp_mon, 'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5); % Monetary government surplus
    ylabel('Government debt/surplus');
    legend('Debt (Fiscal)', 'Surplus (Fiscal)', 'Debt (Monetary)', 'Surplus (Monetary)', 'Location','best');
    hold off;
    
    % Add a title to the figure
    if T - 4 > 0
        graphTitle = sprintf('IRFs for disinflation with announcement %d period ahead', T-4);
    else
        graphTitle = 'IRFs for cold turkey disinflation';
    end
    suptitle(graphTitle);
    
    % Save the combined figure
    set(gcf, 'Position', [100, 100, 800, 600]);
    filename_combined = fullfile(folder_path, sprintf('Combined_An%d.png', T-4));
    saveas(figure_combined, filename_combined);
    
    % Close the figures to avoid display clutter
    close(figure_combined);
end






