function [q, info] = nrregr(func, p, varargin)
  %% created: 2001/09/07 by Bas Kooijman; modofied 2007/04/04
  %% calculates least squares estimates using Newton Raphson method
  %%    multiple-sample case
  %% func: string with name of user-defined function
  %%    f = func (p, xyw) with
  %%      p: k-vector with parameters; xyw: (n,c)-matrix; f: n-vector
  %%    [f1, f2, ...] = func (p, xyw1, xyw2, ...) with  p: k-vector  and
  %%     xywi: (ni,k)-matrix; fi: ni-vector with model predictions
  %%    The dependent variable in the output f; For xyw see below.
  %% p: (k,2) matrix with
  %%    p(:,1) initial guesses for parameter values
  %%    p(:,2) binaries with yes or no iteration (optional)
  %% xyzi (read as xyw1, xyw2, .. ): (ni,3) matrix with
  %%    xywi(:,1) independent variable i
  %%    xywi(:,2) dependent variable i
  %%    xywi(:,3) weight coefficients i (optional)
  %%    xywi(:,>3) data-pont specific information data (optional)
  %%    The number of data matrices xyw1, xyw2, ... is optional but > 0
  %% q: matrix like p, but with least squares estimates
  %% info: 1 if convergence has been successful; 0 otherwise
  %% calls nrdregr, and user-defined function 'func'
  %% set options with 'nrregr_options'

  global index nxyw listx listxyw listf listg global_txt
  global max_step_number max_step_size max_norm report % option settings

  %% set options if necessary
  if exist('max_step_number','var')==0 
    nrregr_options('max_step_number', 10);
  end
  if exist('max_step_size','var')==0 
    nrregr_options('max_step_size', 1e20);
  end
  if exist('max_norm','var')==0
    nrregr_options('max_norm', 1e-8);
  end
  if exist('report','var')==0
    nrregr_options('report', 1);
  end
  if isempty(max_step_number)
    nrregr_options('max_step_number', 10);
  end
  if isempty(max_step_size)
    nrregr_options('max_step_size', 1e20);
  end
  if isempty(max_norm)
    nrregr_options('max_norm', 1e-8);
  end
  if isempty(report)
    nrregr_options('report', 1);
  end

  i = 1; % initiate data set counter
  info = 1; % initiate info setting
  ci = num2str(i); % character string with value of i
  nxyw = nargin - 2; % number of data sets
  while (i <= nxyw) % loop across data sets
    if i == 1
      listxyw = ['xyw', ci,',']; % initiate list xyw
      listx = ['xyw', ci]; % initiate list xyw for global declaration
      listf = ['f', ci,',']; % initiate list f
      listg = ['g', ci,',']; % initiate list g
    else     
      listxyw = [listxyw, ' xyw', ci,',']; % append list xyw
      listx = [listx, ' xyw', ci]; % append list xyw for global declaration
      listf = [listf, ' f', ci,',']; % append list f
      listg = [listg, ' g', ci,',']; % append list g
    end
    i = i + 1;
    ci = num2str(i); % character string with value of i
  end
  nl = size(listxyw,2); listxyw = listxyw(1:(nl - 1)); % remove last ','
  nl = size(listf,2); listf = listf(1:(nl - 1)); % remove last ','
  nl = size(listg,2); listg = listg(1:(nl - 1)); % remove last ','

  global_txt = strrep(['global ', listxyw], ',', ' ');
  eval(global_txt); % make data sets global

  i = 1; n = zeros(nxyw, 1); % initiate data counter
  ci = num2str(i); % character string with value of i
  while (i <= nxyw) % loop across data sets
    eval(['xyw', ci, ' = varargin{',ci,'};']); % assign unnamed arguments to xywi
    eval(['[n(', ci, '), k] = size(xyw', ci, ');']); % number of data points
    if i == 1
      eval(['Y = xyw',ci,'(:,2);']); % initiate dependent variables
      if k > 2
	    eval(['W = xyw',ci,'(:,3);']); % initiate weight coefficients
      else
	    W = ones(n(1),1);
      end
    else     
      eval(['Y = [Y;xyw', ci, '(:,2)];']); % append dependent variables
      if k > 2
	    eval(['W = [W;xyw', ci, '(:,3)];']); % append weight coefficients
      else
	    W = [W; ones(n(i),1)]; % append weight coefficients
      end
    end
    i = i + 1;
    ci = num2str(i); % character string with value of i
  end

  q = p; % copy input parameter matrix into output

  n = sum(n); % total number of data points in all samples
  W = W/ sum(W); % sum of weight coefficients set equal to 1

  [np, k] = size(p); % k: number of parameters
  index = 1:np;
  if k>1
    index = index(1 == p(:,2)); % indices of iterated parameters
  end
  l = length(index);  % l: number of parameters that must be iterated
  if (l == 0)
    return; % no parameters to iterate
  end
  
  norm = 1 + max_norm; % make sure that we start with iteration
  step_number = 0; % initiate number of iterations
  
  %% start of numerical minimization
  while (norm > max_norm) && (step_number < max_step_number)
    step_number = step_number + 1; % increment step number
    [fn, dfn] = nrdregr(func, q(:,1));
				% obtain function values and derivatives
    div = Y - fn;
    f = dfn' * (W .* div);   % weighted derivatives
    norm = f' * f;           % sum of squared derivatives
    step = (dfn' * (dfn .* W(:,ones(1,l))))\f;
    if report ~= 0           % monitor progress
      ssq = (W' * div .^ 2); % weighted sum of squared deviations
      fprintf(['step ', num2str(step_number), ' norm ', num2str(norm), ...
	    ' ssq ', num2str(ssq), '\n']); 
    end
    step_size = step' * step;
    step = step * min(max_step_size, step_size)/ step_size;
				% reduce step if necessary
    q(index,1) = q(index,1) + step; % make step
  end

  %% trouble report
  if step_number == max_step_number || norm > max_norm
    if report ~= 0 % print warning  
      fprintf(['no convergence within ', num2str(max_step_number), ...
	      ' steps \n']);
    end    
    info = 0; % convergence has not been successful
  else
    info = 1; % convergence was successful
  end