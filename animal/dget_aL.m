function daL = dget_aL(aL, UH)
  % used in add_my_pet/get_pars_Danio_rerio

a = aL(1);
L = aL(2);

dHL = dget_HL([UH; L], a);
daL = [1; dHL(2)]/ dHL(1);