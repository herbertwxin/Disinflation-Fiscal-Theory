function [y_non, SET] = disinflation(T,options_,M_,oo_,CPIE,CRPI,RR,Ta,Tstar)
% DISINFLATION is a function that utilizes the Kulish-Pagan method to
% compute the structural change with Smets&Wouters (2007) model under both fiscal and monetary-led regime.
%   The function takes in the length of simulation T, output from DYNARE
%   [options_,M_,oo_], new regime sepcfication [CPIE,CRPI,RR], time of
%   announcement Ta and time of implementation Tstar.
%   Author: Christopher Gibbs
%   Modified by Wei Xin

[oo_.dr,info,M_,options_,oo_]  = resol(0,M_,options_,oo_) ;

% dyn_to_str input struct
dyn_in.options_ = options_ ;
dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

% Struct for KP process
SET.M_ = dyn_in.M_ ;
SET.oo_ = dyn_in.oo_ ;
SET.options_ = options_ ;

% Output from dyn_to_str
out = dyn_to_str(dyn_in) ;

SET.mats.Q = out.mats.Q ; 
Q = SET.mats.Q ;
SET.mats.G = out.mats.G ; 
G = SET.mats.G ;

SET.str_mats.A0 = out.mats.A ;
SET.str_mats.A1 = out.mats.B ;
SET.str_mats.B0 = out.mats.D ;
SET.str_mats.D0 = out.mats.E ;
SET.str_mats.D2 = out.mats.D2 ;
SET.str_mats.Gamma = out.mats.Gamma ;

%Extract variable details from Dynare output
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
% n_ = n_+1 ;        % Constant

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
cpie = CPIE;
cr=cpie/(M_.params(SET.param_names.cbeta)*M_.params(SET.param_names.cgamma)^(-M_.params(SET.param_names.csigma)));

M_.params(SET.param_names.cpie) = cpie;
M_.params(SET.param_names.cr) = cr;
M_.params(SET.param_names.conster) = (cr-1)*100;
M_.params(SET.param_names.constepinf) = (cpie-1)*100;
M_.params(SET.param_names.crpi) = CRPI; 2.0443;
M_.params(SET.param_names.R) = RR; 0.5;

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
SET1.pos_of_i = SET.variable.r ; % Position of interest rate in mod file variable declaration
SET1.tr_row   = 22 ;   % Row (line number) of Taylor rule in mod file
SET1.zlb_val  = -M_.params(SET.param_names.conster); % Value of ihat at ZLB

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
A0Z = SET1.mat_i_f_zlb.A0;
A1Z = SET1.mat_i_f_zlb.A1;
B0Z = SET1.mat_i_f_zlb.B0;
D0Z = SET1.mat_i_f_zlb.D0;
AZ = A0Z\A1Z;
A0Zinv = inv(A0Z);
BZ = A0Z\B0Z;

% T = 50;
Tzs = 2;
Tze = T;


QZ = zeros(n_,n_,Tze-Tzs);
GZ = zeros(n_,l_,Tze-Tzs);

QZ(:,:,end) = (A0Z-B0Z*SET1.mats.Q)\A1Z;
GZ(:,:,end) = (A0Z-B0Z*SET1.mats.Q)\D0Z;

% Sequence of reduced form matrices
for t = Tze-Tzs-1:-1:1
    QZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\A1Z;
    GZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\D0Z;
end

%Disinflation Simulation
% T = 50; %length of the simulation
%Ta = 4; %Date of the announcement
%Tstar = 6; %Date of the disinflation policy implementation

y_non = zeros(n_,T);
y_non(:,1) = SET.y_ss;

if Ta<Tstar

% Allow for announcement date and implementation date to differ
% Do backward induction
Qat = zeros(n_,n_,Tstar-Ta);
Gat = zeros(n_,l_,Tstar-Ta);


% A0 y_t = A1 y_t-1 + B0 E_t y_t+1 + D0 eps_t 

% A = A1/A0
% A = SET.str_mats.A0\SET.str_mats.A1;
% A0inv = inv(SET.str_mats.A0);
% % B = B0/A0
% B = SET.str_mats.A0\SET.str_mats.B0;
D0 = SET.str_mats.D0;
A0 = SET.str_mats.A0;
A1 = SET.str_mats.A1;
B0 = SET.str_mats.B0;
% y_t = A y_t-1 + B E_t y_t+1 + D eps_t

%     Qat(:,:,end) = (eye(n_)-B*SET1.mats.Q)\A;
%     Gat(:,:,end) = (eye(n_)-B*SET1.mats.Q)\A0inv*D0;

Qat(:,:,end) = (A0-B0*SET1.mats.Q)\A1;
Gat(:,:,end) = (A0-B0*SET1.mats.Q)\D0;

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
    Qt(:,:,t) = SET.mats.Q;
    Gt(:,:,t) = SET.mats.G;
end

for t = Ta:Tstar-1
    Qt(:,:,t) = Qtilde(:,:,t-Ta+1);
    Gt(:,:,t) = Gtilde(:,:,t-Ta+1);
end

for t = Tstar:T
    Qt(:,:,t) = SET1.mats.Q;
    Gt(:,:,t) = SET1.mats.G;
end

for t = 2:T
    y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
end

z_index = size(QZ, 3);

for t = T:-1:2
    y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
    while y_non(SET.variable.robs,t) < 0 && z_index > 0
        Qt(:,:,t) = QZ(:,:,z_index);
        Gt(:,:,t) = GZ(:,:,z_index);
        y_non(:,t) = Qt(:,:,t) * y_non(:,t-1);
        z_index = z_index - 1;
    end
end

else
for t= 2:Ta-1
    y_non(:,t) = SET.mats.Q*y_non(:,t-1); 
end

for t= Tstar:T
    y_non(:,t) = SET1.mats.Q*y_non(:,t-1); 
end

end

end

