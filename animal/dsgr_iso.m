function int = dsgr_iso(t)
% t: a/ kM
% int: char equation  S(t) * R(t) * exp(-rt)
%   assuming that dilution by growth hardly affects surv prob S(t)
% called by fnsgr_iso and fnf_ris0

global rho rho0 rhoB lT lp tp f hWG3 hW hG g vHp k

if hWG3 > 100
  S = exp(- (hW * t).^3 - rho * t);
else
  hGt = hG * t;
  S = exp(6 * hWG3 * (1 - exp(hGt) + hGt + hGt .^ 2/2) - rho * t);
end
l = f - (f - lp) * exp( - rhoB * (t - tp));
int = S * rho0 .* max(0,(f * l .^ 2 .* (g + lT + l)/ (f + g) - k * vHp));