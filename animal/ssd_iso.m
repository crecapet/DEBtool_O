function [r Ea EL EL2 EL3 info] = ssd_iso(p, F, r0) 
% [r Ea EL EL2 EL3 info] = ssd_iso(p, F, r0) 
% created 2009/09/15 by Bas Kooijman, modified 2009/10/25
% mean age, length, squared length, cubed length, spec pop growth rate of isomorphs
% embryonic stage is excluded
% p: 11-vector with parameters: kap kapR g kJ kM LT v UHb UHp ha sG
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

global rho rhoB lb_ssd tb_ssd f_ssd hWG3 hW hG 

kap = p(1); kapR = p(2); g   = p(3); 
kJ  = p(4); kM   = p(5); LT  = p(6);  
v   = p(7); UHb  = p(8); UHp = p(9);
ha = p(10); sG = p(11);

if exist('F','var') == 1
    f_ssd = F;
else
    f_ssd = 1;
end

if exist('r0','var') == 1
    r = r0; info = 1; tp = 1e6; 
else
   [r info tb_ssd tp_ssd lb_ssd] = sgr_iso (p, f_ssd);
end
rho = r/ kM;

Lm = v/ g/ kM;
rhoB = 1/ (3 + 3 * f_ssd/g); % rB/ kM
hW = (ha * g/ 6/ kM^2)^(1/3); % hW/ kM
hG = sG * g * f_ssd^3; % hG/ kM
hWG3 = (hW/ hG)^3;

if rho <= 0
  tm = (- log(1e-12))^(1/3);
else
  tm = roots3([hW^3; 0; rho; log(1e-12)],1);
end
  
N = quad('fnE_iso', tb_ssd, tm); % norm to ensure that pdf integrates till 1
Ea = quad('fnEa_iso', tb_ssd, tm)/ N/ kM;
EL = Lm * quad('fnEL_iso', tb_ssd, tm)/ N;
EL2 = Lm^2 * quad('fnEL2_iso', tb_ssd, tm)/ N;
EL3 = Lm^3 * quad('fnEL3_iso', tb_ssd, tm)/ N;