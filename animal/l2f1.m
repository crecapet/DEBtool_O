function [f info] = l2f1(p,tl,f0)
%% [f info] = l2f1(p,tl,f0)
%% created at 2010/03/04 by Bas Kooijman, modified 2010/03/18
%% calculates f before scaled age t and scaled length l
%% p  : 4-vector with g, k, lT, v_Hb
%% tl : 2-vector with scaled age t = a * k_M and scaled length l = L/ L_m
%% f0 : initial estimate for scaled functional response f 
%% f : scaled funct. response up till the moment the organism reaches scaled age t and scaled length l
%% info : scalar for succes (1) or failure (0)


global g k vHb lT l t

% unpack parameters p
g    = p(1); k    = p(2); lT   = p(3); vHb = p(4); 

% unpack data tl
t  = tl(1); l = tl(2);

if exist('f0','var') == 0 % get initial estimate for f
    f0 = lT + l/ (1 - exp(-t/ 3/ (1 + 1/ g)));
end

[f , flag, info] = fzero('fnl2f1', f0);
%[f info] = nmregr('fnl2f1',f0,[0 0]);
