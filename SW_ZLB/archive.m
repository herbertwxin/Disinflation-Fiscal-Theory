% figure(1)
% subplot(2,2,1)
% plot(y_non(SET.variable.robs,:),'k')
% ylabel('Interest rate')
% hold on
% plot(y_non(SET.variable.rr,:),'k--')
% hold on
% plot(y_non(SET.variable.robs,:)-y_non(SET.variable.pinfobs,:),'k:')
% legend('nominal rate', 'ex-ante real rate', 'ex-post real rate')
% subplot(2,2,2)
% plot(y_non(SET.variable.pinfobs,:),'k')
% ylabel('Inflation')
% hold on
% subplot(2,2,3)
% plot(y_non(SET.variable.y,:)-y_non(SET.variable.yf,:),'k')
% % axis([0 T -1 5])
% ylabel('Output gap')
% hold on
% annotation('textbox', annotation_position, 'String', annotation_text, ...
%     'FitBoxToText', 'on', 'EdgeColor', 'black', 'BackgroundColor', 'none');
% % axis([0 T -0.005 1])
% subplot(2,2,4)
% plot(y_non(SET.variable.v,:),'k')
% % axis([0 T -1 4])
% ylabel('Government debt')
% hold on
% % axis([0 T -0.005 1])