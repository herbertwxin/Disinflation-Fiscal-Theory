function [QZ,GZ] = zlb_regime(T)
%ZLB_REGIME Summary of this function goes here
%   Detailed explanation goes here
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

return QZ,GZ;
end

