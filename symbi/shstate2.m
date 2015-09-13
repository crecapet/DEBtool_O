function shstate2 (j)
  %% shstate2 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% chemostat equilibrium plots for 'endosym'
  %% State vector:
  %% (1-2)substrates S (3-4)products P
  %% (5,6)structure V, reserve density m of species 1
  %% (7,8)structure V, reserve density m of species 2 (external)

  global h1_S h2_S h1_P h2_P h1_V h2_V ...        % hazard rates,
      J1_Sr J2_Sr S1_r S2_r                       % substrate input
  global istate2 

  %%   gset term postscript color solid 'Times-Roman' 40
  %%   gset output 'state2.ps'
  %%   gset xrange [0:.06]
  %%   gset xtics 0, .02, .06
  %%   gset yrange [0:140]
  %%   gset ytics 0, 20, 140

  err = testpars; % set and test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end

  %% make sure that hmax exceeds actual max throughput rate
  hmax = 1; nh = 5000; H = linspace(1e-4,hmax,nh); % set throughput rates
  X = zeros(nh,8); % initiate state matrix
  
  %% set nt = 200 if you want time-plots for each h-value
  tmax = 10000; nt = 2; t = linspace(0, tmax, nt); % set time points
  %% clg; gset nokey; xlabel('time'); ylabel('structures'); % label time plots

  i = 20; % set initial counter, H(i) must be lower than h-max
  h = H(i); h1_S = h; h2_S = h; h1_P = h; h2_P = h; h1_V = h; h2_V = h;
  J1_Sr = S1_r*h; J2_Sr = S2_r*h;
  X0  = lsode ('dstate2', istate2, t);
  %% ttext = ['initial h = ', num2str(h)]; title(ttext);
  %% plot (t, X0(:,5), 'b', t, X0(:,7), 'r'); pause(0.5);
  [x, err] = fsolve('dstate2', max(0.5, X0(nt,:)')); X(i,:) = x';
  if err ~= 1 || prod(x>0) == 0
    fprintf(['convergence problems for initial h = ', num2str(h), '\n']);
    return; % hopeless if first throughput already failed
  end

  for k = 1:(i-1) % from initial throughput down to zero
    %% set throughput
    h = H(i-k); h1_S = h; h2_S = h; h1_P = h; h2_P = h; h1_V = h; h2_V = h; 
    J1_Sr = S1_r*h; J2_Sr = S2_r*h;
    x0 =  X(i-k+1,:)'; % set start value for new state variables
    [x, err] = fsolve('dstate2', x0'); X(i-k,:) = x';
    if err ~= 1 || prod(x>0) ~= 1 % if no convergence, then first integrate
      x0([5 7]) = max(1,x0([5 7])); X0  = lsode ('dstate2', x0, t);
      %% ttext = ['down h = ', num2str(h)]; title(ttext);
      %% plot (t, X0(:,5), 'b', t, X0(:,7), 'r'); pause(1);
      [x, err] = fsolve('dstate2', max(0.5, X0(nt,:)')); X(i-k,:) = x';
    end
    if err ~= 1 || prod(x>0) ~= 1 % if still no convergence then report
      fprintf(['convergence problems for h = ', num2str(h), '\n']);
      %% X(i-k,:)=[]; H(i-k)=[]; i=i-1 % remove bad value 
    end
  end

  while prod(X(i,:)>1e-4) == 1 && i<nh
                %% from initial throughput up to max throughput
    i = i+1;
    %% set throughput
    h = H(i); h1_S = h; h2_S = h; h1_P = h; h2_P = h; h1_V = h; h2_V = h; 
    J1_Sr = S1_r*h; J2_Sr = S2_r*h;
    x0 = X(i-1,:)'; % set start value for new state variables
    [x, err] = fsolve('dstate2', x0'); X(i,:) = x';
    if err ~= 1 || prod(x>0) ~= 1 % if no convergence, then first integrate
      x0([5 7]) = max(1,x0([5 7])); X0  = lsode ('dstate2', x0, t);
      %% ttext = ['up h = ', num2str(h)]; title(ttext);
      %% plot (t, X0(:,5), 'b', t, X0(:,7), 'r'); pause(1);
      [x, err] = fsolve('dstate2', max(0.5, X0(nt,:)')); X(i,:) = x';    
    end
    if err ~= 1 || prod(x>0) ~= 1  % if still no convergence then report
      fprintf(['convergence problems for h = ', num2str(h), '\n']);
    end
  end
  
  X = X(1:(i-1),:); % remove throughput rates with washout
  H = H(1:(i-1))';  
    
  clf;
  
  if exist('j', 'var')==1 % single plot mode
    switch j
	
      case 1
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

      case 4
        xlabel('throughput rate'); ylabel('products');
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

      case 2
        xlabel('throughput rate'); ylabel('structures');
        plot (H, X(:,5), 'b', H, X(:,7), 'r');

      case 3
        xlabel('throughput rate'); ylabel('res densities');
        plot (H, X(:,6), 'b',H, X(:,8), 'r');

      case 5
        xlabel('throughput rate'); ylabel('ratio structure 2/1');
        plot (H, X(:,7)./X(:,5), 'g');

      case 6
	xlabel('throughput rate'); ylabel('ratio res density 2/1');
        plot (H, X(:,8)./X(:,6), 'g');

      otherwise
	return;

    end
  else % multiple plot mode
    
        subplot (2, 3, 1);
        xlabel('throughput rate'); ylabel('substrates'); 
        plot (H, X(:,1), 'b', H, X(:,2), 'r');

        subplot (2, 3, 4); 
        xlabel('throughput rate'); ylabel('products'); 
        plot (H, X(:,3), 'b', H, X(:,4), 'r');

        subplot (2, 3, 2);
        xlabel('throughput rate'); ylabel('structures');
        plot (H, X(:,5), 'b', H, X(:,7), 'r');

        subplot (2, 3, 3);
        xlabel('throughput rate'); ylabel('res densities');
        plot (H, X(:,6), 'b', H, X(:,8), 'r');

        subplot (2, 3, 5);
        xlabel('throughput rate'); ylabel('ratio structure 2/1');
        plot (H, X(:,7)./X(:,5), 'g');

        subplot (2, 3, 6);
	    xlabel('throughput rate'); ylabel('ratio res density 2/1');
        plot (H, X(:,8)./X(:,6), 'g');

  end