function res = fnsgr_iso(Rho,x)

global tp tm rho

rho = Rho;
res = quad('dsgr_iso', tp, tm) - 1;