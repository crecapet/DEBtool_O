function [fg, fc, fd, fvc, fvd] = gcd(par,glu,coli,disco,vcoli,vdisco)

  global D xr jcoli jdisco Kcoli Kdisco kEcoli kEdisco gcoli gdisco ...
      kMcoli kMdisco

  %% unpack par
  Kcoli = par(1);    Kdisco = par(2);
  jcoli = par(3);    jdisco = par(4);
  gcoli = par(5);    gdisco = par(6);
  kMcoli = par(7);   kMdisco = par(8);
  kEcoli = par(9);   kEdisco = par(10);
  wcoli = par(11);   wdisco = par(12);
  glu0 = par(13);
  coli0 = par(14);   disco0 = par(15);
  ecoli0 = par(16);  edisco0 = par(17);
  D = par(18);       xr = par(19);
  Vcoli = par(20);   Vdisco = par(21);

  x0 = par(12+(1:5));

  fg = lsode('dgcd',x0,[0;glu(:,1)]); fg(1,:) = [];
  fg = fg(:,1);

  fc = lsode('dgcd',x0,[0;coli(:,1)]); fc(1,:) = [];
  fc = fc(:,2);
  
  fd = lsode('dgcd',x0,[0;disco(:,1)]); fd(1,:) = [];
  fd = fd(:,3);

  fvc = lsode('dgcd',x0,[0;vcoli(:,1)]); fvc(1,:) = [];
  fvc = Vcoli * (1 + wcoli * fvc(:,4));

  fvd = lsode('dgcd',x0,[0;vdisco(:,1)]); fvd(1,:) = [];
  fvd = Vdisco * (1 + wdisco * fvd(:,5));

