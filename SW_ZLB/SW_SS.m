%
% Status : main Dynare file
%
% Warning : this file is generated automatically by Dynare
%           from model file (.mod)

tic0 = tic;
% Save empty dates and dseries objects in memory.
dates('initialize');
dseries('initialize');
% Define global variables.
global M_ options_ oo_ estim_params_ bayestopt_ dataset_ dataset_info estimation_info ys0_ ex0_
options_ = [];
M_.fname = 'SW_SS';
M_.dynare_version = '4.5.6';
oo_.dynare_version = '4.5.6';
options_.dynare_version = '4.5.6';
%
% Some global variables initialization
%
global_initialization;
diary off;
M_.exo_names = 'ea';
M_.exo_names_tex = 'ea';
M_.exo_names_long = 'ea';
M_.exo_names = char(M_.exo_names, 'eb');
M_.exo_names_tex = char(M_.exo_names_tex, 'eb');
M_.exo_names_long = char(M_.exo_names_long, 'eb');
M_.exo_names = char(M_.exo_names, 'eg');
M_.exo_names_tex = char(M_.exo_names_tex, 'eg');
M_.exo_names_long = char(M_.exo_names_long, 'eg');
M_.exo_names = char(M_.exo_names, 'eqs');
M_.exo_names_tex = char(M_.exo_names_tex, 'eqs');
M_.exo_names_long = char(M_.exo_names_long, 'eqs');
M_.exo_names = char(M_.exo_names, 'em');
M_.exo_names_tex = char(M_.exo_names_tex, 'em');
M_.exo_names_long = char(M_.exo_names_long, 'em');
M_.exo_names = char(M_.exo_names, 'epinf');
M_.exo_names_tex = char(M_.exo_names_tex, 'epinf');
M_.exo_names_long = char(M_.exo_names_long, 'epinf');
M_.exo_names = char(M_.exo_names, 'ew');
M_.exo_names_tex = char(M_.exo_names_tex, 'ew');
M_.exo_names_long = char(M_.exo_names_long, 'ew');
M_.exo_names = char(M_.exo_names, 'eps_s');
M_.exo_names_tex = char(M_.exo_names_tex, 'eps\_s');
M_.exo_names_long = char(M_.exo_names_long, 'eps_s');
M_.endo_names = 'labobs';
M_.endo_names_tex = 'labobs';
M_.endo_names_long = 'labobs';
M_.endo_names = char(M_.endo_names, 'robs');
M_.endo_names_tex = char(M_.endo_names_tex, 'robs');
M_.endo_names_long = char(M_.endo_names_long, 'robs');
M_.endo_names = char(M_.endo_names, 'pinfobs');
M_.endo_names_tex = char(M_.endo_names_tex, 'pinfobs');
M_.endo_names_long = char(M_.endo_names_long, 'pinfobs');
M_.endo_names = char(M_.endo_names, 'dy');
M_.endo_names_tex = char(M_.endo_names_tex, 'dy');
M_.endo_names_long = char(M_.endo_names_long, 'dy');
M_.endo_names = char(M_.endo_names, 'dc');
M_.endo_names_tex = char(M_.endo_names_tex, 'dc');
M_.endo_names_long = char(M_.endo_names_long, 'dc');
M_.endo_names = char(M_.endo_names, 'dinve');
M_.endo_names_tex = char(M_.endo_names_tex, 'dinve');
M_.endo_names_long = char(M_.endo_names_long, 'dinve');
M_.endo_names = char(M_.endo_names, 'dw');
M_.endo_names_tex = char(M_.endo_names_tex, 'dw');
M_.endo_names_long = char(M_.endo_names_long, 'dw');
M_.endo_names = char(M_.endo_names, 'ewma');
M_.endo_names_tex = char(M_.endo_names_tex, 'ewma');
M_.endo_names_long = char(M_.endo_names_long, 'ewma');
M_.endo_names = char(M_.endo_names, 'epinfma');
M_.endo_names_tex = char(M_.endo_names_tex, 'epinfma');
M_.endo_names_long = char(M_.endo_names_long, 'epinfma');
M_.endo_names = char(M_.endo_names, 'zcapf');
M_.endo_names_tex = char(M_.endo_names_tex, 'zcapf');
M_.endo_names_long = char(M_.endo_names_long, 'zcapf');
M_.endo_names = char(M_.endo_names, 'rkf');
M_.endo_names_tex = char(M_.endo_names_tex, 'rkf');
M_.endo_names_long = char(M_.endo_names_long, 'rkf');
M_.endo_names = char(M_.endo_names, 'kf');
M_.endo_names_tex = char(M_.endo_names_tex, 'kf');
M_.endo_names_long = char(M_.endo_names_long, 'kf');
M_.endo_names = char(M_.endo_names, 'pkf');
M_.endo_names_tex = char(M_.endo_names_tex, 'pkf');
M_.endo_names_long = char(M_.endo_names_long, 'pkf');
M_.endo_names = char(M_.endo_names, 'cf');
M_.endo_names_tex = char(M_.endo_names_tex, 'cf');
M_.endo_names_long = char(M_.endo_names_long, 'cf');
M_.endo_names = char(M_.endo_names, 'invef');
M_.endo_names_tex = char(M_.endo_names_tex, 'invef');
M_.endo_names_long = char(M_.endo_names_long, 'invef');
M_.endo_names = char(M_.endo_names, 'yf');
M_.endo_names_tex = char(M_.endo_names_tex, 'yf');
M_.endo_names_long = char(M_.endo_names_long, 'yf');
M_.endo_names = char(M_.endo_names, 'labf');
M_.endo_names_tex = char(M_.endo_names_tex, 'labf');
M_.endo_names_long = char(M_.endo_names_long, 'labf');
M_.endo_names = char(M_.endo_names, 'wf');
M_.endo_names_tex = char(M_.endo_names_tex, 'wf');
M_.endo_names_long = char(M_.endo_names_long, 'wf');
M_.endo_names = char(M_.endo_names, 'rrf');
M_.endo_names_tex = char(M_.endo_names_tex, 'rrf');
M_.endo_names_long = char(M_.endo_names_long, 'rrf');
M_.endo_names = char(M_.endo_names, 'mc');
M_.endo_names_tex = char(M_.endo_names_tex, 'mc');
M_.endo_names_long = char(M_.endo_names_long, 'mc');
M_.endo_names = char(M_.endo_names, 'zcap');
M_.endo_names_tex = char(M_.endo_names_tex, 'zcap');
M_.endo_names_long = char(M_.endo_names_long, 'zcap');
M_.endo_names = char(M_.endo_names, 'rk');
M_.endo_names_tex = char(M_.endo_names_tex, 'rk');
M_.endo_names_long = char(M_.endo_names_long, 'rk');
M_.endo_names = char(M_.endo_names, 'k');
M_.endo_names_tex = char(M_.endo_names_tex, 'k');
M_.endo_names_long = char(M_.endo_names_long, 'k');
M_.endo_names = char(M_.endo_names, 'pk');
M_.endo_names_tex = char(M_.endo_names_tex, 'pk');
M_.endo_names_long = char(M_.endo_names_long, 'pk');
M_.endo_names = char(M_.endo_names, 'c');
M_.endo_names_tex = char(M_.endo_names_tex, 'c');
M_.endo_names_long = char(M_.endo_names_long, 'c');
M_.endo_names = char(M_.endo_names, 'inve');
M_.endo_names_tex = char(M_.endo_names_tex, 'inve');
M_.endo_names_long = char(M_.endo_names_long, 'inve');
M_.endo_names = char(M_.endo_names, 'y');
M_.endo_names_tex = char(M_.endo_names_tex, 'y');
M_.endo_names_long = char(M_.endo_names_long, 'y');
M_.endo_names = char(M_.endo_names, 'lab');
M_.endo_names_tex = char(M_.endo_names_tex, 'lab');
M_.endo_names_long = char(M_.endo_names_long, 'lab');
M_.endo_names = char(M_.endo_names, 'pinf');
M_.endo_names_tex = char(M_.endo_names_tex, 'pinf');
M_.endo_names_long = char(M_.endo_names_long, 'pinf');
M_.endo_names = char(M_.endo_names, 'w');
M_.endo_names_tex = char(M_.endo_names_tex, 'w');
M_.endo_names_long = char(M_.endo_names_long, 'w');
M_.endo_names = char(M_.endo_names, 'r');
M_.endo_names_tex = char(M_.endo_names_tex, 'r');
M_.endo_names_long = char(M_.endo_names_long, 'r');
M_.endo_names = char(M_.endo_names, 'a');
M_.endo_names_tex = char(M_.endo_names_tex, 'a');
M_.endo_names_long = char(M_.endo_names_long, 'a');
M_.endo_names = char(M_.endo_names, 'b');
M_.endo_names_tex = char(M_.endo_names_tex, 'b');
M_.endo_names_long = char(M_.endo_names_long, 'b');
M_.endo_names = char(M_.endo_names, 'g');
M_.endo_names_tex = char(M_.endo_names_tex, 'g');
M_.endo_names_long = char(M_.endo_names_long, 'g');
M_.endo_names = char(M_.endo_names, 'qs');
M_.endo_names_tex = char(M_.endo_names_tex, 'qs');
M_.endo_names_long = char(M_.endo_names_long, 'qs');
M_.endo_names = char(M_.endo_names, 'ms');
M_.endo_names_tex = char(M_.endo_names_tex, 'ms');
M_.endo_names_long = char(M_.endo_names_long, 'ms');
M_.endo_names = char(M_.endo_names, 'spinf');
M_.endo_names_tex = char(M_.endo_names_tex, 'spinf');
M_.endo_names_long = char(M_.endo_names_long, 'spinf');
M_.endo_names = char(M_.endo_names, 'sw');
M_.endo_names_tex = char(M_.endo_names_tex, 'sw');
M_.endo_names_long = char(M_.endo_names_long, 'sw');
M_.endo_names = char(M_.endo_names, 'kpf');
M_.endo_names_tex = char(M_.endo_names_tex, 'kpf');
M_.endo_names_long = char(M_.endo_names_long, 'kpf');
M_.endo_names = char(M_.endo_names, 'kp');
M_.endo_names_tex = char(M_.endo_names_tex, 'kp');
M_.endo_names_long = char(M_.endo_names_long, 'kp');
M_.endo_names = char(M_.endo_names, 'rr');
M_.endo_names_tex = char(M_.endo_names_tex, 'rr');
M_.endo_names_long = char(M_.endo_names_long, 'rr');
M_.endo_names = char(M_.endo_names, 'v');
M_.endo_names_tex = char(M_.endo_names_tex, 'v');
M_.endo_names_long = char(M_.endo_names_long, 'v');
M_.endo_names = char(M_.endo_names, 's');
M_.endo_names_tex = char(M_.endo_names_tex, 's');
M_.endo_names_long = char(M_.endo_names_long, 's');
M_.endo_partitions = struct();
M_.param_names = 'curvw';
M_.param_names_tex = 'curvw';
M_.param_names_long = 'curvw';
M_.param_names = char(M_.param_names, 'cgy');
M_.param_names_tex = char(M_.param_names_tex, 'cgy');
M_.param_names_long = char(M_.param_names_long, 'cgy');
M_.param_names = char(M_.param_names, 'curvp');
M_.param_names_tex = char(M_.param_names_tex, 'curvp');
M_.param_names_long = char(M_.param_names_long, 'curvp');
M_.param_names = char(M_.param_names, 'constelab');
M_.param_names_tex = char(M_.param_names_tex, 'constelab');
M_.param_names_long = char(M_.param_names_long, 'constelab');
M_.param_names = char(M_.param_names, 'constepinf');
M_.param_names_tex = char(M_.param_names_tex, 'constepinf');
M_.param_names_long = char(M_.param_names_long, 'constepinf');
M_.param_names = char(M_.param_names, 'constebeta');
M_.param_names_tex = char(M_.param_names_tex, 'constebeta');
M_.param_names_long = char(M_.param_names_long, 'constebeta');
M_.param_names = char(M_.param_names, 'cmaw');
M_.param_names_tex = char(M_.param_names_tex, 'cmaw');
M_.param_names_long = char(M_.param_names_long, 'cmaw');
M_.param_names = char(M_.param_names, 'cmap');
M_.param_names_tex = char(M_.param_names_tex, 'cmap');
M_.param_names_long = char(M_.param_names_long, 'cmap');
M_.param_names = char(M_.param_names, 'calfa');
M_.param_names_tex = char(M_.param_names_tex, 'calfa');
M_.param_names_long = char(M_.param_names_long, 'calfa');
M_.param_names = char(M_.param_names, 'czcap');
M_.param_names_tex = char(M_.param_names_tex, 'czcap');
M_.param_names_long = char(M_.param_names_long, 'czcap');
M_.param_names = char(M_.param_names, 'cbeta');
M_.param_names_tex = char(M_.param_names_tex, 'cbeta');
M_.param_names_long = char(M_.param_names_long, 'cbeta');
M_.param_names = char(M_.param_names, 'csadjcost');
M_.param_names_tex = char(M_.param_names_tex, 'csadjcost');
M_.param_names_long = char(M_.param_names_long, 'csadjcost');
M_.param_names = char(M_.param_names, 'ctou');
M_.param_names_tex = char(M_.param_names_tex, 'ctou');
M_.param_names_long = char(M_.param_names_long, 'ctou');
M_.param_names = char(M_.param_names, 'csigma');
M_.param_names_tex = char(M_.param_names_tex, 'csigma');
M_.param_names_long = char(M_.param_names_long, 'csigma');
M_.param_names = char(M_.param_names, 'chabb');
M_.param_names_tex = char(M_.param_names_tex, 'chabb');
M_.param_names_long = char(M_.param_names_long, 'chabb');
M_.param_names = char(M_.param_names, 'ccs');
M_.param_names_tex = char(M_.param_names_tex, 'ccs');
M_.param_names_long = char(M_.param_names_long, 'ccs');
M_.param_names = char(M_.param_names, 'cinvs');
M_.param_names_tex = char(M_.param_names_tex, 'cinvs');
M_.param_names_long = char(M_.param_names_long, 'cinvs');
M_.param_names = char(M_.param_names, 'cfc');
M_.param_names_tex = char(M_.param_names_tex, 'cfc');
M_.param_names_long = char(M_.param_names_long, 'cfc');
M_.param_names = char(M_.param_names, 'cindw');
M_.param_names_tex = char(M_.param_names_tex, 'cindw');
M_.param_names_long = char(M_.param_names_long, 'cindw');
M_.param_names = char(M_.param_names, 'cprobw');
M_.param_names_tex = char(M_.param_names_tex, 'cprobw');
M_.param_names_long = char(M_.param_names_long, 'cprobw');
M_.param_names = char(M_.param_names, 'cindp');
M_.param_names_tex = char(M_.param_names_tex, 'cindp');
M_.param_names_long = char(M_.param_names_long, 'cindp');
M_.param_names = char(M_.param_names, 'cprobp');
M_.param_names_tex = char(M_.param_names_tex, 'cprobp');
M_.param_names_long = char(M_.param_names_long, 'cprobp');
M_.param_names = char(M_.param_names, 'csigl');
M_.param_names_tex = char(M_.param_names_tex, 'csigl');
M_.param_names_long = char(M_.param_names_long, 'csigl');
M_.param_names = char(M_.param_names, 'clandaw');
M_.param_names_tex = char(M_.param_names_tex, 'clandaw');
M_.param_names_long = char(M_.param_names_long, 'clandaw');
M_.param_names = char(M_.param_names, 'crdpi');
M_.param_names_tex = char(M_.param_names_tex, 'crdpi');
M_.param_names_long = char(M_.param_names_long, 'crdpi');
M_.param_names = char(M_.param_names, 'crpi');
M_.param_names_tex = char(M_.param_names_tex, 'crpi');
M_.param_names_long = char(M_.param_names_long, 'crpi');
M_.param_names = char(M_.param_names, 'crdy');
M_.param_names_tex = char(M_.param_names_tex, 'crdy');
M_.param_names_long = char(M_.param_names_long, 'crdy');
M_.param_names = char(M_.param_names, 'cry');
M_.param_names_tex = char(M_.param_names_tex, 'cry');
M_.param_names_long = char(M_.param_names_long, 'cry');
M_.param_names = char(M_.param_names, 'crr');
M_.param_names_tex = char(M_.param_names_tex, 'crr');
M_.param_names_long = char(M_.param_names_long, 'crr');
M_.param_names = char(M_.param_names, 'crhoa');
M_.param_names_tex = char(M_.param_names_tex, 'crhoa');
M_.param_names_long = char(M_.param_names_long, 'crhoa');
M_.param_names = char(M_.param_names, 'crhoas');
M_.param_names_tex = char(M_.param_names_tex, 'crhoas');
M_.param_names_long = char(M_.param_names_long, 'crhoas');
M_.param_names = char(M_.param_names, 'crhob');
M_.param_names_tex = char(M_.param_names_tex, 'crhob');
M_.param_names_long = char(M_.param_names_long, 'crhob');
M_.param_names = char(M_.param_names, 'crhog');
M_.param_names_tex = char(M_.param_names_tex, 'crhog');
M_.param_names_long = char(M_.param_names_long, 'crhog');
M_.param_names = char(M_.param_names, 'crhols');
M_.param_names_tex = char(M_.param_names_tex, 'crhols');
M_.param_names_long = char(M_.param_names_long, 'crhols');
M_.param_names = char(M_.param_names, 'crhoqs');
M_.param_names_tex = char(M_.param_names_tex, 'crhoqs');
M_.param_names_long = char(M_.param_names_long, 'crhoqs');
M_.param_names = char(M_.param_names, 'crhoms');
M_.param_names_tex = char(M_.param_names_tex, 'crhoms');
M_.param_names_long = char(M_.param_names_long, 'crhoms');
M_.param_names = char(M_.param_names, 'crhopinf');
M_.param_names_tex = char(M_.param_names_tex, 'crhopinf');
M_.param_names_long = char(M_.param_names_long, 'crhopinf');
M_.param_names = char(M_.param_names, 'crhow');
M_.param_names_tex = char(M_.param_names_tex, 'crhow');
M_.param_names_long = char(M_.param_names_long, 'crhow');
M_.param_names = char(M_.param_names, 'ctrend');
M_.param_names_tex = char(M_.param_names_tex, 'ctrend');
M_.param_names_long = char(M_.param_names_long, 'ctrend');
M_.param_names = char(M_.param_names, 'conster');
M_.param_names_tex = char(M_.param_names_tex, 'conster');
M_.param_names_long = char(M_.param_names_long, 'conster');
M_.param_names = char(M_.param_names, 'cg');
M_.param_names_tex = char(M_.param_names_tex, 'cg');
M_.param_names_long = char(M_.param_names_long, 'cg');
M_.param_names = char(M_.param_names, 'cgamma');
M_.param_names_tex = char(M_.param_names_tex, 'cgamma');
M_.param_names_long = char(M_.param_names_long, 'cgamma');
M_.param_names = char(M_.param_names, 'clandap');
M_.param_names_tex = char(M_.param_names_tex, 'clandap');
M_.param_names_long = char(M_.param_names_long, 'clandap');
M_.param_names = char(M_.param_names, 'cbetabar');
M_.param_names_tex = char(M_.param_names_tex, 'cbetabar');
M_.param_names_long = char(M_.param_names_long, 'cbetabar');
M_.param_names = char(M_.param_names, 'cr');
M_.param_names_tex = char(M_.param_names_tex, 'cr');
M_.param_names_long = char(M_.param_names_long, 'cr');
M_.param_names = char(M_.param_names, 'cpie');
M_.param_names_tex = char(M_.param_names_tex, 'cpie');
M_.param_names_long = char(M_.param_names_long, 'cpie');
M_.param_names = char(M_.param_names, 'crk');
M_.param_names_tex = char(M_.param_names_tex, 'crk');
M_.param_names_long = char(M_.param_names_long, 'crk');
M_.param_names = char(M_.param_names, 'cw');
M_.param_names_tex = char(M_.param_names_tex, 'cw');
M_.param_names_long = char(M_.param_names_long, 'cw');
M_.param_names = char(M_.param_names, 'cikbar');
M_.param_names_tex = char(M_.param_names_tex, 'cikbar');
M_.param_names_long = char(M_.param_names_long, 'cikbar');
M_.param_names = char(M_.param_names, 'cik');
M_.param_names_tex = char(M_.param_names_tex, 'cik');
M_.param_names_long = char(M_.param_names_long, 'cik');
M_.param_names = char(M_.param_names, 'clk');
M_.param_names_tex = char(M_.param_names_tex, 'clk');
M_.param_names_long = char(M_.param_names_long, 'clk');
M_.param_names = char(M_.param_names, 'cky');
M_.param_names_tex = char(M_.param_names_tex, 'cky');
M_.param_names_long = char(M_.param_names_long, 'cky');
M_.param_names = char(M_.param_names, 'ciy');
M_.param_names_tex = char(M_.param_names_tex, 'ciy');
M_.param_names_long = char(M_.param_names_long, 'ciy');
M_.param_names = char(M_.param_names, 'ccy');
M_.param_names_tex = char(M_.param_names_tex, 'ccy');
M_.param_names_long = char(M_.param_names_long, 'ccy');
M_.param_names = char(M_.param_names, 'crkky');
M_.param_names_tex = char(M_.param_names_tex, 'crkky');
M_.param_names_long = char(M_.param_names_long, 'crkky');
M_.param_names = char(M_.param_names, 'cwhlc');
M_.param_names_tex = char(M_.param_names_tex, 'cwhlc');
M_.param_names_long = char(M_.param_names_long, 'cwhlc');
M_.param_names = char(M_.param_names, 'cwly');
M_.param_names_tex = char(M_.param_names_tex, 'cwly');
M_.param_names_long = char(M_.param_names_long, 'cwly');
M_.param_names = char(M_.param_names, 'R');
M_.param_names_tex = char(M_.param_names_tex, 'R');
M_.param_names_long = char(M_.param_names_long, 'R');
M_.param_names = char(M_.param_names, 'crpis');
M_.param_names_tex = char(M_.param_names_tex, 'crpis');
M_.param_names_long = char(M_.param_names_long, 'crpis');
M_.param_partitions = struct();
M_.exo_det_nbr = 0;
M_.exo_nbr = 8;
M_.endo_nbr = 43;
M_.param_nbr = 59;
M_.orig_endo_nbr = 43;
M_.aux_vars = [];
options_.varobs = cell(1);
options_.varobs(1)  = {'dy'};
options_.varobs(2)  = {'dc'};
options_.varobs(3)  = {'dinve'};
options_.varobs(4)  = {'labobs'};
options_.varobs(5)  = {'pinfobs'};
options_.varobs(6)  = {'dw'};
options_.varobs(7)  = {'robs'};
options_.varobs_id = [ 4 5 6 1 3 7 2  ];
M_.Sigma_e = zeros(8, 8);
M_.Correlation_matrix = eye(8, 8);
M_.H = 0;
M_.Correlation_matrix_ME = 1;
M_.sigma_e_is_diagonal = 1;
M_.det_shocks = [];
options_.linear = 1;
options_.block=0;
options_.bytecode=0;
options_.use_dll=0;
M_.hessian_eq_zero = 1;
erase_compiled_function('SW_SS_static');
erase_compiled_function('SW_SS_dynamic');
M_.orig_eq_nbr = 43;
M_.eq_nbr = 43;
M_.ramsey_eq_nbr = 0;
M_.set_auxiliary_variables = exist(['./' M_.fname '_set_auxiliary_variables.m'], 'file') == 2;
M_.lead_lag_incidence = [
 0 22 0;
 0 23 0;
 0 24 65;
 0 25 0;
 0 26 0;
 0 27 0;
 0 28 0;
 1 29 0;
 2 30 0;
 0 31 0;
 0 32 66;
 0 33 0;
 0 34 67;
 3 35 68;
 4 36 69;
 5 37 0;
 0 38 70;
 0 39 0;
 0 40 0;
 0 41 0;
 0 42 0;
 0 43 71;
 0 44 0;
 0 45 72;
 6 46 73;
 7 47 74;
 8 48 0;
 0 49 75;
 9 50 76;
 10 51 77;
 11 52 0;
 12 53 0;
 13 54 0;
 14 55 0;
 15 56 0;
 16 57 0;
 17 58 0;
 18 59 0;
 19 60 0;
 20 61 0;
 0 62 0;
 21 63 0;
 0 64 0;]';
