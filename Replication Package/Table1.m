%% Table 1 Disinflation under Simple NK
% Generate results in Table. 1
% for Dynare version 5.5
%% Initialization
clear all
% close all
% clc

addpath("_functions");
addpath('Figures');

%% Model Selection

% model_name = 'NK_SS_LTB';
model_name = 'NK_SS';

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);

%% Options
% Pegged regime
i_peg = 1;

% Plot
Plot = 1;

% Individual Plot
Ind_Plot = 0; % 1 for unpegged only; 2 and 3 for unpegged (2) + pegged (3)

%% Setting the Parameters
% Set inflation target
PARAMS.CPIE = 2/400;0.02;

% Announcement period
PARAMS.Ta = 4;

% Implementation period
PARAMS.Tstar = 6;

% Taylor rule parameter
PARAMS.CRPI = 0.5;

% Fiscal rule parameter
PARAMS.RR = 0;

% Fiscal response to inflation
PARAMS.CRPIS = 1.5;

% Length of Simulation
PARAMS.T = 100;


%% Generate Struct for Base model

% Resolve the model with speicified parameter
M_.params(find(strcmp(M_.param_names, 'phi_s'))) = PARAMS.CRPIS;
M_.params(find(strcmp(M_.param_names, 'phi_i'))) = PARAMS.CRPI;
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

base_inf = M_.params(BASE.param_names.pi_bar);

%% Generate Struct for New model

% Extra beta and put it in PARAMS
PARAMS.beta = M_.params(BASE.param_names.beta);
M_.params(BASE.param_names.pi_bar) = PARAMS.CPIE;
M_.params(BASE.param_names.i_bar) = M_.params(BASE.param_names.pi_bar)-log(PARAMS.beta);
M_.params(BASE.param_names.phi_i) = PARAMS.CRPI;
M_.params(BASE.param_names.R) = PARAMS.RR;
M_.params(BASE.param_names.phi_s) = PARAMS.CRPIS;

% Resolve the model after struct change
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


NEW.pos_of_i = BASE.variable.i ; % Position of interest rate in mod file variable declaration
NEW.tr_row   = 3 ;   % Row (line number) of Taylor rule in mod file
NEW.zlb_val  = 0 ; % Value of ihat at ZLB

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
% AZ = A0Z\A1Z;
% A0Zinv = inv(A0Z);
% BZ = A0Z\B0Z;

%T = 25;
Tzs = 2;
Tze = T;

%Extract variable details from Dynare output
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables + Constant
l_ = M_.exo_nbr ;  % Number of exogenous variables


QZ = zeros(n_,n_,Tze-Tzs);
GZ = zeros(n_,l_,Tze-Tzs);

QZ(:,:,end) = (A0Z-B0Z*NEW.mats.Q)\A1Z;
GZ(:,:,end) = (A0Z-B0Z*NEW.mats.Q)\D0Z;

% Sequence of reduced form matrices
for t = Tze-Tzs-1:-1:1
    warning('off', 'MATLAB:singularMatrix');
    warning('off', 'MATLAB:nearlySingularMatrix');
    QZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\A1Z;
    GZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\D0Z;
end

%% Interest rate peg regime

if (Tstar - Ta)>0

    NEW.pos_of_pi = BASE.variable.pi ; % Position of inflation rate in mod file variable declaration
    % NEW.tr_row   = 3 ;   % Row (line number) of Taylor rule in mod file

    % Structural matrices in peg
    BASEp.mat_i_f_peg = BASE.str_mats;

    % Set phi_i = 0 as pegged
    % BASEp.mat_i_f_peg.A0(NEW.tr_row,:) = 0 ;
    % BASEp.mat_i_f_peg.A1(NEW.tr_row,:) = 0 ;
    % BASEp.mat_i_f_peg.D0(NEW.tr_row,:) = 0 ;
    % BASEp.mat_i_f_peg.B0(NEW.tr_row,:) = 0 ;
    % BASEp.mat_i_f_peg.A0(NEW.tr_row,NEW.pos_of_i) = 1 ;

    BASEp.mat_i_f_peg.A0(NEW.tr_row, NEW.pos_of_pi) = 0 ;
    BASEp.mat_i_f_peg.A0(NEW.tr_row, end) = -BASE.M_.params(BASE.param_names.i_bar);


    A0P = BASEp.mat_i_f_peg.A0;
    A1P = BASEp.mat_i_f_peg.A1;
    B0P = BASEp.mat_i_f_peg.B0;
    D0P = BASEp.mat_i_f_peg.D0;
    % AP = A0P\A1P;
    % A0Pinv = inv(A0P);
    % BP = A0P\B0P;


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
%% Disinflation Simulation
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

