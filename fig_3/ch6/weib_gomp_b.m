function [S100, S75, S44] = weib_gomp_b(p, tS100, tS75, tS44)

  global v kM g LT rho h0 kG kW L0
  
  %% unpack parameters
  h0 = p(1); kW = p(2); kG = p(3);
  V0 = p(4); v = p(5); kM = p(6); LT = p(7); g = p(8);
  
  L0 = V0^(1/3);
  
  qhS0 = [0; 0; 1]; % V, e, MQ, MD, S
  rho = 1; S100  = lsode('dweib_gomp_b', qhS0, tS100(:,1));
  S100 = S100(:,3);
  rho = 0.75; S75 = lsode('dweib_gomp_b', qhS0, tS75(:,1));
  S75 = S75(:,3);
  rho = 0.44; S44 = lsode('dweib_gomp_b', qhS0, tS44(:,1));
  S44 = S44(:,3);

