%% ZLB with change to inflation target

model_name = 'longterm_debt';

eval(['dynare ', model_name, '.mod noclearall nostrict']) ;

dyn_in.options_ = options_ ;

dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

SET.M_ = dyn_in.M_ ;
SET.oo_ = dyn_in.oo_ ;
SET.options_ = options_ ;

out = dyn_to_str(dyn_in) ;

SET.mats.Q = out.mats.Q ; Q = SET.mats.Q ;
SET.mats.G = out.mats.G ; G = SET.mats.G ;

SET.str_mats.A0 = out.mats.A ;
SET.str_mats.A1 = out.mats.B ;
SET.str_mats.B0 = out.mats.D ;
SET.str_mats.D0 = out.mats.E ;
SET.str_mats.D2 = out.mats.D2 ;
SET.str_mats.Gamma = out.mats.Gamma ;

%% Extract variable details from Dynare output

n_ = M_.endo_nbr ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
n_ = n_+1 ;        % Constant

SET.variable.n_ = n_ ; 
SET.variable.l_ = l_ ; 
SET.nparam      = M_.param_nbr ;

var_names   = cellstr(M_.endo_names) ;
param_names = cellstr(M_.param_names) ;
exo_var_names = cellstr(M_.exo_names) ;

for ii=1:n_-1
    eval(['SET.variable.',var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:l_
    eval(['SET.variable.shock.',exo_var_names{ii},'=',int2str(ii),';']) ;
end

for ii=1:M_.param_nbr
    eval(['SET.param_names.',param_names{ii},'=',int2str(ii),';']) ;
end

SET.y_ss = (eye(n_-1) - Q(1:n_-1,1:n_-1)) \ Q(1:n_-1,end)  ;
SET.y_ss = [SET.y_ss ; 1] ; % Constant


%% No ZLB Change in inflation target

M_.params(SET.param_names.pi_bar) = 0;
M_.params(SET.param_names.i_bar) = M_.params(SET.param_names.pi_bar)-log(beta);
M_.params(SET.param_names.phi_pi) = .5;1.25;
M_.params(SET.param_names.R) =1.5; 1/1.5;
[oo_.dr,info,M_,options_,oo_]  = resol(0,M_,options_,oo_) ;

dyn_in.options_ = options_ ;

dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

SET1.M_ = dyn_in.M_ ;
SET1.oo_ = dyn_in.oo_ ;
SET1.options_ = options_ ;

out = dyn_to_str(dyn_in) ;



SET1.mats.Q = out.mats.Q ; Q = SET1.mats.Q ;
SET1.mats.G = out.mats.G ; G = SET1.mats.G ;

SET1.str_mats.A0 = out.mats.A ;
SET1.str_mats.A1 = out.mats.B ;
SET1.str_mats.B0 = out.mats.D ;
SET1.str_mats.D0 = out.mats.E ;
SET1.str_mats.D2 = out.mats.D2 ;
SET1.str_mats.Gamma = out.mats.Gamma ;
%% ZLB regime

SET1.pos_of_i = SET.variable.i ; % Position of interest rate in mod file variable declaration
SET1.tr_row   = 3 ;   % Row (line number) of Taylor rule in mod file
SET1.zlb_val  = 0; % Value of ihat at ZLB

% Structural matrices at ZLB
SET1.mat_i_f_zlb = SET1.str_mats ;

SET1.mat_i_f_zlb.A0(SET1.tr_row,:) = 0 ;
SET1.mat_i_f_zlb.A1(SET1.tr_row,:) = 0 ;
SET1.mat_i_f_zlb.D0(SET1.tr_row,:) = 0 ;
SET1.mat_i_f_zlb.B0(SET1.tr_row,:) = 0 ;
SET1.mat_i_f_zlb.A0(SET1.tr_row,SET1.pos_of_i) = 1 ;
SET1.mat_i_f_zlb.A0(SET1.tr_row,end) = -SET1.zlb_val ; % Constant

SET1.mat_init    = SET1.str_mats ; % Structural matrices not at ZLB
SET1.mat_fin     = SET1.str_mats ; % Structural matrices after ZLB

% SET.zlb.Qf          = SET.mats.Q ; 
% SET.zlb.mat_init    = SET.mat_init ; 
SET1.zlb.mat_i_f_zlb = SET1.mat_i_f_zlb ;
A0 = SET1.mat_i_f_zlb.A0;
A1 = SET1.mat_i_f_zlb.A1;
B0 = SET1.mat_i_f_zlb.B0;
D0 = SET1.mat_i_f_zlb.D0;


%% Simulate FG

A = A0\A1;
A0inv = inv(A0);
B = A0\B0;

exps = [10,79];
ll = length(exps);

T_a = 4;
T_star =10;
T = 140;

Qat = zeros(n_,n_,T_star-T_a);
Gat = zeros(n_,l_,T_star-T_a);

Qat(:,:,end) = (A0-B0*SET1.mats.Q)\A1;
Gat(:,:,end) = SET1.mats.G;

% Sequence of reduced form matrices
for t = T_star-T_a-1:-1:1
    Qat(:,:,t) = (A0-B0*Qat(:,:,t+1))\A1;
    Gat(:,:,t) = (A0-B0*Qat(:,:,t+1))\D0;
end

Qt = zeros(n_,n_,T);
Gt = zeros(n_,l_,T);


for t = 1:T_a-1
    Qt(:,:,t) = SET.mats.Q;
    Gt(:,:,t) = SET.mats.G;
end

for t = T_a:T_star-1
    Qt(:,:,t) = Qat(:,:,t-T_a+1);
    Gt(:,:,t) = Gat(:,:,t-T_a+1);
end

%    Qt(:,:,T_star) = Qat(:,:,end);
%    Gt(:,:,T_star) = (A0 - B0*SET.mats.Q)\D0;

for t = T_star:T
    Qt(:,:,t) = SET1.mats.Q;
    Gt(:,:,t) = SET1.mats.G;
end


y_non = zeros(n_,T);
y_non(:,1) = SET.y_ss;

for t = 2:T
    y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
end

figure(1)
subplot(3,1,1)
plot(y_non(SET.variable.pi,:),'Linewidth',2)
hold on
ylabel('Inflation','FontName', 'Times New Roman','FontSize',24)
% xlabel('\Delta_p','FontName', 'Times New Roman')
subplot(3,1,2)
plot(y_non(SET.variable.x,:),'Linewidth',2)
hold on
ylabel('Output','FontName', 'Times New Roman','FontSize',24)
% xlabel('\Delta_p','FontName', 'Times New Roman')
subplot(3,1,3)
plot(y_non(SET.variable.i,:)*4,'Linewidth',2)
hold on
ylabel('Interest Rate','FontName', 'Times New Roman','FontSize',24)
% xlabel('\Delta_p','FontName', 'Times New Roman')
% axis([0 T 3.5 5])

