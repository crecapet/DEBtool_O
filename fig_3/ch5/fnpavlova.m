function [MV, XP, XB, qP, qB] = fnpavlova(p, H, Xr)
  %% no coupling between nutrients to form reserves:
  %%  jEiA = fi jEiAm with fi = Xi/ (Xi + Ki) and yEX = 1
  %% excreted nutrients cannot be taken up again

  global KP KB jPAm jBAm kP kB jPM jBM yPV yBV kapP kapB XrP XrB h;
  
  %% unpack parameters
  KP = p(1); KB = p(2); jPAm = p(3); jBAm = p(4);
  kP = p(5); kB = p(6); kMP = p(7); kMB = p(8);
  yPV = p(9); yBV = p(10); kapP = p(11); kapB = p(12);
  XrP = Xr(1); XrB = Xr(2); nr = length(H);

  %% compound parameters
  jPM = yPV * kMP; jBM = yBV * kMB;

  MV = zeros(nr,1); XP = zeros(nr,1); XB = zeros(nr,1); qP = zeros(nr,1); qB = zeros(nr,1); % prefil output variables
  h = H(1,1); % set first throughput rate
  %% first integrate to get appropriate intitial values
  f0 = lsode('find_pavlova',[1, XrP, XrB, jPAm/kP, jBAm/kB, 0, 0]',[0 2000]');
  f0 = f0(2,:)'; % state variables at time 2000
  for i = 1:nr
    h = H(i,1); % copy appropriate throughput into h
    %% find equilibrium states
    [f err] = fsolve('find_pavlova', f0); f0 = f; % continuation
    if err ~= 1 % trouble
      %% first try to solve problem by integration
      f0 = [1, XrP, XrB, jPAm/kP, jBAm/kB, 0, 0]';
      f0 = lsode('find_pavlova', f0,[0 2000]');
      f0 = f0(2,:)'; % state variables at time 2000
      [f err] = fsolve('find_pavlova', f0); f0 = f; % continuation
      if err ~= 1 % trouble cannot be solved
        fprintf(['Warning: no steady states found for point ', ...
	       num2str(i), '\n']);
      end
    end
    MV(i) = f(1); % biomass
    %% measured concentration includes excreted concentrations
    XP(i) = f(2) + f(6); XB(i) = f(3) + f(7);
    %% measured cell quota of P,B = reserve per cell + P, B in structure
    qP(i) = yPV + f(4); qB(i) = yBV + f(5);
    
    %% test balances
    P = XrP - XP(i) - MV(i) * qP(i); % P balance
    B = XrB - XB(i) - MV(i) * qB(i); % B balance
    if P^2 + B^2 > 1e-4 % test mass balances
       fprintf(['Warning: mass balances are in error for point ', ...
     	       num2str(i), '\n']);
    end

    %% test biomass being non-negative
    if MV(i) < 0
      %% first try to solve problem by integration
      f0 = [1, XrP, XrB, jPAm/kP, jBAm/kB, 0, 0]';
      f0 = lsode('find_pavlova', f0,[0 2000]');
      f0 = f0(2,:)'; % state variables at time 2000
      [f err] = fsolve('find_pavlova', f0); f0 = f; % continuation
      MV(i) = f(1); XP(i) = f(2) + f(6); XB(i) = f(3) + f(7);
      qP(i) = yPV + f(4); qB(i) = yBV + f(5);
      if err ~= 1 || MV(i) < 0 % trouble cannot be solved
        fprintf(['Warning: no steady states with MV > 0 found for point ', ...
	       num2str(i), '\n']);
      end
    end
    
  end

