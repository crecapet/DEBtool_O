function shregr (func, p, varargin)
  %% shregr (func, p, varargin)
  %% created: 2001/08/20 by Bas Kooijman; modified 2009/10/29
  %% plots observations and model predictions
  %% func: character string with name of user-defined function
  %%   see nrregr
  %% p: (r,k) matrix with parameter values in p(:,1) 
  %% xywi: (ni,k) matrix with
  %%    xywi(:,1) independent variable
  %%    xywi(:,2) dependent variable (optional)
  %%    The number of data matrices xyw1, xyw2, ... is optional but >0
  %%    but must match the definition of 'func'.

  i = 1; % initiate data set counter
  ci = num2str(i); % character string with value of i
  nxyw = nargin - 2; % number of data sets
  while (i <= nxyw) % loop across data sets
    eval(['xyw', ci, ' = varargin{i};']); % assing unnamed arguments to xywi
    eval(['[n(', ci, ') k] = size(xyw', ci, ');']); % number of data points
    if i == 1
      listxyw = ['xyw', ci,',']; % initiate list xyw
      listX = ['X', ci,',']; % initiate list X
      listf = ['f', ci,',']; % initiate list f
      listg = ['g', ci,',']; % initiate list f
    else     
      listxyw = [listxyw, ' xyw', ci,',']; % append list xyw
      listX = [listX, ' X', ci,',']; % append list X
      listf = [listf, ' f', ci,',']; % append list f
      listg = [listg, ' g', ci,',']; % append list g
    end
    i = i + 1;
    ci = num2str(i); % character string with value of i
  end

  [i, nl] = size(listxyw); listxyw = listxyw(1:(nl-1)); % remove last ','
  [i, nl] = size(listX); listX = listX(1:(nl-1)); % remove last ','
  [i, nl] = size(listf); listf = listf(1:(nl-1)); % remove last ','
  [i, nl] = size(listg); listg = listg(1:(nl-1)); % remove last ','
  
  p = p(:,1); % remove other columns from parameter data

  global dataset Range all_in_one; % option settings

  for i = 1:nxyw
    ci = num2str(i);
    eval(['global xlabel', ci, ' ylabel', ci, ';']);
  end

  sh_options_exist; % make sure that show options exist
  %% set options if necessary
  if 0 == prod(size(dataset)) % select data sets to be plotted
    dataset = 1:nxyw;
  end
  if 0 == prod(size(all_in_one)) % all graphs in one
    all_in_one = 0;
  end
  if 0 == prod(size(Range)) % set plot ranges
    Range = zeros (nxyw, 2);
    for i = 1:nxyw
      ci = num2str(i);
      eval(['r0 = 0.9*min(xyw', ci, '(:,1));']);
      eval(['r1 = 1.1*max(xyw', ci, '(:,1));']);
      Range(i,:) = [r0 r1];
    end
  end
  
  [nr i] = size(Range);
  if nr ~= nxyw % set plot ranges, because existing ones are invalid
    Range = zeros (nxyw, 2);
    for i = 1:nxyw
      ci = num2str(i);
      eval(['r0 = 0.9*min(xyw', ci, '(:,1));']);
      eval(['r1 = 1.1*max(xyw', ci, '(:,1));']);
      Range(i,:) = [r0 r1];
    end
  end
  
  for i = 1:nxyw % set plot labels
    ci = num2str(i);
    if exist(['xlabel', ci], 'var') ~= 1
      eval(['xlabel', ci, ' = '' '';']);
    end
    if exist(['ylabel', ci], 'var') ~= 1
      eval(['ylabel', ci, ' = '' '';']);
    end    
  end

  nS = max(size(dataset)); % set number of data sets to be plotted  

  for i = 1:nxyw  %% set independent variables
    eval(['X', num2str(i), ' = linspace(', ...
	  num2str(Range(i,1)), ', ', num2str(Range(i,2)), ', 100);']);
  end
  
  %% get dependent variables
  eval(['[', listf,'] = ', func, '(p,', listX,' );']);
  eval(['[', listg,'] = ', func, '(p,', listxyw,' );']);
  clf;

  hold on;

  if all_in_one ~= 0 % single plot mode
    for i = 1:nS % loop across data sets that must be plotted
      ci = num2str(dataset(i));
      eval(['plot(X', ci, '(:, 1), f', ci, ', ''r'');']);
      eval(['[nr nc] = size(xyw', ci, ');']);
      if nc>1
        eval(['plot(xyw', ci, '(:,1), xyw', ci, '(:,2), ''b+'');']);
        for j = 1:n(dataset(i)) % connect data points with curves
	  eval(['plot([xyw', ci, '(j,[1 1]),' ...
	        'xyw', ci, '(j,2); g', ci, '(j)], ''m'');']);
        end
      end
      if i == 1 % set labels
	eval(['xtext = xlabel',ci,';']);
        eval(['xlabel(''', xtext, ''');']);
        eval(['ytext = ylabel',ci,';']);
        eval(['ylabel(''', ytext, ''');']);
      end  
    end
  else % multiplot mode
    %% rows and colums of multiplot
    r = max([1, floor(sqrt(nxyw))]); k = ceil(nS/r);
    for i = 1:nS % loop across data sets that must be plotted
      subplot(r,k,i)  
      clf;
      ci = num2str(dataset(i));
      eval(['xtext = xlabel',ci,';']);
      eval(['xlabel(''', xtext, ''');']);
      eval(['ytext = ylabel',ci,';']);
      eval(['ylabel(''', ytext, ''');']);
      eval(['plot(X', ci, '(:, 1), f', ci, ', ''r'');']);
      eval(['[nr nc] = size(xyw', ci, ');']);
      if nc>1
        eval(['plot(xyw', ci, '(:,1), xyw', ci, '(:,2), ''b+'');']);
      end
    end

  end
