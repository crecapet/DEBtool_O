function int = fnEL_iso(t)
% t: a/kM
% int: l(t) * exp(- rho*t) * S(t)
% called by ssd_iso

global rho rhoB lb_ssd tb_ssd f_ssd hWG3 hW hG

if hWG3 > 100
    S = exp(- (hW * t).^3 - rho * t);
else
  hGt = hG * t;
  S = exp(6 * hWG3 * (1 - exp(hGt) + hGt + hGt .^ 2/2) - rho * t);
end
  
l = f_ssd - (f_ssd - lb_ssd) * exp( - rhoB * (t - tb_ssd));
int = S .* l;