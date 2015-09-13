function [H, XY0, XYP, XYS] = shchemo
  global Kx Ky jxm kE ld g dy Xr h; 
  
  %% parameters
  Xr = 10; g = 1; ld = .01; jxm = 1; kE = .2; Kx = .1; Ky = .1; dy = 0.01;

  fm = Xr/ (Xr + Kx); hm = kE * (fm - ld)/ (fm + g); % max throughput rate

  H = linspace(.0001, hm, 100)'; % set throughput rates
  xy0 = [.01;.01]; xyP = [.01;.01]; xyS = [.01;.01]; % initiate start estimate
  XY0 = zeros(100,2); XYP = zeros(100,2); XYS = zeros(100,2); % fill output vars

  for i = 1:100 % loop across throughput rates
    h = H(i);
    xy0 = fsolve('chemo0', xy0); XY0(i,:) = xy0'; 
    xyP = fsolve('chemoP', xyP); XYP(i,:) = xyP'; 
    xyS = fsolve('chemoS', xyS); XYS(i,:) = xyS';
  end

%%  return;
  clf
  subplot (1,2,1)
    xlabel('throughput rate'); ylabel('substrate')
    plot(H, XY0(:,1), 'g', H, XYP(:,1), 'r', H, XYS(:,1), 'b')
  subplot (1,2,2)
    xlabel('throughput rate'); ylabel('biomass')
    plot(H, XY0(:,2), 'g', H, XYP(:,2), 'r', H, XYS(:,2), 'b')
