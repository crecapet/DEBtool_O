function M = shapecorr(L, L_ref, Mpars)
% shape correction function M = 1 for L = L_ref
% L: n-vector of lengths
% L_ref: value of L for which M = 1
% Mpars: vector with parameters
% M: n-vector with shape correction function

L_j = Mpars(1);
if length(M) == 1
  x = 1;
else
  x = Mpars(2);
end

M = (max(L_ref, min(L_j, L)) ./ L_ref) .^ x;