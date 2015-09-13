function [c, info] = ecx (fnm, p, tc, x)
  %% [c, info] = ecx (fnm, p, tc, x)
  %% created 2002/06/10 by Bas Kooijman
  %% calculates EC(100x) values from parameter values
  %% function [c, info] = ecx (fnm, p, tc, x)
  %% fnm: character string with function name, eg magrowth or corepr
  %% p: 3-vector with parameters
  %% tc: n-vector with exposure times
  %% x: scaler between 0 and 1 with effect level, default is 0.5
  %% c: n-vector with EC(100x)-values
  %% info: n-vector with convergence codes; if successful, all are one

  global P X FNM t ;

  FNM = fnm; % copy to make global for 'fnecx'

  if exist('x', 'var') == 0
    X = 0.5;
  else
    X = x;
  end
  
  %% initiate output vector
  [nt i] = size(tc); c = ones(nt,1); info = ones(nt,1); 
  for i = 1:nt
    t = tc(i,1); % get exposure time
    ec = 5*p(1); % very rough initial estimate of 5 times NEC
    %% will give problems if response at ec is at blank level
    [c(i), err] = nmmin('fnecx', ec, p); % get true value from approximation
    info(i) = err;
    if err ~=1
      printf('No convergence \n');
    end
  end
