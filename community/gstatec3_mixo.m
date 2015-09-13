function [X info]= gstatec3_mixo (X_t)
  %% [X info]= gstatec3_mixo (X_t)
  %% gets steady states from initial estimates for 3-reserve mixotrophs
  %% calls findstatec3_mixo
  %% info =
  %%   'C' carbon limitation
  %%   'E' no positive equilibria

  global j_L_F Ctot Ntot n_NV n_NE n_NEN;

  %% C limitation
  XC = zeros(8,1);
  XC([1 3 4 6 7 8]) = fsolve('findstatec3_mixo',X_t([1 3 4 6 7 8]));
  C = XC(1); DV = XC(3); DE = XC(4); E = XC(6); EC = XC(7); EN = XC(8);
  
  V = Ctot - C - DV - DE - E - EC;
  XC(5) = V;
  XC(2) = Ntot - n_NV*DV - n_NE*DE - n_NV*V - n_NE*E - n_NEN*EN;

  if (0 == prod(XC > 0)) % no positive solution
    printf (['No pos. equil. for Light = ', num2str(j_L_F), ...
	     '; Ctot = ', num2str(Ctot), ...
	     '; Ntot = ', num2str(Ntot), ' on C-lim branch \n']);
    X = [Ctot Ntot 0 0 0 0 0 0]'; % end of branch
    info = 'E';
  else
    X = XC; % C limitation
    info = 'C';
  end
  