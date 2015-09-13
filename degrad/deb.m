function [c, b] = deb (p, tcw, tbw)
  %% [c, b] = deb (p, tcw, tbw)
  %% created at 2002/10/28 by Bas Kooijman
  %% calculates concentrations of substrate and
  %%  microbial biomass as functions of time in a batch culture
  %%  using the DEB model
  %% p: parameter vector, see initial values and ddeb
  %% tcw: (nc,k) matrix with times in column 1
  %% tbw: (nb,k) matrix with times in column 1
  %% c: (nc,1) matrix with calculated concentrations
  %% b: (nb,1) matrix with calculated biomass (= structure)

  global par;
  par = p(3:7);   % copy parameters for transfer to routine ddeb

  %% initial values for concentration, structure, max scaled res density
  x0 = [p(1:2,1); p(4)/(p(6)*p(5))]; 
  
  c = lsode('ddeb', x0, tcw(:,1)); c = c(:,1); % concentration of substrate
  b = lsode('ddeb', x0, tbw(:,1)); b = b(:,2); % structure
  







