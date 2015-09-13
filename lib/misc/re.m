function a = re(c)
  %% a = re(c)
  %% created at 2002/21/05 by Bas Kooijman
  %% calculates the real part of c
  %% a = re(c)
  %% c: matrix with complex numbers
  %% a: matrix with real part of c

  [nr nc] = size (c); c = c(:);
  a = (c + c'(:))/2;
  a = reshape(a,nr,nc);
  