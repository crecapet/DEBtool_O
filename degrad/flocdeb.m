function [c, b, d] = flocdeb (p, tcw, tbw, tdw)
  %% [c, b, d] = flocdeb (p, tcw, tbw, tdw)
  %% created at 2002/10/31 by Bas Kooijman
  %% calculates concentrations of substrate and
  %%  microbial biomass as functions of time in a batch culture
  %%  using the deb model for flocs
  %% p: parameter vector, initial values and see dflocdeb
  %% tcw: (nc,k) matrix with times in column 1
  %% tbw: (nb,k) matrix with times in column 1
  %% tdw: (nd,k) matrix with times in column 1
  %% c: (nc,1) matrix with calculated concentrations
  %% b: (nb,1) matrix with calculated living biomass
  %% d: (nd,1) matrix with calculated dead biomass

  global par;
  par = p(6:13);  % copy parameters for transfer to routine dflocpirt
  
  x0 = p(1:5); % initial values for concentration and living structure,
				% reserve density, dead structure, dead reserve
  
  c = lsode('dflocdeb', x0, tcw(:,1)); c = c(:,1);
  b = lsode('dflocdeb', x0, tbw(:,1)); b = b(:,2);
  d = lsode('dflocdeb', x0, tdw(:,1)); d = d(:,4);
  %% column 3 has reserve densities, but these are not assumed to be measured  
