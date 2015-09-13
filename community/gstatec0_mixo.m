function [X info]= gstatec0_mixo (X_t)
  %% [X info]= gstatec0_mixo (X_t)
  %% gets steady states from initial estimates for 0-reserve mixotrophs
  %% calls findstatec0_mixo
  %% info =
  %%   'C' carbon limitation
  %%   'E' no positive equilibria

  global j_L_F Ctot Ntot n_NV;

  %% C limitation
  XC = zeros(4,1);
  [XC([1 3]), info] = fsolve('findstatec0_mixo',X_t([1 3]));
  C = XC(1); D = XC(3);
  
  V = Ctot - C - D;
  XC(4) = V;
  XC(2) = Ntot - n_NV*D - n_NV*V; % N

  if (0 == prod(XC > 0)) || (info ~= 1) % no positive solution
    %% printf (['No pos. equil. for Light = ', num2str(j_L_F), ...
    %%	     '; Ctot = ', num2str(Ctot), ...
    %%%	     '; Ntot = ', num2str(Ntot), ' on C-lim branch \n']);
    X = [Ctot Ntot 0 0]'; % end of branch
    info = 'E';
  else
    X = XC; % C limitation
    info = 'C';
  end
 