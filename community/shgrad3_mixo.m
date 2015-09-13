function Xinf = shgrad3_mixo (j)
  %% Xinf = shgrad3_mixo (j)
  %% created: 2002/03/16 by Bas Kooijman, modified 2009/02/20
  %% time_plots for 'mixo' in vertical gradients: 3 reserves
  %% Xinf: (nL,nX) matrix with values of state variables (in columns)
  %%   as function of depth (in rows) at last integration point (t = tmax)
  %%   first row corresponds with surface layer
  %%   no downward transport from bottum layer (closed stack)
  %%   light reduction factor constant per layer

  global istate; % initial states 
  global nL nX j_L_F J_L_F;

  pars3_mixo; % set parameter values
  J_L_F = j_L_F; % copy light intensity into dummy
  nL = 50; L = linspace(0, -nL, nL); %% number of layers, depth
  nX = max(size(istate)); % number of state variables per layer
  X0 = zeros(nL*nX,1);    % initiate initial state
  
  %% start with homogeneous gradient at time = 0
  %% catenate state variables in all layers
  for i = 1:nL
    X0((i-1)*nX + (1:nX)) = istate;
  end
  
  
  tmax = 50; nt = 100; t = linspace (0, tmax, nt); % set time points
  X_t  = lsode ('dgrad3_mixo', X0, t);

  Xinf = reshape(X_t(nt,:), nX, nL)'; % set last time point in output
  Xm =  reshape(max(X_t), nX, nL)'; Xm = max(Xm); % maximum value
  
  fprintf('hit a key to proceed \n');
  pause;

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
          plot ([0;Xm(2)], [L(nl);0], 'b.', X(:,2), L, 'b');
	  pause (0.5);
	end

      case 3
        ylabel('depth, m'); xlabel('struc-detritus, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(3)], [L(nL);0], '6.', X(:,3), L, '6');
	  pause (0.5);
	end

      case 4
        ylabel('depth, m'); xlabel('res-detritus, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(4)], [L(nL);0], '6.', X(:,4), L, '6');
	  pause (0.5);
	end

      case 5
        ylabel('depth, m'); xlabel('structure, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(5)], [L(nL);0], 'g.', X(:,5), L, 'g');
	  pause (0.5);
	end

      case 6
        ylabel('depth, m'); xlabel('reserves, muM');
	for i = 1:nt
	  X = reshape(X_t(i,:), nX, nL)';
          plot ([0;Xm(6)], [L(nL);0], 'r.', X(:,6), L, 'r', ...
		[0;Xm(7)], [L(nL);0], '8.', X(:,7), L, '8', ...
		[0;Xm(8)], [L(nL);0], 'b.', X(:,8), L, 'b');
	  pause (0.5);
	end

      otherwise
	return;

    end
  else % multiple plot mode
    %% last time point only
    
        subplot (2, 3, 1)
        ylabel('depth, m'); xlabel('DIC, muM');
	    plot (Xinf(:,1), L, '8', 0, 0, '8.');

        subplot (2, 3, 2)
        ylabel('depth, m'); xlabel('DIN, muM');
        plot (Xinf(:,2), L, 'b', 0, 0, 'b.');

        subplot (2, 3, 3)
        ylabel('depth, m'); xlabel('struc-detritus, muM');
        plot (Xinf(:,3), L, '6', 0, 0, '6.');

        subplot (2, 3, 4)
        ylabel('depth, m'); xlabel('res-detritus, muM');
        plot (Xinf(:,4), L, '6', 0, 0, '6.');

        subplot (2, 3, 5)
        ylabel('depth, m'); xlabel('structure, muM');
        plot (Xinf(:,5), L, 'g', 0, 0, 'g.');

        subplot (2, 3, 6)
        ylabel('depth, m'); xlabel('reserves, muM');
        plot (Xinf(:,6), L, 'r', 0, 0, 'r.', ...
	      Xinf(:,7), L, '8', 0, 0, '8.', ...
	      Xinf(:,8), L, 'b', 0, 0, 'b.');

  end
