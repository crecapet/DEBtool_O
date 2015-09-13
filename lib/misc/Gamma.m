function G = Gamma(x, a)
  %% G = Gamma(x, a): incomplete Gamma function
  %% 2009/08/04 by Bas Kooijman
  
  if exist('a', 'var') == 0
    a = 0;
  end
    
  G = gamma(a) * (1 - gammainc(x, a));