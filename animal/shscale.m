function shscale (j)
  %% created 2000/11/02 by Bas Kooijman, modified 2009/02/05
  %% body-size-scaling plots for 'animal'
  %% macro around 'scale'

  %% set structural length range from 0.1 till 150 cm:
  z = 10.^linspace(log10(.1), log10(150), 50)'; % zoom factors

  
  %% replace S1 by S in call for 'shloglogstar'
  %%   to place star-center at first data-point
  
  if exist('j', 'var') == 1 % single-plot mode
    
    S1 = scale (1,j);              % get variables for zoom factor 1
    S =  scale (z,j);              % get variables for all zoom factors
    RS = [min(S); max(S)];         % range of variables
    switch j
	
  case 1
	 xlabel('log max weight, g');
	 ylabel('log structure, cm^3');
	 shloglogstar (S1(1, [1 2]), RS(:, [1 2]), 'r');
	 plot(log10(S(:,1)), log10(S(:,2)), 'g');

  case 2
    xlabel('log max weight, g');
	 ylabel('log egg weight, g');
	 shloglogstar (S1(1, [1 3]), RS(:, [1 3]), 'r');
	 plot(log10(S(:,1)), log10(S(:,3)), 'g');

  case 3
 	 xlabel('log max weight, g');
	 ylabel('log dioxygen consumption, mol/d');
	 shloglogstar (S1(1, [1 4]), RS(:, [1 4]), 'r');
	 plot(log10(S(:,1)), log10(S(:,4)), 'g');

  case 4
	 xlabel('log max weight, g');
	 ylabel('log N-waste production, mol/d');
	 shloglogstar (S1(1, [1 5]), RS(:, [1 5]), 'r');
	 plot(log10(S(:,1)), log10(S(:,5)), 'g');

  case 5
	 xlabel('log max weight, g');
	 ylabel('log min food density, mM');
	 shloglogstar (S1(1, [1 6]), RS(:, [1 6]), 'r');
	 plot(log10(S(:,1)), log10(S(:,6)), 'g');

  case 6
	 xlabel('log max weight, g');
	 ylabel('log max ingestion rate, mol/d');
	 shloglogstar (S1(1, [1 7]), RS(:, [1 7]), 'r');
	 plot(log10(S(:,1)), log10(S(:,7)), 'g');

  case 7
	 xlabel('log max weight, g');
	 ylabel('log max growth rate, cm^3/d');
	 shloglogstar (S1(1, [1 8]), RS(:, [1 8]), 'r');
	 plot(log10(S(:,1)), log10(S(:,8)), 'g');

  case 8
	 xlabel('log max weight, g');
	 ylabel('log von Bertalanffy growth rate, 1/d');
	 shloglogstar (S1(1, [1 9]), RS(:, [1 9]), 'r');
	 plot(log10(S(:,1)), log10(S(:,9)), 'g');

  case 9
	 xlabel('log max weight, g');
	 ylabel('log min incubation period, d');
	 shloglogstar (S1(1, [1 10]), RS(:, [1 10]), 'r');
	 plot(log10(S(:,1)), log10(S(:,10)), 'g');

  case 10
	 xlabel('log max weight, g');
	 ylabel('log min juvenile period, d');
	 shloglogstar (S1(1, [1 11]), RS(:, [1 11]), 'r');
	 plot(log10(S(:,1)), log10(S(:,11)), 'g');

  case 11
	 xlabel('log max weight, g');
	 ylabel('log max starvation time, d');
	 shloglogstar (S1(1, [1 12]), RS(:, [1 12]), 'r');
	 plot(log10(S(:,1)), log10(S(:,12)), 'g');

  case 12
	 xlabel('log max weight, g');
	 ylabel('log max reproduction rate, 1/d');
	 shloglogstar (S1(1, [1 13]), RS(:, [1 13]), 'r');
	 plot(log10(S(:,1)), log10(S(:,13)), 'g');
	
  otherwise
	 return
  end
    
else % multiplot mode
    S1 = scale (1);              % get variables for zoom factor 1
    S = scale (z);               % get variables for all zoom factors
    RS = [min(S); max(S)];       % range of variables

   subplot(3,4,1)
	xlabel('log max weight, g');
	ylabel('log structure, cm^3');
	shloglogstar (S1(1, [1 2]), RS(:, [1 2]), 'r');
	plot(log10(S(:,1)), log10(S(:,2)), 'g');

   subplot(3,4,2)
	xlabel('log max weight, g');
	ylabel('log egg weight, g');
	shloglogstar (S1(1, [1 3]), RS(:, [1 3]), 'r');
	plot(log10(S(:,1)), log10(S(:,3)), 'g');

   subplot(3,4,3)
	xlabel('log max weight, g');
	ylabel('log dioxygen consumption, mol/d');
	shloglogstar (S1(1, [1 4]), RS(:, [1 4]), 'r');
	plot(log10(S(:,1)), log10(S(:,4)), 'g');

   subplot(3,4,4)
	xlabel('log max weight, g');
	ylabel('log N-waste production, mol/d');
	shloglogstar (S1(1, [1 5]), RS(:, [1 5]), 'r');
	plot(log10(S(:,1)), log10(S(:,5)), 'g');

   subplot(3,4,5)
	xlabel('log max weight, g');
	ylabel('log min food density, mM');
	shloglogstar (S1(1, [1 6]), RS(:, [1 6]), 'r');
	plot(log10(S(:,1)), log10(S(:,6)), 'g');

   subplot(3,4,6)
	xlabel('log max weight, g');
	ylabel('log max ingestion rate, mol/d');
	shloglogstar (S1(1, [1 7]), RS(:, [1 7]), 'r');
	plot(log10(S(:,1)), log10(S(:,7)), 'g');

   subplot(3,4,7)
	xlabel('log max weight, g');
	ylabel('log max growth rate, cm^3/d');
	shloglogstar (S1(1, [1 8]), RS(:, [1 8]), 'r');
	plot(log10(S(:,1)), log10(S(:,8)), 'g');

   subplot(3,4,8)
	xlabel('log max weight, g');
	ylabel('log von Bertalanffy growth rate, 1/d');
	shloglogstar (S1(1, [1 9]), RS(:, [1 9]), 'r');
	plot(log10(S(:,1)), log10(S(:,9)), 'g');

   subplot(3,4,9)
	xlabel('log max weight, g');
	ylabel('log min incubation period, d');
	shloglogstar (S1(1, [1 10]), RS(:, [1 10]), 'r');
	plot(log10(S(:,1)), log10(S(:,10)), 'g');

   subplot(3,4,10)
	xlabel('log max weight, g');
	ylabel('log min juvenile period, d');
	shloglogstar (S1(1, [1 11]), RS(:, [1 11]), 'r');
	plot(log10(S(:,1)), log10(S(:,11)), 'g');

   subplot(3,4,11)
	xlabel('log max weight, g');
	ylabel('log max starvation time, d');
	shloglogstar (S1(1, [1 12]), RS(:, [1 12]), 'r');
	plot(log10(S(:,1)), log10(S(:,12)), 'g');

   subplot(3,4,12)
	xlabel('log max weight, g');
	ylabel('log max reproduction rate, 1/d');
	shloglogstar (S1(1, [1 13]), RS(:, [1 13]), 'r');
	plot(log10(S(:,1)), log10(S(:,13)), 'g');
        
  end