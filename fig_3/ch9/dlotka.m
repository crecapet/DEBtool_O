function dxy = dlotka(xy) % Lotka-Volterra dynamics in chemostat
  global xr jXm Yg
  %% cf Eq (9.7, 9.8) {313}  
  dxy = [xr - jXm * prod(xy) - xy(1); ...
	 Yg * jXm * prod(xy) - xy(2)];
