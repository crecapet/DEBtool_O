  ## function test_get_pars_ts
  ## [Lb, Lp, Li, rB, Ri] = fnget_pars_s(p, fLbw, fLpw, fLiw, frBw, fRiw)
  ## p: 8-vector with
  ##   1 kap   # -    # fraction allocated to som maint + growth
  ##   2 g     # -    # energy investment ratio
  ##   3 kJ    # d^-1 # maturity maintenance rate coefficient
  ##   4 kM    # d^-1 # somatic maintenance rate coefficient
  ##   5 v     # mm/d # energy conductance
  ##   6 Hb    # d mm^2 # scaled maturity at birth M_H^b/{J_EAm}
  ##   7 Hp    # d mm^2 # scaled maturity at puberty M_H^p/{J_EAm}

  clear
  global U0 Ub Up ab # for transfer to get_pars_s

  f = [1 .9 .8]';
  p = [.8 .1 1 1 1.5 .0001 1]'; 
  [Lb_s, Lp_s, Li_s, rB_s, Ri_s] = fnget_pars_s(p,f,f,f,f,f);
  U0_s = U0; Ub_s = Ub; Up_s = Up; ab_s = ab;

  p(3)=[]; # remove kJ 
  [Lb_t, Lp_t, Li_t, rB_t, Ri_t] = fnget_pars_t(p,f,f,f,f,f);
  U0_t = U0; Ub_t = Ub; Up_t = Up; ab_t = ab;

  # these pairs should be the same because fnget_pars_s is used for k_J = k_M
  Lb=[Lb_t, Lb_s]
  Lp=[Lp_t, Lp_s]
  Li=[Li_t, Li_s]
  rB=[rB_t, rB_s]
  Ri=[Ri_t, Ri_s]

  U0=[U0_t, U0_s]
  Ub=[Ub_t, Ub_s]
  Up=[Up_t, Up_s]
  ab=[ab_t, ab_s]
