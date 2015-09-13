%% this script-file illustrates the use of fomort
%%   for the analysis of toxic effects on the survival of individuals
%% created 2001/09/14 by Bas Kooijman, modified 2009/02/20

%% exposure times in days
t = [0 7]';
%% dieldrin concentrations in mug/l
c = [0 .32 5.6 10 18 32 56 100]';
%% surviving guppies, data from IMW-TNO
N = [20*ones(1,8); 20 18 18 8 2 0 0 0];
%% parameter values: first guesses
h = 0.008; % 1/d, hazard rate in the blank
c0 = 2.77; % mug/l, no-effect concentration
b = 0.3; % 1/(d*mug/l), killing rate
k = 0.72; % 1/d, elimination rate
%% collect parameter values in a (4,1) matrix
par = [h, c0, b, k]'; % indicate all parameters to be estimated
%% par = [1e-8, c0, b, k; 0 1 1 1]'; % keep nat. mort. rate fixed at zero

%% set path to library routines

%% parameter estimation
p0 = nmsurv2('fomort', par, t, c, N); % use NM-method for first estimate
p1 = scsurv2('fomort', p0, t, c, N); % refine estimate with SC-method
[cov, cor, sd, dev] = psurv2('fomort', p1, t, c, N); % get statistics
[p0, p1, sd] % present ml-estimates and asymptotic standard deviations

%% data and model presentation
%% shregr2_options('all_in_one', 1);
shregr2_options('default');
shregr2_options('xlabel',1, 'exposuretime, d');
shregr2_options('xlabel',2, 'exposuretime, d');
shregr2_options('ylabel',1, ' dieldrin, mug/l');
shregr2_options('ylabel',2, 'fraction of surv guppies');

shsurv2('fomort', p, t, c, N);

%% get profile likelihood for the NEC (parameter 2)
%% p = [p, [1 2 1 1]'];
%% proflik = plsurv2('fomort', p, t, c, N, [0 10]);
%% plot(proflik(:,1), proflik(:,2), 'r')