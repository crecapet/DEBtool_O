function ep = get_ep_min(p)
  %% ep = get_ep_min(p)
  %% created 2009/01/15 by Bas Kooijman; modified 2009/10/27
  %% p: 3-vector with parameters: k lT v_H^p (cf get_lp)
  %% ep: scalar with e_p such that growth and maturation cease at puberty
  
  k = p(1); lT = p(2); vHp = p(3);
  ep = roots3([1; -2 * lT; lT^2; - k * vHp], 1); 
 if length(ep) ~= 1  
     fprintf(['Warning in get_ep_min: ', num2str(length(ep)), ' solutions\n']);
 end
