function substr(H, XY0, XYP, XYS)
  clf
  %% gset output 'substr.ps'

  plot(H, XY0(:,1), 'g', H, XYP(:,1), 'r', H, XYS(:,1), 'b')
