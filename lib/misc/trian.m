function m = trian  (r)
  %% m = trian  (r)
  %% Created: 2002/04/09 by  Bas Kooijman
  %% wraps vector-argument into an upper triangular matrix
  %% Requires: -

  nr = length(r);
  n = sqrt(0.25 + 2*nr) - 0.5;
  if 0 == n - floor(n)
    m = zeros(n); c = 0;
    for i = 1:n
      m(i,i:n) = r(c + (i:n));
      c = c + n - i;
    end
  else
    m = [];
    fprintf('impropor size of argument \n');
  end
  