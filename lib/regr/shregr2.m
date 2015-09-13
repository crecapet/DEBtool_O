function shregr2 (func, p, x, y, Z)
  %% shregr2 (func, p, x, y, Z)
  %% created: 2001/08/20 by Bas Kooijman; 2005/02/18; 2009/02/20
  %% plots observations and model predictions
  %% func: name of user-defined function (see nrregr2)
  %% p: (r,k)-matrix with parameters in p(1,:)
  %% x: (n,1)-vector with first independent variable
  %% y: (m,1)-vector with second independent variable
  %% Z: (n,m)-matrix with observations (optional)

  global xtext ytext ztext plotnr Range all_in_one;

  sh_options_exist; % make sure that show options exist
  %% set options if necessary
  if 0 == prod(size(plotnr)) % select plot number
    plotnr = 1:2;
  end
  if 0 == prod(size(all_in_one)) % all graphs in one
    all_in_one = 0;
  end
  if 0 == prod(size(Range)) % set plot ranges
    Range = [0.9*min(x(:,1)) 1.1*max(x(:,1)); ...
             0.9*min(y(:,1)) 1.1*max(y(:,1))];
  end
  if 0 == prod(size(xtext))
    xtext = ' ';
  end
  if 0 == prod(size(ytext))
    ytext = ' ';
  end
  if 0 == prod(size(ztext))
    ztext = ' ';
  end

  [nx, k] = size(x); [ny, k] = size(y); n = nx*ny;
  N = 100; M = 10;
  xaxis = linspace(Range(1,1), Range(1,2), N)';
  yaxis = linspace(Range(2,1), Range(2,2), N)';
  Xaxis = linspace(Range(1,1), Range(1,2), M)';
  Yaxis = linspace(Range(2,1), Range(2,2), M)';

  p = p(:,1);
  eval(['F = ', func,' (p, x, y);']);
  
  clf;

  if all_in_one == 1
    hold on;
    for i = 1:M
      eval(['f = ', func, '(p, Xaxis(i), yaxis);']);
      xyz = [Xaxis(i*ones(N,1)), yaxis, f'];
      plot3(xyz(:,1), xyz(:,2), xyz(:,3), 'r');
    end
    for j = 1:M
      eval(['f = ', func, '(p, xaxis, Yaxis(j));']);
      xyz = [xaxis, Yaxis(j*ones(N,1)), f];
      plot3(xyz(:,1), xyz(:,2), xyz(:,3), 'r');
    end
    xlabel(xtext); ylabel(ytext); zlabel(ztext);
    view(-37.5, 30);
    grid on
    axis square
    rotate3d on;
  
    if prod(size(Z)) ~= 0
      xyz = zeros(n, 3);
      for i= 1:nx
        xyz((i-1)*ny + (1:ny), :) = [x(i*ones(ny,1)), y, Z(i,:)'];
      end
      plot3(xyz(:,1), xyz(:,2), xyz(:,3),'*b'); % with points;
      z = ones(2,1);
      for i = 1:nx
        for j=1:ny
	      xyz = [x(i*z), y(j*z), [Z(i,j);F(i,j)]];
	      plot3 (xyz(:,1), xyz(:,2), xyz(:,3),'m');
        end
      end
    end
    
  elseif plotnr == 1
    hold on;
    eval(['f = ', func, '(p, xaxis, y);']);
    for i = 1:ny
      plot(xaxis, f(:,i), 'r')
      if prod(size(Z)) ~= 0
        plot(x, Z(:,i), 'b+');
        for j = 1:nx
          plot(x([j j]), [Z(j,i); F(j,i)], 'm');
        end
      end
    end
    xlabel(xtext);
    ylabel(ztext);

  elseif plotnr == 2
    hold on;
    for i = 1:nx
      eval(['f = ', func, '(p, x(i), yaxis);']);
      plot(yaxis, f, 'r');
      if prod(size(Z)) ~= 0
        plot(y, Z(i,:)', 'b+');
        for j = 1:ny
          plot(y([j j]), [Z(i, j); F(i, j)], 'm');
        end
      end
    end
    xlabel(ytext);
    ylabel(ztext);
  
  else
    subplot(1,2,1); hold on;
    for i = 1:ny
      eval(['f = ', func, '(p, xaxis, y(i));']);
      plot(xaxis, f, 'r');
      if prod(size(Z)) ~= 0
        plot(x, Z(:,i), 'b+');
        for j = 1:nx
          plot(x([j j]), [Z(j,i); F(j,i)], 'm');
        end
      end
    end
    xlabel(xtext);
    ylabel(ztext);
  
    subplot(1,2,2); hold on;
    for i = 1:nx
      eval(['f = ', func, '(p, x(i), yaxis);']);
      plot(yaxis, f', 'r');
      if prod(size(Z)) ~= 0
        plot(y, Z(i,:)', 'b+');
        for j = 1:ny
          plot(y([j j]), [Z(i,j); F(i,j)], 'm');
        end
      end
    end
    xlabel(ytext);
    ylabel(ztext);
  
  end 