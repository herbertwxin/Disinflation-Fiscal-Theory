%% Table 2 Disinflation under Smets & Wouters (2007)
% Generate results in Table. 2
% for Dynare version 5.5
%% Initialization
clear all
% close all
% clc

warning('off', 'MATLAB:singularMatrix');
warning('off', 'MATLAB:nearlySingularMatrix');
addpath("_functions");

%% Model Selection

% model_name = 'SW_SS_LTB';
model_name = 'SW_SS';

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);

% addpath("SW_SS/metropolis");
% load("SW_SS_mh1_blck1.mat");

%% Options
% Pegged regime
i_peg = 0;

% Plot
Plot = 1;

% Comparison graph
Compare = 0;

%% Setting the Parameters
% Set inflation target
PARAMS.CPIE = 1.005;

% Announcement period
PARAMS.Ta = 4;

% Implementation period
PARAMS.Tstar = 5;

% Taylor rule parameter
PARAMS.CRPI = 0.5;2.0443;

% Fiscal rule parameter
PARAMS.RR = 0;0.35;

% Fiscal response to inflation
PARAMS.CRPIS = 0.5;

% Length of Simulation
PARAMS.T = 100;

if PARAMS.CRPI > 1
    disp("Monetary-led regime")
else
    disp("Fiscal-led regime")
end

if model_name == "SW_SS_LTB"
    disp("Long-term debt")
else 
    disp("Short-term debt")
end

if i_peg == 1
    disp('Interest rate peg activated')
else 
    disp('No interest rate peg')
end

disp(['Announcement of ', num2str(PARAMS.Tstar - PARAMS.Ta), ' period ahead'])

disp("Parameters:")
disp(['new inflation target = ', num2str(PARAMS.CPIE)])
disp(['phi_i = ', num2str(PARAMS.CRPI)])
disp(['phi_s = ', num2str(PARAMS.CRPIS)])
disp(['R = ', num2str(PARAMS.RR)])


%% Generate Struct for Base model
% Take in the specified crpis, crpi, rr
M_.params(find(strcmp(M_.param_names, 'crpis'))) = PARAMS.CRPIS;
M_.params(find(strcmp(M_.param_names, 'crpi'))) = PARAMS.CRPI;
M_.params(find(strcmp(M_.param_names, 'R'))) = PARAMS.RR;

[oo_.dr,info,M_,oo_]  = resol(0,M_,options_,oo_) ;

% dyn_to_str input struct
dyn_in.options_ = options_ ;
dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

% Uses BASE to indicate for the base model
BASE.M_ = dyn_in.M_ ;
BASE.oo_ = dyn_in.oo_ ;
BASE.options_ = options_ ;

% Output from dyn_to_str
out = dyn_to_str(dyn_in) ;

BASE.mats.Q = out.mats.Q ;
Q = BASE.mats.Q ;
BASE.mats.G = out.mats.G ;
G = BASE.mats.G ;

% Assign struct mat to BASE
BASE.str_mats.A0 = out.mats.A ;
BASE.str_mats.A1 = out.mats.B ;
BASE.str_mats.B0 = out.mats.D ;
BASE.str_mats.D0 = out.mats.E ;
BASE.str_mats.D2 = out.mats.D2 ;
BASE.str_mats.Gamma = out.mats.Gamma ;

% Number of variables
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables


BASE.variable.n_ = n_ ;
BASE.variable.l_ = l_ ;
BASE.nparam      = M_.param_nbr ;

var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;
exo_var_names = cellstr(M_.exo_names) ;

