function [proflik, info] = plsurv(func, p, varargin)
  %% [proflik, info] = plsurv(func, p, varargin)
  %% created: 2001/09/16 by Bas Kooijman; 2005/01/31
  %% calculates profile likelihood function
  %%    of a single parameter using Nelder Mead's simplex method
  %% func: string with name of user-defined function
  %%    f = func (p, t, y) with p: np-vector; t: nt-vector; y: ny-vector
  %%    f: (nt,ny)-matrix with model-predictions for surviving numbers
  %% p: (np,2) matrix with
  %%    p(:,1) parameter values
  %%    p(:,2) codes for what to do with the parameters
  %%      <=0: keep it fixed
  %%      >0: iterate (so estimate the corresponding parameter)
  %%      2: construct likelihood profile for this parameter 
  %% tni (read as tn1, tn2, .. ): (ni,2) matrix with
  %%    tni(:,1) time: must be increasing with rows
  %%    tni(:,2) number of survivors: must be non-increasing with rows
  %%    tni(:,3, 4, ... ) data-pont specific information data (optional)
  %%    The number of data matrices tn1, tn2, ... is optional but >0
  %% Range: 2 or 3 -vector with lower and upper boundaries of
  %%    the parameter that is indicated with code 2 in p(:,2)
  %%    the value of the selected parameter must be within the range
  %%  optional element 3 of the range vector is the number of parameter
  %%    evaluations, like in linspace; default: 100.
  %%  the last argument is interpreted as the range
  %% proflik: (99,2) matrix with par-values, and deviances
  %% info: 1 if convergence has been successful; 0 otherwise
  %% set options with 'nmsurv_options'
  %% uses user-defined function 'func' and nmsurv2

  %% set options if necessary
  if exist('max_step_number', 'var')==0 
    scsurv_options('max_step_number', 20);
  end
  if exist('max_step_size', 'var')==0 
    scsurv_options('max_step_size', 1e20);
  end
  if exist('max_norm', 'var')==0
    scsurv_options('max_norm', 1e-8);
  end
  if exist('report', 'var')==0
    scsurv_options('report', 1);
  end

  i = 1; % initiate data set counter
  ci = num2str(i); % character string with value of i
  ntn = nargin - 2; % number of data sets
  n = zeros(ntn, 1); % initiate data counter
  while (i <= ntn) % loop across data sets
    eval(['tn', ci, ' = va_arg();']); % assing unnamed arguments to tni
    eval(['[n(', ci, ') k] = size(tn', ci, ');']); % number of data points
    if i == 1      %% obtain time intervals and numbers of death
      D = tn1(:,2) - [tn1(2:n(i),2);0]; % initiate death count
      n0 =  tn1(1,2)*ones(n(1),1); % initiate start number
      listtn = ['tn', ci,',']; % initiate list tn
      listt = ['tn', ci]; % initiate list tn for global declaration
      listf = ['f', ci,',']; % initiate list f
      listg = ['g', ci,',']; % initiate list g
    else     
      eval(['D = [D; tn', ci,'(:,2) - [tn', ci, '(2:n(i),2);0]];']);
                             % append death counts
      eval(['n0 = [n0; tn', ci, '(1,2)*ones(n(', ci,'),1)];']);
				             % append initial numbers
      listtn = [listtn, ' tn', ci,',']; % append list tn
      listt = [listt, ' tn', ci]; % append list tn for global declaration
      listf = [listf, ' f', ci,',']; % append list f
      listg = [listg, ' g', ci,',']; % append list g
    end
    i = i + 1;
    ci = num2str(i); % character string with value of i
  end

  [i nl] = size(listtn); listtn = listtn(1:(nl-1)); % remove last ','

  [np k] = size(p); % np is number of parameters
  index = 1:np; % indices of parameters
  if k <= 1
    printf('codes for parameters are missing\n');
    return
  else
    par_nr = index(2 == p(:,2)); % index of parameter for prof likelihood
  end
  if 1 ~= prod(size(par_nr))
    printf('codes for parameters are invalid\n');
    return
  end

  p(par_nr,2) = 0; % fix target parameter
  par = p; % make copy of par matrix
  %% set numer of parameter evaluations
  if max(size(Range)) > 2
    npar = Range(3);
  else
    npar = 100;
  end
  
  %% number of par evaluations in branch 1
  nbr1 = floor(npar * (p(par_nr,1) - Range(1))/(Range(2)- Range(1)));

  if (nbr1<1) | (nbr1>npar) % check range relative to par value
    printf('selected parameter not within range\n')
    return
  end
  
  br1 = linspace(p(par_nr,1), Range(1), nbr1); % branch 1 par values
  br2 = linspace(p(par_nr,1), Range(2), npar-nbr1); % branch 2 par values

  nmregr_options('report',0); % nmsurv2 must be silent
  info = 1; % succesful convergence
  
  proflik = zeros(npar-1,2); % initiate prof-lik matrix

  %% fill prof-lik matrix at target value
  eval(['proflik(nbr1,:) = [p(par_nr,1), dev(''', func, ''', p, ', ...
	listtn, ')];']);

  %% fill prof-lik matrix from par-value to lower boundary: branch 1
  dp = br1(1) - br1(2); % increment for par-value (positive)
  for i = 2:nbr1
    p(par_nr,1) = p(par_nr,1) - dp; % set new par value
    eval(['[p, infp]= nmsurv(''', func, ''', p, ', listtn, ...
	  ');']); % get estimates
    info = info*infp;
    eval(['d = dev(''', func, ''', p, ', listtn, ...
	  ');']); % get deviance
    proflik(nbr1-i+1,:) = [p(par_nr,1), d]; % fill prof-lik matrix
  end

  %% fill prof-lik matrix from par-value to upper boundary: branch 2
  dp = br2(2) - br2(1); % increment for par-value (positive)
  p = par; % restore original parameter value for second branch
  for i = 2:(npar-nbr1)
    p(par_nr,1) = p(par_nr,1) + dp;  % set new par value
    eval(['[p, infp]= nmsurv(''', func, ''', p, ', listtn, ...
	  ');']); % get estimates
    info = info*infp;
    eval(['d = dev(''', func, ''', p, ', listtn, ...
	  ');']); % get deviance
    proflik(nbr1+i-1,:) = [p(par_nr,1), d]; % fill prof-lik matrix    
  end
