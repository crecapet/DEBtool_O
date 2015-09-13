function biomass(H, XY0, XYP, XYS)
  gset nokey
  clf
  
  % gset output "biomass.ps"

  plot(H, XY0(:,2), 'g', H, XYP(:,2), 'r', H, XYS(:,2), 'b')
