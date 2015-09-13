function N = surv_count(n,S)
  %% N = surv_count(n,p)
  %% coded 2005/10/26
  %% p: (r,c)-matrix with survivor probabilities
  %%     interpretation: obs. times across rows, conditions across cols
  %% n: scalar, or (1,c)-matrix with number of test subjects
  %% N: (r,c)-matrix with number of surviving subjects
  
  F = 1 - S; [nr nc] = size(F);
  nn = length(n);
  if nn == 1 % generate equal numbers of initial subjects
    n = n(ones(1,nc));
  elseif nn ~= nc % numbers of subjects should match numbers of concentrations
    printf('sizes do not match \n');
    N = [];
    return
  end
  
  N = zeros(nr + 1, nc); % initiate counting of deaths
  for j = 1:nc % concentrations
    for i = 1:n(j) % number of subjects
      rnd = rand(1); % random probability
      index = 1 + sum(rnd > F(:,j)); % determine cell in counts
      N(index,j) = N(index,j) + 1; % add dead subject to cell
    end
  end
  N = n(ones(nr+1,1),:) - cumsum(N,1); % convert death to survivors
  N(nr+1,:) = [];
