%% %% created: 2001/08/28 by Bas Kooijman; modified 2006/05/28, 2006/10/05
%% %% sample data for regr routines

%% we need "cat" from DEBtool/lib/misc for nmregr and garegr

%% %% example of function definition; here a hyperbola
%% %% set initial parameter estimates
%% %%  (do this first to make this file a script file)
hpars = [3.5 2.8]';

function f = hyp(p, xyw)
  %% p: (1) maximum (2) saturation coefficient
  f = p(1) * xyw(:,1)./ (p(2) + xyw(:,1));
endfunction

function f=bert(p, xyw)
  %% von Bertalanffy growth curve
  %% p: (1) init value for von Bert (2) max for von Bert (3) growth rate
  f = p(2) - (p(2) - p(1)) * e.^(- p(3) * xyw(:,1));
endfunction

function [f1 f2] = hypbert (p, xyw1, xyw2)
  %% hyperbolic functional response and von Bert curve
  %% p:(1) max for hyperbola (2) saturation coefficient
  %%   (3) init value for von Bert (3) max for von Bert (4) growth rate
  f1 = p(1) * xyw1(:,1)./ (p(2) + xyw1(:,1));
  f2 = p(4) - (p(4) - p(3)) * e.^(- p(5) * xyw2(:,1));
endfunction

data = [0.1 1 2 3 4; 0.1 1 1.8 2 2.4]';

switch 3 % change this number for other options
    case 1
      %% %% show a plot of the function;
      shregr('hyp', hpars,[0 3]')
    case 2
      %% estimate the parameter values:
      nrregr_options('max_step_size',.1);
      hpars = [3.5 1; 2.8 1];
      pars = nrregr('hyp', hpars, data) %% using Newton-Raphson
    case 3 %%  or alternatively:
      pars = nmregr('hyp', hpars, data) %% using Nelder-Mead
      %%  or alternatively:
    case 4
      pars = nmvcregr('hyp', pars, data) %% using Nelder-Mead with sd
      %% propto mean
      %% using genetic algorithm (not advisable in this simple case)
      garegr_options('max_step_number',500);
      %% adjust parameter settings for application in garegr
      hpars = [3.5 1 1e-6 10; 2.8 1 1e-6 5];
      %% the initial values 3.5 & 2.8 are not used
      %% column 2 indicates iteration in both parameters
      %% only the ranges (1e-6,10) & (1e-6,5)
      pars = garegr('hyp', hpars, data) %% using genetic algorithm
      %% now run nrregr on the result op garegr for 'fine-tuning'
      pars = nrregr('hyp', pars, data) %% using genetic algorithm
    case 5
      %% show goodness of fit:
      shregr('hyp', pars, data)
    case 6
      %% get weighted sum of squared deviations:
      ssq('hyp', pars, data)
      %% obtain parameter statistics:
      [cov, cor, sd, ss] = pregr('hyp', pars, data)
    case 7
      %% Another example using the same data matrix:
      %% fix parameter number 2 
      bpars = [0 3 .5; 1 0 1]';
      p = nrregr('bert', bpars, data)
      shregr('bert', p, data)
      [cov, cor, sd, ss] = pregr('bert', p, data)
    otherwise
      %% Another example with two data sets;
      %%  The example is silly because the data sets have no parameters
      %%  in common, so there is no reason to combine the functions in
      %%  a single definition

      %% set initial parameter values, and fix parameter number 3
      hbpars = [1 3 0 3 .5; 1 1 0 1 1]';

      %% obtain parameter estimates:
      p = nrregr('hypbert', hbpars, data, data)
      %% show regression of each data set:
      shregr_options('default'); shregr('hypbert', p, data, data)
      %% show regression results in one graph:
      %% shregr_options('all_in_one', 1); shregr('hypbert', p, data, data)
  end
 