SR = round(-sum(y_non(BASE.variable.x,:)*100)/((base_inf-PARAMS.CPIE)*400),4);
disp(' ')
disp(['Sacrifice Ratio = ', num2str(SR)])
% figure(2)
if Plot == 1
    Plot_range = 1:10;
    subplot(2,2,1)
    plot(y_non(BASE.variable.i,Plot_range),'Color', '#024b79', 'LineWidth', 2)
    ylabel('Nominal rate/real rate')
    hold on
    plot(y_non(BASE.variable.r,Plot_range),'Color', '#C2444E', 'LineStyle', '-.', 'LineWidth', 2)
    % plot(y_non(BASE.variable.r,Plot_range),'Color', 'r', 'LineStyle', '-.', 'LineWidth', 2)
    if model_name == "NK_SS_LTB"
        plot(y_non(BASE.variable.rn,Plot_range),'Color', 'k', 'LineStyle', '-.', 'LineWidth', 2)
    end
    legend('interest rate', 'real rate')

    subplot(2,2,2)
    plot(y_non(BASE.variable.pi,Plot_range),'Color', '#024b79', 'LineWidth', 2)
    % plot(y_non(BASE.variable.pi,Plot_range),'Color', 'b', 'LineWidth', 2)
    ylabel('Inflation')
    hold on

    subplot(2,2,3)
    plot(y_non(BASE.variable.x,Plot_range),'Color', '#024b79', 'LineWidth', 2)
    % plot(y_non(BASE.variable.x,Plot_range),'Color', 'b', 'LineWidth', 2)
    ylabel('Output gap')
    hold on

    subplot(2,2,4)
    plot(y_non(BASE.variable.v,Plot_range),'Color', '#024b79', 'LineWidth', 2)
    % plot(y_non(BASE.variable.v,Plot_range),'Color', 'b', 'LineWidth', 2)
    ylabel('Government debt/surplus')
    hold on
    plot(y_non(BASE.variable.s,Plot_range),'Color', '#C2444E', 'LineStyle', '-.', 'LineWidth', 2)
    legend('Debt', 'Surplus')

    set(gcf, 'Position', [100, 100, 800, 600]);
    % print('Figures\test.png', '-dpng')
end

%% Individual figures

% color_selection = char('b','r','k');
% select =3;


Plot_range = 1:10;

