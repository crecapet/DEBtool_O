function xmax = cummax(x)
% xmax = cummax(x)
% created at 2010/03/31 by Bas Kooijman
% x: n-vector
% xmax: n-vector with cumulative maxima of x

n = length(x); xmax = x;
for i = 2:n
  xmax(i) = max(x(i), xmax(i-1));
end
