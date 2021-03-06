function [q,info,endPop,bPop,traceInfo] = garegr(func, p, varargin)
  %% [q,info,endPop,bPop,traceInfo] = garegr(func, p, varargin)
  %% created: 2006/05/23 by Bas Kooijman
  %% calculates least squares estimates using a genetic algorithm
  %%    similar to nrregr, but slower and a larger bassin of attraction
  %% func: string with name of user-defined function
  %%    f = func (p, xyw) with
  %%      p: k-vector with parameters; xyw: (n,c)-matrix; f: n-vector
  %%    [f1, f2, ...] = func (p, xyw1, xyw2, ...) with  p: k-vector  and
  %%      xywi: (ni,k)-matrix; fi: ni-vector with model predictions
  %%    The dependent variable in the output f; For xyw see below.
  %% p: (k,4) matrix with
  %%    p(:,1) initial guesses for parameter values (not used)
  %%    p(:,2) binaries with yes or no iteration
  %%    p(:,[2 3]) boundaries for iterated parameters
  %% xywi (read as xyw1, xyw2, .. ): (ni,3) matrix with
  %%    xywi(:,1) independent variable i
  %%    xywi(:,2) dependent variable i
  %%    xywi(:,3) weight coefficients i (optional)
  %%    xywi(:,>3) data-point specific information data (optional)
  %%    The number of data matrices xyw1, xyw2, ... is optional but >0
  %% q: matrix like p, but with least squares estimates in first column
  %% info: 1 if convergence has been successful; 0 otherwise
  %% endPop: the final population
  %%  individual in each row; last column is minus weighted sum of squares  
  %% bPop: a trace of the best population
  %% traceInfo: a matrix of best and means of the ga for each generation
  %% 
  %% set options with 'garegr_options'

  %% modified from gaot package version 1996/02/02:
  %% C.R. Houck, J.Joines, and M.Kay. A genetic algorithm for function
  %% optimization: A Matlab implementation. ACM Transactions on Mathmatical
  %% Software, Submitted 1996; binary and order options removed
  %%
  %% garegr calls for:
  %%
  %% User-defined function:
  %%   'func'
  %% Crossover Operators:
  %%   simpleXover heuristicXover arithXover 
  %% Mutation Operators:
  %%   boundaryMutation multiNonUnifMutation nonUnifMutation unifMutation
  %% Selection Functions:
  %%   normGeomSelect roulette tournSelect
  %% Utility functions:
  %%   cat
  %% Option setting:
  %%   garegr_options options_exist
  %% Demonstrations:
  %%   mydata_regr

  global popSize startPop tol_fun report max_step_number max_evol

  i = 1; % initiate data set counter
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
  [i, nl] = size(listxyw); listxyw = listxyw(1:(nl-1)); % remove last ','
  [i, nl] = size(listf); listf = listf(1:(nl-1)); % remove last ','
  [i, nl] = size(listg); listg = listg(1:(nl-1)); % remove last ','

  global_txt = strrep(['global ', listxyw], ',', ' ');
  eval(global_txt); % make data sets global

  i = 1; N = zeros(nxyw, 1); % initiate data counter
  ci = num2str(i); % character string with value of i
  while (i <= nxyw) % loop across data sets
    eval(['xyw', ci, ' = varargin{',ci,'};']); % assing unnamed arguments to xywi
    eval(['[N(', ci, '), k] = size(xyw', ci, ');']); % number of data points
    if i == 1
      eval(['Y = xyw',ci,'(:,2);']); % initiate dependent variables
      if k > 2
	eval(['W = xyw',ci,'(:,3);']); % initiate weight coefficients
      else
	W = ones(N(1),1);
      end
    else     
      eval(['Y = [Y;xyw', ci, '(:,2)];']); % append dependent variables
      if k > 2
	eval(['W = [W;xyw', ci, '(:,3)];']); % append weight coefficients
      else
	W = [W; ones(N(i),1)]; % append weight coefficients
      end
    end
    i = i + 1;
    ci = num2str(i); % character string with value of i
  end

  q = p; % copy input parameter matrix into output
  N = sum(N); % total number of data points in all samples
  W = W/sum(W); % sum of weight coefficients set equal to 1

  [np k] = size(p); % np: number of parameters
  index = 1:np;
  if k > 1
    index = index(1 == p(:,2)); % indices of iterated parameters
  end
  numVar = size(index,2);  % number of parameters that must be iterated
  if (numVar == 0)
    return; % no parameters to iterate
  end
  bounds = q(index,[3 4]); % lower and upper boundaries of iterated parameters
  xZomeLength  = 1 + numVar; % Length of the xzome=numVars+fittness

  options_exist; % make sure that options exist
  %% set options if necessary

  if prod(size(popSize)) == 0
    garegr_options('popSize', 80)
  end
  if prod(size(tol_fun)) == 0
    garegr_options('tol_fun', 1e-6)
  end
  if prod(size(report)) == 0 
    garegr_options('report', 1)
  end
  if prod(size(max_step_number)) == 0
    garegr_options('max_step_number', 500)
  end
  if prod(size(max_evol)) == 0
    garegr_options('max_evol', 50)
  end

  %% minus weighted sum of squares because ga maximizes
  estr = ['[', listf, '] = ', func, '(indiv, ', listxyw, ');'];
  estr = [estr, 'indiv_val = -W''*(cat(1, ', listf, ')-Y).^2;'];

  %%   selectFN   - name of the .m selection function (['normGeomSelect'])
  %%   selectOpts - options string to be passed to select after
  %%                select(pop,%,opts) ([0.08])
  selectFN = 'normgeomselect';
  selectOpts = 0.08;

  %%   xOverFNs   - a string containing blank seperated names of Xover.m
  %%                files (['arithXover heuristicXover simpleXover']) 
  %%   xOverOpts  - A matrix of options to pass to Xover.m files with the
  %%                first column being the number of that xOver to perform
  %%                similiarly for mutation ([2 0;2 3;2 0])
  xOverFNs = ['arithxover'; 'heuristicxover'; 'simplexover'];
  xOverOpts = [2 0; 2 3; 2 0];

  %%   mutFNs     - a string containing blank seperated names of mutation.m 
  %%                files (['boundaryMutation multiNonUnifMutation ...
  %%                         nonUnifMutation unifMutation'])
  %%   mutOpts    - A matrix of options to pass to Xover.m files with the
  %%                first column being the number of that xOver to perform
  %%                similiarly for mutation ([4 0 0;6 100 3;4 100 3;4 0 0])
  mutFNs = ['boundarymutation'; 'multinonunifmutation';
	    'nonunifmutation'; 'unifmutation'];
  mutOpts = [4 0 0; 6 max_evol 3; 4 max_evol 3; 4 0 0];

  endPop       = zeros(popSize,xZomeLength); % A secondary population matrix
  c1           = zeros(1,xZomeLength); 	% An individual
  c2           = zeros(1,xZomeLength); 	% An individual
  numXOvers    = size(xOverFNs,1); 	% Number of Crossover operators
  numMuts      = size(mutFNs,1); 	% Number of Mutation operators
  bFoundIn     = 1; 			% Number of times best has changed
  done         = 0;                     % Done with simulated evolution
  gen          = 1; 			% Current Generation Number
  gen_bval     = 0;                     % Gen Number since last new best
  collectTrace = (nargout > 4); 	% Should we collect info every gen
  bPop         = zeros(0,xZomeLength+1);% inserted because of error in ga

  %% Generate start population if necessary
  if isempty(startPop) | ~sum(size(startPop,2) == [numVar xZomeLength])
    startPop = zeros(popSize,xZomeLength);
    range = bounds(:,2) - bounds(:,1);
    for i = 1:popSize
      startPop(i,1:numVar) = (bounds(:,1) + range .* rand(numVar,1))';
      indiv = p(:,1); indiv(index) = startPop(i,1:numVar)';
      eval(estr); startPop(i,xZomeLength) = indiv_val;
    end
  elseif numVar == size(startPop,2) % supplement startPop with fitness values
    popSize = size(startPop,1);
    startPop = [startPop, zeros(popSize,1)];
    for i = 1:popSize
      indiv = p(:,1); indiv(index) = startPop(i,1:numVar)';
      eval(estr); startPop(i,xZomeLength) = indiv_val;
    end
  else % make sure that popSize represents number of individuals
    popSize = size(startPop,1);    
  end 

  oval = max(startPop(:,xZomeLength)); % Best value in start pop

  while(~done)
    %% Elitist Model
    [bval,bindx] = max(startPop(:,xZomeLength));       % Best of current pop
    best =  startPop(bindx,:);

    if collectTrace
      traceInfo(gen,1) = gen; 		               % current generation
      traceInfo(gen,2) = startPop(bindx,xZomeLength);  % Best fittness
      traceInfo(gen,3) = mean(startPop(:,xZomeLength));% Avg fittness
      traceInfo(gen,4) = std(startPop(:,xZomeLength)); 
    end

    if ((abs(bval - oval) > tol_fun) || (gen == 1)) % If we have a new best sol
      if report == 1
        fprintf(1,'\n%d %f\n',gen,-bval);          % Update the report
      end 
      bPop(bFoundIn,:) = [gen startPop(bindx,:)];  % Update bPop Matrix
      bFoundIn = bFoundIn + 1;                % Update number of changes
      oval = bval;                            % Update the best val
      gen_bval = 0;
    else 
      if report == 1
        fprintf(1,'%d ',gen);	              % Otherwise just update num gen
      end
      gen_bval = gen_bval + 1;
    end 

    endPop = feval(selectFN,startPop,[gen selectOpts]); % Select

    for i = 1:numXOvers
      for j = 1:xOverOpts(i,1)
	a = 1 + round(rand * (popSize - 1)); 	% Pick a parent
	b = 1 + round(rand * (popSize - 1)); 	% Pick another parent
	xN = deblank(xOverFNs(i,:)); 	% Get the name of crossover function
        [c1 c2] = feval(xN,endPop(a,:),endPop(b,:),bounds,[gen xOverOpts(i,:)]);
	
	if c1(1:numVar) == endPop(a,(1:numVar)) % Make sure we created a new 
	  c1(xZomeLength) = endPop(a,xZomeLength); % solution before evaluating
	elseif c1(1:numVar) == endPop(b,(1:numVar))
	  c1(xZomeLength) = endPop(b,xZomeLength);
	else 
	  indiv = p(:,1); indiv(index) = c1(1:numVar)';
	  eval(estr); c1(xZomeLength) = indiv_val;
	end 
	if c2(1:numVar) == endPop(a,(1:numVar))
	  c2(xZomeLength) = endPop(a,xZomeLength);
	elseif c2(1:numVar) == endPop(b,(1:numVar))
	  c2(xZomeLength) = endPop(b,xZomeLength);
	else 
	  indiv = p(:,1); indiv(index) = c2(1:numVar)';
	  eval(estr); c2(xZomeLength) = indiv_val;
	end      
	
	endPop(a,:) = c1;
	endPop(b,:) = c2;
      end
    end 

    for i = 1:numMuts
      for j = 1:mutOpts(i,1)
	a = 1 + round(rand * (popSize - 1));
	c1 = feval(deblank(mutFNs(i,:)),endPop(a,:),bounds,[gen mutOpts(i,:)]);
	if c1(1:numVar) == endPop(a,(1:numVar)) 
	  c1(xZomeLength) = endPop(a,xZomeLength);
	else
	  indiv = p(:,1); indiv(index) = c1(1:numVar)';
	  eval(estr); c1(xZomeLength) = indiv_val;
	end
	endPop(a,:) = c1;
      end
    end  
      
    gen = gen + 1;

    if gen >= max_step_number % stop because number of generation exceeds maximum
      done = 1;
      info = 0;
      printf(['\n no convergence within ', num2str(max_step_number), ' generations \n']);
    elseif gen_bval >= max_evol % stop because of lack of improvement
      done = 1;
      info = 1;
      if report > 0
        printf(['\n no improvement within ', num2str(max_evol), ' generations \n']);
      end
    end

    startPop = endPop; 			% Swap the populations
  
    [bval,bindx] = min(startPop(:,xZomeLength)); % Keep the best solution
    startPop(bindx,:) = best; 		% replace it with the worst
  end 

  [bval,bindx] = max(startPop(:,xZomeLength));
  if report 
    fprintf(1,'\n%d %f\n',gen,-bval);	  
  end

  x = startPop(bindx,:);
  bPop(bFoundIn,:) = [gen startPop(bindx,:)];

  if collectTrace
    traceInfo(gen,1) = gen; % current generation
    traceInfo(gen,2) = startPop(bindx,xZomeLength);   % Best fittness
    traceInfo(gen,3) = mean(startPop(:,xZomeLength)); % Avg fittness
  end

  q(index, 1) = x(1:numVar)'; % copy best solution to output
