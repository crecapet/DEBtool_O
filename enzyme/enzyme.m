%% Copyright (C) 2000 Bas Kooijman
%% Author: Bas Kooijman <bas@bio.vu.nl>
%% Created: 2000/10/16, modified 2009/02/20
%% Keywords: Enzyme kinetics for the transformation
%%                    n_A A + n_B B -> n_C C
%%
%% This program is distributed in the hope that it will be useful, but
%% WITHOUT ANY WARRANTY; without even the implied warranty of
%% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
%%
%% This script has been coded and tested in
%%   Octave version 2.0.13: http://www.che.wisc.edu/octave/
%%   gnuplot version 3.7: http://www.gnuplot.org/
%% This script can be obtained from http://www.bio.vu.nl/thb/deb/deblab/
%%   new versions are indicated by the date of creation
%%
%% Usage: enzyme
%%   Produces plots of fluxes.
%%   The parameters in the routine "pars" can be modified.
 
%% The theory for the model can be found in:
%%   Kooijman, S. A. L. M. 2000 Dynamic Energy and Mass Budgets in
%%   Biological Systems. Cambridge University Press.
%% You can download a concepts-paper from http://www.bio.vu.nl/thb/deb/
%%

pars_enzyme;

%% pipe_gnuplot;
shcontsu;
fprintf(stderr, 'hit a key to proceed \n');
pause;

shbatch;
fprintf(stderr, 'hit a key to proceed \n');
pause;

