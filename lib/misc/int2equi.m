function  [X info] = int2equi (fn, X0)
  %% [X info] = int2equi (fn, X0)
  %% Created: 28 aug 2000 by Bas Kooijman 
  %% Integration of a set of ode's specified by "fn" by "lsode"
  %%   till equilibrium, but switch to "fsolve" if derivetives are small
  %%   fn: string, for user-defined function of structure dX = fn (X)
  %%       dX, X are vectors of equal lengths
  %%   X0: vector, value of vector X at t=0
  %% Requires: userdefined function "fn"

  norm = 1 ;          % d^-2, norm on derivatives for switch to Newton
  dt = 50;            % integration period
  imax = 10;          % max number of integration blocks

  i = 0; X0 = X0(:);
  while i <= imax     % start solve/integration procedure
    eval(['dx = ', fn, '(X0);']);
    dx = dx./max(1e-4, X0); % calculate relative change
    if dx'*dx < norm
      [X info] = fsolve(fn, X0); % we first try to find value directly
      X = X(:);
      if info == 1
        return;                % solution found 
      end
    end
  i = i + 1; % if direct search failed, we integrate and try again
  Xt = lsode(fn, X0, [0 dt]); X0 = Xt(2,:)'; % new start value in X0
  end
 
  if i >= imax
    info = 0;
    fprintf(['warning: no convergence within ', num2str(imax), ' steps \n']);
  else
    info = 1;
  end
  