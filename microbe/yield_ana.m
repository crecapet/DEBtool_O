function Y = yield_ana(n)
  %% Y = yield_ana(n)
  %% created at 2007/06/24 by Bas Kooijman
  %% anabolic transformation of one compound into another
  %% n: 4,2-matrix with chemical indices for elements CHON
  %%    assumption: n(1,:) = 1
  %% Y: 4,1-vector with yield coefficients for compounds CHON

  Y = n(:,1); Y(1) = 0; Y(4) = n(4,1) - n(4,2);
  Y(2) = (n(2,1) - n(2,2) - 3 * Y(4))/ 2;
  Y(3) = (n(3,1) - n(3,2) - Y(2))/ 2;