if Ind_Plot == 1

    real_rate_meaned = -log(beta) + y_non(BASE.variable.r,Plot_range);
    
    % Interest rates 
    figure1 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);
    
    % Create axes
    axes1 = axes('Parent',figure1);
    plot(y_non(BASE.variable.i,Plot_range)*400,'Color', '#024b79', 'LineWidth', 20)
    hold on;
    plot(real_rate_meaned(Plot_range)*400,'Color', '#C2444E', 'LineStyle', '-.','LineWidth', 20)
    plot([PARAMS.Ta PARAMS.Ta],[-5 12],'b--')
        plot([PARAMS.Tstar PARAMS.Tstar],[-5 12],'k--')
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    ylim([-2 12])
    ylabel('Interest rates')
    % xlabel('Quarter')
    legend('Policy rate','Real rate','Announcement','Implementation')
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',64);
    set(axes1,'position',[.075 .09 .9 .9])
    
    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_i.pdf','-dpdf','-fillpage')
    else 
        print('Figures\Figure_fp0_i.pdf','-dpdf','-fillpage')
        % print('Figures\Figure_fp15_i.pdf','-dpdf','-fillpage')
    end
    
    
    
    % Inflation
    figure2 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);
    
    % Create axes
    axes1 = axes('Parent',figure2);
    plot(y_non(BASE.variable.pi,Plot_range)*400,'Color', '#024b79', 'LineWidth', 20)
    hold on;
    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', '#C2444E', 'LineStyle', '-.','LineWidth',20)
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    plot([PARAMS.Ta PARAMS.Ta],[-2 10],'b--')
        plot([PARAMS.Tstar PARAMS.Tstar],[-2 10],'k--')
    ylabel('Inflation/Output Gap')
    % xlabel('Quarter')
    legend('Inflation','Output Gap')
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',64);
    set(axes1,'position',[.075 .09 .9 .9])

    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_pi.pdf','-dpdf','-fillpage')
    else 
        print('Figures\Figure_fp0_pi.pdf','-dpdf','-fillpage')
        % print('Figures\Figure_fp15_pi.pdf','-dpdf','-fillpage')
    end
    
    % Output gap
    figure3 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);

    % Create axes
    axes1 = axes('Parent',figure3);
    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', '#024b79', 'LineWidth',20)
    hold on;
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    ylabel('Output gap')
    xlabel('Quarter')
    ylim([-4,4])
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',56);
    set(axes1,'position',[.075 .09 .9 .9])

    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_x.pdf','-dpdf','-fillpage')
    else 
        print('Figures\Figure_fp0_x.pdf','-dpdf','-fillpage')
        % print('Figures\Figure_fp15_x.pdf','-dpdf','-fillpage')
    end
    
    
    % Debt and surplus
    figure4 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);
    
    % Create axes
    axes1 = axes('Parent',figure4);
    plot(y_non(BASE.variable.v,Plot_range)*100,'Color', '#024b79', 'LineWidth',20)
    hold on;
    plot(y_non(BASE.variable.s,Plot_range)*100,'Color', '#C2444E', 'LineStyle', '-.','LineWidth',20)
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    plot([PARAMS.Ta PARAMS.Ta],[-2 6],'b--')
    plot([PARAMS.Tstar PARAMS.Tstar],[-2 6],'k--')
    ylabel('Debt and Deficits')
    % xlabel('Quarter')
    legend('Debt','Surpluses')
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',64);
    set(axes1,'position',[.075 .09 .9 .9])
    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_v.pdf','-dpdf','-fillpage')
    else 
        print('Figures\Figure_fp0_v.pdf','-dpdf','-fillpage')
        % print('Figures\Figure_fp15_v.pdf','-dpdf','-fillpage')
    end

elseif Ind_Plot == 2
    real_rate_meaned = -log(beta) + y_non(BASE.variable.r,Plot_range);
    
    % Interest rates 
    figure1 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);
    
    % Create axes
    axes1 = axes('Parent',figure1);
    plot(y_non(BASE.variable.i,Plot_range)*400,'Color', [0.1 0.29 0.47 0.7], 'LineWidth', 20)
    hold on;
    plot(real_rate_meaned(Plot_range)*400,'Color', [0.76 0.27 0.31 0.7],'LineWidth', 20)
    plot([PARAMS.Ta PARAMS.Ta],[-5 12],'b--')
        plot([PARAMS.Tstar PARAMS.Tstar],[-5 12],'k--')
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    ylim([-2 12])
    ylabel('Interest rates')
    % xlabel('Quarter')
    legend('Policy rate','Real rate','Announcement','Implementation')
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',64);
    set(axes1,'position',[.075 .09 .9 .9])
   
    
    % Inflation
    figure2 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);
    
    % Create axes
    axes1 = axes('Parent',figure2);
    plot(y_non(BASE.variable.pi,Plot_range)*400,'Color', [0.1 0.29 0.47 0.7], 'LineWidth', 20)
    hold on;
    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', [0.76 0.27 0.31 0.7],'LineWidth',20)
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    plot([PARAMS.Ta PARAMS.Ta],[-4 10],'b--')
        plot([PARAMS.Tstar PARAMS.Tstar],[-4 10],'k--')
    ylabel('Inflation/Output Gap')
    % xlabel('Quarter')
    legend('Inflation','Output Gap')
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',64);
    set(axes1,'position',[.075 .09 .9 .9])

    
    % Output gap
    figure3 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);

    % Create axes
    axes1 = axes('Parent',figure3);
    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', [0.1 0.29 0.47 0.7], 'LineWidth',20)
    hold on;
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    ylabel('Output gap')
    xlabel('Quarter')
    ylim([-4,4])
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',56);
    set(axes1,'position',[.075 .09 .9 .9])


    % Debt and surplus
    figure4 = figure('PaperOrientation','landscape',...
        'PaperSize',[29.69999902 20.99999864],...
        'Color',[1 1 1]);
    
    % Create axes
    axes1 = axes('Parent',figure4);
    plot(y_non(BASE.variable.v,Plot_range)*100,'Color', [0.1 0.29 0.47 0.7], 'LineWidth',20)
    hold on;
    plot(y_non(BASE.variable.s,Plot_range)*100,'Color', [0.76 0.27 0.31 0.7],'LineWidth',20)
    plot(zeros(1,Plot_range(end)),'k','LineWidth',1)
    plot([PARAMS.Ta PARAMS.Ta],[-2 6],'b--')
    plot([PARAMS.Tstar PARAMS.Tstar],[-2 6],'k--')
    ylabel('Debt and Deficits')
    % xlabel('Quarter')
    legend('Debt','Surpluses')
    box(axes1,'off')
    set(axes1,'FontName','Times New Roman','FontSize',64);
    set(axes1,'position',[.075 .09 .9 .9])


