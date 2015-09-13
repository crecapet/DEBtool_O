function f_G = fnget_ep_min_G(ep)
  %% for e = ep, growth ceases at puberty
  
  global g k lT vHb vHp
  
  lb = get_lb([g; k; vHb]);
  l = lsode('dget_lp', lb, [vHb; vHp]); lp = l(2);
  f_G = ep - lT - lp;