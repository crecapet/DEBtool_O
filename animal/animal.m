%% Copyright (C) 2000 Bas Kooijman
%  Author: Bas Kooijman <bas@bio.vu.nl>
%  Created: 2000/10/18, modified 2011/02/03
%  Keywords: Metabolism of an individual animal
% 
%  This program is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
% 
%  This script has been coded and tested in Matlab version 7.3
%  This script can be obtained from http://www.bio.vu.nl/thb/deb/deblab/
%    new versions are indicated by the date of modification
%  The manual is in subdirectory "manual" in package "debtool"
%    load file "index.html" in a browsers, such as Firefox
% 
%  Usage: animal
%    Calculates statistics and produces plots of state variables and fluxes.
%    The parameters in the routine "pars_animal" can be modified
%    The feeding coditions in the routine "statistics" can be modified
 
%% The theory for the standard DEB model can be found in:
%    Kooijman, S. A. L. M. 2010 Dynamic Energy Budgets theory
%    for metabolic organisation. Cambridge University Press.
% 
%  The standard DEB model accounts for:
%    effects of food availability (X) and temperature (T).
%    These environmental parameters are taken to be constant in pars_animal
%    but other routines let them vary in time.
%
%  The animal is decomposed in structure (V) and general reserve (E),
%    and metabolic switching is linked to maturity (H)
%  The animal developes through an embryonic, juvenile and adult phase.
%    Assimilation is switched on at birth
%    Investment in maturity is redirected to reproduction at puberty
%  Organic compounds:
%    X = food, V = structure, E = reserve, P = faeces
%  Mineral compounds:
%    C = carbon dioxide, H = water, O = dioxygen, N = nitrogen waste
% 
%  Uptake is proportional to surface area, which is taken to be
%    proportional to the structural volume^(2/3): isomorph

pars_animal % set parameters and compute quantities

lsode_options('relative tolerance', 1e-3)

clf;shbirth_pie;
fprintf('hit a key to proceed \n');
pause; close all;

clf;shmics;
fprintf('hit a key to proceed \n');
pause;

clf;shtime_animal;
fprintf('hit a key to proceed \n');
pause;

clf;shphase;
fprintf('hit a key to proceed \n');
pause;

clf;shflux;
fprintf('hit a key to proceed \n');
pause;

clf;shflux_struc;
fprintf('hit a key to proceed \n');
pause;

clf;shflux_weight;
fprintf('hit a key to proceed \n');
pause;

clf;shratio;
fprintf('hit a key to proceed \n');
pause;

clf;shpower;
fprintf('hit a key to proceed \n');
pause;

clf;shscale;