function [ihaz, haz] = fohaz (p, tc)
  %% [ihaz, haz] = fohaz (p, tc)
  %% created 2002/06/04 by Bas Kooijman
  %% standard effects on survival: first-order-mortality
  %%  first order toxico kinetics
  %%  hazard rate linear in the internal conc
  %% function f = fohaz (p, tc)
  %% p:  (4,k) matrix with parameters values in p(:,1) (see below)
  %% tc: (n,2) matrix with exposure times and concentrations
  %% ihaz: (n,1) matrix with integrated hazard rates
  %% haz: (n,1) matrix with hazard rates

  %% application is illustrated in script-file mydata_fohaz
  %% routine called by phaz
  
  p = p(:,1); % first column only, unpack parameters for easy reference
  h = p(1);  % 1/h, blank mortality prob rate (always >0)
  c0 = p(2); % mM, No-Effect-Concentration (external, may be zero)
  b = p(3);  % 1/(h*mM), killing rate
  k = p(4);  % 1/h, elimination rate

  [n k] = size(tc);
  t0 = -log(max(1e-8,1-c0./max(1e-8,tc(:,2))))/k; % no-effect-time
  ihaz = (b/k)*max(0,e.^(-k*t0) - e.^(-k*tc(:,1)).*tc(:,2) - ...
          b*(max(0,tc(:,2)-c0))).*max(0,tc(:,1) - t0);
  ihaz = h * tc(:,1) - min(0,ihaz);

  haz = h * tc(:,1) + max(0, b * (1 - e.^(-k * tc(:,1)) .* tc(:,2) - c0));
