function [residual, g1, g2, g3] = SW_SS_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(43, 1);
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
lhs =y(53);
rhs =params(9)*y(32)+(1-params(9))*y(39);
residual(1)= lhs-rhs;
lhs =y(31);
rhs =y(32)*T21;
residual(2)= lhs-rhs;
lhs =y(32);
rhs =y(39)+y(38)-y(33);
residual(3)= lhs-rhs;
lhs =y(33);
rhs =y(31)+y(19);
residual(4)= lhs-rhs;
lhs =y(36);
rhs =T37*(y(4)+params(44)*params(42)*y(69)+1/T44*y(34))+y(56);
residual(5)= lhs-rhs;
lhs =y(34);
rhs =(-y(40))+y(54)*1/T62+params(47)/(params(47)+1-params(13))*y(66)+T74*y(67);
residual(6)= lhs-rhs;
lhs =y(35);
rhs =y(54)+T57/(1+T57)*y(3)+1/(1+T57)*y(68)+T90*(y(38)-y(70))-y(40)*T62;
residual(7)= lhs-rhs;
lhs =y(37);
rhs =y(35)*params(54)+y(36)*params(53)+y(55)+y(31)*params(55);
residual(8)= lhs-rhs;
lhs =y(37);
rhs =params(18)*(y(53)+params(9)*y(33)+(1-params(9))*y(38));
residual(9)= lhs-rhs;
lhs =y(39);
rhs =y(38)*params(23)+y(35)*T120-y(3)*T123;
residual(10)= lhs-rhs;
lhs =y(60);
rhs =y(19)*(1-params(49))+y(36)*params(49)+y(56)*T44*params(49);
residual(11)= lhs-rhs;
lhs =y(41);
rhs =params(9)*y(43)+(1-params(9))*y(51)-y(53);
residual(12)= lhs-rhs;
lhs =y(42);
rhs =T21*y(43);
residual(13)= lhs-rhs;
lhs =y(43);
rhs =y(51)+y(49)-y(44);
residual(14)= lhs-rhs;
lhs =y(44);
rhs =y(42)+y(20);
residual(15)= lhs-rhs;
lhs =y(47);
rhs =y(56)+T37*(y(7)+params(44)*params(42)*y(74)+1/T44*y(45));
residual(16)= lhs-rhs;
lhs =y(45);
rhs =y(54)*1/T62+(-y(52))+y(76)-params(5)+params(47)/(params(47)+1-params(13))*y(71)+T74*y(72);
residual(17)= lhs-rhs;
lhs =y(46);
rhs =y(54)+T57/(1+T57)*y(6)+1/(1+T57)*y(73)+T90*(y(49)-y(75))-T62*(y(52)-(y(76)-params(5)));
residual(18)= lhs-rhs;
lhs =y(48);
rhs =y(55)+params(54)*y(46)+params(53)*y(47)+params(55)*y(42);
residual(19)= lhs-rhs;
lhs =y(48);
rhs =params(18)*(y(53)+params(9)*y(44)+(1-params(9))*y(49));
residual(20)= lhs-rhs;
lhs =y(50)-params(5);
rhs =T215*(params(44)*params(42)*(y(76)-params(5))+params(21)*(y(9)-params(5))+y(41)*T231)+y(58);
residual(21)= lhs-rhs;
lhs =y(51);
rhs =T37*y(10)+T240*y(77)+(y(9)-params(5))*params(19)/(1+params(44)*params(42))-(y(50)-params(5))*(1+params(44)*params(42)*params(19))/(1+params(44)*params(42))+(y(76)-params(5))*T240+T268*(params(23)*y(49)+T120*y(46)-T123*y(6)-y(51))+y(59);
residual(22)= lhs-rhs;
lhs =y(52);
rhs =(y(50)-params(5))*params(26)*(1-params(29))+(1-params(29))*params(28)*(y(48)-y(37))+params(27)*(y(48)-y(37)-y(8)+y(5))+params(29)*y(11)+y(57);
residual(23)= lhs-rhs;
lhs =y(53);
rhs =params(30)*y(12)+x(it_, 1);
residual(24)= lhs-rhs;
lhs =y(54);
rhs =params(32)*y(13)+x(it_, 2);
residual(25)= lhs-rhs;
lhs =y(55);
rhs =params(33)*y(14)+x(it_, 3)+x(it_, 1)*params(2);
residual(26)= lhs-rhs;
lhs =y(56);
rhs =params(35)*y(15)+x(it_, 4);
residual(27)= lhs-rhs;
lhs =y(57);
rhs =params(36)*y(16)+x(it_, 5);
residual(28)= lhs-rhs;
lhs =y(58);
rhs =params(37)*y(17)+y(30)-params(8)*y(2);
residual(29)= lhs-rhs;
lhs =y(30);
rhs =x(it_, 6);
residual(30)= lhs-rhs;
lhs =y(59);
rhs =params(38)*y(18)+y(29)-params(7)*y(1);
residual(31)= lhs-rhs;
lhs =y(29);
rhs =x(it_, 7);
residual(32)= lhs-rhs;
lhs =y(61);
rhs =(1-params(49))*y(20)+params(49)*y(47)+y(56)*params(12)*T42*params(49);
residual(33)= lhs-rhs;
lhs =y(63);
rhs =y(55)+y(52)+T371*y(21)-(y(50)-params(5))-y(64);
residual(34)= lhs-rhs;
lhs =y(64);
rhs =y(21)*params(58)+(y(50)-params(5))*params(59)-x(it_, 8);
residual(35)= lhs-rhs;
lhs =y(25);
rhs =y(48)-y(8)+params(39);
residual(36)= lhs-rhs;
lhs =y(26);
rhs =params(39)+y(46)-y(6);
residual(37)= lhs-rhs;
lhs =y(27);
rhs =params(39)+y(47)-y(7);
residual(38)= lhs-rhs;
lhs =y(28);
rhs =params(39)+y(51)-y(10);
residual(39)= lhs-rhs;
lhs =y(24);
rhs =y(50);
residual(40)= lhs-rhs;
lhs =y(23);
rhs =y(52)+params(40);
residual(41)= lhs-rhs;
lhs =y(22);
rhs =y(49)+params(4);
residual(42)= lhs-rhs;
lhs =y(62);
rhs =y(23)-y(65);
residual(43)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(43, 85);

  %
  % Jacobian matrix
  %

  g1(1,32)=(-params(9));
  g1(1,39)=(-(1-params(9)));
  g1(1,53)=1;
  g1(2,31)=1;
  g1(2,32)=(-T21);
  g1(3,32)=1;
  g1(3,33)=1;
  g1(3,38)=(-1);
  g1(3,39)=(-1);
  g1(4,31)=(-1);
  g1(4,33)=1;
  g1(4,19)=(-1);
  g1(5,34)=(-(T37*1/T44));
  g1(5,4)=(-T37);
  g1(5,36)=1;
  g1(5,69)=(-(params(44)*params(42)*T37));
  g1(5,56)=(-1);
  g1(6,66)=(-(params(47)/(params(47)+1-params(13))));
  g1(6,34)=1;
  g1(6,67)=(-T74);
  g1(6,40)=1;
  g1(6,54)=(-(1/T62));
  g1(7,3)=(-(T57/(1+T57)));
  g1(7,35)=1;
  g1(7,68)=(-(1/(1+T57)));
  g1(7,38)=(-T90);
  g1(7,70)=T90;
  g1(7,40)=T62;
  g1(7,54)=(-1);
  g1(8,31)=(-params(55));
  g1(8,35)=(-params(54));
  g1(8,36)=(-params(53));
  g1(8,37)=1;
  g1(8,55)=(-1);
  g1(9,33)=(-(params(9)*params(18)));
  g1(9,37)=1;
  g1(9,38)=(-((1-params(9))*params(18)));
  g1(9,53)=(-params(18));
  g1(10,3)=T123;
  g1(10,35)=(-T120);
  g1(10,38)=(-params(23));
  g1(10,39)=1;
  g1(11,36)=(-params(49));
  g1(11,56)=(-(T44*params(49)));
  g1(11,19)=(-(1-params(49)));
  g1(11,60)=1;
  g1(12,41)=1;
  g1(12,43)=(-params(9));
  g1(12,51)=(-(1-params(9)));
  g1(12,53)=1;
  g1(13,42)=1;
  g1(13,43)=(-T21);
  g1(14,43)=1;
  g1(14,44)=1;
  g1(14,49)=(-1);
  g1(14,51)=(-1);
  g1(15,42)=(-1);
  g1(15,44)=1;
  g1(15,20)=(-1);
  g1(16,45)=(-(T37*1/T44));
  g1(16,7)=(-T37);
  g1(16,47)=1;
  g1(16,74)=(-(params(44)*params(42)*T37));
  g1(16,56)=(-1);
  g1(17,71)=(-(params(47)/(params(47)+1-params(13))));
  g1(17,45)=1;
  g1(17,72)=(-T74);
  g1(17,76)=(-1);
  g1(17,52)=1;
  g1(17,54)=(-(1/T62));
  g1(18,6)=(-(T57/(1+T57)));
  g1(18,46)=1;
  g1(18,73)=(-(1/(1+T57)));
  g1(18,49)=(-T90);
  g1(18,75)=T90;
  g1(18,76)=(-T62);
  g1(18,52)=T62;
  g1(18,54)=(-1);
  g1(19,42)=(-params(55));
  g1(19,46)=(-params(54));
  g1(19,47)=(-params(53));
  g1(19,48)=1;
  g1(19,55)=(-1);
  g1(20,44)=(-(params(9)*params(18)));
  g1(20,48)=1;
  g1(20,49)=(-((1-params(9))*params(18)));
  g1(20,53)=(-params(18));
  g1(21,41)=(-(T215*T231));
  g1(21,9)=(-(params(21)*T215));
  g1(21,50)=1;
  g1(21,76)=(-(params(44)*params(42)*T215));
  g1(21,58)=(-1);
  g1(22,6)=(-(T268*(-T123)));
  g1(22,46)=(-(T120*T268));
  g1(22,49)=(-(params(23)*T268));
  g1(22,9)=(-(params(19)/(1+params(44)*params(42))));
  g1(22,50)=(1+params(44)*params(42)*params(19))/(1+params(44)*params(42));
  g1(22,76)=(-T240);
  g1(22,10)=(-T37);
  g1(22,51)=1-(-T268);
  g1(22,77)=(-T240);
  g1(22,59)=(-1);
  g1(23,5)=(-params(27));
  g1(23,37)=(-((-((1-params(29))*params(28)))-params(27)));
  g1(23,8)=params(27);
  g1(23,48)=(-((1-params(29))*params(28)+params(27)));
  g1(23,50)=(-(params(26)*(1-params(29))));
  g1(23,11)=(-params(29));
  g1(23,52)=1;
  g1(23,57)=(-1);
  g1(24,12)=(-params(30));
  g1(24,53)=1;
  g1(24,78)=(-1);
  g1(25,13)=(-params(32));
  g1(25,54)=1;
  g1(25,79)=(-1);
  g1(26,14)=(-params(33));
  g1(26,55)=1;
  g1(26,78)=(-params(2));
  g1(26,80)=(-1);
  g1(27,15)=(-params(35));
  g1(27,56)=1;
  g1(27,81)=(-1);
  g1(28,16)=(-params(36));
  g1(28,57)=1;
  g1(28,82)=(-1);
  g1(29,2)=params(8);
  g1(29,30)=(-1);
  g1(29,17)=(-params(37));
  g1(29,58)=1;
  g1(30,30)=1;
  g1(30,83)=(-1);
  g1(31,1)=params(7);
  g1(31,29)=(-1);
  g1(31,18)=(-params(38));
  g1(31,59)=1;
  g1(32,29)=1;
  g1(32,84)=(-1);
  g1(33,47)=(-params(49));
  g1(33,56)=(-(params(12)*T42*params(49)));
  g1(33,20)=(-(1-params(49)));
  g1(33,61)=1;
  g1(34,50)=1;
  g1(34,52)=(-1);
  g1(34,55)=(-1);
  g1(34,21)=(-T371);
  g1(34,63)=1;
  g1(34,64)=1;
  g1(35,50)=(-params(59));
  g1(35,21)=(-params(58));
  g1(35,64)=1;
  g1(35,85)=1;
  g1(36,25)=1;
  g1(36,8)=1;
  g1(36,48)=(-1);
  g1(37,26)=1;
  g1(37,6)=1;
  g1(37,46)=(-1);
  g1(38,27)=1;
  g1(38,7)=1;
  g1(38,47)=(-1);
  g1(39,28)=1;
  g1(39,10)=1;
  g1(39,51)=(-1);
  g1(40,24)=1;
  g1(40,50)=(-1);
  g1(41,23)=1;
  g1(41,52)=(-1);
  g1(42,22)=1;
  g1(42,49)=(-1);
  g1(43,23)=(-1);
  g1(43,65)=1;
  g1(43,62)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],43,7225);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],43,614125);
end
end
end
end
