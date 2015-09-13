function f = fnknot(y, data)
  %% f = fnknot(y, data)
  %% created at 2002/05/26 by Bas Kooijman, modified 2006/08/11
  %% subroutine for "knot" to find smoothing spline ordinates
  global X  DY1 DYk
  f = spline(data(:,1),[X,y], DY1, DYk);
