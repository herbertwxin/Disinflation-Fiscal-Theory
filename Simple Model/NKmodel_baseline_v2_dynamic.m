function [residual, g1, g2, g3] = NKmodel_baseline_v2_dynamic(y, x, params, steady_state, it_)
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
lhs =y(5);
rhs =y(11)-params(1)*(y(6)-params(7)-y(10)+params(6));
residual(1)= lhs-rhs;
lhs =y(4);
rhs =params(6)*(1-params(2))+0.5*y(1)+y(10)*params(2)*0.5+y(5)*params(3);
residual(2)= lhs-rhs;
lhs =y(6);
rhs =params(7)+params(5)*(y(4)-params(6))+x(it_, 2);
residual(3)= lhs-rhs;
lhs =y(7);
rhs =y(6)-params(7)+params(4)*(y(2)-(y(4)-params(6))-y(8));
residual(4)= lhs-rhs;
lhs =y(9);
rhs =y(6)-y(10);
residual(5)= lhs-rhs;
lhs =y(8);
rhs =0.5*y(3)-x(it_, 1);
residual(6)= lhs-rhs;
if nargout >= 2,
  g1 = zeros(6, 13);

  %
  % Jacobian matrix
  %

  g1(1,10)=(-params(1));
  g1(1,5)=1;
  g1(1,11)=(-1);
  g1(1,6)=params(1);
  g1(2,1)=(-0.5);
  g1(2,4)=1;
  g1(2,10)=(-(params(2)*0.5));
  g1(2,5)=(-params(3));
  g1(3,4)=(-params(5));
  g1(3,6)=1;
  g1(3,13)=(-1);
  g1(4,4)=params(4);
  g1(4,6)=(-1);
  g1(4,2)=(-params(4));
  g1(4,7)=1;
  g1(4,8)=params(4);
  g1(5,10)=1;
  g1(5,6)=(-1);
  g1(5,9)=1;
  g1(6,3)=(-0.5);
  g1(6,8)=1;
  g1(6,12)=1;

if nargout >= 3,
  %
  % Hessian matrix
  %

  g2 = sparse([],[],[],6,169);
if nargout >= 4,
  %
  % Third order derivatives
  %

  g3 = sparse([],[],[],6,2197);
end
end
end
end
