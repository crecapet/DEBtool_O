function dl = dget_lj(l, vH)
% created at 2010/02/10 by Bas Kooijman, modified 2010/02/22
% called by get_lj
% dl = d/dvH l during exponential growth

global k lb_j li g f_get

f = f_get;

r = g * (li/ lb_j - 1)/ (f + g);
dl = r * l/ (3 * f * l^3 * (1/ lb_j - r/ g) - 3 * k * vH);
