function shdiffu(n,p)
  global k kE kP DE DP JE JF dL LR

  k = p(1); kE = p(2); kP = p(3); DE = p(4); DP = p(5); JE = p(6);
  dL = p(7); LR = p(8); JF = JE * pi * LR^2; 
  LE = sqrt(DE/kE);

  nEP0 = zeros(2 * n, 1); L = LR + dL * (0:(n - 1))';
  nt = 5; t = linspace(0, 500, nt)';
  nEPF = lsode('ddiffuF', nEP0, t);
  nEP = lsode('ddiffuE', nEP0, t);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  clf
  hold on

  subplot(2,2,1)
  xlabel('distance')
  ylabel('conc enzyme/metabolites')
  for i = 2:nt
    plot(L, nEP(i,1:n)', 'r', L, nEP(i,(n+1):(2*n))', 'g')
  end
  nPi = JE * kP * LE/ (kE * DP);
  nE = exp((LR - L)/ LE) * JE/ (kE * LE);
  nP = (kP/ kE) * (JE * LE - DE * nE)/ DP;
  plot(L, nE,'m', L, nP, 'b')
  
  subplot(2,2,2)
  xlabel('time')
  ylabel('y_{PE}')
  plot(t, k * dL * nEP(:, n + 1)/ JE,'g', ...
       [0;t(nt)], [kP/kE; kP/kE],'r', ...
       t, k * dL * nEPF(:, n + 1)/ JE, 'b')

  subplot(2,2,3)
  xlabel('distance')
  ylabel('conc enzyme/metabolites')
  for i = 2:nt
    plot(L, nEPF(i,1:n)', 'r', L, nEPF(i,(n+1):(2*n)), 'g')
  end
  nE = (LR^2 ./ (L * (LR + LE))) .* exp((LR - L)/ LE) * JF/ (kE * LE);
  nP = (kP/ kE) * (DE/ DP) * (JF * LE * LR ./ (DE * (LE + LR)) - nE);
  plot(L, nE, 'm', L, nP, 'b') 

