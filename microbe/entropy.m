function s = entropy(n)
  %% s = entropy(n)
  %% created at 2007/06/24 by Bas Kooijman
  %% catabolic decomposition of a compound
  %% n: 4-vector with chemical indices for elements CHON
  %%   C: CO2; H: H2O; O: O2; N: NH3
  %% s: entropy of compound CHON in J/mol.K
  sCHON = [214.70 72.331 205.80 112.34]; % spec entropies for C H O N
  s = sCHON * yield_cat(n); % J/mol.K
