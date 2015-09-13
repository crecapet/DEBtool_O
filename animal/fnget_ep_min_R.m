function f_R = fnget_ep_min_R(elp)
  
  global g k lT vHb vHp
  
  ep = elp(1); lp = elp(2);

  lb = get_lb([g;k;vHb]);
  l = lsode('dget_lp', lb, [vHb; vHp]); lp0 = l(2);

  f_R = [k * vHp - ep * lp^2 * (g + lT + lp)/ (g + ep);
         lp - lp0];
         
         