function [p, U0b] = iget_pars_g(par, F)
  %% [p, U0b] = iget_pars_g(par, F)
  %% Bas Kooijman, 2006/10/01, modified 2007/08/07
  %% par: 4-vector with
  %%   1 VHb   % scaled maturity at birth
  %%   2 g     % energy investment ratio
  %%   3 kM    % somatic maintenance rate coefficient
  %%   4 v     % energy conductance
  %% F: scalar with scaled functional response (optional)
  %% p: 5-vector with: f, L_b, L_i, a_b, \dot{r}_B
  %% U0b: (2,n)-matrix with:
  %%   U^0 = M_E^0/\{\dot{J}_{EAm}\}, U^b = M_E^b/\{\dot{J}_{EAm}\}
  %% calls dget_au, fniget_pars_g
  %% get_pars_g is inverse to iget_pars_g

  if exist('F', 'var') == 0
    f = 1; % abundant food
  else
    f = F; % to make scaled functional response global
  end
 
  %% unpack input parameters
  VHb = par(1); % scaled maturity at birth
  g   = par(2); % energy investment ratio
  kM  = par(3); % somatic maintenance rate coefficient
  v   = par(4); % energy conductance

  Lb = (VHb * v/ g)^(1/3);       % length at birth
  rB = kM * g/ (3 * (f + g));    % von Bert growth rate
  Lm = v/ (kM * g); Li = f * Lm; % max, ultimate length
  lb = Lb/ Lm;                   % scaled length at birth
  U0 = get_ue0([g, 1], f, lb) * v^2/ g^2/ kM^3;
  %% initial scaled reserve M_E^0/{J_EAm}

  ab = get_tb([g 1], f, lb)/ kM;
  Ub = f * Lb^3/ v;

  U0b = [U0; Ub];
  p = [f; Lb; Li; ab; rB];
