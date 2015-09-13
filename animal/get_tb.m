function [tb lb info] = get_tb(p, eb, lb)
  %% [tb lb info] = get_tb(p, eb, lb)
  %% created at 2007/07/27 by Bas Kooijman; modified 2009/02/20
  %% p: 1 or 3-vector with parameters g, k_J/ k_M, v_H^b
  %% eb: optional scalar with scaled reserve density at birth (default eb = 1)
  %% lb: optional scalar with scaled length at birth
  %%     default: lb is obtained from get_lb
  %% tb: scaled age at birth \tau_b = a_b k_M

  global ab xb
  
  if exist('eb', 'var') == 0
    eb = 1; % maximum value as juvenile
  end

  info = 1;
  
  if exist('lb', 'var') == 0
    if length(p) < 3
      fprintf('not enough input parameters, see get_lb \n');
      tb = [];
      return;
    end
    [lb info] = get_lb(p, eb);
  end
  if isempty(lb)
    [lb info] = get_lb(p, eb);
  end


  %% unpack p
  g = p(1);  % energy investment ratio

  xb = g/ (eb + g); % f = e_b 
  ab = 3 * g * xb^(1/ 3)/ lb; % \alpha_b
  tb = 3 * quad('dget_tb', 1e-10, xb);
