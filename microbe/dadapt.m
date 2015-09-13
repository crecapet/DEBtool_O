function dX = dadapt (X, t)
  %% Differential equation for adaption; called by adapt
  
  global KA KAB KB KBA jAm jBm kapA0 kapB0 pA h kE kM yAE yBE yEV;

  %% Unpack state vector for easy reference
  A =    X(1); % Substr A
  B =    X(2); % Substr B
  V =    X(3); % structure
  mE =   X(4); % reserve density
  kapA = X(5); % expression for A
  kapB = 1 + kapA0 + kapB0 - kapA; % expression for B

  fA = (A/KA)/ (1 + (A/KA) + (B/KBA));
  fB = (B/KB)/ (1 + (A/KAB) + (B/KB));
  r = (kE * mE - kM * yEV)/ (mE + yEV);
  spkf = pA * kapA * fA + (1 - pA) * kapB * fB;

  dA = - V * jAm * fA * kapA/(1 + kapA0);
  dB = - V * jBm * fB * kapB/(1 + kapB0);
  dV = V * r;
  dmE = - dA/ yAE - dB/ yBE - kE * mE;
  dkapA = (r + h) * (pA * kapA * fA/ spkf + kapA0 - kapA);

  %% Pack derivatives
  dX = [dA; dB; dV; dmE; dkapA];
  