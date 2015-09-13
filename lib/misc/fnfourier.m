function f = fnfourier(t, p)
  %% f = fnfourier(t, p)
  %% Coded by Bas Kooijman, 2007/03/30
  %% t: (nt,1)-vector with time points
  %% p: (n+1,2)-matrix with parameters
  %% f: (nt,1)-vector with function values
  %% input-output structure similar to spline
  %% cf dfnfourier for derivative
  %%    ifnfourier for integration
  %%    rfnfourier for roots
  %%    get_fnfourier for parameters

  n = size(p,1);   % number of fourier terms +1
  period = p(1,1); % period of periodic function
  a0 = p(1,2);     % mean level of function
  a = p(2:n,1);    % fourier coefficients for cosinus
  b = p(2:n,2);    % fourier coefficients for sinus
  n = n - 1;       % number of Fourier terms

  T = (2 * pi * t(:,1)/period - pi) * (1:n); % matrix of times, order

  f = a0 + cos(T) * a + sin(T) * b; % function values
