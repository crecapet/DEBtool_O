function [L S Lf Sf] = eLqhS(p, aL, aS, aLf, aSf)
  %% LT = 0; 
  global kM v g ha sG f0
  
  %% unpack parameters
  Lb = p(1); g = p(2); kM = p(3);
  v = p(4); ha = 1E-6 * p(5); sG = p(6);

  f0 = 1;
  eLqhS0 = [1; Lb; 0; 0; 1];
  eLqhSt = lsode('deLqhS', eLqhS0, [-1e-6; aL(:,1)]);
  L = eLqhSt(:,2); L(1) = [];
  eLqhSt = lsode('deLqhS', eLqhS0, [-1e-6; aS(:,1)]);
  S = eLqhSt(:,5); S(1) = [];

  f0 = p(7);
  eLqhSt = lsode('deLqhS', eLqhS0, [-1e-6; aLf(:,1)]);
  Lf = eLqhSt(:,2); Lf(1) = [];
  eLqhSt = lsode('deLqhS', eLqhS0, [-1e-6; aSf(:,1)]);
  Sf = eLqhSt(:,5); Sf(1) = [];
