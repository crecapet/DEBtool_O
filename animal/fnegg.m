function F = fnegg(ab)
  global E0 EG EJb pM pJ pAm kap

  EViV = lsode('degg', [E0; 1e-8; 0], [0; ab]);
  Eb = EViV(2,1); Vb = EViV(2,2); iVb = EViV(2,3);       
  k = 1/ kap - 1;
  F = EJb - k * EG * Vb - ( k * pM - pJ) * iVb;
      