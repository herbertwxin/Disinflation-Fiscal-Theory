function [y_non] = disinf(PARAMS, BASE, options_, M_, oo_)
%DISINF Extract Dynare output and apply the Kulish-Pagan method to simulate
%disinflation
%   The first section resolves the model with specified parameters
%   The second section calculates the terminal regime
%   ZLB code is disabled as it casuses issues
%   The last section simulates the disinflation

warning('off', 'MATLAB:singularMatrix');
warning('off', 'MATLAB:nearlySingularMatrix');
%% Generate Struct for New model
% Pre policy posterior draw
M_.params(BASE.param_names.cpie) = BASE.M_.params(BASE.param_names.cpie);
M_.params(BASE.param_names.cr) = BASE.M_.params(BASE.param_names.cr);
M_.params(BASE.param_names.conster) = BASE.M_.params(BASE.param_names.conster);
M_.params(BASE.param_names.constepinf) = BASE.M_.params(BASE.param_names.constepinf);
M_.params(BASE.param_names.crpi) = BASE.M_.params(BASE.param_names.crpi);

% Resolve the system with the above variables kept unchanged
[oo_.dr,info,M_,oo_]  = resol(0,M_,options_,oo_) ;

dyn_in.options_ = options_ ;

dyn_in.M_  = M_ ;
dyn_in.oo_ = oo_ ;
dyn_in.solve = 1 ;
dyn_in.linearize_around_diff_y = 0 ;

BASEp.M_ = dyn_in.M_ ;
BASEp.oo_ = dyn_in.oo_ ;
BASEp.options_ = options_ ;

out = dyn_to_str(dyn_in) ;

BASEp.str_mats.A0 = out.mats.A ;
BASEp.str_mats.A1 = out.mats.B ;
BASEp.str_mats.B0 = out.mats.D ;
BASEp.str_mats.D0 = out.mats.E ;
BASEp.str_mats.D2 = out.mats.D2 ;
BASEp.str_mats.Gamma = out.mats.Gamma ;

% No peg case
D0 = BASEp.str_mats.D0;
A0 = BASEp.str_mats.A0;
A1 = BASEp.str_mats.A1;
B0 = BASEp.str_mats.B0;

% Peg regime
NEW.pos_of_i = BASE.variable.r ; % Position of interest rate in mod file variable declaration
NEW.tr_row   = 22 ;   % Row (line number) of Taylor rule in mod file
NEW.pos_of_pi = BASE.variable.pinf ; % Position of inflation rate in mod file variable declaration

% Structural matrices in peg
BASEp.mat_i_f_peg = BASEp.str_mats;

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


% BASE.param_crosswalk = estim_params_.param_vals(:,1);

%% Resolve with new inflation regime
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
% 
% % Extract time settings
Ta = PARAMS.Ta;
Tstar = PARAMS.Tstar;
T = PARAMS.T;
% 
% NEW.pos_of_i = BASE.variable.r ; % Position of interest rate in mod file variable declaration
% NEW.tr_row   = 22 ;   % Row (line number) of Taylor rule in mod file
% NEW.zlb_val  = -M_.params(BASE.param_names.conster); % Value of ihat at ZLB
% 
% % Structural matrices at ZLB
% NEW.mat_i_f_zlb = NEW.str_mats ;
% 
% NEW.mat_i_f_zlb.A0(NEW.tr_row,:) = 0 ;
% NEW.mat_i_f_zlb.A1(NEW.tr_row,:) = 0 ;
% NEW.mat_i_f_zlb.D0(NEW.tr_row,:) = 0 ;
% NEW.mat_i_f_zlb.B0(NEW.tr_row,:) = 0 ;
% NEW.mat_i_f_zlb.A0(NEW.tr_row,NEW.pos_of_i) = 1 ;
% NEW.mat_i_f_zlb.A0(NEW.tr_row,end) = -NEW.zlb_val ; % Constant
% 
% NEW.mat_init    = NEW.str_mats ; % Structural matrices not at ZLB
% NEW.mat_fin     = NEW.str_mats ; % Structural matrices after ZLB
% 
% % BASE.zlb.Qf          = BASE.mats.Q ; 
% % BASE.zlb.mat_init    = BASE.mat_init ; 
% NEW.zlb.mat_i_f_zlb = NEW.mat_i_f_zlb ;
% A0Z = NEW.mat_i_f_zlb.A0;
% A1Z = NEW.mat_i_f_zlb.A1;
% B0Z = NEW.mat_i_f_zlb.B0;
% D0Z = NEW.mat_i_f_zlb.D0;
% AZ = A0Z\A1Z;
% A0Zinv = inv(A0Z);
% BZ = A0Z\B0Z;
% 
% % T = 50;
% Tzs = 2;
% Tze = T;
% 
% %Extract variable details from Dynare output
n_ = M_.endo_nbr + 1 ; % Number of endogenous variables
l_ = M_.exo_nbr ;  % Number of exogenous variables
% % n_ = n_+1 ;        % Constant
% 
% QZ = zeros(n_,n_,Tze-Tzs);
% GZ = zeros(n_,l_,Tze-Tzs);
% 
% QZ(:,:,end) = (A0Z-B0Z*NEW.mats.Q)\A1Z;
% GZ(:,:,end) = (A0Z-B0Z*NEW.mats.Q)\D0Z;
% 
% % Sequence of reduced form matrices
% for t = Tze-Tzs-1:-1:1
%     QZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\A1Z;
%     GZ(:,:,t) = (A0Z-B0Z*QZ(:,:,t+1))\D0Z;
% end

%% Interest rate peg regime
if (Tstar - Ta)>0

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


    Qat(:,:,end) = (A0-B0*NEW.mats.Q)\A1;
    Gat(:,:,end) = (A0-B0*NEW.mats.Q)\D0;


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
    if PARAMS.i_peg == 1
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

end