for ii=1:n_-1
    eval(['BASE.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:l_
    eval(['BASE.variable.shock.',exo_var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:M_.param_nbr
    eval(['BASE.param_names.',param_names{ii},'=',int2str(ii),';']) ;
end

BASE.y_ss = (eye(n_-1) - Q(1:n_-1,1:n_-1)) \ Q(1:n_-1,end)  ;
BASE.y_ss = [BASE.y_ss ; 1] ; % Constant

base_inf = M_.params(BASE.param_names.cpie);

%% Generate Struct for New model
% BASE.param_crosswalk = estim_params_.param_vals(:,1);

% Extra cr and put it in PARAMS
PARAMS.CR = PARAMS.CPIE/(M_.params(BASE.param_names.cbeta)*M_.params(BASE.param_names.cgamma)^(-M_.params(BASE.param_names.csigma)));


M_.params(BASE.param_names.cpie) = PARAMS.CPIE;
M_.params(BASE.param_names.cr) = PARAMS.CR;
M_.params(BASE.param_names.conster) = (PARAMS.CR-1)*100;
M_.params(BASE.param_names.constepinf) = (PARAMS.CPIE-1)*100;
M_.params(BASE.param_names.crpi) = PARAMS.CRPI;
M_.params(BASE.param_names.R) = PARAMS.RR;

[oo_.dr,info,M_,oo_]  = resol(0,M_,options_,oo_) ;

dyn_in.options_ = options_ ;

dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

NEW.M_ = dyn_in.M_ ;
NEW.oo_ = dyn_in.oo_ ;
NEW.options_ = options_ ;

out = dyn_to_str(dyn_in) ;

NEW.mats.Q = out.mats.Q ;
NEW.mats.G = out.mats.G ;

NEW.str_mats.A0 = out.mats.A ;
NEW.str_mats.A1 = out.mats.B ;
NEW.str_mats.B0 = out.mats.D ;
NEW.str_mats.D0 = out.mats.E ;
NEW.str_mats.D2 = out.mats.D2 ;
NEW.str_mats.Gamma = out.mats.Gamma ;


%% ZLB regime

% Extract time settings
Ta = PARAMS.Ta;
Tstar = PARAMS.Tstar;
T = PARAMS.T;

NEW.pos_of_i = BASE.variable.r ; % Position of interest rate in mod file variable declaration
NEW.tr_row   = 22 ;   % Row (line number) of Taylor rule in mod file
NEW.zlb_val  = -M_.params(BASE.param_names.conster); % Value of ihat at ZLB

% Structural matrices at ZLB
NEW.mat_i_f_zlb = NEW.str_mats ;

NEW.mat_i_f_zlb.A0(NEW.tr_row,:) = 0 ;
NEW.mat_i_f_zlb.A1(NEW.tr_row,:) = 0 ;
NEW.mat_i_f_zlb.D0(NEW.tr_row,:) = 0 ;
NEW.mat_i_f_zlb.B0(NEW.tr_row,:) = 0 ;
NEW.mat_i_f_zlb.A0(NEW.tr_row,NEW.pos_of_i) = 1 ;
NEW.mat_i_f_zlb.A0(NEW.tr_row,end) = -NEW.zlb_val ; % Constant

NEW.mat_init    = NEW.str_mats ; % Structural matrices not at ZLB
NEW.mat_fin     = NEW.str_mats ; % Structural matrices after ZLB

% BASE.zlb.Qf          = BASE.mats.Q ;
% BASE.zlb.mat_init    = BASE.mat_init ;
NEW.zlb.mat_i_f_zlb = NEW.mat_i_f_zlb ;
A0Z = NEW.mat_i_f_zlb.A0;
A1Z = NEW.mat_i_f_zlb.A1;
B0Z = NEW.mat_i_f_zlb.B0;
D0Z = NEW.mat_i_f_zlb.D0;
AZ = A0Z\A1Z;
A0Zinv = inv(A0Z);
BZ = A0Z\B0Z;

% T = 50;
Tzs = 2;
Tze = T;

%Extract variable details from Dynare output
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
% n_ = n_+1 ;        % Constant

QZ = zeros(n_,n_,Tze-Tzs);
GZ = zeros(n_,l_,Tze-Tzs);

QZ(:,:,end) = (A0Z-B0Z*NEW.mats.Q)\A1Z;
GZ(:,:,end) = (A0Z-B0Z*NEW.mats.Q)\D0Z;

% Sequence of reduced form matrices
for t = Tze-Tzs-1:-1:1
    QZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\A1Z;
    GZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\D0Z;
end

%% Interest rate peg regime
if (Tstar - Ta)>0

    NEW.pos_of_pi = BASE.variable.pinf ; % Position of inflation rate in mod file variable declaration

    % Structural matrices in peg
    BASEp.mat_i_f_peg = BASE.str_mats;

    % Set phi_i = 0 as pegged
    BASEp.mat_i_f_peg.A0(NEW.tr_row,:) = 0 ;
    BASEp.mat_i_f_peg.A1(NEW.tr_row,:) = 0 ;
    BASEp.mat_i_f_peg.D0(NEW.tr_row,:) = 0 ;
    BASEp.mat_i_f_peg.B0(NEW.tr_row,:) = 0 ;
    BASEp.mat_i_f_peg.A0(NEW.tr_row,NEW.pos_of_i) = 1;
    BASEp.mat_i_f_peg.A0(NEW.tr_row, end) = 0;


    A0P = BASEp.mat_i_f_peg.A0;
    A1P = BASEp.mat_i_f_peg.A1;
    B0P = BASEp.mat_i_f_peg.B0;
    D0P = BASEp.mat_i_f_peg.D0;


    QP = zeros(n_,n_,Tstar-Ta);
    GP = zeros(n_,l_,Tstar-Ta);

    QP(:,:,end) = (A0P-B0P*NEW.mats.Q)\A1P;
    GP(:,:,end) = (A0P-B0P*NEW.mats.Q)\D0P;


    % Sequence of reduced form matrices

    for t = Tstar-Ta-1:-1:1
        QP(:,:,t) = (A0P-B0P*QP(:,:,t+1))\A1P;
        GP(:,:,t) = (A0P-B0P*QP(:,:,t+1))\D0P;
    end

end

y_non = zeros(n_,T);
y_non(:,1) = BASE.y_ss;

if Ta < Tstar

    % Allow for announcement date and implementation date to differ
    % Do backward induction
    Qat = zeros(n_,n_,Tstar-Ta);
    Gat = zeros(n_,l_,Tstar-Ta);


    % A0 y_t = A1 y_t-1 + B0 E_t y_t+1 + D0 eps_t

    % A = A1/A0
    % A = BASE.str_mats.A0\BASE.str_mats.A1;
    % A0inv = inv(BASE.str_mats.A0);
    % % B = B0/A0
    % B = BASE.str_mats.A0\BASE.str_mats.B0;
    D0 = BASE.str_mats.D0;
    A0 = BASE.str_mats.A0;
    A1 = BASE.str_mats.A1;
    B0 = BASE.str_mats.B0;
    % y_t = A y_t-1 + B E_t y_t+1 + D eps_t

    %     Qat(:,:,end) = (eye(n_)-B*NEW.mats.Q)\A;
    %     Gat(:,:,end) = (eye(n_)-B*NEW.mats.Q)\A0inv*D0;

    Qat(:,:,end) = (A0-B0*NEW.mats.Q)\A1;
    Gat(:,:,end) = (A0-B0*NEW.mats.Q)\D0;

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
        Qtilde(:,:,t) = (A0-B0*Qat(:,:,t))\A1;
    end



    Qt = zeros(n_,n_,T);
    Gt = zeros(n_,l_,T);

    for t = 1:Ta
        Qt(:,:,t) = BASE.mats.Q;
        Gt(:,:,t) = BASE.mats.G;
    end

    for t = Tstar:T
        Qt(:,:,t) = NEW.mats.Q;
        Gt(:,:,t) = NEW.mats.G;
    end

    % Allow for a pegged interest rate
    if i_peg == 1
        for t = Ta:Tstar-1
            Qt(:,:,t) = QP(:,:,t-Ta+1);
            Gt(:,:,t) = GP(:,:,t-Ta+1);
        end
    else
        for t = Ta:Tstar-1
            Qt(:,:,t) = Qat(:,:,t-Ta+1);
            Gt(:,:,t) = Gat(:,:,t-Ta+1);
            % Qt(:,:,t) = Qtilde(:,:,t-Ta+1);
            % Gt(:,:,t) = Gtilde(:,:,t-Ta+1);
        end
    end

    % for t = Ta:Tstar-1
    %     Qt(:,:,t) = Qtilde(:,:,t-Ta+1);
    %     Gt(:,:,t) = Gtilde(:,:,t-Ta+1);
    % end



    for t = 2:T
        y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
    end

    % Here is the place where all the problems are
    % z_index = size(QZ, 3);

    % for t = T:-1:Ta
    %     y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
    %     while y_non(BASE.variable.pi,t) < 0 && z_index > 0
    %         Qt(:,:,t) = QZ(:,:,z_index);
    %         Gt(:,:,t) = GZ(:,:,z_index);
    %         y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
    %         z_index = z_index - 1;
    %     end
    % end

else
    for t= 2:Ta-1
        y_non(:,t) = BASE.mats.Q*y_non(:,t-1);
    end

    for t= Tstar:T
        y_non(:,t) = NEW.mats.Q*y_non(:,t-1);
    end

end

%% Plot and SR
    SR = round(-sum(y_non(BASE.variable.y,:))/((base_inf-PARAMS.CPIE)*400),4);
    disp(['Sacrifice Ratio = ', num2str(SR)])

if Plot == 1 & Compare == 0
    Plot_range = 1:20;
    subplot(2,2,1)
    plot(y_non(BASE.variable.robs,Plot_range),'Color', '#024b79', 'LineWidth', 2.5)
    ylabel('Nominal rate/real rate')
    hold on
    plot(y_non(BASE.variable.rr,Plot_range),'Color', '#C2444E', 'LineStyle', '-.', 'LineWidth', 2)
    if model_name == "SW_SS_LTB"
        plot(y_non(BASE.variable.rn,Plot_range),'Color', '#2F4F4F', 'LineStyle', '-.', 'LineWidth', 2)
    end
    legend('interest rate', 'real rate', 'bond return')

    subplot(2,2,2)
    plot(y_non(BASE.variable.pinfobs,Plot_range),'Color', '#024b79', 'LineWidth', 2.5)
    ylabel('Inflation')
    hold on

    subplot(2,2,3)
    plot(y_non(BASE.variable.y,Plot_range),'Color', '#024b79', 'LineWidth', 2.5)
    ylabel('Output gap')
    hold on

    subplot(2,2,4)
    plot(y_non(BASE.variable.v,Plot_range),'Color', '#024b79', 'LineWidth', 2.5)
    ylabel('Government debt/surplus')
    hold on
    plot(y_non(BASE.variable.s,Plot_range),'Color', '#C2444E', 'LineStyle', '-.', 'LineWidth', 2)
    legend('Debt', 'Surplus')

    set(gcf, 'Position', [100, 100, 800, 600]);
end

if Plot == 1 & Compare == 1
    Plot_range = 1:20;
    
    % Blood Red
    % Plot_color = '#880808'; 

    % Bright Red
    % Plot_color = '#EE4B2B';

    % Burnt Sienna
    % Plot_color = '#E97451';


    % Astro Navy
    % Plot_color = '#002D62';

    % Air Force Blue
    % Plot_color = '#00308F';

    % Aero
    Plot_color = '#7CB9E8';

    subplot(2,2,1)
    plot(y_non(BASE.variable.robs,Plot_range),'Color', Plot_color, 'LineWidth', 2.5)
    ylabel('Nominal rate/real rate')
    hold on
    plot(y_non(BASE.variable.rr,Plot_range),'Color', Plot_color, 'LineStyle', '-.', 'LineWidth', 2)
    if model_name == "SW_SS_LTB"
        plot(y_non(BASE.variable.rn,Plot_range),'Color', Plot_color, 'LineStyle', '-.', 'LineWidth', 2)
    end


    subplot(2,2,2)
    plot(y_non(BASE.variable.pinfobs,Plot_range),'Color', Plot_color, 'LineWidth', 2.5)
    ylabel('Inflation')
    hold on

    subplot(2,2,3)
    plot(y_non(BASE.variable.y,Plot_range),'Color', Plot_color, 'LineWidth', 2.5)
    ylabel('Output gap')
    hold on

    subplot(2,2,4)
    plot(y_non(BASE.variable.v,Plot_range),'Color', Plot_color, 'LineWidth', 2.5)
    ylabel('Government debt/surplus')
    hold on
    plot(y_non(BASE.variable.s,Plot_range),'Color', Plot_color, 'LineStyle', '-.', 'LineWidth', 2)

    set(gcf, 'Position', [100, 100, 800, 600]);
end

