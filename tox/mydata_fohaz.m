%% this script-file illustrates the use of fohaz via lfohaz
%%   for the analysis of toxic effects on the survival of individuals
%% created 2002/06/04 by Bas Kooijman, modified 2009/02/20
%% like fomort, but time-to-death observations are made for each individual

%% time-to-death in days; "experiment" terminated ar time 21
%% in this example 4 individuals are still alive at the end of the experiment
%%    if at conc 4.6 an individual is taken alive out of the experiment
%%    at time 3.4, we should append a row "3.4 4.6 0"
tci = [21 0 0;
       21 0 0;
       20 0 1;
       21 0 0;
       21 1 0;
       20 1.1 1;
       20 0.9 1;
       18 1.2 1;
       16 1.3 1;
       16 1.4 1;
       15 1.5 1;
       10 2 1;
       9 1.8 1;
       6 2.2 1;
       5 2.5 1;
       2 3 1;
       2 4.3 1;
       1 5 1;
       1 4.5 1;];

%% parameter values: first guesses
h = 0.1; % 1/d, hazard rate in the blank
c0 = 1.77; % mug/l, no-effect concentration
b = 0.3; % 1/(d*mug/l), killing rate
k = 0.72; % 1/d, elimination rate
%% collect parameter values in a (4,1) matrix
par = [h, c0, b, k]'; % indicate all parameters to be estimated
%% par = [1e-8, c0, b, k; 0 1 1 1]'; % keep nat. mort. rate fixed at zero

%% set pathe to library routines


%% parameter estimation
p = nmmin('lfohaz', par, tci) % use NM-method to find ML estimates
%% it will find:
%% h=  0.061225
%% c0= 1.927783
%% b=  0.334752
%% k=  0.754273
