function F = get_ab(a)
  %% find age at birth for foetal development
  %% called by get_ael_f, get_ael
  %% obsolate; use get_tb_foetus
  
  global kJ kM MV yVE kap MHb v

  akJ = a * kJ;
  A = 3 * (akJ * (akJ - 2) + 2);
  B = (akJ * (akJ * (akJ - 3) + 6) - 6) * kM/ kJ;
  C = 6 * (kM/ kJ - 1) * exp(- akJ);
  D = (3 * kJ/ v)^3 * kap * yVE/ ((1 - kap) * MV);
  F = MHb - (A + B + C)/ D;
