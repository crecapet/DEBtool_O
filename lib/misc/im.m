function a = im(c)
  %% a = im(c)
  %% created at 2002/21/05 by Bas Kooijman
  %% calculates the imaginary part of c
  %% a = im(c)
  %% c: matrix with complex numbers
  %% a: matrix with imaginary part of c

  [nr nc] = size (c); c = c(:);
  a = -i * (c - c'(:))/2;
  a = reshape(a,nr,nc);
