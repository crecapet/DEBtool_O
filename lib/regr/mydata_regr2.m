%% created: 2001/08/28 by Bas Kooijman; modified 2006/05/25
%% sample data for regr2 routines (for a response-surface)
%%   the defenitions are a natural extension of those for regr routines

%% set dependent variables, data, weights, parameters
x = [0.5 1 2 3 4]';
y = [1 2 3]';
zdata = [.1 1 1.8 2 2.4; 1.2*[.1 1 1.8 2 2.4]; 1.8*[.1 1 1.8 2 2.4]]';
weights = ones(5,3); weights(3,[2 3]) =0; %% kick out zdata(3,[2 3])
ipars = [1 3 1]';

%% define a function of 2 variables
function f = hype(p, x, y)
  %% p:(1) etc ..
  f = (x./ (p(1) + x)) * (p(2) * e .^ (p(3) * y))';
endfunction

%% %% estimate parameter values, starting from ipars:
%% pars = nrregr2 ('hype', ipars, x, y, zdata) %% using Newton Raphson
%% %% or with the specification of weights, if different from ones:
%% pars = nrregr2 ('hype', ipars, x, y, zdata, weights) %% using Newton Raphson
%% %% or alternatively:
%% pars = nmregr2 ('hype', ipars, x, y, zdata) %% using Nelder Mead
%% %% or alternatively:
%% adjust initial parameter values for use in genetic algorith
%% first column is not used; iterate (yes); range (0,10)
ipars = [1 1 0 10;3 1 0 10; 1 1 0 10];
pars = garegr2 ('hype', ipars, x, y, zdata) %% using a genetic algorithm

%% %% show regression results
%% shregr2('hype', pars, x, y, zdata)
%% %% or in a 3-D plot
%% shregr2_options('all_in_one', 1); shregr2('hype', pars, x, y, zdata)
%% %% get weighted sum of squared deviations
%% ssq2('hype', pars, x, y, zdata)
%% %% obtain parameter statistics
%% [cov cor sd ss] = pregr2('hype', pars, x, y, zdata, weights)

