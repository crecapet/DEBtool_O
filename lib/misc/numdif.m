function df = numdif(fn, x)
  %% df = numdif(fn, x)
  %% Created: 28 aug 2000 by Bas Kooijman
  %% numerical differiation of user defined function "fn" with respect to
  %%   vector-valued argument x
  %% Requires: user-defind function "fn"  

  n = max(size(x)); h = 0.0001;
  df = zeros(n);
  for i = 1:n
    y = x; y(i) = y(i) + h;
    z = x; z(i) = z(i) - h;
    eval(['df(:,i) = (', fn, '(y) - ', fn, '(z))/(2*h);']);
  end
    
