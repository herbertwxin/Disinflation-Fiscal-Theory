%% Simulate Changes in the Inflation Target of the Central Bank
clear all
clc
% close all

% model_name = 'NK';
% model_name = 'NK_SS';
% model_name = 'NK_SS_LTB';
% model_name = 'NK_CS';
model_name = 'NK_CS_LTB';


eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);
warning('off', 'MATLAB:singularMatrix');

%% 


color = ['k','b','r'];
c_color = 1;
% Extract variable details from Dynare output

n_ = M_.endo_nbr ;
n_ = n_+1 ; % Constant
l_ = M_.exo_nbr ;

base_model.variable.n_ = n_ ; % Number of endogenous variables
base_model.variable.l_ = l_ ; % Number of exogenous variables
var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;

for ii=1:n_-1
    eval(['base_model.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:M_.param_nbr
    eval(['base_model.param_names.',param_names{ii},'=',int2str(ii),';']) ;
end

base_model.M_  = M_ ;
base_model.oo_ = oo_ ;

base_model.options_ = options_ ;
base_model.solve = 1 ;
base_model.linearize_around_diff_y = 0 ;

out = dyn_to_str(base_model) ;

base_model.mats.Q = out.mats.Q ;
base_model.mats.G = out.mats.G ;

% A0 y_t = A1 y_t-1 + B0 E_t y_t+1 + D0 eps_t 
% y_t = A0^{-1}.A1 y_t-1 + A0^{-1}B0 E_t y_{t+1} ...
base_model.str_mats.A0 = out.mats.A ;
base_model.str_mats.A1 = out.mats.B ;
base_model.str_mats.B0 = out.mats.D ;
base_model.str_mats.D0 = out.mats.E ;
base_model.str_mats.D2 = out.mats.D2 ;
base_model.str_mats.Gamma = out.mats.Gamma ;

% y_ss = Q/(I - Q)
y_ss = (eye(n_-1) - out.mats.Q(1:n_-1,1:n_-1)) \ out.mats.Q(1:n_-1,end)  ;
base_model.y_ss = [y_ss ; 1] ; % Constant

%% Simulating a change to the inflation target to 2%

new_model = base_model;
beta = 0.99;
M_.params(new_model.param_names.pi_bar) = 0.02;
M_.params(new_model.param_names.i_bar) = M_.params(new_model.param_names.pi_bar)-log(beta);
M_.params(new_model.param_names.phi_i) = 0.5;1.5;%1.5;0.8;1.25;
M_.params(new_model.param_names.R) = 0;0.35; %0.99^(-1);0.5; 1/1.5;1.01;0.5;
% RR = M_.params(new_model.param_names.R);
% For dynare 5.3
%[oo_.dr,info,M_,oo_]  = resol(0,M_,options_,oo_) ; 

% For dyanre 4.5.6
[oo_.dr,info,M_,options_,oo_]  = resol(0,M_,options_,oo_) ;

new_model.M_  = M_ ;
new_model.oo_ = oo_ ;
new_model.solve = 1 ;
new_model.linearize_around_diff_y = 0;
new_model.options_ = options_;

out = dyn_to_str(new_model) ;

new_model.mats.Q = out.mats.Q ;
new_model.mats.G = out.mats.G ;

new_model.str_mats.A0 = out.mats.A ;
new_model.str_mats.A1 = out.mats.B ;
new_model.str_mats.B0 = out.mats.D ;
new_model.str_mats.D0 = out.mats.E ;
new_model.str_mats.D2 = out.mats.D2 ;
new_model.str_mats.Gamma = out.mats.Gamma ;

y_ss = (eye(n_-1) - out.mats.Q(1:n_-1,1:n_-1)) \ out.mats.Q(1:n_-1,end);
new_model.y_ss = [y_ss ; 1] ; % Constant

%% Simulate an unanticipated disinflation 
T = 20; %length of the simulation
Ta = 4; %Date of the announcement
Tstar = 4; %Date of the disinflation policy implementation

y_non = zeros(n_,T);
y_non(:,1) = base_model.y_ss;

if Ta<Tstar

% Allow for announcement date and implementation date to differ
% Do backward induction
Qat = zeros(n_,n_,Tstar-Ta);
Gat = zeros(n_,l_,Tstar-Ta);


% A = A1/A0
% A = base_model.str_mats.A0\base_model.str_mats.A1;
% A0inv = inv(base_model.str_mats.A0);
% % B = B0/A0
% B = base_model.str_mats.A0\base_model.str_mats.B0;
D0 = base_model.str_mats.D0;
A0 = base_model.str_mats.A0;
A1 = base_model.str_mats.A1;
B0 = base_model.str_mats.B0;
% y_t = A y_t-1 + B E_t y_t+1 + D eps_t

%     Qat(:,:,end) = (eye(n_)-B*new_model.mats.Q)\A;
%     Gat(:,:,end) = (eye(n_)-B*new_model.mats.Q)\A0inv*D0;
    
    Qat(:,:,end) = (A0-B0*new_model.mats.Q)\A1;
    Gat(:,:,end) = (A0-B0*new_model.mats.Q)\D0;

% for t = Tstar-Ta-1:-1:1
%     Qat(:,:,t) = (eye(n_)-B*Qat(:,:,t+1))\A;
%     Gat(:,:,t) = (eye(n_)-B*Qat(:,:,t+1))\A0inv*D0;
% end

for t = Tstar-Ta-1:-1:1
    Qat(:,:,t) = (A0-B0*Qat(:,:,t+1))\A1;
    Gat(:,:,t) = (A0-B0*Qat(:,:,t+1))\D0;
end

Qtilde = zeros(n_,n_,Tstar-Ta);
Gtilde = zeros(n_,l_,Tstar-Ta);

% for t = 1:Tstar-Ta
%     Qtilde(:,:,t) = (eye(n_) - B*Qat(:,:,t))\A;
% end
for t = 1:Tstar-Ta
   Qtilde(:,:,t) = (A0 - B0*Qat(:,:,t))\A1;
end


% Initial policy regime
for t= 2:Ta-1
    y_non(:,t) = base_model.mats.Q*y_non(:,t-1); 
end

% for t = Ta:Tstar-1
%    y_non(:,t) = Qat(:,:,t-Ta+1)*y_non(:,t-1);
% end

for t = Ta:Tstar-1
   y_non(:,t) =  Qtilde(:,:,t-Ta+1)*y_non(:,t-1);
end

for t= Tstar:T
    y_non(:,t) = new_model.mats.Q*y_non(:,t-1); 
end

else
for t= 2:Ta-1
    y_non(:,t) = base_model.mats.Q*y_non(:,t-1); 
end


for t= Tstar:T
    y_non(:,t) = new_model.mats.Q*y_non(:,t-1); 
end
    
end

%% Graph outcome

% sacrifice_ratio = -sum(y_non(base_model.variable.x,:))/(0.08-0.02);
% sr_value_rounded = round(sacrifice_ratio, 4);
% 
% 
% 
% figure(1)
% subplot(3,2,1)
% plot(y_non(base_model.variable.i,:),'Color', '#024b79', 'LineWidth', 1.5)
% ylabel('Interest rate/real rate')
% hold on
% plot(y_non(base_model.variable.r,:),'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5)
% legend('interest rate', 'real rate')
% subplot(3,2,2)
% plot(y_non(base_model.variable.pi,:),'Color', '#024b79', 'LineWidth', 1.5)
% ylabel('Inflation')
% hold on
% subplot(3,2,3)
% plot(y_non(base_model.variable.x,:),'Color', '#024b79', 'LineWidth', 1.5)
% ylabel('Output gap')
% hold on
% 
% subplot(3,2,4)
% 
% plot(y_non(base_model.variable.v,:),'Color', '#024b79', 'LineWidth', 1.5)
% hold on
% plot(y_non(base_model.variable.s,:),'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5)
% legend('Debt', 'Surplus')
% ylabel('Government debt')
% hold on

% 
% subplot(3,2,5)
% plot(y_non(base_model.variable.vstar,:),'Color', '#024b79', 'LineWidth', 1.5)
% ylabel('Latent debt')
% hold on

% subplot(3,2,6)
% plot(y_non(base_model.variable.rn,:),'Color', '#024b79', 'LineWidth', 1.5)
%
% hold on
%
% plot(y_non(base_model.variable.q,:),'Color', '#024b79', 'LineStyle', '--', 'LineWidth', 1.5)
% ylabel('Debt return/portfolio price')
% legend('Return', 'Debt Price')
% hold on

% set(gcf, 'Position', [100, 100, 800, 800]);
% suptitle('Detailed IRF for long-term debt analysis');
%% 

hold on
subplot(3,2,1)
plot(y_non(base_model.variable.i,:),'Color', '#C2444E', 'LineWidth', 1.5)
ylabel('Interest rate/real rate')
hold on
plot(y_non(base_model.variable.r,:),'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5)
legend('interest rate', 'real rate')
subplot(3,2,2)
plot(y_non(base_model.variable.pi,:),'Color', '#C2444E', 'LineWidth', 1.5)
ylabel('Inflation')
hold on
subplot(3,2,3)
plot(y_non(base_model.variable.x,:),'Color', '#C2444E', 'LineWidth', 1.5)
ylabel('Output gap')
hold on

subplot(3,2,4)

plot(y_non(base_model.variable.v,:),'Color', '#C2444E', 'LineWidth', 1.5)
hold on
plot(y_non(base_model.variable.s,:),'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5)
legend('Debt', 'Surplus')
ylabel('Government debt')
hold on


subplot(3,2,5)
plot(y_non(base_model.variable.vstar,:),'Color', '#024b79', 'LineWidth', 1.5)
ylabel('Latent debt')
hold on

subplot(3,2,6)
plot(y_non(base_model.variable.rn,:),'Color', '#C2444E', 'LineWidth', 1.5)

hold on

plot(y_non(base_model.variable.q,:),'Color', '#C2444E', 'LineStyle', '--', 'LineWidth', 1.5)
ylabel('Debt return/portfolio price')
legend('Return', 'Debt Price')
hold on
set(gcf, 'Position', [100, 100, 1000, 1000]);

% figure(1)
% if RR == 0
%     plot(y_non(base_model.variable.v,:),'Color', '#C2444E', 'LineWidth', 2)
% else
%     plot(y_non(base_model.variable.v,:),'Color', '#024b79', 'LineWidth', 2)
% end
% 
% hold on
% ylabel('Government debt')
% legend('Fiscal led', 'Monetary led')
% title('Government debt comparison')

% figure(2)
% if RR == 0
%     plot(y_non(base_model.variable.pi,:),'Color', '#C2444E', 'LineWidth', 2)
% else
%     plot(y_non(base_model.variable.pi,:),'Color', '#024b79', 'LineWidth', 2)
% end
% hold on
% ylabel('Inflation')
% legend('Monetary led', 'Fiscal led')
% title('Inflation Comparison')