function [residual, g1, g2, g3] = longterm_debt_surplus_rule_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(10, 1);
lhs =y(7);
rhs =y(17)-params(1)*(y(11)-params(6)-y(16)+params(5));
residual(1)= lhs-rhs;
lhs =y(6);
rhs =params(5)*(1-params(2))+params(2)*0.5*y(1)+y(16)*params(2)*0.5+y(7)*params(3);
residual(2)= lhs-rhs;
lhs =y(11);
rhs =params(6)+params(4)*(y(6)-params(5))+x(it_, 2);
residual(3)= lhs-rhs;
lhs =y(18);
rhs =y(11);
residual(4)= lhs-rhs;
lhs =y(10)-params(6);
rhs =params(7)*y(12)-y(3);
residual(5)= lhs-rhs;
lhs =y(13);
rhs =y(11)-params(6)-y(16)+params(5);
residual(6)= lhs-rhs;
lhs =y(9);
rhs =params(8)*y(5)+params(10)*y(2)+y(14);
residual(7)= lhs-rhs;
lhs =params(2)*y(15);
rhs =y(5)-y(9);
residual(8)= lhs-rhs;
lhs =params(2)*y(8);
rhs =y(10)-params(6)+y(2)-(y(6)-params(5))-y(9);
residual(9)= lhs-rhs;
lhs =y(14);
rhs =params(9)*y(4)+x(it_, 1);
residual(10)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(10, 20);

  %
  % Jacobian matrix
  %

  g1(1,16)=(-params(1));
  g1(1,7)=1;
  g1(1,17)=(-1);
  g1(1,11)=params(1);
  g1(2,1)=(-(params(2)*0.5));
  g1(2,6)=1;
  g1(2,16)=(-(params(2)*0.5));
  g1(2,7)=(-params(3));
  g1(3,6)=(-params(4));
  g1(3,11)=1;
  g1(3,20)=(-1);
  g1(4,18)=1;
  g1(4,11)=(-1);
  g1(5,10)=1;
  g1(5,3)=1;
  g1(5,12)=(-params(7));
  g1(6,16)=1;
  g1(6,11)=(-1);
  g1(6,13)=1;
  g1(7,2)=(-params(10));
  g1(7,9)=1;
  g1(7,14)=(-1);
  g1(7,5)=(-params(8));
  g1(8,9)=1;
  g1(8,5)=(-1);
  g1(8,15)=params(2);
  g1(9,6)=1;
  g1(9,2)=(-1);
  g1(9,8)=params(2);
  g1(9,9)=1;
  g1(9,10)=(-1);
  g1(10,4)=(-params(9));
  g1(10,14)=1;
  g1(10,19)=(-1);

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],10,400);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],10,8000);
end
end
end
end
