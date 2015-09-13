function shlc50 (c0,bk,ke)
  %% shlc50 (c0,bk,ke)
  %% created 2001/12/28 by Bas Kooijman, modified 2009/02/20
  %% shows lc50.time curve, given three parameters
  %%   c0: M, NEC
  %%   bk: 1/(M t), killing rate
  %%   ke: 1/t, elimination rate
  %% calls fnlt50, fnlc50

  global t c C0 Bk Ke;

  %% set time
  C0 = c0; Bk = bk; Ke = ke; % copy pars to global variables 
  c = 50*c0; t0 = - log(1 - c0/ c)/ ke;
  t0 = fsolve('fnlt50', t0);    % lower time, upper c boundary
  c = 2*c0;  t1 = - log(1 - c0/ c)/ ke;
  t1 = fsolve('fnlt50', t1);   % upper time, lower c boundary
  nt = 100;  tc = linspace(t0,t1,nt);         % set time points

  lc = c0*ones(nt,1); c= 100*c0; % initiate lc50 vector
  LC = lc; % copy for Bonnemet approximation

  for i=1:nt
    t = tc(i); c = fsolve('fnlc50',c); lc(i) = c; % get true value
    %% approximation by Vincent Bonnemet
    if t < 1/ke
      x = log(2)*(log(2)/bk+2*c0*t)/bk;
      LC(i) = (log(2)/ bk + c0 * t + sqrt(x))/ (ke * t^2);
    else
      x = (log(2)/bk+c0*t)^2 - (2*t-1/ke)*c0^2/ke;
      LC(i) = (log(2)/ bk + c0 * t + sqrt(x))/ (2 * t - 1/ke);
    end
  end

  Lc = c0./(1 - exp(-ke * tc));

  %% plotting
  clf
  ylabel('LC50'); xlabel('exposure time');
  plot ([0, 0, tc(nt)], [0, c0, c0], 'g', ...
	tc, lc, 'g', ...
	tc, LC, 'r', ...
	tc, Lc, 'b');

  %[bk*c0/ke, max(abs((LC-lc)./lc))]
