function [tb info] = get_tb_foetus(par, tb0)
  %% [tb, info] = get_tb_foetus(par, tb0)
  %% Bas Kooijman, 2007/07/28; modified 2011/01/20
  %% par: 3-vector with
  %%   1 g     % energy investment ratio
  %%   2 k     % ratio of maturity and somatic maintenance rate coefficients
  %%   3 vHb   % scaled maturity at birth
  %%             (g^2 k_M^3/ v^2) M_H^b/ ((1 - kap) {J_EAm})
  %% tb: scalar with scaled aged at birth tau_b = a_b k_M
  %% info: scalar for numerical convergence

  global k g vHb % for fnget_tb_foetus

  %% unpack input parameters
  g   = par(1); % energy investment ratio
  k   = par(2); % ratio of maturity and somatic maintenance rate coefficients
  vHb = par(3); % scaled maturity at birth
  %%              (g^2 k_M^3/ v^2) M_H^b/ ((1 - kap) {J_EAm})

  if exist('tb0', 'var') == 0
    lb = vHb^(1/ 3); % exact solution for k = 1
    tb = 3 * lb/ g;
    if k == 1
      info = 1;
      return;
    end
  else
    tb = tb0;
  end
  
  if 1
    [tb, info] = fzero('fnget_tb_foetus', tb);
  else
    nmregr_options('default');
    nmregr_options('report', 0);
    [tb, info] = nmregr('fnget_tb_foetus', tb, zeros(1,2));
  end
