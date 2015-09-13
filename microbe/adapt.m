function  [V1, V2, V3, V4] = adapt (p, XA, XB, XC, XD)
  %% [V1, V2, V3, V4] = adapt (p, XA, XB, XC, XD)
  %% created 2001/09/17 by Bas Kooijman
  %% specifies a model for adaptation/inhibition to substrates by microbes
  %% theory is given in
  %%   Brandt, B. W., Kelpin, F. D. L., Leeuwen, I. M. M. van,
  %%   Kooijman, S. A. L. M. 2001. A simple model for microbial
  %%   adaptation to changing feeding conditions.
  %%   Environ. Sci. & Technol., subm 2001/09/17.
  
  %% calls for dadapt

  %% p: parameter vector
  %% XA, (ntA,k)-matrix with times in (:,1) for exposure to substrate A 
  %% XB, (ntB,k)-matrix with times in (:,1) for exposure to substrate B
  %% XC, (ntC,k)-matrix with times for exposure to substr A and B
  %% XD, (ntD,k)-matrix with times for exposure to substr A and B

  %% V1: (ntA,1)-vector with Biomass in culture 1
  %% V2: (ntB,1)-vector with Biomass in culture 2
  %% V3: (ntC,1)-vector with Biomass in culture 3
  %% V4: (ntD,1)-vector with Biomass in culture 4

  %% State vector:
  %% X(1): A, Substr A  (2): B, Substr B,
  %%  (3): V, structure (4): mE, reserve density
  %%  (5): kapA, expression for A

  global KA KAB KB KBA jAm jBm kapA0 kapB0 pA h kE kM yAE yBE yEV;
  
  %% unpack parameters for easy reference
  KA = p(1);    % mM, saturation constant for substr A
  KAB = p(2);   % mM, inhibition constant for substr A on B 
  KB = p(3);    % mM, saturation constant for substr B
  KBA = p(4);   % mM, inhibition constant for substr B on A
  jAm = p(5);   % mM/(mol.h), max spec uptake rate for substr A
  jBm = p(6);   % mM/(mol.h), max spec uptake rate for substr B
  kapA0 = p(7); % -, rel background expression for substr A
  kapB0 = p(8); % -, rel background expression for substr B
  pA = p(9);    % -, preference parameter for substr A; pB = 1 - pA
  h = p(10);    % 1/h, carrier turnover rate
  kE = p(11);   % 1/h, reserve turnover rate
  kM = p(12);   % 1/h, maintenance rate coefficient
  yAE = p(13);  % mol/mol yield of substr A on reserves
  yBE = p(14);  % mol/mol yield of substr B on reserves
  yEV = p(15);  % mol/mol yield of reserve on structure
  %% Now follow initial conditions for cultures 1-4
  A10 = p(16);  % mM, substr A in cult 1 at time 0
  B10 = p(17);  % mM, substr B in cult 1 at time 0
  V10 = p(18);  % mM, biomass in cult 1 at time 0
  m10 = p(19);  % mol/mol, res density in cult 1 at time 0
  kapA10 = p(20); % -, rel expresion for substr A
  A20 = p(21);  % mM, substr A in cult 2 at time 0
  B20 = p(22);  % mM, substr B in cult 2 at time 0
  V20 = p(23);  % -, biomass in cult 2 at time 0
  m20 = p(24);  % -, res density in cult 2 at time 0
  kapA20 = p(25); % -, rel expresion for substr A
  A30 = p(26);  % mM, substr A in cult 3 at time 0
  B30 = p(27);  % mM, substr B in cult 3 at time 0
  V30 = p(28);  % -, biomass in cult 3 at time 0
  m30 = p(29);  % -, res density in cult 3 at time 0
  kapA30 = p(30); % -, rel expresion for substr A
  A40 = p(31);  % mM, substr A in cult 4 at time 0
  B40 = p(32);  % mM, substr B in cult 4 at time 0
  V40 = p(33);  % -, biomass in cult 4 at time 0
  m40 = p(34);  % -, res density in cult 4 at time 0
  kapA40 = p(35); % -, rel expresion for substr A
  %% rel expression for B: kapB = 1 + kapA0 + kapB0 - kapA;

 
  kapA = 1 + kapA0;
  X0 = [A10; B10; V10; m10; kapA10];   %% initialize state vector
  Xt1 = lsode('dadapt', X0, XA(:,1)); V1 = Xt1(:,3).*(1+Xt1(:,4));
  X0 = [A20; B20; V20; m10; kapA10];   %% initialize state vector
  Xt2 = lsode('dadapt', X0, XB(:,1)); V2 = Xt2(:,3).*(1+Xt2(:,4));
  X0 = [A30; B30; V30; m10; kapA10];   %% initialize state vector
  Xt3 = lsode('dadapt', X0, XC(:,1)); V3 = Xt3(:,3).*(1+Xt3(:,4));
  X0 = [A40; B40; V40; m10; kapA10];   %% initialize state vector
  Xt4 = lsode('dadapt', X0, XD(:,1)); V4 = Xt4(:,3).*(1+Xt4(:,4));
 
endfunction
