function [S100, S75, S44, W100, W75, W44, WF] = ...
      weib_gomp(p, tS100, tS75, tS44, tW100, tW75, tW44, tWF)
  %% h = ha mD
  %% d/dt MD = kD (MQ yDQ + MD)
  %% d/dt MQ = nu_QC pC

  global v kM g LT rho h0 ha sG t0
  
  %% unpack parameters
  h0 = p(1); ha = p(2); sG = p(3); 
  V0 = p(4); w = p(5); dV = 1;
  v = p(6); kM = p(7); LT = p(8); g = p(9); t0 = p(10);
  
  Lm = v/ kM/ g; Vm = (Lm - LT)^3;
  VeqhS0 = [V0; 1; 0; 0; 1];
  rho = 1;
  VeqhS  = lsode('dweib_gomp', VeqhS0, tS100(:,1)); S100 = VeqhS(:,5);
  VeqhS  = lsode('dweib_gomp', VeqhS0, tW100(:,1));
  W100 = VeqhS(:,1) * dV .* (1 + w * VeqhS(:,2));

  rho = 0.75;
  VeqhS = lsode('dweib_gomp', VeqhS0, tS75(:,1)); S75 = VeqhS(:,5);
  VeqhS = lsode('dweib_gomp', VeqhS0, tW75(:,1));
  W75 = VeqhS(:,1) * dV .* (1 + w * VeqhS(:,2));

  rho = 0.44;
  VeqhS = lsode('dweib_gomp', VeqhS0, tS44(:,1)); S44 = VeqhS(:,5);
  VeqhS = lsode('dweib_gomp', VeqhS0, tW44(:,1));
  W44 = VeqhS(:,1) * dV .* (1 + w * VeqhS(:,2));
  
  WF = dV * (1 + .8* w) * (v * max(0,tWF(:,1) - t0)/ 3) .^ 3;
