function Y = yield_cat(n)
  %% Y = yield_cat(n)
  %% created at 2007/06/24 by Bas Kooijman
  %% catabolic decomposition of a compound
  %% n: 4-vector with chemical indices for elements CHON
  %% Y: 4-vector with yield coefficients for compounds CHON

  Y = n(:); Y(2) = (n(2) - 3 * n(4))/ 2; Y(3) = (n(3) - 2 - Y(2))/ 2;
