function [residual, g1, g2, g3] = NK_CS_LTB_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(9, 1);
T58 = params(2)^(-1);
lhs =y(6);
rhs =y(15)-params(1)*(y(7)-params(8)-y(14)+params(7));
residual(1)= lhs-rhs;
lhs =y(5);
rhs =params(7)*(1-params(2))+params(2)*0.5*y(1)+y(14)*params(2)*0.5+y(6)*params(3);
residual(2)= lhs-rhs;
lhs =y(7);
rhs =params(8)+params(5)*(y(5)-params(7))+x(it_, 2);
residual(3)= lhs-rhs;
lhs =y(9);
rhs =y(7)-params(8)-(y(14)-params(7));
residual(4)= lhs-rhs;
lhs =y(11);
rhs =params(4)*y(3)+(y(5)-params(7))*params(6)+x(it_, 1);
residual(5)= lhs-rhs;
lhs =y(10);
rhs =y(3)*T58-y(11);
residual(6)= lhs-rhs;
lhs =y(8);
rhs =T58*(1-params(9))*y(2)+y(12)-params(8)-(y(5)-params(7))-y(11);
residual(7)= lhs-rhs;
lhs =y(12)-params(8);
rhs =params(10)*y(13)-y(4);
residual(8)= lhs-rhs;
lhs =y(16);
rhs =y(7);
residual(9)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(9, 18);

  %
  % Jacobian matrix
  %

  g1(1,14)=(-params(1));
  g1(1,6)=1;
  g1(1,15)=(-1);
  g1(1,7)=params(1);
  g1(2,1)=(-(params(2)*0.5));
  g1(2,5)=1;
  g1(2,14)=(-(params(2)*0.5));
  g1(2,6)=(-params(3));
  g1(3,5)=(-params(5));
  g1(3,7)=1;
  g1(3,18)=(-1);
  g1(4,14)=1;
  g1(4,7)=(-1);
  g1(4,9)=1;
  g1(5,5)=(-params(6));
  g1(5,3)=(-params(4));
  g1(5,11)=1;
  g1(5,17)=(-1);
  g1(6,3)=(-T58);
  g1(6,10)=1;
  g1(6,11)=1;
  g1(7,5)=1;
  g1(7,2)=(-(T58*(1-params(9))));
  g1(7,8)=1;
  g1(7,11)=1;
  g1(7,12)=(-1);
  g1(8,12)=1;
  g1(8,4)=1;
  g1(8,13)=(-params(10));
  g1(9,7)=(-1);
  g1(9,16)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],9,324);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],9,5832);
end
end
end
end
