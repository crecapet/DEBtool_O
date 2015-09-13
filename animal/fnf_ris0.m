function res = fnf_ris0(f,x)

global hW sG
global rhoB lp tp tm hWG3 hG rho0 g lT vHb vHp k kap kapR

hG = sG * g * f^3; % hG/ kM
hWG3 = (hW/ hG)^3; 

[uE0 lb] = get_ue0([g k vHb], f);
[tp tb lp] = get_tp([g k lT vHb vHp], f, lb);
rho0 = kapR * (1 - kap)/ uE0;
rhoB = 1/(3 + 3 * f/ g); % rB/ kM

res = quad('dsgr_iso', tp, tm) - 1;