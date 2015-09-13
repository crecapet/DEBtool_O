function dxy = ddroop(xy) % Droop dynamics in chemostat
  global xr jXm Yg g
  %% cf Eq (9.11-12) {315}
  f = xy(1)/ (1 + xy(1)); Y = Yg * f/ (f + g); 
  dxy = [xr - jXm * f * xy(2) - xy(1); ...
	 Y * jXm * f * xy(2) - xy(2)];
