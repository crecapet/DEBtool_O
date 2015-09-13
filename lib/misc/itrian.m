function r = itrian  (m)
  %% r = itrian  (m)
  %% Created: 2002/04/09 by  Bas Kooijman
  %% wraps the upper triangular elements of an upper triangular matrix
  %%   into a vector; This function is inverse to "trian"
  %% Requires: -
 
  [n,k] = size(m);
  if n~=k 
    fprintf('impropor size of argument \n');
    r = []; return;

  elseif n == 1
    r=m; return;
  else
    nr = n*(n-1)/2; r = zeros(nr,1); c = 0;
    for i = 1:n
      r(c + (i:n)) = m(i,i:n);
      c = c + n - i;
    end
  end
