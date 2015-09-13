function fn = fnget_tul(lb)

  global g f vHb k % for dget_tul
  l0 = 1e-4;
  uE0 = get_ue0([g k],f, lb);
  vH0 = uE0 * l0^2 * (g + l0)/ (uE0 + l0^3)/ k;
  tul = lsode('dget_tul', [0; uE0; l0], [vH0; vHb]);
  lb = tul(2,3); uEb = tul(2,2);
  fn = f * lb^3/ g - uEb;
 