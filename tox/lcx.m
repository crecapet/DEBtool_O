function [c, ERR] = lcx (p, tc, x)
  %% function [c, ERR] = lcx (p, tc, x)
  %% created 2002/03/06 by Bas Kooijman
  %% calculates LCx values from parameter values
  %% p: 3-vector with parameters
  %% tc: n-vector with exposure times
  %% x: scaler between 0 and 1 with effect level, default is 0.5
  %% c: n-vector with LC(100x)-values
  %% ERR: n-vector with error codes; if successful, all are zero
  
  global t C0 Bk Ke X;

  if exist('x', 'var') == 0
    X = 0.5;
  else
    X = x;
  end
  
  %% unpack parameters
  C0 = p(1); Bk = p(2); Ke = p(3);

  %% initiate output vector
  [nt i] = size(tc); c = ones(nt,1); ERR = ones(nt,1); 
  for i = 1:nt
    t = tc(i,1); % get exposure time
    LC = 1.1*C0./(1 - exp(-Ke * t)); % guess given Bk = infty
    [c(i), err] = fsolve('fnlcx', LC); % get true value from approximation
    ERR(i) = err;
    if err ~=1
      fprintf('No convergence \n');
    end
  end

  
endfunction
  
