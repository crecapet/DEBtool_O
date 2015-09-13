function [equi, p] = varpar (fn, X0, par, start, stop, np)
  %% [equi, p] = varpar (fn, X0, par, start, stop, np)
  %% Created: 1 aug 2000 by Bas Kooijman
  %% Finds equilibrium of a set of ode's as a function of one parameter

  %% Usage: [par, equi] = varpar ('fn_name', initial_values,
  %%                              'par_name', start, stop, n)
  %%   fn_name: name of function that defines a set of ode's (see lsode)
  %%   initial_values: vector of values of variables for which ode's
  %%     are given; used to obtain equilibrium value by integration 
  %%   par_name: name of parameter that is changed
  %%   start: first value of parameter that is changed
  %%   stop: last value of parameter that is changed
  %%   n: number of parameter values for which equilibrium is evaluated 
  %%   par: (n, 1)-matrix of parameter values
  %%   equi: (n, k)-matrix of equilibrium values
  %%
  %% The ode's are first integrated to obtain an initial guess for the
  %% equilibrium values, given parameter value equals `start'.
  %% The equilibrium values serve as initial guesses for the next parameter
  %% value. This assumes that the system has a point attractor at
  %% parameter value `start'. The used-defined function fn_name should
  %% define the parameter as global.
  %%
  %% Requires: int2equi
  %%           user-defined function 'fn_name' for ode's, see lsode
  %%           global parameter 'par_name'
  %% See also: varpar2

  eval(['global ', par, ';']);
  eval(['value = ', par, ';']); % grab current value of parameter

  %% fill output for p, and initiate equi
  p = linspace (start, stop, np); p = p.';
  [nr, nc] = size(X0); equi = zeros (np, nc);

  Xi = X0;
  
  for i = 1:np
    eval([par, ' = p(i);']);
    [Xi, info] = int2equi (fn, Xi); % use earlier value as start
    equi(i,:) = Xi.';               % collect results in matrix

    if info ~= 1
      perror('fsolve', info);       % print trouble report
    end

  end
  eval([par, ' = value;']);         % restore value of parameter
