function shcontsu (j)
  %% shcontsu (j)
  %% created 2000/10/17 by Bas Kooijman
  %% shows contour plot for bi-substrate RU, SU, and enzyme

  X_A = linspace(.0001,10,50)';
  X_B = X_A;

  if exist('j', 'var') == 1 % single plot mode
    clf

    switch j
	
      case 1; clf
        fSU = su11(X_A,X_B);
        title('1,1-SU');
        contour(fSU, 10);

      case 2; clf
        fenz = enz11(X_A,X_B);
        title('1,1-enzyme');
        contour(fenz, 10);

      case 3; clf
        fRU = ru11(X_A,X_B);
        title('1,1-RU');
        contour(fRU, 10);

      otherwise
	return
    end

  else % multiplot mode

 
    subplot(1,3,1); clf
    fSU = su11(X_A,X_B);
    title('1,1-SU');
    contour(fSU, 10);


    subplot(1,3,3); clf
    fRU = su11(X_A, X_B);
    title('1,1-RU');
    contour(fRU, 10);

    subplot(1,3,2); clf
    fenz = enz11(X_A,X_B);
    title('1,1-enzyme');
    size(fenz)
    contour(fenz, 10);
  end