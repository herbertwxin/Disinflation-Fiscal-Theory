function [residual, g1, g2, g3] = NK_SS_LTD_dynamic(y, x, params, steady_state, it_)
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
lhs =y(6);
rhs =y(16)-params(1)*(y(7)-params(7)-y(15)+params(6));
residual(1)= lhs-rhs;
lhs =y(5);
rhs =params(6)*(1-params(2))+0.5*y(1)+y(15)*params(2)*0.5+y(6)*params(3);
residual(2)= lhs-rhs;
lhs =y(7);
rhs =params(7)+params(5)*(y(5)-params(6))+x(it_, 1);
residual(3)= lhs-rhs;
lhs =params(2)*y(8);
rhs =y(2)+y(11)-params(7)-(y(5)-params(6))-y(9);
residual(4)= lhs-rhs;
lhs =params(2)*y(13);
rhs =y(11)-params(7)+y(4)-(y(14)-params(6))-y(9);
residual(5)= lhs-rhs;
lhs =y(18);
rhs =y(15);
residual(6)= lhs-rhs;
lhs =y(10);
rhs =y(7)-y(15);
residual(7)= lhs-rhs;
lhs =y(9);
rhs =y(5)*params(9)+y(6)*params(10)+y(4)*params(11);
residual(8)= lhs-rhs;
lhs =y(17);
rhs =y(7);
residual(9)= lhs-rhs;
lhs =y(11)-params(7);
rhs =params(8)*y(12)-y(3);
residual(10)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(10, 19);

  %
  % Jacobian matrix
  %

  g1(1,15)=(-params(1));
  g1(1,6)=1;
  g1(1,16)=(-1);
  g1(1,7)=params(1);
  g1(2,1)=(-0.5);
  g1(2,5)=1;
  g1(2,15)=(-(params(2)*0.5));
  g1(2,6)=(-params(3));
  g1(3,5)=(-params(5));
  g1(3,7)=1;
  g1(3,19)=(-1);
  g1(4,5)=1;
  g1(4,2)=(-1);
  g1(4,8)=params(2);
  g1(4,9)=1;
  g1(4,11)=(-1);
  g1(5,9)=1;
  g1(5,11)=(-1);
  g1(5,4)=(-1);
  g1(5,13)=params(2);
  g1(5,14)=1;
  g1(6,15)=(-1);
  g1(6,18)=1;
  g1(7,15)=1;
  g1(7,7)=(-1);
  g1(7,10)=1;
  g1(8,5)=(-params(9));
  g1(8,6)=(-params(10));
  g1(8,9)=1;
  g1(8,4)=(-params(11));
  g1(9,7)=(-1);
  g1(9,17)=1;
  g1(10,11)=1;
  g1(10,3)=1;
  g1(10,12)=(-params(8));

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],10,361);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],10,6859);
end
end
end
end
