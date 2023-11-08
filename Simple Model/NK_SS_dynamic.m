function [residual, g1, g2, g3] = NK_SS_dynamic(y, x, params, steady_state, it_)
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

residual = zeros(6, 1);
T58 = params(2)^(-1);
lhs =y(4);
rhs =y(10)-params(1)*(y(5)-params(8)-y(9)+params(7));
residual(1)= lhs-rhs;
lhs =y(3);
rhs =params(7)*(1-params(2))+params(2)*0.5*y(1)+y(9)*params(2)*0.5+y(4)*params(3);
residual(2)= lhs-rhs;
lhs =y(5);
rhs =params(8)+params(5)*(y(3)-params(7))+x(it_, 2);
residual(3)= lhs-rhs;
lhs =y(8);
rhs =y(5)-params(8)-(y(9)-params(7));
residual(4)= lhs-rhs;
lhs =y(7);
rhs =params(4)*y(2)+(y(3)-params(7))*params(6)+x(it_, 1);
residual(5)= lhs-rhs;
lhs =y(6);
rhs =y(5)-params(8)+y(2)*T58-(y(3)-params(7))-y(7);
residual(6)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(6, 12);

  %
  % Jacobian matrix
  %

  g1(1,9)=(-params(1));
  g1(1,4)=1;
  g1(1,10)=(-1);
  g1(1,5)=params(1);
  g1(2,1)=(-(params(2)*0.5));
  g1(2,3)=1;
  g1(2,9)=(-(params(2)*0.5));
  g1(2,4)=(-params(3));
  g1(3,3)=(-params(5));
  g1(3,5)=1;
  g1(3,12)=(-1);
  g1(4,9)=1;
  g1(4,5)=(-1);
  g1(4,8)=1;
  g1(5,3)=(-params(6));
  g1(5,2)=(-params(4));
  g1(5,7)=1;
  g1(5,11)=(-1);
  g1(6,3)=1;
  g1(6,5)=(-1);
  g1(6,2)=(-T58);
  g1(6,6)=1;
  g1(6,7)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],6,144);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],6,1728);
end
end
end
end
