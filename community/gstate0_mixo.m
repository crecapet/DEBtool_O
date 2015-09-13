function [X info] = gstate0_mixo (X_t)
  %% [X info] = gstate0_mixo (X_t)
  %% gets steady states from initial estimates for 0-reserve mixotrophs
  %% calls findstate0

  global j_L_F Ctot Ntot n_NV
  
  %% X_t = state0(Ctot, Ntot);
  X = zeros(4,1);
  [X([3 4]), info] = fsolve('findstate0_mixo',X_t([3 4]));
  D = X(3); V = X(4);
  
  X(1) = Ctot - D - V;
  X(2) = Ntot - n_NV*D - n_NV*V;

  if (0 == prod(X > 0)) || (info ~= 1) % no positive solution
    %% printf (['No pos. equil. for Light = ', num2str(j_L_F), ...
    %%	     '; Ctot = ', num2str(Ctot), ...
    %%	     '; Ntot = ', num2str(Ntot), ' on L-lim branch\n']);
    X = [Ctot Ntot 0 0]'; % end of branch
    info = 'E';
  else
    info = 'L';
  end
