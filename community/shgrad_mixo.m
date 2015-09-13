function Xinf = shgrad_mixo (j)
  %% Xinf = shgrad_mixo (j)
  %% created: 2002/03/15 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'mixo' in vertical gradients
  %% Xinf: (nL,nX) matrix with values of state variables (in columns)
  %%   as function of depth (in rows) at last integration point (t = tmax)
  %%   first row corresponds with surface layer
  %%   no downward transport from bottum layer (closed stack)
  %%   light reduction factor constant per layer

  global istate; % initial states 
  global nL nX;

  pars0_mixo; % set parameter values
  nL = 50; L = linspace(0, -nL, nL); %% number of layers, depth
  nX = max(size(istate)); % number of state variables per layer
  X0 = zeros(nL*nX,1);    % initiate initial state
  
  %% start with homogeneous gradient at time = 0
  %% catenate state variables in all layers
  for i = 1:nL
    X0((i-1)*nX + (1:nX)) = istate;
  end
  
  
  tmax = 50; nt = 100; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dgrad_mixo', X0, t);

  Xinf = reshape(X_t(tmax,:), nX, nL)'; % set last time point in output
  Xm =  reshape(max(X_t), nX, nL)'; Xm = max(Xm); % maximum value

  clf
  
  if exist('j', 'var') == 1 % single plot mode
    %% movie of gradients
    switch j
	
      case 1
        ylabel('depth, m'); xlabel('DIC, muM'); 
        for i = 1:nt
	      X = reshape(X_t(i,:), nX, nL)';
	      plot (X(:,1), L, '8', 0, 0, '8.', Xm(1), 0, '8.');
	    end
	

      case 2
        ylabel('depth, m'); xlabel('DIN, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot (X(:,2), L, 'b', 0, 0, 'b.', Xm(2), 0, 'b.');
	end

      case 3
        ylabel('depth, m'); xlabel('detritus, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot (X(:,3), L, '6', 0, 0, '6.', Xm(3), 0, '6.');
	end

      case 4
        ylabel('depth, m'); xlabel('structure, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot (X(:,4), L, 'g', 0, 0, 'g.', Xm(4), 0, 'g.');
	end

      otherwise
	return;

    end
  else % multiple plot mode
    %% last time point only
    
        subplot (2, 2, 1)
        ylabel('depth, m'); xlabel('DIC, muM');
	    plot (Xinf(:,1), L, '8', 0, 0, '8.');

        subplot (2, 2, 2)
        ylabel('depth, m'); xlabel('DIN, muM');
        plot (Xinf(:,2), L, 'b', 0, 0, 'b.');

        subplot (2, 2, 3)
        ylabel('depth, m'); xlabel('detritus, muM');
        plot (Xinf(:,3), L, '6', 0, 0, '6.');

        subplot (2, 2, 4)
        ylabel('depth, m'); xlabel('structure, muM');
        plot (Xinf(:,4), L, 'g', 0, 0, 'g.');

  end
