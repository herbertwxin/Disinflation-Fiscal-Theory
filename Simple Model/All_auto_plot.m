%% Disinflation IRFs with Simple NK-Model
clear all
close all
clc

%% Model names list and SR
model_names = {'NK', 'NK_SS', 'NK_SS_LTB', 'NK_CS', 'NK_CS_LTB'};
SR_fis_all = {};
SR_mon_all = {};
ModelNames_all = {};

%% Loop over each model name
for model_idx = 1:length(model_names)
    model_name = model_names{model_idx};

    %% Run Dynare for the selected model
    eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);
    warning('off', 'MATLAB:singularMatrix');

    %% Create folder path for outputs
    folder_path = fullfile(pwd, model_name); 
    if ~exist(folder_path, 'dir')
       mkdir(folder_path);
    end

    %% Setting the Parameters (assuming these are constant across models)
    inflation_target = 0.02; % Update this line if inflation_target is an array
    Tstar = 6; %default Ta = 4

    % Fiscal-led regime
    CRPI_fis = 0.5;
    R_fis = 0;

    % Monetary-led regime
    CRPI_mon = 1.5;
    R_mon = 0.35;

    %% Loop for plotting IRFs for both fiscal and monetary led disinflation
    for T = 4:Tstar
        % Fiscal-led disinflation
        [sr_fis, nir_fis, rir_fis, infl_fis, ogap_fis, debt_fis, surp_fis] = ...
            disinflation(model_name, options_, M_, oo_, inflation_target, CRPI_fis, R_fis, 4, T);

        % Monetary-led disinflation
        [sr_mon, nir_mon, rir_mon, infl_mon, ogap_mon, debt_mon, surp_mon] = ...
            disinflation(model_name, options_, M_, oo_, inflation_target, CRPI_mon, R_mon, 4, T);

        % Collect the sacrifice ratios
        SR_fis_all{end+1} = sr_fis;  % Append fiscal sacrifice ratio
        SR_mon_all{end+1} = sr_mon;  % Append monetary sacrifice ratio
        ModelNames_all{end+1} = model_name; % Append model name

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
        

        % Save and close figures
        set(gcf, 'Position', [100, 100, 800, 600]);
        filename_combined = fullfile(folder_path, sprintf('Combined_An%d.png', T-4));
        saveas(figure_combined, filename_combined);
        close(figure_combined);
    end

    % Optionally, clear variables before the next iteration
    % to avoid any potential conflicts
    clearvars -except model_names model_idx SR_fis_all SR_mon_all ModelNames_all;
end

% Number of entries should be the same for both fiscal and monetary
num_entries = length(SR_fis_all);
assert(num_entries == length(SR_mon_all), 'Fiscal and Monetary entries must match.');

% Create tables for the sacrifice ratios
SR_fis_table = table([SR_fis_all{:}]', 'VariableNames', {'SR_fis'});
SR_mon_table = table([SR_mon_all{:}]', 'VariableNames', {'SR_mon'});

% Assuming each model has the same number of T values (announcements)
num_models = length(model_names);
entries_per_model = num_entries / num_models;

% Create status and model name arrays
status = cell(num_entries, 1);
model_names_expanded = cell(num_entries, 1);

for i = 1:num_models
    base_idx = (i-1) * entries_per_model;
    status(base_idx + 1) = {'Cold-turkey'};
    status(base_idx + 2:base_idx + entries_per_model) = arrayfun(@(x) ['Announced ', num2str(x - 1)], 2:entries_per_model, 'UniformOutput', false)';
    model_names_expanded(base_idx + 1:base_idx + entries_per_model) = repmat(model_names(i), entries_per_model, 1);
end

% Create tables from the status and model name variables
status_table = table(status, 'VariableNames', {'Status'});
model_names_table = table(model_names_expanded, 'VariableNames', {'Model'});

% Concatenate the tables horizontally
combined_table = [model_names_table, status_table, SR_fis_table, SR_mon_table];

% Display the combined table
disp(combined_table);

% Close all figures
close all;
