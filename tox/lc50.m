function [c, ERR] = lc50 (p, tc)
  %% [c, ERR] = lc50 (p, tc)
  %% created 2002/03/06 by Bas Kooijman/Tjalling Jager
  %% calculates LC50 values from parameter values
  global t C0 Bk Ke;

  %% unpack parameters

  %% initiate output vector
  [nt i] = size(tc); c = ones(nt,1); ERR = ones(nt,1); 
  for i = 1:nt
    t = tc(i,1); % get exposure time
    [c(i), err] = fnLC50(p,t); % get true value from approximation
    ERR(i) = err;
    if err ~=1
      fprintf('No convergence \n');
    end
  end

 