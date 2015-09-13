function [lb, tb, info] = get_lb_foetus(p, tb0)
  %  [lb, tb, info] = get_lb_foetus(p, tb0)
  %  created 2007/07/28 by Bas Kooijman; modified 2011/04/07
  %  p: 1-vector with g if tb is specified else 3-vector, see get_tb_foetus
  %  tb0: optional scalar with scaled age at birth
  %  lb: scalar with scaled length at birth
  %  tb: scalar with age at birth
  %  info: indicator for failure (0) of success (1) of convergence

  info = 1;
  if exist('tb0', 'var') == 0
    if length(p) < 3
      fprintf('warning in get_lb_foetus: not enough input parameters, see get_tb_foetus \n');
      lb = []; tb = []; info = 0; return;
    end

    [tb, lb] = get_tb_foetus(p); % get scaled age at birth
    info = 1;
  else
    tb = tb0;
  end

  g = p(1);   % energy investment ratio
  lb = g * tb/ 3;
