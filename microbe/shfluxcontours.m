function shfluxcontours
  MX = linspace(1e-4,0.4,50)';
  MN = linspace(1e-4,0.2,50)';
  iso = linspace(-.5, .5, 7)';
  clf;

  f1 = gflux(MX,MN,1);
  f2 = gflux(MX,MN,2);
  f3 = gflux(MX,MN,3);
  f4 = gflux(MX,MN,4);
  f5 = gflux(MX,MN,5);
  f6 = gflux(MX,MN,6);
  f7 = gflux(MX,MN,7);
  

  subplot(3,3,1) % CH4
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('CH4, mmol/h')
  contour(MX, MN, f1, iso)
  subplot(3,3,2) % CO2
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('CO2, mmol/h')
  contour(MX, MN, f2, iso)
  subplot(3,3,3) % H2O
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('H2O, mmol/h')
  contour(MX, MN, f3, iso)
  
  subplot(3,3,4) % O2
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('O2, mmol/h')
  contour(MX, MN, f4, iso)
  subplot(3,3,5) % NH3
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('NH3, mmol/h')
  contour(MX, MN, f5, iso)
  subplot(3,3,6) % structure
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('structure, mmol/h')
  contour(MX, MN, f7, iso)

  subplot(3,3,7) % CO2/CH4
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('CO2/CH4, mol/mol')
  contour(MX, MN, f2./f1, iso)
  subplot(3,3,8) % O2/CO2
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('O2/CO2, mol/mol')
  contour(MX, MN, f4./f2, iso)
  subplot(3,3,9) % res/structure
  xlabel('CH4, mM'); ylabel('NH3, mM'); title('res/struct, mol/mol')
  contour(MX, MN, f6./f7, iso)
