function [cov, cor, sd, ss] = pregr2 (func, p, x, y, Z, W)
  %% [cov, cor, sd, ss] = pregr2 (func, p, x, y, Z, W)
  %% created: 2002/02/05 by Bas Kooijman modified 2010/05/08
  %% calculates covariance and correlation matrix of parameters
  %%   standard deviation and sum of squared deviations of model
  %%   predictions with respect to observations
  %% func: character string with name of user-defined function
  %%   f = func (p, x, y) with x: n-vector; y: m-vector; p: k-vector
  %%   f: (n,m)-matrix with model-predictions for dependent variable
  %%   see regr2_NR
  %% p: (2,k) matrix with
  %%    p(1,:) parameter values
  %%    p(2,:) binaries with yes or no conditional values
  %%    all conditional parameters have zero (co)variance
  %% x: (n,1)-vector with first independent variable
  %% y: (m,2)-vector with second independent variable
  %% Z: (n,m)-matrix with dependent variable
  %% W: (n,m)-matrix with weight coefficients
  %% cov: (k,k) matrix with covariances
  %% cor: (k,k) matrix with correlation coefficients
  %% sd: (k,1) matrix with standard deviations
  %% ss: scalar with weighted sum of squared deviations
  
  %% calls nrdregr2, and user-defined function 'func'

  global nxy index n_pars
  
  [np k] = size(p); % np is number of parameters
  index = 1:np;
  if k>1
    index = index(1 == p(:,2)); % indices of iterated parameters
  end
  n_pars = size(index,2); % number of parameters that must be iterated
  if (n_pars == 0)
    return; % no parameters to iterate
  end

  [nx ny] = size(Z); % nx,ny is number of values of dependent variables
  nxy = nx * ny; % total number of data points
  if exist('W', 'var') ~= 1
    W = ones(nx, ny);
  end

  W = W/sum(sum(W)); WW = reshape(W, nxy, 1); 
     
  [f df] = nrdregr2(func, p(:,1), x, y);
  ss = sum(sum((W .* (f - Z) .^ 2)));
  cov = zeros(np, np);
  cov(index, index) = inv(df' * (df .* WW(:,ones(1, n_pars))))/ nxy;
  cov = cov * ss;
  sd = sqrt(diag(cov));
  cor = cov ./ (sd * sd');