elseif Ind_Plot == 3
    real_rate_meaned = -log(beta) + y_non(BASE.variable.r,Plot_range);
    
    % Interest rates 
    figure(figure1);
    hold on
    plot(y_non(BASE.variable.i,Plot_range)*400,'Color', [0.1 0.29 0.47 0.5], 'LineStyle', '-.', 'LineWidth', 20, 'HandleVisibility', 'off')
    hold on;
    plot(real_rate_meaned(Plot_range)*400,'Color', [0.76 0.27 0.31 0.5], 'LineStyle', '-.','LineWidth', 20, 'HandleVisibility', 'off')

    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_i_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 0
        print('Figures\Figure_fp0_i_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 1.5
        print('Figures\Figure_fp15_i_duo.pdf','-dpdf','-fillpage')
    end
   
    
    % Inflation
    figure(figure2)
    plot(y_non(BASE.variable.pi,Plot_range)*400,'Color', [0.1 0.29 0.47 0.5], 'LineStyle', '-.', 'LineWidth', 20, 'HandleVisibility', 'off')
    hold on;
    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', [0.76 0.27 0.31 0.5], 'LineStyle', '-.','LineWidth',20, 'HandleVisibility', 'off')
    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_pi_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 0
        print('Figures\Figure_fp0_pi_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 1.5
        print('Figures\Figure_fp15_pi_duo.pdf','-dpdf','-fillpage')
    end


    % Output gap
    figure(figure3)

    plot(y_non(BASE.variable.x,Plot_range)*100,'Color', [0.1 0.29 0.47 0.5], 'LineStyle', '-.', 'LineWidth',20, 'HandleVisibility', 'off')
    hold on;
    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_x_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 0
        print('Figures\Figure_fp0_x_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 1.5    
        print('Figures\Figure_fp15_x_duo.pdf','-dpdf','-fillpage')
    end
    
    % Debt and surplus
    figure(figure4)
    
    % Create axes
    plot(y_non(BASE.variable.v,Plot_range)*100,'Color', [0.1 0.29 0.47 0.5], 'LineStyle', '-.', 'LineWidth',20, 'HandleVisibility', 'off')
    hold on;
    plot(y_non(BASE.variable.s,Plot_range)*100,'Color', [0.76 0.27 0.31 0.5], 'LineStyle', '-.','LineWidth',20, 'HandleVisibility', 'off')

    if PARAMS.CRPI > 1
        print('Figures\Figure_mp_v_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 0
        print('Figures\Figure_fp0_v_duo.pdf','-dpdf','-fillpage')
    elseif PARAMS.CRPIS == 1.5 
        print('Figures\Figure_fp15_v_duo.pdf','-dpdf','-fillpage')
    end
end