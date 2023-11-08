function [residual, g1, g2, g3] = SW_SS_LTB_dynamic(y, x, params, steady_state, it_)
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
T371 = params(11)^(-1);
lhs =y(54);
rhs =params(9)*y(33)+(1-params(9))*y(40);
residual(1)= lhs-rhs;
lhs =y(32);
rhs =y(33)*T21;
residual(2)= lhs-rhs;
lhs =y(33);
rhs =y(40)+y(39)-y(34);
residual(3)= lhs-rhs;
lhs =y(34);
rhs =y(32)+y(19);
residual(4)= lhs-rhs;
lhs =y(37);
rhs =T37*(y(4)+params(44)*params(42)*y(72)+1/T44*y(35))+y(57);
residual(5)= lhs-rhs;
lhs =y(35);
rhs =(-y(41))+y(55)*1/T62+params(47)/(params(47)+1-params(13))*y(69)+T74*y(70);
residual(6)= lhs-rhs;
lhs =y(36);
rhs =y(55)+T57/(1+T57)*y(3)+1/(1+T57)*y(71)+T90*(y(39)-y(73))-y(41)*T62;
residual(7)= lhs-rhs;
lhs =y(38);
rhs =y(36)*params(54)+y(37)*params(53)+y(56)+y(32)*params(55);
residual(8)= lhs-rhs;
lhs =y(38);
rhs =params(18)*(y(54)+params(9)*y(34)+(1-params(9))*y(39));
residual(9)= lhs-rhs;
lhs =y(40);
rhs =y(39)*params(23)+y(36)*T120-y(3)*T123;
residual(10)= lhs-rhs;
lhs =y(61);
rhs =y(19)*(1-params(49))+y(37)*params(49)+y(57)*T44*params(49);
residual(11)= lhs-rhs;
lhs =y(42);
rhs =params(9)*y(44)+(1-params(9))*y(52)-y(54);
residual(12)= lhs-rhs;
lhs =y(43);
rhs =T21*y(44);
residual(13)= lhs-rhs;
lhs =y(44);
rhs =y(52)+y(50)-y(45);
residual(14)= lhs-rhs;
lhs =y(45);
rhs =y(43)+y(20);
residual(15)= lhs-rhs;
lhs =y(48);
rhs =y(57)+T37*(y(7)+params(44)*params(42)*y(77)+1/T44*y(46));
residual(16)= lhs-rhs;
lhs =y(46);
rhs =y(55)*1/T62+(-y(53))+y(79)-params(5)+params(47)/(params(47)+1-params(13))*y(74)+T74*y(75);
residual(17)= lhs-rhs;
lhs =y(47);
rhs =y(55)+T57/(1+T57)*y(6)+1/(1+T57)*y(76)+T90*(y(50)-y(78))-T62*(y(53)-(y(79)-params(5)));
residual(18)= lhs-rhs;
lhs =y(49);
rhs =y(56)+params(54)*y(47)+params(53)*y(48)+params(55)*y(43);
residual(19)= lhs-rhs;
lhs =y(49);
rhs =params(18)*(y(54)+params(9)*y(45)+(1-params(9))*y(50));
residual(20)= lhs-rhs;
lhs =y(51)-params(5);
rhs =T215*(params(44)*params(42)*(y(79)-params(5))+params(21)*(y(9)-params(5))+y(42)*T231)+y(59);
residual(21)= lhs-rhs;
lhs =y(52);
rhs =T37*y(10)+T240*y(80)+(y(9)-params(5))*params(19)/(1+params(44)*params(42))-(y(51)-params(5))*(1+params(44)*params(42)*params(19))/(1+params(44)*params(42))+(y(79)-params(5))*T240+T268*(params(23)*y(50)+T120*y(47)-T123*y(6)-y(52))+y(60);
residual(22)= lhs-rhs;
lhs =y(53);
rhs =(y(51)-params(5))*params(26)*(1-params(29))+(1-params(29))*params(28)*(y(49)-y(38))+params(27)*(y(49)-y(38)-y(8)+y(5))+params(29)*y(11)+y(58);
residual(23)= lhs-rhs;
lhs =y(54);
rhs =params(30)*y(12)+x(it_, 1);
residual(24)= lhs-rhs;
lhs =y(55);
rhs =params(32)*y(13)+x(it_, 2);
residual(25)= lhs-rhs;
lhs =y(56);
rhs =params(33)*y(14)+x(it_, 3)+x(it_, 1)*params(2);
residual(26)= lhs-rhs;
lhs =y(57);
rhs =params(35)*y(15)+x(it_, 4);
residual(27)= lhs-rhs;
lhs =y(58);
rhs =params(36)*y(16)+x(it_, 5);
residual(28)= lhs-rhs;
lhs =y(59);
rhs =params(37)*y(17)+y(31)-params(8)*y(2);
residual(29)= lhs-rhs;
lhs =y(31);
rhs =x(it_, 6);
residual(30)= lhs-rhs;
lhs =y(60);
rhs =params(38)*y(18)+y(30)-params(7)*y(1);
residual(31)= lhs-rhs;
lhs =y(30);
rhs =x(it_, 7);
residual(32)= lhs-rhs;
lhs =y(62);
rhs =(1-params(49))*y(20)+params(49)*y(48)+y(57)*params(12)*T42*params(49);
residual(33)= lhs-rhs;
lhs =y(64);
rhs =y(56)+T371*y(21)+y(66)-params(40)-(y(51)-params(5))-y(65);
residual(34)= lhs-rhs;
lhs =y(65);
rhs =y(21)*params(58)+(y(51)-params(5))*params(59)-x(it_, 8);
residual(35)= lhs-rhs;
lhs =y(81);
rhs =y(24);
residual(36)= lhs-rhs;
lhs =y(66)-params(40);
rhs =params(60)*y(67)-y(22);
residual(37)= lhs-rhs;
lhs =y(26);
rhs =y(49)-y(8)+params(39);
residual(38)= lhs-rhs;
lhs =y(27);
rhs =params(39)+y(47)-y(6);
residual(39)= lhs-rhs;
lhs =y(28);
rhs =params(39)+y(48)-y(7);
residual(40)= lhs-rhs;
lhs =y(29);
rhs =params(39)+y(52)-y(10);
residual(41)= lhs-rhs;
lhs =y(25);
rhs =y(51);
residual(42)= lhs-rhs;
lhs =y(24);
rhs =y(53)+params(40);
residual(43)= lhs-rhs;
lhs =y(23);
rhs =y(50)+params(4);
residual(44)= lhs-rhs;
lhs =y(63);
rhs =y(24)-y(68);
residual(45)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(45, 89);

  %
  % Jacobian matrix
  %

  g1(1,33)=(-params(9));
  g1(1,40)=(-(1-params(9)));
  g1(1,54)=1;
  g1(2,32)=1;
  g1(2,33)=(-T21);
  g1(3,33)=1;
  g1(3,34)=1;
  g1(3,39)=(-1);
  g1(3,40)=(-1);
  g1(4,32)=(-1);
  g1(4,34)=1;
  g1(4,19)=(-1);
  g1(5,35)=(-(T37*1/T44));
  g1(5,4)=(-T37);
  g1(5,37)=1;
  g1(5,72)=(-(params(44)*params(42)*T37));
  g1(5,57)=(-1);
  g1(6,69)=(-(params(47)/(params(47)+1-params(13))));
  g1(6,35)=1;
  g1(6,70)=(-T74);
  g1(6,41)=1;
  g1(6,55)=(-(1/T62));
  g1(7,3)=(-(T57/(1+T57)));
  g1(7,36)=1;
  g1(7,71)=(-(1/(1+T57)));
  g1(7,39)=(-T90);
  g1(7,73)=T90;
  g1(7,41)=T62;
  g1(7,55)=(-1);
  g1(8,32)=(-params(55));
  g1(8,36)=(-params(54));
  g1(8,37)=(-params(53));
  g1(8,38)=1;
  g1(8,56)=(-1);
  g1(9,34)=(-(params(9)*params(18)));
  g1(9,38)=1;
  g1(9,39)=(-((1-params(9))*params(18)));
  g1(9,54)=(-params(18));
  g1(10,3)=T123;
  g1(10,36)=(-T120);
  g1(10,39)=(-params(23));
  g1(10,40)=1;
  g1(11,37)=(-params(49));
  g1(11,57)=(-(T44*params(49)));
  g1(11,19)=(-(1-params(49)));
  g1(11,61)=1;
  g1(12,42)=1;
  g1(12,44)=(-params(9));
  g1(12,52)=(-(1-params(9)));
  g1(12,54)=1;
  g1(13,43)=1;
  g1(13,44)=(-T21);
  g1(14,44)=1;
  g1(14,45)=1;
  g1(14,50)=(-1);
  g1(14,52)=(-1);
  g1(15,43)=(-1);
  g1(15,45)=1;
  g1(15,20)=(-1);
  g1(16,46)=(-(T37*1/T44));
  g1(16,7)=(-T37);
  g1(16,48)=1;
  g1(16,77)=(-(params(44)*params(42)*T37));
  g1(16,57)=(-1);
  g1(17,74)=(-(params(47)/(params(47)+1-params(13))));
  g1(17,46)=1;
  g1(17,75)=(-T74);
  g1(17,79)=(-1);
  g1(17,53)=1;
  g1(17,55)=(-(1/T62));
  g1(18,6)=(-(T57/(1+T57)));
  g1(18,47)=1;
  g1(18,76)=(-(1/(1+T57)));
  g1(18,50)=(-T90);
  g1(18,78)=T90;
  g1(18,79)=(-T62);
  g1(18,53)=T62;
  g1(18,55)=(-1);
  g1(19,43)=(-params(55));
  g1(19,47)=(-params(54));
  g1(19,48)=(-params(53));
  g1(19,49)=1;
  g1(19,56)=(-1);
  g1(20,45)=(-(params(9)*params(18)));
  g1(20,49)=1;
  g1(20,50)=(-((1-params(9))*params(18)));
  g1(20,54)=(-params(18));
  g1(21,42)=(-(T215*T231));
  g1(21,9)=(-(params(21)*T215));
  g1(21,51)=1;
  g1(21,79)=(-(params(44)*params(42)*T215));
  g1(21,59)=(-1);
  g1(22,6)=(-(T268*(-T123)));
  g1(22,47)=(-(T120*T268));
  g1(22,50)=(-(params(23)*T268));
  g1(22,9)=(-(params(19)/(1+params(44)*params(42))));
  g1(22,51)=(1+params(44)*params(42)*params(19))/(1+params(44)*params(42));
  g1(22,79)=(-T240);
  g1(22,10)=(-T37);
  g1(22,52)=1-(-T268);
  g1(22,80)=(-T240);
  g1(22,60)=(-1);
  g1(23,5)=(-params(27));
  g1(23,38)=(-((-((1-params(29))*params(28)))-params(27)));
  g1(23,8)=params(27);
  g1(23,49)=(-((1-params(29))*params(28)+params(27)));
  g1(23,51)=(-(params(26)*(1-params(29))));
  g1(23,11)=(-params(29));
  g1(23,53)=1;
  g1(23,58)=(-1);
  g1(24,12)=(-params(30));
  g1(24,54)=1;
  g1(24,82)=(-1);
  g1(25,13)=(-params(32));
  g1(25,55)=1;
  g1(25,83)=(-1);
  g1(26,14)=(-params(33));
  g1(26,56)=1;
  g1(26,82)=(-params(2));
  g1(26,84)=(-1);
  g1(27,15)=(-params(35));
  g1(27,57)=1;
  g1(27,85)=(-1);
  g1(28,16)=(-params(36));
  g1(28,58)=1;
  g1(28,86)=(-1);
  g1(29,2)=params(8);
  g1(29,31)=(-1);
  g1(29,17)=(-params(37));
  g1(29,59)=1;
  g1(30,31)=1;
  g1(30,87)=(-1);
  g1(31,1)=params(7);
  g1(31,30)=(-1);
  g1(31,18)=(-params(38));
  g1(31,60)=1;
  g1(32,30)=1;
  g1(32,88)=(-1);
  g1(33,48)=(-params(49));
  g1(33,57)=(-(params(12)*T42*params(49)));
  g1(33,20)=(-(1-params(49)));
  g1(33,62)=1;
  g1(34,51)=1;
  g1(34,56)=(-1);
  g1(34,21)=(-T371);
  g1(34,64)=1;
  g1(34,65)=1;
  g1(34,66)=(-1);
  g1(35,51)=(-params(59));
  g1(35,21)=(-params(58));
  g1(35,65)=1;
  g1(35,89)=1;
  g1(36,24)=(-1);
  g1(36,81)=1;
  g1(37,66)=1;
  g1(37,22)=1;
  g1(37,67)=(-params(60));
  g1(38,26)=1;
  g1(38,8)=1;
  g1(38,49)=(-1);
  g1(39,27)=1;
  g1(39,6)=1;
  g1(39,47)=(-1);
  g1(40,28)=1;
  g1(40,7)=1;
  g1(40,48)=(-1);
  g1(41,29)=1;
  g1(41,10)=1;
  g1(41,52)=(-1);
  g1(42,25)=1;
  g1(42,51)=(-1);
  g1(43,24)=1;
  g1(43,53)=(-1);
  g1(44,23)=1;
  g1(44,50)=(-1);
  g1(45,24)=(-1);
  g1(45,68)=1;
  g1(45,63)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],45,7921);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],45,704969);
end
end
end
end
