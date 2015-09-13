function shtemp2corr (T_1, Tpars)
  %% shtemp2corr (T_1, Tpars)
  %% Created 2002/04/10 by Bas Kooijman, modified 2009/02/15
  %% plots correction factor as a function of temperature

  global t_1 tpars; % for use in findt
  t_1 = T_1; tpars = Tpars;
  
  T_A = Tpars(1); % Arrhenius temperature
  T_L = Tpars(2); % Lower temp boundary
  T_H = Tpars(3); % Upper temp boundary
  T_AL = Tpars(4); % Arrh. temp for lower boundary
  T_AH = Tpars(5); % Arrh. temp for upper boundary
  
  %% clg; hold on; gset nokey;
  title ('temperature dependence of rates')
  xlabel('10^4/temp, K'); ylabel('corr factor');
  
  T_LL = fsolve('findt', T_L);
  T_HH = fsolve('findt', T_H + 10);
  iT_L = linspace(1/T_LL, 1/T_L, 20);
  TC_L = tempcorr (1./iT_L, T_1, Tpars);
  iT   = linspace(1/T_L, 1/T_H, 60);
  TC   = tempcorr (1./iT, T_1, Tpars);
  iT_H = linspace(1/T_H, 1/T_HH, 20);
  TC_H = tempcorr (1./iT_H, T_1, Tpars);

  semilogy(10^4*iT_H, TC_H, 'r', 10^4*iT, TC, 'g', ...
      10^4*iT_L, TC_L, 'b');

  %% return;
  %% the second plot is standard Arrhenius between Temp-boundaries
  
  TC_L = exp(T_A/T_1 - T_A/T_L); TC_H = exp(T_A/T_1 - T_A/T_H);
  semilogy([10^4/T_L, 10^4/T_L], [0.01, TC_L], 'b', ...
	   [10^4/T_L, 10^4/T_H], [TC_L, TC_H], 'g', ...
	   [10^4/T_H, 10^4/T_H], [0.01, TC_H], 'r');
