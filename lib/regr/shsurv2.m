function shsurv2 (func, p, t, y, Z)
  %% shsurv2 (func, p, t, y, Z);
  %% created: 2002/01/11 by Bas Kooijman; modified 2009/02/20
  %% plots observations and model predictions
  %% func: name of user-defined function (see scsurv2)
  %% p: (r,k)-matrix with parameters in p(1,:)
  %% t: (n,1)-vector with first independent variable (time)
  %% y: (m,1)-vector with second independent variable
  %% Z: (n,m)-matrix with observed numbers of survivors (optional)

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
    Range = [0, 1.1*max(t); 0.9*min(y(:,1)), 1.1*max(y(:,1))];
  end
  if 0 == prod(size(xtext))
    xtext = 'time ';
  end
  if 0 == prod(size(ytext))
    ytext = ' ';
  end
  if 0 == prod(size(ztext))
    ztext = 'number ';
  end
  
  nt = max(size(t)); ny = max(size(y(:,1))); nty = nt*ny;
  N = 100; M = 10;
  xaxis = linspace(Range(1,1), Range(1,2), N)';
  yaxis = linspace(Range(2,1), Range(2,2), N)';
  Xaxis = linspace(Range(1,1), Range(1,2), M)';
  Yaxis = linspace(Range(2,1), Range(2,2), M)';

  
  p = p(:,1);
  eval(['F = ', func,' (p, t, y);']);
  Z = Z./(ones(nt,1)*Z(1,:));

  clf
  
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
  
    xlabel(xtext); ylabel(ytext); zlabel(ztext);
    %% gset linestyle 1 lt 2 lw 2 pt 3 ps 0.5
  
    if prod(size(Z)) ~= 0
      xyz = zeros(nty, 3);
      for i= 1:nt
        xyz((i-1)*ny + (1:ny), :) = [t(i*ones(ny,1)), y(:,1), Z(i,:)'];
      end
      plot3(xyz(:,1), xyz(:,2), xyz(:,3),'*b'); %% with points;
      z = ones(2,1);
      for i = 1:nt
        for j=1:ny
	      xyz = [t(i*z), y(j*z,1), [Z(i,j);F(i,j)]];
	      plot3 (xyz(:,1), xyz(:,2), xyz(:,3),'m');
        end
      end
    end
 
  elseif (plotnr == 1)
    hold on;
    for i = 1:ny
      eval(['f = ', func, '(p, xaxis, y(i,:));']);
      plot(xaxis, f, 'r')
      if prod(size(Z)) ~= 0
        plot(t, Z(:,i), 'b+');
        for j = 1:nt
          plot(t([j,j]), [Z(j,i); F(j,i)], 'm');
        end
      end
    end
    xlabel(xtext);
    ylabel(ztext);

  elseif (plotnr == 2)
    hold on;
    for i = 1:nt
      eval(['f = ', func, '(p, t(i), yaxis);']);
      plot(yaxis, f, 'r');
      if prod(size(Z)) ~= 0
        plot(y(:,1), Z(i,:)', 'b+');
        for j = 1:ny
          plot(y([j j],1), [Z(i, j); F(i, j)], 'm');
        end
      end
    end
    xlabel(ytext);
    ylabel(ztext);

  else
    clf;
    
    subplot(1,2,1); hold on;
    for i = 1:ny
      eval(['f = ', func, '(p, xaxis, y(i,1));']);
      plot(xaxis, f, 'r');
      if prod(size(Z)) ~= 0
        plot(t, Z(:,i), 'b+');
        for j = 1:nt
          plot(t([j, j]), [Z(j,i); F(j,i)], 'm');
        end
      end
    end
    xlabel(xtext);
    ylabel(ztext);
  
    subplot(1,2,2); hold on;
    for i = 1:nt
      eval(['f = ', func, '(p, t(i), yaxis);']);
      plot(yaxis, f, 'r');
      if prod(size(Z)) ~= 0
        plot(y(:,1), Z(i,:)', 'b+');
        for j = 1:ny
          plot(y([j, j],1), [Z(i,j); F(i,j)], 'm');
        end
      end
    end
    xlabel(ytext);
    ylabel(ztext);

  end