function [par, U0b] = get_pars_g(p)
  %% [par, U0b] = get_pars_g(p, par0)
  %% Bas Kooijman, 2006/09/30 modified 2007/05/03, 2007/08/07
  %% p: 5-vector with f, L_b, L_i, a_b, \dot{r}_B
  %% par: (4,1)-matrix with
  %%   1 VHb   % scaled maturity at birth
  %%   2 g     % energy investment ratio
  %%   3 kM    % somatic maintenance rate coefficient
  %%   4 v     % energy conductance
  %% U0b: 2-vector with
  %%   U^0 = M_E^0/\{\dot{J}_{EAm}\}, U^b = M_E^b/\{\dot{J}_{EAm}\}
  %% called by get_pars_r
  %% calls fnget_pars_g, dget_ul
  %% iget_pars_g is inverse to get_pars_g

  %% for transfer to fnget_pars, dget_ul
  global Lb Li Lm rB ab f
    
  %% unpack input parameters
  f  = p(1); % scaled functional response
  Lb = p(2); % length at birth at abundant food
  Li = p(3); % ultimate length
  ab = p(4); % age at birth at abundant food
  rB = p(5); % max von Bertalannfy growth rate

  abm =  Lb/ (Li * rB); % max possible value for ab
  if ab > abm
    fprintf(['Warning: a_b = ', num2str(ab), ' is larger than maximum ', ...
	    num2str(abm), '\n']);
  end

  %% prepare initial estimates, but final for small ab
  Lm = Li/ f;                    % maximum length
  v = 3 * Lb/ ab;                % from foetus
  g = f * v/ (3 * rB * Li) - f;  % from Li
  kM = 3 * (f + g) * rB/ g;      % from rB
  U0 = get_ue0([g 1], f, Lb/ Lm) * v^2/ g^2/ kM^3;
  Ub = f * Lb^3/ v; 
								 
  %% pack initial estimates p = [g, \dot{k}_M, \dot{v}, U^0]
  p = [g; kM; v; U0]; 
   
  %% obtain final estimates %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  %% jacobian to test that it is larger than zero (= ab large enough)
  step = 1e-3; % step in parameter values for numerical differentiation
  dfn = zeros(4,4); % initiate jacobian
  Fp = fnget_pars_g(p);
  for i = 1 : 4 % loop across parameters to be iterated
    q = p; q(i) = p(i) + step; % make step in a single parameter value
    Fq = fnget_pars_g(q); % get function values at changed parameter value
    dfn(:,i) = (Fq - Fp)/ step; % numerical differentials for parameter i
  end
  D = det(dfn' * dfn); % jacobian

  if  abs(D) > 1e-6 % ab large enough
    %% [p, info] = fsolve("fnget_pars_g",p);
    nrregr_options('report', 1);
    nrregr_options('max_norm', 1e-10);
    nrregr_options('max_step_number', 500);
    nrregr_options('max_step_size', 1);
    [p, info] = nrregr('fnget_pars_g', p, zeros(4,2));
    if info ~= 1
      fprintf('trying to solve convergence problems in growth parameters\n');
      nmregr_options('report', 1);    
      nmregr_options('max_fun_evals', 10000);
      nmregr_options('max_step_number', 5000);
      nmregr_options('tol_simplex', 1e-6);
      nmregr_options('tol_fun', 1e-6);
      [p, info] = nmregr('fnget_pars_g', p, zeros(4,2));
      if info ~= 1
        fprintf('convergence problem in finding growth parameters\n');
      end
      nrregr_options('report', 0);
      nrregr_options('max_step_number', 500);
    end
  end
 
  %% unpack p
  g = p(1); kM = p(2); v = p(3); U0 = p(4);
  VHb = Lb^3 * g/ v;
  par = [VHb; g; kM; v];
  Ub = f * Lb^3/ v;

  %% prepare scaled reserve
  U0b = [U0; Ub];
