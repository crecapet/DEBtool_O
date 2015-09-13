function shstate1 (j)
  %% shstate1 (j)
  %% created: 2002/04/01 by Bas Kooijman, modified 2009/02/20
  %% chemostat equilibrium plots for 'endosym'
  %% State vector:
  %% (1-2)substrates S (3-4)products P
  %% (5,6)structure V, reserve density m of species 1
  %% (7,8)structure V, reserve density m of species 2 (external)

  global h1_S h2_S h1_P h2_P h1_V h2_V ...       % hazard rates,
      J1_Sr J2_Sr S1_r S2_r                      % substrate input
  global istate1

  err = testpars; % set and test parameter values on consistency
  if err ~= 0 % inconsistent parameter values
    return
  end

  %% make sure that hmax exceeds actual max throughput rate
  hmax = 1.0; nh = 500; H = linspace(1e-4, hmax, nh); % set throughput rates
  X = zeros(nh,8); % initiate state matrix

  %% set nt = 200 if you want time-plots for each h-value
  tmax = 200; nt = 2; t = linspace(0,tmax,nt); % set time points
  %% clg; gset nokey; xlabel('time'); ylabel('structures');

  i = 20; % set initial counter
  h = H(i); h1_S = h; h2_S = h; h1_P = h; h2_P = h; h1_V = h; h2_V = h;
  J1_Sr = S1_r*h; J2_Sr = S2_r*h;
  X0  = lsode ('dstate1', istate1, t);
  %% ttext = ['initial h = ', num2str(h)]; title(ttext);
  %% plot (t, X0(:,5), 'b', t, X0(:,7), 'r');
  X(i,:) = fsolve('dstate1',X0(nt,:)')';

  for k = 1:(i-1) % from initial throughput down to zero
    h = H(i-k); h1_S = h; h2_S = h; h1_P = h; h2_P = h; h1_V = h; h2_V = h;
    J1_Sr = S1_r*h; J2_Sr = S2_r*h;
    X0 = lsode ('dstate1', X(i-k+1,:)', t);
    %% ttext = ['down h = ', num2str(h)]; title(ttext);
    %% plot (t, X0(:,5), 'b', t, X0(:,7), 'r');
    X(i-k,:) = fsolve('dstate1', X0(nt,:)')';
  end
  
  while X(i,5)>1e-4 && X(i,7)>1e-4 && i<nh
	                  % from initial throughput up to max throughput
    i = i+1;
    h = H(i); h1_S = h; h2_S = h; h1_P = h; h2_P = h; h1_V = h; h2_V = h;
    J1_Sr = S1_r*h; J2_Sr = S2_r*h;
    X0 = lsode ('dstate1', X(i-1,:)', t);
    %% ttext = ['up h = ', num2str(h)]; title(ttext);
    %% plot (t, X0(:,5), 'b', t, X0(:,7), 'r');
    X(i,:) = fsolve('dstate1',X0(nt,:)')';
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
 
endfunction
