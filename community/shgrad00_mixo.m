function Xinf = shgrad00_mixo (X_t, j)
  %% Xinf = shgrad00_mixo (X_t, j)
  %% created: 2002/03/17 by Bas Kooijman, modified 2009/02/10
  %% time_plots for 'mixo' in vertical gradients: 0 reserves
  %% Xinf: (nL,nX) matrix with values of state variables (in columns)
  %%   as function of depth (in rows) at last integration point (t = tmax)
  %%   first row corresponds with surface layer
  %%   no downward transport from bottum layer (closed stack)
  %%   light reduction factor constant per layer

  [nt, nL] = size(X_t); nX = 4; nL = nL/nX; L = linspace(0,-nL,nL);
  
  Xinf = reshape(X_t(nt,:), nX, nL)'; % set last time point in output
  Xm =  reshape(max(X_t), nX, nL)'; Xm = max(Xm); % maximum value
  %% we need this for scaling plot axes

  clf
  
  if exist('j', 'var') == 1 % single plot mode
    %% movie of gradients
    switch j
	
      case 1
      ylabel('depth, m'); xlabel('DIC, muM'); 
      for i = 1:nt
	    X = reshape(X_t(i,:), nX, nL)';
	    plot ([0;Xm(1)], [L(nL);0], '8.', X(:,1), L, '8');
	    pause (0.5);
	  end
	

      case 2
      ylabel('depth, m'); xlabel('DIN, muM');
	  for i = 1:nt
	      X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(2)], [L(nL);0], 'b.', X(:,2), L, 'b');
	      pause (0.5);
	  end

      case 3
      ylabel('depth, m'); xlabel('detritus, muM');
	  for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(3)], [L(nL);0], '6.', X(:,3), L, '6');
	      pause (0.5);
	  end

      case 4
      ylabel('depth, m'); xlabel('structure, muM');
	  for i = 1:nt
	      X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(4)], [L(nL);0], 'g.', X(:,4), L, 'g');
	      pause (0.5);
	  end

      otherwise
	return;

    end
  else % multiple plot mode
    %% last time point only
    
        subplot (2, 2, 1);
        ylabel('depth, m'); xlabel('DIC, muM');
	    plot (Xinf(:,1), L, '8', 0, 0, '8.');

        subplot (2, 2, 2);
        ylabel('depth, m'); xlabel('DIN, muM');
        plot (Xinf(:,2), L, 'b', 0, 0, 'b.');

        subplot (2, 2, 3);
        ylabel('depth, m'); xlabel('detritus, muM');
        plot (Xinf(:,3), L, '6', 0, 0, '6.');

        subplot (2, 2, 4);
        ylabel('depth, m'); xlabel('structure, muM');
        plot (Xinf(:,4), L, 'g', 0, 0, 'g.');

  end