M_.nstatic = 15;
M_.nfwrd   = 7;
M_.npred   = 15;
M_.nboth   = 6;
M_.nsfwrd   = 13;
M_.nspred   = 21;
M_.ndynamic   = 28;
M_.equations_tags = {
};
M_.static_and_dynamic_models_differ = 0;
M_.exo_names_orig_ord = [1:8];
M_.maximum_lag = 1;
M_.maximum_lead = 1;
M_.maximum_endo_lag = 1;
M_.maximum_endo_lead = 1;
oo_.steady_state = zeros(43, 1);
M_.maximum_exo_lag = 0;
M_.maximum_exo_lead = 0;
oo_.exo_steady_state = zeros(8, 1);
M_.params = NaN(59, 1);
M_.NNZDerivatives = [173; -1; -1];
M_.params( 13 ) = .025;
ctou = M_.params( 13 );
M_.params( 24 ) = 1.5;
clandaw = M_.params( 24 );
M_.params( 41 ) = 0.18;
cg = M_.params( 41 );
M_.params( 3 ) = 10;
curvp = M_.params( 3 );
M_.params( 1 ) = 10;
curvw = M_.params( 1 );
M_.params( 9 ) = .24;
calfa = M_.params( 9 );
M_.params( 42 ) = 1.004;
cgamma = M_.params( 42 );
M_.params( 14 ) = 1.3808;
csigma = M_.params( 14 );
1.5;
M_.params( 46 ) = 1.02;
cpie = M_.params( 46 );
1.025;
M_.params( 18 ) = 1.6064;
cfc = M_.params( 18 );
1.5;
M_.params( 2 ) = 0.5187;
cgy = M_.params( 2 );
0.51;
M_.params( 12 ) = 5.7606;
csadjcost = M_.params( 12 );
M_.params( 15 ) = 0.7133;
chabb = M_.params( 15 );
M_.params( 20 ) = 0.7061;
cprobw = M_.params( 20 );
M_.params( 23 ) = 1.8383;
csigl = M_.params( 23 );
1.9423;
M_.params( 22 ) = 0.6523;
cprobp = M_.params( 22 );
M_.params( 19 ) = 1;
cindw = M_.params( 19 );
0.5845; 
M_.params( 21 ) = 1;
cindp = M_.params( 21 );
0.2432; 0.8; 0.47; 
M_.params( 10 ) = 0.5462;
czcap = M_.params( 10 );
M_.params( 26 ) = 2.0443;
crpi = M_.params( 26 );
1.488; 
M_.params( 29 ) = 0.8103;
crr = M_.params( 29 );
M_.params( 28 ) = 0.0882;
cry = M_.params( 28 );
M_.params( 27 ) = 0.2247;
crdy = M_.params( 27 );
M_.params( 58 ) = 0.5;
R = M_.params( 58 );
M_.params( 59 ) = 0.2751;
crpis = M_.params( 59 );
0.5;
M_.params( 30 ) = 0.9577;
crhoa = M_.params( 30 );
M_.params( 32 ) = 0.2194;
crhob = M_.params( 32 );
M_.params( 33 ) = 0.9767;
crhog = M_.params( 33 );
M_.params( 34 ) = 0.9928;
crhols = M_.params( 34 );
M_.params( 35 ) = 0.7113;
crhoqs = M_.params( 35 );
M_.params( 31 ) = 1;
crhoas = M_.params( 31 );
M_.params( 36 ) = 0.1479;
crhoms = M_.params( 36 );
0;
M_.params( 37 ) = 0.8895;
crhopinf = M_.params( 37 );
0;
M_.params( 38 ) = 0.9688;
crhow = M_.params( 38 );
0.97;
M_.params( 8 ) = 0.7010;
cmap = M_.params( 8 );
0.87;
M_.params( 7 ) = 0.8503;
cmaw = M_.params( 7 );
0.89;
M_.params( 6 ) = 0.1657;
constebeta = M_.params( 6 );
M_.params( 11 ) = 1/(1+M_.params(6)/100);
cbeta = M_.params( 11 );
M_.params( 43 ) = M_.params(18);
clandap = M_.params( 43 );
M_.params( 44 ) = M_.params(11)*M_.params(42)^(-M_.params(14));
cbetabar = M_.params( 44 );
M_.params( 45 ) = M_.params(46)/(M_.params(11)*M_.params(42)^(-M_.params(14)));
cr = M_.params( 45 );
M_.params( 47 ) = M_.params(11)^(-1)*M_.params(42)^M_.params(14)-(1-M_.params(13));
crk = M_.params( 47 );
M_.params( 48 ) = (M_.params(9)^M_.params(9)*(1-M_.params(9))^(1-M_.params(9))/(M_.params(43)*M_.params(47)^M_.params(9)))^(1/(1-M_.params(9)));
cw = M_.params( 48 );
M_.params( 49 ) = 1-(1-M_.params(13))/M_.params(42);
cikbar = M_.params( 49 );
M_.params( 50 ) = M_.params(42)*(1-(1-M_.params(13))/M_.params(42));
cik = M_.params( 50 );
M_.params( 51 ) = (1-M_.params(9))/M_.params(9)*M_.params(47)/M_.params(48);
clk = M_.params( 51 );
M_.params( 52 ) = M_.params(18)*M_.params(51)^(M_.params(9)-1);
cky = M_.params( 52 );
M_.params( 53 ) = M_.params(50)*M_.params(52);
ciy = M_.params( 53 );
M_.params( 54 ) = 1-M_.params(41)-M_.params(50)*M_.params(52);
ccy = M_.params( 54 );
M_.params( 55 ) = M_.params(47)*M_.params(52);
crkky = M_.params( 55 );
M_.params( 56 ) = M_.params(52)*M_.params(47)*(1-M_.params(9))*1/M_.params(24)/M_.params(9)/M_.params(54);
cwhlc = M_.params( 56 );
M_.params( 57 ) = 1-M_.params(47)*M_.params(52);
cwly = M_.params( 57 );
M_.params( 39 ) = 100*(M_.params(42)-1);
ctrend = M_.params( 39 );
M_.params( 40 ) = 100*(M_.params(45)-1);
conster = M_.params( 40 );
M_.params( 5 ) = 100*(M_.params(46)-1);
constepinf = M_.params( 5 );
M_.params( 4 ) = 0.5509;
constelab = M_.params( 4 );
0;
steady;
oo_.dr.eigval = check(M_,options_,oo_);
%
% SHOCKS instructions
%
M_.exo_det_length = 0;
M_.Sigma_e(8, 8) = (1)^2;
estim_params_.var_exo = [];
estim_params_.var_endo = [];
estim_params_.corrx = [];
estim_params_.corrn = [];
estim_params_.param_vals = [];
estim_params_.var_exo = [estim_params_.var_exo; 1, 0.4618, 0.01, 3, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 2, 0.1818513, 0.025, 5, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 3, 0.6090, 0.01, 3, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 4, 0.46017, 0.01, 3, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 5, 0.2397, 0.01, 3, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 6, 0.1455, 0.01, 3, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.var_exo = [estim_params_.var_exo; 7, 0.2089, 0.01, 3, 4, 0.1, 2, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 30, .9676, .01, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 32, .2703, .01, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 33, .9930, .01, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 35, .5724, .01, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 36, .3, .01, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 37, .8692, .01, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 38, .9546, .001, .9999, 1, 0.5, 0.20, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 8, .7652, 0.01, .9999, 1, 0.5, 0.2, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 7, .8936, 0.01, .9999, 1, 0.5, 0.2, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 12, 6.3325, 2, 15, 3, 4, 1.5, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 14, 1.2312, 0.25, 3, 3, 1.50, 0.375, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 15, 0.7205, 0.001, 0.99, 1, 0.7, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 20, 0.7937, 0.3, 0.95, 1, 0.5, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 23, 2.8401, 0.25, 10, 3, 2, 0.75, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 22, 0.7813, 0.5, 0.95, 1, 0.5, 0.10, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 19, 0.4425, 0.01, 0.99, 1, 0.5, 0.15, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 21, 0.3291, 0.01, 0.99, 1, 0.5, 0.15, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 10, 0.2648, 0.01, 1, 1, 0.5, 0.15, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 18, 1.4672, 1.0, 3, 3, 1.25, 0.125, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 26, 1.7985, 1.0, 3, 3, 1.5, 0.25, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 29, 0.8258, 0.5, 0.975, 1, 0.75, 0.10, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 28, 0.0893, 0.001, 0.5, 3, 0.125, 0.05, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 27, 0.2239, 0.001, 0.5, 3, 0.125, 0.05, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 5, 0.7, 0.1, 2.0, 2, 0.625, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 6, 0.7420, 0.01, 2.0, 2, 0.25, 0.1, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 4, 1.2918, (-10.0), 10.0, 3, 0.0, 2.0, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 39, 0.3982, 0.1, 0.8, 3, 0.4, 0.10, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 2, 0.05, 0.01, 2.0, 3, 0.5, 0.25, NaN, NaN, NaN ];
estim_params_.param_vals = [estim_params_.param_vals; 9, 0.24, 0.01, 1.0, 3, 0.3, 0.05, NaN, NaN, NaN ];
options_.irf = 30;
options_.nograph = 1;
options_.order = 1;
var_list_ = char();
info = stoch_simul(var_list_);
save('SW_SS_results.mat', 'oo_', 'M_', 'options_');
if exist('estim_params_', 'var') == 1
  save('SW_SS_results.mat', 'estim_params_', '-append');
end
if exist('bayestopt_', 'var') == 1
  save('SW_SS_results.mat', 'bayestopt_', '-append');
end
if exist('dataset_', 'var') == 1
  save('SW_SS_results.mat', 'dataset_', '-append');
end
if exist('estimation_info', 'var') == 1
  save('SW_SS_results.mat', 'estimation_info', '-append');
end
if exist('dataset_info', 'var') == 1
  save('SW_SS_results.mat', 'dataset_info', '-append');
end
if exist('oo_recursive_', 'var') == 1
  save('SW_SS_results.mat', 'oo_recursive_', '-append');
end


disp(['Total computing time : ' dynsec2hms(toc(tic0)) ]);
if ~isempty(lastwarn)
  disp('Note: warning(s) encountered in MATLAB/Octave code')
end
