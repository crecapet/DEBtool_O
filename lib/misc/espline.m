function [xy_min, xy_max , info] = espline(xy, Dy1, Dyk)
  %% [x_min, x_max, info] = espline(xy, Dy1, Dyk)
  %% created at 2007/04/01 by Bas Kooijman
  %% calculates extremes of fnfourier(t,p) on interval (0,period)
  %% xy: (r,2)-matrix with knots (r>3)
  %% xy_min: (n_min,2)-matrix with (x,y)-values of local minima
  %% xy_max: (n_max,2)-matrix with (x,y)-values of local maxima
  %% info: 1 = successful, 0 if not
  %% cf spline
  
  n = size(xy,1); 
  if n < 4
    printf('number of knots must be at least 4\n');
    xy_min = []; xy_max = []; info = 0; return
  end
  
  if exist('Dy1', 'var') == 0 % make sure that left clamp is specified
    Dy1 = []; % no left clamp; second derivative at first knot is zero
  end
  if exist('Dyk', 'var') == 0 % make sure that right clamp is specified
    Dyk = []; % no right clamp; second derivative at last knot is zero
  end
  
  x = linspace(xy(1,1),xy(n,1),10 * n)';
  [y, dy] = spline(x, xy, Dy1, Dyk);
  x = rspline1([x,dy]);
  nx = length(x);
  info = 1;
  for i = 1:nx
      %% Newton Raphson loop to make preliminary estimates more precise
      j = 1; % initiate counter
      dy = 1; % make sure to start nr-procedure
      while dy^2 > 1e-10 && j < 10
          [y, dy, ddy] = spline(x(i), xy, Dy1, Dyk);
          x(i) = x(i) - dy/ ddy;
          j = j + 1;
      end
      if j == 10;
          info = 0;
          printf('no convergence\n');
      end
  end
  [y, dy, ddy] = spline(x, xy, Dy1, Dyk);
  xy_min = [x, y]; xy_min(ddy < 0,:) = [];
  xy_max = [x, y]; xy_max(ddy > 0,:) = [];
endfunction
