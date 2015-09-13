function [ty_min, ty_max , info] = efnfourier(ty)
  %% [t_min, t_max, info] = efnfourier (ty, y)
  %% created at 2007/03/30 by Bas Kooijman
  %% calculates extremes of fnfourier(t,p) on interval (0,period)
  %% ty: (r,2)-matrix with parameters; r>3
  %% ty_min: (n_min,2)-matrix with (t,y)-values of local minima
  %% ty_max: (n_max,2)-matrix with (t,y)-values of local maxima
  %% info: 1 = successful, 0 if not
  %% cf fnfourier
  
  t = linspace(0,ty(1,1),100)';
  t = rspline1([t, dfnfourier(t,ty)]);
  nt = length(t);
  info = 1;
  for i = 1:nt
      %% Newton Raphson loop to make preliminary estimates more precise
      j = 1; % initiate counter
      f = 1; % make sure to start nr-procedure
      while f^2 > 1e-10 && j < 10
          f = dfnfourier(t(i), ty);
          df = ddfnfourier(t(i), ty);
          t(i) = t(i) - f/ df;
          j = j + 1;
      end
      if j == 10;
          info = 0;
          fprintf('no convergence\n');
      end
  end
  ddt = ddfnfourier(t, ty); t = [t, fnfourier(t,ty)];
  ty_min = t; ty_min(ddt < 0,:) = [];
  ty_max = t; ty_max(ddt > 0,:) = [];