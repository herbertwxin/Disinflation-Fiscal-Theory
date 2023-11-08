function [fig, sr_value_rounded, sr_sd] = autoplot(x2, estim_params_, options_,M_,oo_, T,CPIE, CRPI, RR, Ta, Tstar)
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



sr_sd = std(sacrifice_ratio_raw(:)); 
sacrifice_ratio = mean(sacrifice_ratio_raw(:));

sr_value_rounded = round(sacrifice_ratio, 4);


% Create the annotation with the text "SR = NUMBER"
annotation_text = sprintf('SR = %.4f ± %.4f', sr_value_rounded, sr_sd);


% Calculate the mean and 95 percentile for each variable 
robs_mean = mean(squeeze(y_non(SET.variable.robs,:,:)),2);
robs_95 = prctile(squeeze(y_non(SET.variable.robs,:,:)),95,2);
robs_5 = prctile(squeeze(y_non(SET.variable.robs,:,:)),5,2);

rr_mean = mean(squeeze(y_non(SET.variable.rr,:,:)),2);
rr_95 = prctile(squeeze(y_non(SET.variable.rr,:,:)),95,2);
rr_5 = prctile(squeeze(y_non(SET.variable.rr,:,:)),5,2);

pinfobs_mean = mean(squeeze(y_non(SET.variable.pinfobs,:,:)),2);
pinfobs_95 = prctile(squeeze(y_non(SET.variable.pinfobs,:,:)),95,2);
pinfobs_5 = prctile(squeeze(y_non(SET.variable.pinfobs,:,:)),5,2);

y_mean = mean(squeeze(y_non(SET.variable.y,:,:)-y_non(SET.variable.yf,:,:)),2);
y_95 = prctile(squeeze(y_non(SET.variable.y,:,:)-y_non(SET.variable.yf,:,:)),95,2);
y_5 = prctile(squeeze(y_non(SET.variable.y,:,:)-y_non(SET.variable.yf,:,:)),5,2);

v_mean = mean(squeeze(y_non(SET.variable.v,:,:)),2);
v_95 = prctile(squeeze(y_non(SET.variable.v,:,:)),95,2);
v_5 = prctile(squeeze(y_non(SET.variable.v,:,:)),5,2);

s_mean = mean(squeeze(y_non(SET.variable.s,:,:)),2);
s_95 = prctile(squeeze(y_non(SET.variable.s,:,:)),95,2);
s_5 = prctile(squeeze(y_non(SET.variable.s,:,:)),5,2);


% Plot the shaded region between 5th and 95th percentiles
x = 1:T;

fill_alpha = 0.5; % Set transparency level

fig = figure;
subplot(2,2,1)
fill([x, fliplr(x)], [robs_5', fliplr(robs_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot(y_non(SET.variable.robs,:,i_)', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(robs_mean, 'Color', '#005092', 'LineWidth', 3, 'DisplayName', 'nominal interest rate')

% Plot the mean for robs data and get handle
h_robs_mean = plot(robs_mean, 'Color', '#005092', 'LineWidth', 3, 'DisplayName', 'nominal interest rate');
hold on

% Plot the 95th and 5th percentiles in blue
plot(robs_95, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
plot(robs_5, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
hold on

ylabel('Interest rate')
hold on

fill([x, fliplr(x)], [rr_5', fliplr(rr_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot(y_non(SET.variable.rr,:,i_)', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(rr_mean, 'Color', '#C2444E', 'LineWidth', 2.5, 'LineStyle', '-.', 'DisplayName', 'ex-ante real rate')

% Plot the mean for robs data and get handle
h_rr_mean = plot(rr_mean, 'Color', '#C2444E', 'LineWidth', 2.5, 'LineStyle', '-.', 'DisplayName', 'ex-ante real rate');
hold on

% Plot the 95th and 5th percentiles in blue
plot(rr_95, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
plot(rr_5, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
hold on



% Create legend using the specific handles
legend([h_robs_mean, h_rr_mean])



subplot(2,2,2)
fill([x, fliplr(x)], [pinfobs_5', fliplr(pinfobs_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot(y_non(SET.variable.pinfobs,:,i_)', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(pinfobs_mean, 'Color', '#005092', 'LineWidth', 3)
hold on

% Plot the 95th and 5th percentiles in blue
plot(pinfobs_95, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
plot(pinfobs_5, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
hold on

ylabel('Inflation')
hold on


subplot(2,2,3)
fill([x, fliplr(x)], [y_5', fliplr(y_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot((y_non(SET.variable.y,:,i_)-y_non(SET.variable.yf,:,i_))', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(y_mean, 'Color', '#005092', 'LineWidth', 3)
hold on

% Plot the 95th and 5th percentiles in blue
plot(y_95, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
plot(y_5, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
hold on

ylabel('Output gap')

% Get current axis position
currentAxis = gca;
axisPosition = currentAxis.Position;

% Adjust these offsets as needed
x_offset = 0.11;
y_offset = 0.255;

% Calculate annotation position
annotation_x = axisPosition(1) + axisPosition(3) - x_offset;
annotation_y = axisPosition(2) + y_offset;
annotation_position = [annotation_x, annotation_y, 0.1, 0.1];

% Add the annotation
annotation('textbox', annotation_position, 'String', annotation_text, ...
    'FitBoxToText', 'on', 'EdgeColor', 'black', 'BackgroundColor', 'none', ...
    'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom');
hold on

subplot(2,2,4)

fill([x, fliplr(x)], [v_5', fliplr(v_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot(y_non(SET.variable.v,:,i_)', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(v_mean, 'Color', '#005092', 'LineWidth', 3, 'DisplayName', 'Debt')
h_v_mean = plot(v_mean, 'Color', '#005092', 'LineWidth', 3, 'DisplayName', 'Debt');
hold on

% Plot the 95th and 5th percentiles in blue
plot(v_95, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
plot(v_5, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
hold on

fill([x, fliplr(x)], [s_5', fliplr(s_95')], [0.8, 0.8, 0.8], 'EdgeColor', 'none', 'FaceAlpha', fill_alpha); % Using a light grey color
hold on

% Plot each IRF in grey
for i_ = 1:100
    plot(y_non(SET.variable.s,:,i_)', 'Color', [0.7, 0.7, 0.7]) % Slightly darker grey than the shaded region
    hold on
end

% Plot the mean in red
plot(s_mean, 'Color', '#C2444E', 'LineWidth', 2.5, 'LineStyle', '-.', 'DisplayName', 'Surplus')
h_s_mean = plot(s_mean, 'Color', '#C2444E', 'LineWidth', 2.5, 'LineStyle', '-.', 'DisplayName', 'Surplus');
hold on

% Plot the 95th and 5th percentiles in blue
plot(s_95, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
plot(s_5, 'Color', '#024b79', 'LineWidth', 1, 'LineStyle', '--')
hold on

ylabel('Government debt/surplus')

legend([h_v_mean, h_s_mean])

hold off


end

