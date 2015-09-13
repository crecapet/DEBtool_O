function [cov, cor, sd, ss] = pregr (func, p, varargin)
  %% created: 2002/02/05 by Bas Kooijman, modified 2010/05/08
  %% calculates covariance and correlation matrix of parameters
  %%   standard deviation and sum of squared deviations of model
  %%   predictions with respect to observations
  %% func: character string with name of user-defined function
  %%   see nrregr
  %% p: (np,2) matrix with
  %%    p(:,1) parameter values
  %%    p(:,2) binaries with yes or no conditional values
  %%    all conditional parameters have zero (co)variance
  %% xywi: (ni,3) matrix with
  %%    xywi(:,1) independent variable
  %%    xywi(:,2) dependent variable
  %%    xywi(:,3) weight coefficients (optional)
  %%    The number of data matrices xyw1, xyw2, ... is optional
  %% cov: (np,np) matrix with covariances
  %% cor: (np,np) matrix with correlation coefficients
  %% sd: (np,1) matrix with standard deviations
  %% ss: scalar with weighted sum of squared deviations
    
  global index nxyw listx listxyw listf listg global_txt

  i = 1; n = 1; % initiate data set counter
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
  listxyw(end) = []; listf(end) = []; listg(end) = []; % remove last ','

  global_txt = strrep(['global ', listxyw], ',', ' ');
  eval(global_txt); % make data sets global

  i = 1; % initiate data set counter
  ci = num2str(i); % character string with value of i
  while (i <= nxyw) % loop across data sets
    eval(['xyw', ci, ' = varargin{i};']); % assing unnamed arguments to xywi
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
	    W = [W; ones(n(i), 1)]; % append weight coefficients
      end
    end
    i = i + 1;
    ci = num2str(i); % character string with value of i
  end

  W = W/ sum(W); % sum of weight coefficients set equal to 1

  [np, k] = size(p); % np: number of parameters
  index = 1:np;
  if k>1
    index = index(1 == p(:,2)); % indices of iterated parameters
  end
  n_pars = size(index, 2);  % number of parameters that must be iterated
  if (n_pars == 0)
    return; % no parameters to iterate
  end
     
  [f, df] = nrdregr(func, p(:,1));
  ss = W' * (f - Y) .^ 2;
  cov = zeros(np, np);
  cov(index, index) = inv(df' * (df .* W(:, ones(1, n_pars))));
  n = sum(df ~= 0); % number of data points that contributed to the parameter
  cov(index, index) = cov(index, index) * ss ./ sqrt(n' * n);
  sd = sqrt(diag(cov));
  cor = zeros(np, np);
  cor(index, index) = cov(index, index) ./ (sd(index) * sd(index)');
