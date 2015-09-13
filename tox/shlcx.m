function shlcx (c0,bk,ke,x)
  %% shlcx (c0,bk,ke,x)
  %% created 2002/06/04 by Bas Kooijman, modified 2009/02/20
  %% shows lc(100x).time curve, given three parameters
  %%   c0: M, NEC
  %%   bk: 1/(M t), killing rate
  %%   ke: 1/t, elimination rate
  %% calls fnltx, fnlcx

  global t c C0 Bk Ke X;
  if exist('x', 'var')==0
    X = 0.5;
  else
    X = x;
  end

  %% set time
  C0 = c0; Bk = bk; Ke = ke; % copy pars to global variables 
  c = 50*c0; t0 = - log(1 - c0/ c)/ ke; % crude initial estimate!
  t0 = fsolve('fnltx', t0);    % lower time, upper c boundary
  c = 2*c0;  t1 = - 10*log(1 - c0/ c)/ ke; % crude initial estimate!
  t1 = fsolve('fnltx', t1);   % upper time, lower c boundary
  nt = 100;  tc = linspace(t0,t1,nt); % set time points

  lc = c0*ones(nt,1); c= 100*c0; % initiate lc(100x) vector

  for i=1:nt
    t = tc(i); c = fsolve('fnlcx',c); lc(i) = c; % get true value
  end

  %% plotting
  clf
  ylabel(['LC',num2str(100*X)]); xlabel('exposure time');
  plot ([0, 0, tc(nt)], [0, c0, c0], 'g', tc, lc, 'g');
