function [r Ea EL EL2 EL3 info] = ssd_iso_metam(p, F, r0) 
% [r Ea EL EL2 EL3 info] = ssd_iso_metam(p, F, r0) 
% created 2011/05/02 by Bas Kooijman, modified 2011/07/27
% mean age, length, squared length, cubed length, spec pop growth rate of isomorphs
% embryonic stage is excluded, early juvenile V1-stage is assumed
% p: 12-vector with parameters: kap kapR g kJ kM LT v UHb UHj UHp ha sG
% F: optional scalar with scaled function response (default 1)
% r0: optional scalar with specific population growth rate
%    if specified, its computation is supressed
% r: scalar with specific population growth rate
% Ea: scalar with mean age of juveniles & adults
% EL: scalar with mean structural length
% EL2: scale with mean squared structural length
% EL3: scale with mean cubed structural length
%    1 = \int_0^infty S(t) R(t) exp(- r t) dt
% info: scalar with indicator for failure (0) or success (0)

global rho_ssd rhoj_ssd rhoB_ssd lb_ssd lj_ssd li_ssd tb_ssd tj_ssd f_ssd hWG3 hW hG 

kap = p(1); kapR = p(2); g   = p(3); 
kJ  = p(4); kM   = p(5); LT  = p(6);  
v   = p(7); UHb  = p(8); UHj = p(9);
UHp = p(10); ha  = p(11); sG = p(12);

k = kJ/ kM; Lm = v/ g/ kM; lT = LT/ Lm; 
VHb = UHb/ (1 - kap); vHb = VHb * g^2 * kM^3/ v^2; 
VHj = UHj/ (1 - kap); vHj = VHj * g^2 * kM^3/ v^2; 
VHp = UHp/ (1 - kap); vHp = VHp * g^2 * kM^3/ v^2;

if exist('F','var') == 1
    f_ssd = F;
else
    f_ssd = 1;
end

if exist('r0','var') == 1
   r = r0; info = 1; 
   pars_tj = [g k lT vHb vHj];
   [tj_ssd tp tb_ssd lj_ssd lp_ssd lb_ssd li_ssd rhoj_ssd rhoB_ssd] = get_tj(pars_tj, f_ssd, vHb^(1/3));
   %tp = 1e6; lp_ssd = f_ssd * lj_ssd/ lb_ssd - lT;
else
   pars_tj = [g k lT vHb vHj vHp];
   [tj_ssd tp tb_ssd lj_ssd lp_ssd lb_ssd li_ssd rhoj_ssd rhoB_ssd] = get_tj(pars_tj, f_ssd, vHb^(1/3));
   [r info tb_ssd tj tp_ssd lb_ssd] = sgr_iso_metam (p, F);
end
rho_ssd = r/ kM;
hW = (ha * g/ 6/ kM^2)^(1/3); % hW/ kM
hG = sG * g * f_ssd^3; % hG/ kM
hWG3 = (hW/ hG)^3;
tm = roots3([hW^3 0 rho_ssd log(1e-12)],1);

N = quad('fnE_iso', tb_ssd, tm); % norm to ensure that pdf integrates till 1
Ea = quad('fnEa_iso', tb_ssd, tm)/ N/ kM;

EL = Lm * quad('fnEL_iso_metam', tb_ssd, tm)/ N;
EL2 = Lm^2 * quad('fnEL2_iso_metam', tb_ssd, tm)/ N;
EL3 = Lm^3 * quad('fnEL3_iso_metam', tb_ssd, tm)/ N;
end

function int = fnEL_iso_metam(t)
% t: a * kM
% int: l(t)^2 * exp(- rho*t) * S(t)
% called by ssd_iso_metam

global rho_ssd rhoj_ssd rhoB_ssd lb_ssd lj_ssd li_ssd tj_ssd hWG3 hW hG 

if hWG3 > 100
    S = exp(- (hW * t).^3 - rho_ssd * t);
else
  hGt = hG * t;
  S = exp(6 * hWG3 * (1 - exp(hGt) + hGt + hGt .^ 2/2) - rho_ssd * t);
end

if t < tj_ssd
   l = lb_ssd * exp(t * rhoj_ssd/ 3);
else
   l = li_ssd - (li_ssd - lj_ssd) * exp( - rhoB_ssd * (t - tj_ssd));
end
int = S .* l;
end

function int = fnEL2_iso_metam(t)
% t: a * kM
% int: l(t)^2 * exp(- rho*t) * S(t)
% called by ssd_iso_metam

global rho_ssd rhoj_ssd rhoB_ssd lb_ssd lj_ssd li_ssd tj_ssd hWG3 hW hG 

if hWG3 > 100
    S = exp(- (hW * t).^3 - rho_ssd * t);
else
  hGt = hG * t;
  S = exp(6 * hWG3 * (1 - exp(hGt) + hGt + hGt .^ 2/2) - rho_ssd * t);
end

if t < tj_ssd
   l = lb_ssd * exp(t * rhoj_ssd/ 3);
else
   l = li_ssd - (li_ssd - lj_ssd) * exp( - rhoB_ssd * (t - tj_ssd));
end
int = S .* l.^2;
end

function int = fnEL3_iso_metam(t)
% t: a * kM
% int: l(t)^2 * exp(- rho*t) * S(t)
% called by ssd_iso_metam

global rho_ssd rhoj_ssd rhoB_ssd lb_ssd lj_ssd li_ssd tj_ssd hWG3 hW hG 

if hWG3 > 100
    S = exp(- (hW * t).^3 - rho_ssd * t);
else
  hGt = hG * t;
  S = exp(6 * hWG3 * (1 - exp(hGt) + hGt + hGt .^ 2/2) - rho_ssd * t);
end

if t < tj_ssd
   l = lb_ssd * exp(t * rhoj_ssd/ 3);
else
   l = li_ssd - (li_ssd - lj_ssd) * exp( - rhoB_ssd * (t - tj_ssd));
end
int = S .* l.^3;
end