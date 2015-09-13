function [EMJHG info] = get_EMJHG_foetus(p, eb)
% [EMJHG info] = get_EMJHG_foetus(p, eb)
% created at 2011/01/19 by Bas Kooijman
% p: 4 or 5-vector with parameters
% eb: optional n-vector with scaled reserve densities at birth
%    default: 1
% EMJHG: (n,5 or 6)-matrix with in the columns fractions of initial reserve at birth
%  reserve left at birth, cumulatively allocated to som maint, mat maint, maturation, growth 
%  if p(5) is specified, growth if splitted in dissipated and fixed in structure
% info: n-vector with failure (0) of success (1) for uE0 and tau_b-computations
% called by birth_pie_foetus

global g kap k

% unpack p
g   = p(1);
k   = p(2); 
vHb = p(3);
kap = p(4);

if length(p) > 4
    kap_G = p(5);
end

if exist('eb','var') == 0
    eb = 1; % maximum value as juvenile
end
n = length(eb);
EMJHG = zeros(n,5); info = ones(n);

for i = 1:n
  [uE0, lb, tb, info(i)] = get_ue0_foetus(p, eb(i));
  ulhMJ = lsode('dget_ulhMJ_foetus', [uE0; 0; 0; 0; 0], [0;tb]);
  EMJHG(i, :) = [eb(i) * lb^3/ g, ulhMJ(end,[4 5]), vHb * (1 - kap), kap * lb^3];
  EMJHG(i, :) = EMJHG(i, :)/sum(EMJHG(i, :));
end

if exist('kap_G','var') == 1
  EMJHG = [EMJHG(:,1:4), EMJHG(:,5) * [ (1 - kap_G), kap_G]];
end
