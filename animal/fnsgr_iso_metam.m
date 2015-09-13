function res = fnsgr_iso_metam(Rho,x)

global tp tm rho hW hG hGW3

rho = max(0,Rho);

tm = max([5 * tp; roots3([hW^3 0 rho log(1e-12)], 1)]);
res = quad('dsgr_iso', tp, tm) - 1;