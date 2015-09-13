function p = get_fourier(period, n, ty)
  %% p = get_fourier(period, n, ty)
  %% coded by Bas Kooijman, 2007/03/27
  %% period: scalar with period
  %% n: scalar with order
  %% ty: (k,2)-matrix with time, function values
  %% p: (n+1,2)-matrix with 
  %%  row 1: period, mean function,
  %%  row 2,.,n+1: fourier coefficients
  %% input-output structure similar to knot
  %% cf fnfourier

  %% force independent variable on interval (-pi,pi)
  t = 2 * pi * ty(:,1)/ period - pi;
  y = ty(:,2); % unpack function values

  %% Euler formulas for Fourier coefficients
  a0 = ispline1([-pi;pi],ty); a0 = a0(2)/ (2 * pi);
  p = [period 0; a0 1]; % fix period in later least squares procedure
  for i = 1:n % n Fourier terms
    ai = ispline1([-pi;pi], [t, y .* cos(i * t)]);
    ai = ai(2)/ pi;
    bi = ispline1([-pi;pi], [t, y .* sin(i * t)]);
    bi = bi(2)/ pi;
    p = [p; ai 1; bi 1]; % append parameters
  end

  %% improve Euler formulas by least squares minimasation
  nrregr_options('report', 0);
  nrregr_options('max_step_number', 500);
  [p, info] = nrregr('fn_fourier', p, ty); 
  p = wrap(p(:,1), n + 1, 2); % compose output

  if info ~= 1
    fprintf('convergence problems\n');
  end
