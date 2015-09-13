%% %% created: 2001/09/11 by Bas Kooijman; modified 2006/05/25
%% %% sample data for surv routines

%% %% set initial parameter estimates
%% %%  (do this first to make this file a script file)
par = .3;

%% %% example of function definition;
function f = expon(p, tn)
  %% p: (1) exponential decay
  f = e.^(-p(1) * tn(:,1));
endfunction


%% %% show a plot of the function:
%%   shsurv('expon', par, [0 3]')

data = [0 1 2 3 4; 10 7 5 4 3]';

%% %% estimate the parameter values:
par = scsurv('expon', par, data) %% using scores
%% %%  or alternatively:
par = nmsurv('expon', par, data) %% using Nelder-Mead
%% %%  or alternatively: adapt initial par for genetic algorithm
par = [1 1 0 1]; % value (not used), iteration (yes), range: (0,10)
par = gasurv('expon', par, data) %% using a genetic algorithm

%% %% show goodness of fit:
%%   shsurv('expon', par, data)
%% %% get deviance:
%%   dev('expon', par, data)
%% %% obtain parameter statistics:
%%   [cov, cor, sd, d] = psurv('expon', par, data)

function [f1, f2] = expon2(p, tn1, tn2)
  %% p: (1,2) exponential decay
  f1 = e.^(-p(1) * tn1(:,1));
  f2 = e.^(-p(2) * tn2(:,1));
endfunction

%% %% estimate the parameter values:
%%   par = scsurv('expon2', [.2 .5]', data, data) %% using scores
