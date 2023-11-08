function [residual, g1, g2, g3] = SW_LTB_RR_dynamic(y, x, params, steady_state, it_)
%
% Status : Computes dynamic model for Dynare
%
% Inputs :
%   y         [#dynamic variables by 1] double    vector of endogenous variables in the order stored
%                                                 in M_.lead_lag_incidence; see the Manual
%   x         [nperiods by M_.exo_nbr] double     matrix of exogenous variables (in declaration order)
%                                                 for all simulation periods
%   steady_state  [M_.endo_nbr by 1] double       vector of steady state values
%   params    [M_.param_nbr by 1] double          vector of parameter values in declaration order
%   it_       scalar double                       time period for exogenous variables for which to evaluate the model
%
% Outputs:
%   residual  [M_.endo_nbr by 1] double    vector of residuals of the dynamic model equations in order of 
%                                          declaration of the equations.
%                                          Dynare may prepend auxiliary equations, see M_.aux_vars
%   g1        [M_.endo_nbr by #dynamic variables] double    Jacobian matrix of the dynamic model equations;
%                                                           rows: equations in order of declaration
%                                                           columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g2        [M_.endo_nbr by (#dynamic variables)^2] double   Hessian matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%   g3        [M_.endo_nbr by (#dynamic variables)^3] double   Third order derivative matrix of the dynamic model equations;
%                                                              rows: equations in order of declaration
%                                                              columns: variables in order stored in M_.lead_lag_incidence followed by the ones in M_.exo_names
%
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

%
% Model equations
%

residual = zeros(45, 1);
T21 = 1/(params(10)/(1-params(10)));
T37 = 1/(1+params(44)*params(42));
T42 = params(42)^2;
T44 = T42*params(12);
T57 = params(15)/params(42);
T62 = (1-T57)/(params(14)*(1+T57));
T74 = (1-params(13))/(params(47)+1-params(13));
T90 = (params(14)-1)*params(56)/(params(14)*(1+T57));
T120 = 1/(1-T57);
T123 = T57/(1-T57);
T215 = 1/(1+params(44)*params(42)*params(21));
T231 = (1-params(22))*(1-params(44)*params(42)*params(22))/params(22)/(1+(params(18)-1)*params(3));
T240 = params(44)*params(42)/(1+params(44)*params(42));
T268 = (1-params(20))*(1-params(44)*params(42)*params(20))/((1+params(44)*params(42))*params(20))*1/(1+(params(24)-1)*params(1));
lhs =y(55);
rhs =params(9)*y(34)+(1-params(9))*y(41);
residual(1)= lhs-rhs;
lhs =y(33);
rhs =y(34)*T21;
residual(2)= lhs-rhs;
lhs =y(34);
rhs =y(41)+y(40)-y(35);
residual(3)= lhs-rhs;
lhs =y(35);
rhs =y(33)+y(19);
residual(4)= lhs-rhs;
lhs =y(38);
rhs =T37*(y(4)+params(44)*params(42)*y(73)+1/T44*y(36))+y(58);
residual(5)= lhs-rhs;
lhs =y(36);
rhs =(-y(42))+y(56)*1/T62+params(47)/(params(47)+1-params(13))*y(70)+T74*y(71);
residual(6)= lhs-rhs;
lhs =y(37);
rhs =y(56)+T57/(1+T57)*y(3)+1/(1+T57)*y(72)+T90*(y(40)-y(74))-y(42)*T62;
residual(7)= lhs-rhs;
lhs =y(39);
rhs =y(37)*params(54)+y(38)*params(53)+y(57)+y(33)*params(55);
residual(8)= lhs-rhs;
lhs =y(39);
rhs =params(18)*(y(55)+params(9)*y(35)+(1-params(9))*y(40));
residual(9)= lhs-rhs;
lhs =y(41);
rhs =y(40)*params(23)+y(37)*T120-y(3)*T123;
residual(10)= lhs-rhs;
lhs =y(62);
rhs =y(19)*(1-params(49))+y(38)*params(49)+y(58)*T44*params(49);
residual(11)= lhs-rhs;
lhs =y(43);
rhs =params(9)*y(45)+(1-params(9))*y(53)-y(55);
residual(12)= lhs-rhs;
lhs =y(44);
rhs =T21*y(45);
residual(13)= lhs-rhs;
lhs =y(45);
rhs =y(53)+y(51)-y(46);
residual(14)= lhs-rhs;
lhs =y(46);
rhs =y(44)+y(20);
residual(15)= lhs-rhs;
lhs =y(49);
rhs =y(58)+T37*(y(7)+params(44)*params(42)*y(78)+1/T44*y(47));
residual(16)= lhs-rhs;
lhs =y(47);
rhs =y(56)*1/T62+(-y(54))+y(80)-params(5)+params(47)/(params(47)+1-params(13))*y(75)+T74*y(76);
residual(17)= lhs-rhs;
lhs =y(48);
rhs =y(56)+T57/(1+T57)*y(6)+1/(1+T57)*y(77)+T90*(y(51)-y(79))-T62*(y(54)-(y(80)-params(5)));
residual(18)= lhs-rhs;
lhs =y(50);
rhs =y(57)+params(54)*y(48)+params(53)*y(49)+params(55)*y(44);
residual(19)= lhs-rhs;
lhs =y(50);
rhs =params(18)*(y(55)+params(9)*y(46)+(1-params(9))*y(51));
residual(20)= lhs-rhs;
lhs =y(52)-params(5);
rhs =T215*(params(44)*params(42)*(y(80)-params(5))+params(21)*(y(9)-params(5))+y(43)*T231)+y(60);
residual(21)= lhs-rhs;
lhs =y(53);
rhs =T37*y(10)+T240*y(81)+(y(9)-params(5))*params(19)/(1+params(44)*params(42))-(y(52)-params(5))*(1+params(44)*params(42)*params(19))/(1+params(44)*params(42))+(y(80)-params(5))*T240+T268*(params(23)*y(51)+T120*y(48)-T123*y(6)-y(53))+y(61);
residual(22)= lhs-rhs;
lhs =y(54);
rhs =(y(52)-params(5))*params(26)*(1-params(29))+(1-params(29))*params(28)*(y(50)-y(39))+params(27)*(y(50)-y(39)-y(8)+y(5))+params(29)*y(11)+y(59);
residual(23)= lhs-rhs;
lhs =y(55);
rhs =params(30)*y(12)+x(it_, 1);
residual(24)= lhs-rhs;
lhs =y(56);
rhs =params(32)*y(13)+x(it_, 2);
residual(25)= lhs-rhs;
lhs =y(57);
rhs =params(33)*y(14)+x(it_, 3)+x(it_, 1)*params(2);
residual(26)= lhs-rhs;
lhs =y(58);
rhs =params(35)*y(15)+x(it_, 4);
residual(27)= lhs-rhs;
lhs =y(59);
rhs =params(36)*y(16)+x(it_, 5);
residual(28)= lhs-rhs;
lhs =y(60);
rhs =params(37)*y(17)+y(32)-params(8)*y(2);
residual(29)= lhs-rhs;
lhs =y(32);
rhs =x(it_, 6);
residual(30)= lhs-rhs;
lhs =y(61);
rhs =params(38)*y(18)+y(31)-params(7)*y(1);
residual(31)= lhs-rhs;
lhs =y(31);
rhs =x(it_, 7);
residual(32)= lhs-rhs;
lhs =y(63);
rhs =(1-params(49))*y(20)+params(49)*y(49)+y(58)*params(12)*T42*params(49);
residual(33)= lhs-rhs;
lhs =y(64);
rhs =params(58)*(y(57)+y(21)+y(65)-params(40)-(y(52)-params(5))-y(67));
residual(34)= lhs-rhs;
lhs =y(82);
rhs =y(25);
residual(35)= lhs-rhs;
lhs =y(65)-params(40);
rhs =params(59)*y(66)-y(22);
residual(36)= lhs-rhs;
lhs =y(67);
rhs =0.85*y(23)+x(it_, 8);
residual(37)= lhs-rhs;
lhs =y(27);
rhs =y(50)-y(8)+params(39);
residual(38)= lhs-rhs;
lhs =y(28);
rhs =params(39)+y(48)-y(6);
residual(39)= lhs-rhs;
lhs =y(29);
rhs =params(39)+y(49)-y(7);
residual(40)= lhs-rhs;
lhs =y(30);
rhs =params(39)+y(53)-y(10);
residual(41)= lhs-rhs;
lhs =y(26);
rhs =y(52);
residual(42)= lhs-rhs;
lhs =y(25);
rhs =y(54)+params(40);
residual(43)= lhs-rhs;
lhs =y(24);
rhs =y(51)+params(4);
residual(44)= lhs-rhs;
lhs =y(68);
rhs =y(69)-y(25);
residual(45)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(45, 90);

  %
  % Jacobian matrix
  %

  g1(1,34)=(-params(9));
  g1(1,41)=(-(1-params(9)));
  g1(1,55)=1;
  g1(2,33)=1;
  g1(2,34)=(-T21);
  g1(3,34)=1;
  g1(3,35)=1;
  g1(3,40)=(-1);
  g1(3,41)=(-1);
  g1(4,33)=(-1);
  g1(4,35)=1;
  g1(4,19)=(-1);
  g1(5,36)=(-(T37*1/T44));
  g1(5,4)=(-T37);
  g1(5,38)=1;
  g1(5,73)=(-(params(44)*params(42)*T37));
  g1(5,58)=(-1);
  g1(6,70)=(-(params(47)/(params(47)+1-params(13))));
  g1(6,36)=1;
  g1(6,71)=(-T74);
  g1(6,42)=1;
  g1(6,56)=(-(1/T62));
  g1(7,3)=(-(T57/(1+T57)));
  g1(7,37)=1;
  g1(7,72)=(-(1/(1+T57)));
  g1(7,40)=(-T90);
  g1(7,74)=T90;
  g1(7,42)=T62;
  g1(7,56)=(-1);
  g1(8,33)=(-params(55));
  g1(8,37)=(-params(54));
  g1(8,38)=(-params(53));
  g1(8,39)=1;
  g1(8,57)=(-1);
  g1(9,35)=(-(params(9)*params(18)));
  g1(9,39)=1;
  g1(9,40)=(-((1-params(9))*params(18)));
  g1(9,55)=(-params(18));
  g1(10,3)=T123;
  g1(10,37)=(-T120);
  g1(10,40)=(-params(23));
  g1(10,41)=1;
  g1(11,38)=(-params(49));
  g1(11,58)=(-(T44*params(49)));
  g1(11,19)=(-(1-params(49)));
  g1(11,62)=1;
  g1(12,43)=1;
  g1(12,45)=(-params(9));
  g1(12,53)=(-(1-params(9)));
  g1(12,55)=1;
  g1(13,44)=1;
  g1(13,45)=(-T21);
  g1(14,45)=1;
  g1(14,46)=1;
  g1(14,51)=(-1);
  g1(14,53)=(-1);
  g1(15,44)=(-1);
  g1(15,46)=1;
  g1(15,20)=(-1);
  g1(16,47)=(-(T37*1/T44));
  g1(16,7)=(-T37);
  g1(16,49)=1;
  g1(16,78)=(-(params(44)*params(42)*T37));
  g1(16,58)=(-1);
  g1(17,75)=(-(params(47)/(params(47)+1-params(13))));
  g1(17,47)=1;
  g1(17,76)=(-T74);
  g1(17,80)=(-1);
  g1(17,54)=1;
  g1(17,56)=(-(1/T62));
  g1(18,6)=(-(T57/(1+T57)));
  g1(18,48)=1;
  g1(18,77)=(-(1/(1+T57)));
  g1(18,51)=(-T90);
  g1(18,79)=T90;
  g1(18,80)=(-T62);
  g1(18,54)=T62;
  g1(18,56)=(-1);
  g1(19,44)=(-params(55));
  g1(19,48)=(-params(54));
  g1(19,49)=(-params(53));
  g1(19,50)=1;
  g1(19,57)=(-1);
  g1(20,46)=(-(params(9)*params(18)));
  g1(20,50)=1;
  g1(20,51)=(-((1-params(9))*params(18)));
  g1(20,55)=(-params(18));
  g1(21,43)=(-(T215*T231));
  g1(21,9)=(-(params(21)*T215));
  g1(21,52)=1;
  g1(21,80)=(-(params(44)*params(42)*T215));
  g1(21,60)=(-1);
  g1(22,6)=(-(T268*(-T123)));
  g1(22,48)=(-(T120*T268));
  g1(22,51)=(-(params(23)*T268));
  g1(22,9)=(-(params(19)/(1+params(44)*params(42))));
  g1(22,52)=(1+params(44)*params(42)*params(19))/(1+params(44)*params(42));
  g1(22,80)=(-T240);
  g1(22,10)=(-T37);
  g1(22,53)=1-(-T268);
  g1(22,81)=(-T240);
  g1(22,61)=(-1);
  g1(23,5)=(-params(27));
  g1(23,39)=(-((-((1-params(29))*params(28)))-params(27)));
  g1(23,8)=params(27);
  g1(23,50)=(-((1-params(29))*params(28)+params(27)));
  g1(23,52)=(-(params(26)*(1-params(29))));
  g1(23,11)=(-params(29));
  g1(23,54)=1;
  g1(23,59)=(-1);
  g1(24,12)=(-params(30));
  g1(24,55)=1;
  g1(24,83)=(-1);
  g1(25,13)=(-params(32));
  g1(25,56)=1;
  g1(25,84)=(-1);
  g1(26,14)=(-params(33));
  g1(26,57)=1;
  g1(26,83)=(-params(2));
  g1(26,85)=(-1);
  g1(27,15)=(-params(35));
  g1(27,58)=1;
  g1(27,86)=(-1);
  g1(28,16)=(-params(36));
  g1(28,59)=1;
  g1(28,87)=(-1);
  g1(29,2)=params(8);
  g1(29,32)=(-1);
  g1(29,17)=(-params(37));
  g1(29,60)=1;
  g1(30,32)=1;
  g1(30,88)=(-1);
  g1(31,1)=params(7);
  g1(31,31)=(-1);
  g1(31,18)=(-params(38));
  g1(31,61)=1;
  g1(32,31)=1;
  g1(32,89)=(-1);
  g1(33,49)=(-params(49));
  g1(33,58)=(-(params(12)*T42*params(49)));
  g1(33,20)=(-(1-params(49)));
  g1(33,63)=1;
  g1(34,52)=params(58);
  g1(34,57)=(-params(58));
  g1(34,21)=(-params(58));
  g1(34,64)=1;
  g1(34,65)=(-params(58));
  g1(34,67)=params(58);
  g1(35,25)=(-1);
  g1(35,82)=1;
  g1(36,65)=1;
  g1(36,22)=1;
  g1(36,66)=(-params(59));
  g1(37,23)=(-0.85);
  g1(37,67)=1;
  g1(37,90)=(-1);
  g1(38,27)=1;
  g1(38,8)=1;
  g1(38,50)=(-1);
  g1(39,28)=1;
  g1(39,6)=1;
  g1(39,48)=(-1);
  g1(40,29)=1;
  g1(40,7)=1;
  g1(40,49)=(-1);
  g1(41,30)=1;
  g1(41,10)=1;
  g1(41,53)=(-1);
  g1(42,26)=1;
  g1(42,52)=(-1);
  g1(43,25)=1;
  g1(43,54)=(-1);
  g1(44,24)=1;
  g1(44,51)=(-1);
  g1(45,25)=1;
  g1(45,69)=(-1);
  g1(45,68)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],45,8100);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],45,729000);
end
end
end
end
