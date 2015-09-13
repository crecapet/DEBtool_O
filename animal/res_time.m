function tE  = res_time(l, f, p)
  %% tE = res_time(l, f, p)
  %% created 2009/01/15 by Bas Kooijman
  %% l: n-vector with scaled length
  %% f: scalar with functional response
  %% p: 3-vector with parameters: kM g lT
  %% tE: n-vector with residence times of reserve "molecules" in reserve

  % unpack parameters
  kM   = p(1);  % 1/d, somatic maint rate coeff
  g    = p(1);  % -, energy investment ratio
  lT   = p(2);  % -, scaled heating length
  
  pC = f * l .^ 2 .* (g + l + lT)/ (g + f);   % -, scaled mobilisation power
  tE = f * l .^3 ./ pC/ g/ kM;