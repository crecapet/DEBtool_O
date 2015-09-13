function [U0 Lb info] = initial_scaled_reserve(f, p, Lb0)
  %% [U0 Lb info] = initial_scaled_reserve(F, p)
  %% created 2007/08/06 by Bas Kooyman; modified 2007/09/14
  %% f: n-vector with scaled functional response
  %% p: 5-vector with parameters
  %% Lb0: optiona scalar with initial estimate for Lb 
  %% U0: n-vector with initial scaled reserve: M_E^0/ {J_EAm}
  %% Lb: n-vector with length at birth
  %% info: n-vector with ones for successful convergence; else zeros
  
  %% unpack parameters
  VHb  = p(1); % d mm^2, scaled maturity at birth: M_H^b/ ((1 - kap) {J_EAm})
  g   = p(2); % -, energy investment ratio
  kJ  = p(3); % 1/d, maturity maintenance rate coefficient
  kM  = p(4); % 1/d, somatic maintenance rate coefficient
  v   = p(5); % mm/d, energy conductance
  %% if kJ = kM: VHb = g * Lb^3/ v;
  %% if Lb is given: see get_ue0
  
  nf = length(f); U0 = zeros(nf,1); Lb = zeros(nf,1); info = zeros(nf,1);
  q = [g; kJ/ kM; VHb * g^2 * kM^3/ v^2]; % pars for get_lb
  if exist('Lb0', 'var') == 1
    lb0 = ones(nf,1) .* Lb0 * kM * g/ v;
  else
    lb0 = ones(nf,1) * get_lb(q,f(1)); % initial estimate for scaled length
  end
  for i = 1:nf
    [lb, info(i)] = get_lb(q, f(i), lb0(i));
    %% try get_lb1 or get_lb2 for higher accuracy
    Lb(i) = lb * v/ kM/ g;
    uE0 = get_ue0(q, f(i), lb);
    U0(i) = uE0 * v^2/ g^2/ kM^3;
  end
