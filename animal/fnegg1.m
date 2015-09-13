function F = fnegg1(abE0)
  global f EJb EG Em pM pJ pAm kap

  %% unpack state variables
  ab = abE0(1); E0 = abE0(2);
  
  EViV = lsode('degg', [E0; 1e-8; 0], [0; ab]);
  Eb = EViV(2,1); Vb = EViV(2,2); iVb = EViV(2,3);       
  k = 1/ kap - 1;
  F = [EJb - k * EG * Vb - ( k * pM - pJ) * iVb;
       Eb - f * Em * Vb];
      