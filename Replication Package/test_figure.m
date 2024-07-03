%% Figure
    Plot_range = 1:12;
    subplot(2,2,1)
    plot(y_non(BASE.variable.i,Plot_range)*400,'Color', '#024b79', 'LineWidth', 2)
    ylabel('Policy rate/real rate')
    hold on
    plot(y_non(BASE.variable.r,Plot_range)*400,'Color', '#C2444E', 'LineStyle', '-.', 'LineWidth', 2)
    % plot(y_non(BASE.variable.r,Plot_range),'Color', 'r', 'LineStyle', '-.', 'LineWidth', 2)
    if model_name == "NK_SS_LTB"
        plot(y_non(BASE.variable.rn,Plot_range),'Color', 'k', 'LineStyle', '-.', 'LineWidth', 2)
    end
    plot([PARAMS.Ta PARAMS.Ta],[-2 12],'b--')
    plot([PARAMS.Tstar PARAMS.Tstar],[-2 12],'k--')
    legend('Policy rate', 'Real rate (r - r*)','Announced','Implemented')
    ylim([-2,12])
    set(gca, 'FontSize', 16)

    subplot(2,2,2)
    plot(y_non(BASE.variable.pi,Plot_range)*400,'Color', '#024b79', 'LineWidth', 2)
    % plot(y_non(BASE.variable.pi,Plot_range),'Color', 'b', 'LineWidth', 2)
    ylabel('Inflation')
    hold on
    plot([PARAMS.Ta PARAMS.Ta],[0 10],'b--')
    plot([PARAMS.Tstar PARAMS.Tstar],[0 10],'k--')
    set(gca, 'FontSize', 16)

    subplot(2,2,3)
    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', '#024b79', 'LineWidth', 2)
    % plot(y_non(BASE.variable.x,Plot_range),'Color', 'b', 'LineWidth', 2)
    ylabel('Output gap')
    hold on
    set(gca, 'FontSize', 16)

    subplot(2,2,4)
    plot(y_non(BASE.variable.v,Plot_range)*100,'Color', '#024b79', 'LineWidth', 2)
    % plot(y_non(BASE.variable.v,Plot_range),'Color', 'b', 'LineWidth', 2)
    ylabel('Government debt/surplus')
    hold on
    plot(y_non(BASE.variable.s,Plot_range)*100,'Color', '#C2444E', 'LineStyle', '-.', 'LineWidth', 2)
    legend('Debt', 'Surplus')

    set(gcf, 'Position', [100, 100, 800, 600]);
    set(gca, 'FontSize', 16)