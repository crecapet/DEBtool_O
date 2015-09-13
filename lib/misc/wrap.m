function b = wrap (a, nr, nc)
  %% b = wrap (a, nr, nc)
  %% Created: 28 aug 2000 by Bas Kooijman
  %% unravel matrix a and wrap it into a (nr, nc) matrix, repeating elements
  %% Requires: -
  
  b = zeros(nr, nc);
  a = a(:);                % unravel a
  [m, n] = size (a);       % n =1

    for i = 1:nr
      for j = 1:nc
	k = j + (i-1)*nc; k = k - m*floor((k-1)/m);
	b(i,j) = a(k);	
      end
    end
  