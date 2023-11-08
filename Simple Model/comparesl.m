%% Disinflation IRFs with Simple NK-Model
clear all
close all
clc

%% Setting the Parameters
inflation_target = 0.02;0;0.06;


% Fiscal-led regime
CRPI_fis = 0.5;
R_fis = 0;

% Monetary-led regime
CRPI_mon = 0.5;
R_mon = 0;
T=4;
%% Dynare part
model_name = 'NK_SS';

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);
warning('off', 'MATLAB:singularMatrix');

[sr_fis, nir_fis, rir_fis, infl_fis, ogap_fis, debt_fis, surp_fis] = ...
        disinflation(model_name, options_, M_, oo_, inflation_target, CRPI_fis, R_fis, 4, T);

clearvars -except inflation_target CRPI_fis R_fis CRPI_mon R_mon T sr_fis ...
    nir_fis rir_fis infl_fis ogap_fis debt_fis surp_fis

model_name2 = 'NK_SS_LTB';
eval(['dynare ', model_name2, '.mod noclearall nostrict nolog']);
warning('off', 'MATLAB:singularMatrix');
[sr_mon, nir_mon, rir_mon, infl_mon, ogap_mon, debt_mon, surp_mon, rn, price] = ...
        disinf2(model_name2, options_, M_, oo_, inflation_target, CRPI_mon, R_mon, 4, T);

%% Loop for plotting IRFs for both fiscal and monetary led disinflation

    % Create a new figure for combined plots
    figure_combined = figure;
    
    % Interest rate and real rate subplot
    subplot(3, 2, 1);
    hold on;
    plot(nir_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal nominal interest rate
    plot(rir_fis, 'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5); % Fiscal real interest rate
    plot(nir_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary nominal interest rate
    plot(rir_mon, 'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5); % Monetary real interest rate
    ylabel('Interest rate/real rate');
    legend('Nominal IR (short-term)', 'Real IR (short-term)', 'Nominal IR (long-term)', 'Real IR (long-term)');
    hold off;
    
    % Inflation subplot
    subplot(3, 2, 2);
    hold on;
    plot(infl_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal inflation
    plot(infl_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary inflation
    ylabel('Inflation');
    legend('Inflation (short-term)', 'Inflation (long-term)');
    hold off;
    
    % Output gap subplot
    subplot(3, 2, 3);
    hold on;
    plot(ogap_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal output gap
    plot(ogap_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary output gap
    ylabel('Output gap');
    legend('Output Gap (short-term)', 'Output Gap (long-term)', 'Location','southeast');
    hold off;
    
    % Government debt and surplus subplot
    subplot(3, 2, 4);
    hold on;
    plot(debt_fis, 'Color', '#C2444E', 'LineWidth', 1.5); % Fiscal government debt
    plot(surp_fis, 'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5); % Fiscal government surplus
    plot(debt_mon, 'Color', '#024b79', 'LineWidth', 1.5); % Monetary government debt
    plot(surp_mon, 'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5); % Monetary government surplus
    ylabel('Government debt/surplus');
    legend('Debt (short-term)', 'Surplus (short-term)', 'Debt (long-term)', 'Surplus (long-term)', 'Location','best');
    hold off;
    
    subplot(3, 2, 5);
    plot(rn,'Color', '#C2444E','LineWidth', 1.5);
    plot(price,'Color', '#C2444E','LineWidth', 1.5);
    hold on;
    
    % Save the combined figure
    set(gcf, 'Position', [100, 100, 1000, 600]);






