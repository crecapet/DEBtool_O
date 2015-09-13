function  [cov, cor, sd, dev] = psurv3(func, p, t, x, y, N)
  %% [cov, cor, sd, dev] = psurv3(func, p, t, x, y, N)
  %% created: 2006/03/07 by Bas Kooijman
  %% calculates deviance;  multiple-sample case
  %% func: string with name of user-defined function
  %%    f = func (p, t, x, y) with
  %%    p: np-vector; t: nt-vector; x:nx-vector; y: ny-vector
  %%    f: (nt,nx*ny)-matrix with model-predictions for surviving numbers
  %% p: (np,2) matrix with
  %%    p(:,1) initial guesses for parameter values
  %%    p(:,2) binaries with yes or no iteration (optional)
  %% t: (nt,1)-vector with first independent variable (time)
  %% x: (nx,1)-vector with second independent variable
  %% y: (ny,1)-vector with third independent variable
  %% N: (nt,nx*ny)-matrix with surviving numbers
  %% cov: (np,np) matrix with covariances
  %% cor: (np,np) matrix with correlation coefficients
  %% sd: (np,1) matrix with standard deviations
  %% dev: scalar with deviance
  %% calls scdsurv3, and user-defined function "func"

  global nt nx ny l index

  %% t = t(:); x = x(:); y = y(:); % set independent vars to column vectors
  nt = length(t); % number of time points
  nx = length(x); % number of values for second independent vars
  ny = length(y); % number of values for third independent vars
  [nNt nNxy] = size(N); % number data points
  if nNt ~= nt && nNxy ~= nx * ny % test size data matrix
    printf('size of data matrix does not match specification of arguments \n');
    q = []; info = 0;
    return
  end
  nxy = nx * ny; ntxy = nt * nxy; 
  
  [np, k] = size(p); % np: number of parameters
  cov = zeros(np,np);
  cor = zeros(np,np);

  index = 1:np;
  if k>1
    index = index(1 == p(:,2)); % indices of estimated parameters
  end
  l = max(size(index));  % l: number of estimated parameters
  if (l == 0)
    return; % no parameters to present statistics
  end

  D = N - [N(2:nt,:); zeros(1,nxy)]; D = reshape(D, ntxy, 1);
  n0 = ones(nt,1) * N(1,:); n0 = reshape(n0, ntxy, 1);
  likmax = D' * log(max(1e-10, D./ n0)); % max of log lik function

  %% eval([ "f = ", func, "(p(:,1), t, y);"]);
				% obtain survival probabilities
  %% prob = reshape(f - [f(2:nt,:);zeros(1,ny)], nty, 1);

  [prob, Dprob] = scdsurv3(func, p(:,1), t, x, y);
				% obtain death prob and derivatives
  dprob = zeros(ntxy,np);
  dprob(:,index) = Dprob;
  
  dev = 2 * (likmax - D' * log(max(1e-10,prob)));
				% deviance: 2* log lik minus its supremum
  cov(index, index) = inv((n0./prob * ones(1,l) .* Dprob)' * Dprob);
				% inv of information matrix
  sd = sqrt(diag(cov)); % standard deviations
  cor = cov./(sd*sd'); % correlation matrix
