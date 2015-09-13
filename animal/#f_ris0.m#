function [f info] = f_ris0 (p, f0)
% [f info] = f_ris0 (p, f0)
% created 2009/09/18 by Bas Kooijman
% p: 11-vector with parameters: kap kapR g kJ kM LT v UHb UHp ha sG
% f0: optional scalar with f for which r = 0
% f: f at which r = 0 for reproducing isomorphs
% info: scalar with indicator for failure (0) or success (0)

global tm hW sG g lT vHb vHp k kap kapR rho

kap = p(1); kapR = p(2); g   = p(3); 
kJ  = p(4); kM   = p(5); LT  = p(6);  
v   = p(7); UHb  = p(8); UHp = p(9);
ha = p(10); sG = p(11);

k = kJ/ kM;
Lm = v/ g/ kM;
lT = LT/ Lm;
VHb = UHb/ (1 - kap); VHp = UHp/ (1 - kap);
vHb = VHb * g^2 * kM^3/ v^2; vHp = VHp * g^2 * kM^3/ v^2;
hW = (ha * g/ 6/ kM^2)^(1/3); % hW/ kM
tm = 1e3/ hW;
rho = 0; % r/ k_M

if exist('r0','var') == 0 
    f0 = [];
end
if isempty(f0)
    f0 = get_lp([g k lT vHb vHp] ,1);
end

% options = optimset('Display','off');
%[f val info] = fsolve('fnf_ris0', f0, options);
nrregr_options('max_step_number', 1e4)
nrregr_options('report',0)
[f info] = nrregr('fnf_ris0', f0 , [0 0]); % rho = r/ kM
%[f info] = nmregr('fnf_ris0', f0 , [0 0]); % rho = r/ kM
if abs(fnf_ris0(f)) > 1e-3
    info = 0;
    fprintf('f_ris0 warning: no convergence\n');
end