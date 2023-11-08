function [sr_value_rounded, nominal_interest_rate, real_interest_rate, inflation, output_gap, debt, surplus,rn,price] = disinf2(model_name, options_,M_,oo_, CPIE, CRPI, RR, Ta, Tstar)
%AUTOPLOT_SIMPLE is the code for automatically plotting the IRFs for monetary and fiscal-led disinflation with a
%simple NK model. 
%  The code grabs model used in the Plot_Simple_IRF script and create a
%  baseline model with calibration in the dynare file and simulate a
%  disinflation with calibration specified in the input.

warning('off', 'MATLAB:singularMatrix');

eval(['dynare ', model_name, '.mod noclearall nostrict nolog']);


%(options_,M_,oo_)
base_model = create_struct(options_, M_, oo_);


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
M_.params(new_model.param_names.pi_bar) = CPIE;
M_.params(new_model.param_names.i_bar) = M_.params(new_model.param_names.pi_bar)-log(beta);
M_.params(new_model.param_names.phi_i) = CRPI;
M_.params(new_model.param_names.R) = RR;
% M_.params(new_model.param_names.alpha) = RR;

% For dyanre 4.5.6
[oo_.dr,~,M_,options_,oo_]  = resol(0,M_,options_,oo_) ;

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

y_ss = (eye(n_-1) - out.mats.Q(1:n_-1,1:n_-1)) \ out.mats.Q(1:n_-1,end)  ;
new_model.y_ss = [y_ss ; 1] ; % Constant

%% ZLB Regime

new_model.pos_of_i = base_model.variable.i ; % Position of interest rate in mod file variable declaration
new_model.tr_row   = 3 ;   % Row (line number) of Taylor rule in mod file
new_model.zlb_val  = 0 ; % Value of ihat at ZLB

% Structural matrices at ZLB
new_model.mat_i_f_zlb = new_model.str_mats ;

new_model.mat_i_f_zlb.A0(new_model.tr_row,:) = 0 ;
new_model.mat_i_f_zlb.A1(new_model.tr_row,:) = 0 ;
new_model.mat_i_f_zlb.D0(new_model.tr_row,:) = 0 ;
new_model.mat_i_f_zlb.B0(new_model.tr_row,:) = 0 ;
new_model.mat_i_f_zlb.A0(new_model.tr_row,new_model.pos_of_i) = 1 ;
new_model.mat_i_f_zlb.A0(new_model.tr_row,end) = -new_model.zlb_val ; % Constant

new_model.mat_init    = new_model.str_mats ; % Structural matrices not at ZLB
new_model.mat_fin     = new_model.str_mats ; % Structural matrices after ZLB

% SET.zlb.Qf          = SET.mats.Q ; 
% SET.zlb.mat_init    = SET.mat_init ; 
new_model.zlb.mat_i_f_zlb = new_model.mat_i_f_zlb ;
A0Z = new_model.mat_i_f_zlb.A0;
A1Z = new_model.mat_i_f_zlb.A1;
B0Z = new_model.mat_i_f_zlb.B0;
D0Z = new_model.mat_i_f_zlb.D0;
AZ = A0Z\A1Z;
A0Zinv = inv(A0Z);
BZ = A0Z\B0Z;

T = 25;
Tzs = 2;
Tze = T;

QZ = zeros(n_,n_,Tze-Tzs);
GZ = zeros(n_,l_,Tze-Tzs);

QZ(:,:,end) = (A0Z-B0Z*new_model.mats.Q)\A1Z;
GZ(:,:,end) = (A0Z-B0Z*new_model.mats.Q)\D0Z;

% Sequence of reduced form matrices
for t = Tze-Tzs-1:-1:1
    QZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\A1Z;
    GZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\D0Z;
end



%% Simulate an unanticipated disinflation 
% T = 50; %length of the simulation


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

Qt = zeros(n_,n_,T);
Gt = zeros(n_,l_,T);

for t = 1:Ta
    Qt(:,:,t) = base_model.mats.Q;
    Gt(:,:,t) = base_model.mats.G;
end

for t = Ta:Tstar-1
    Qt(:,:,t) = Qtilde(:,:,t-Ta+1);
    Gt(:,:,t) = Gtilde(:,:,t-Ta+1);
end

for t = Tstar:T
    Qt(:,:,t) = new_model.mats.Q;
    Gt(:,:,t) = new_model.mats.G;
end

for t = 2:T
    y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
end

z_index = size(QZ, 3);

for t = T:-1:2
    y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
    while y_non(base_model.variable.i,t) < 0 && z_index > 0
        Qt(:,:,t) = QZ(:,:,z_index);
        Gt(:,:,t) = GZ(:,:,z_index);
        y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
        z_index = z_index - 1;
    end
end


% Initial policy regime
% for t= 2:Ta-1
%     y_non(:,t) = base_model.mats.Q*y_non(:,t-1); 
% end
% 
% % for t = Ta:Tstar-1
% %    y_non(:,t) = Qat(:,:,t-Ta+1)*y_non(:,t-1);
% % end
% 
% for t = Ta:Tstar-1
%    y_non(:,t) =  Qtilde(:,:,t-Ta+1)*y_non(:,t-1);
% end
% 
% for t= Tstar:T
%     y_non(:,t) = new_model.mats.Q*y_non(:,t-1); 
% end

else
for t= 2:Ta-1
    y_non(:,t) = base_model.mats.Q*y_non(:,t-1); 
end


for t= Tstar:T
    y_non(:,t) = new_model.mats.Q*y_non(:,t-1); 
end
    
end

%% Sacrifice ratio

sacrifice_ratio = -sum(y_non(base_model.variable.x,:))/(0.08-CPIE);
sr_value_rounded = round(sacrifice_ratio, 4);

% Create the annotation with the text "SR = NUMBER"
% annotation_text = sprintf('SR = %.4f', sr_value_rounded);
% annotation_position = [0.345 0.3 0.3 0.1]; % [x, y, width, height] in normalized coordinates



nominal_interest_rate = y_non(base_model.variable.i,:);
real_interest_rate = y_non(base_model.variable.r,:);
inflation = y_non(base_model.variable.pi,:);
output_gap = y_non(base_model.variable.x,:);
debt = y_non(base_model.variable.v,:);
surplus = y_non(base_model.variable.s,:);
rn = y_non(base_model.variable.rn,:);
price = y_non(base_model.variable.q,:);



end

