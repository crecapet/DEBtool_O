function f = ifnfourier(t, p)
  %% f = ifnfourier(t, p)
  %% Coded by Bas Kooijman, 2007/03/30
  %% t: (nt,1)-vector with time points
  %% p: (n+1,2)-matrix with parameters
  %% f: (nt,1)-vector with integrated function values, f(1)=0
  %% cf fnfourier 

  n = size(p,1);   % number of fourier terms +1
  period = p(1,1); % period of periodic function
  a0 = p(1,2);     % mean level of function
  a = p(2:n,1);    % fourier coefficients for cosinus
  b = p(2:n,2);    % fourier coefficients for sinus
  n = n - 1;       % number of Fourier terms
  nt = length(t);

  s = 2 * pi * t(:,1)/period - pi;
  T = s * (1 ./ (1:n)); % matrix of times, order
  ds = s(2:nt) - s(1:nt-1);

  f = a0 * ds + (sin(T(2:nt,:)) - sin(T(1:nt-1,:))) * a - ...
              (cos(T(2:nt,:)) - cos(T(1:nt-1,:))) * b;
  f = cumsum([0;f]) * period/ (2 * pi);
