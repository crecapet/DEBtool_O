function [r info tb tj tp_out lb lj lp_out uE0_sgr] = sgr_iso_metam (p, F)
% [r info tb tj tp_out lb lj lp_out uE0_sgr] = sgr_iso_metam (p, F)
% created 2011/04/26 by Bas Kooijman, modified 2011/05/17
% specific population growth rate for reproducing isomorphs with V1-early juv stage
% p: 12-vector with parameters: kap kapR g kJ kM LT v UHb UHj UHp ha sG
% F: optional scalar with scaled function response (default 1)
% r: scalar with specific population growth rate
%    1 = \int_0^infty S(t) R(t) exp(- r t) dt
% info: scalar with indicator for failure (0) or success (1)
% tb: scalar with scaled age at birth ab/kM 
% tj: scalar with scaled age at metamorphosis aj/kM 
% tp: scalar with scaled age at puberty ap/kM 
% lb: scalar with scaled length at birth
% lj: scalar with scaled length at metamorphosis
% lp: scalar with scaled length at puberty
% uE0_sgr: scalar with scaled initial reserve

% see ssd_iso_metam for mean age, length, squared length, cubed length
% see f_ris0 for f at which r = 0

global tp tm hWG3 rho rhoB lp hW sG rho0 g lT vHj vHp k li hG

kap = p(1); kapR = p(2); g   = p(3); 
kJ  = p(4); kM   = p(5); LT  = p(6);  
v   = p(7); UHb  = p(8); UHj = p(9);
UHp = p(10); ha = p(11); sG = p(12);

if exist('F','var') == 1
    f = F;
else
    f = 1;
end

k = kJ/ kM;
Lm = v/ g/ kM;
lT = LT/ Lm;
VHb = UHb/ (1 - kap); vHb = VHb * g^2 * kM^3/ v^2; 
VHj = UHj/ (1 - kap); vHj = VHj * g^2 * kM^3/ v^2; 
VHp = UHp/ (1 - kap); vHp = VHp * g^2 * kM^3/ v^2;
rhoB = 1/(3 + 3 * f/g); % rB/ kM
hW = (ha * g/ 6/ kM^2)^(1/3); % hW/ kM
hG = sG * g * f^3; % hG/ kM
hWG3 = (hW/ hG)^3;
tm = 1e4;

[uE0_sgr lb info] = get_ue0([g k vHb], f);
if info == 0
    r = 0;
    fprintf('sgr_iso_metam warning: ue0 could not be obtained in get_ue0\n');
    return
end
rho0 = kapR * (1 - kap)/ uE0_sgr;

[tj tp tb lj lp lb li rj rB info] = get_tj([g k lT vHb vHj vHp], f, lb);

if lp > li || info == 0 || tp < 0
    r = 0;
    info = 0;
    fprintf('sgr_iso_metam warning: lp > li\n');
    tp_out = []; lp_out = [];
    return
end

% initialize range for r/k_M
rho_0 = 0; norm_0 = fnsgr_iso(rho_0);
Lb = Lm * lb; Lj = Lm * lj; Lp = Lm * lp; Li = Lm * li;
pars_reprod = [p(1:8)'; UHp; Lb; Lj; Lp];
rho_1 = reprod_rate_metam(Li, f, pars_reprod)/kM; % R_i/ k_M
norm_1 = fnsgr_iso(rho_1);
if norm_0 < 0 || norm_1 > 0
    fprintf('sgr_iso_metam warning: invalid parameter combination\n')
    printpar({'lower boundary'; 'upper boundary'}, [rho_0; rho_1], [norm_0; norm_1], 'r, char eq'); 
    r = 0;
    info = 0;
    lp_out = []; tp_out = []; 
    return
end
norm = 1; i = 0; % initialize norm and counter

while i < 100 && norm^2 > 1e-16 % bisection method
    i = i + 1;
    rho = (rho_0 + rho_1)/ 2;
    norm = fnsgr_iso_metam(rho);
    if norm > 0
        rho_0 = rho;
    else
        rho_1 = rho;
    end
end

r = rho * kM; % spec pop growth rate

if i == 100
    info = 0;
    fprintf('sgr_iso_metam warning: no convergence for r in 100 steps\n')
else
    info = 1;
    %fprintf(['sgr_iso_metam warning: successful convergence for r in ', num2str(i), ' steps\n'])
end

lp_out = lp; % copy lp to output
tp_out = tp; % copy tp to output
