function [t50 info] = get_t50_s(p, f, t500)
  %% [t50 info] = get_t50_s(p, f, t500)
  %% created 2010/03/01 by Bas Kooijman
  %% calculates scaled median life span at constant f for short growth periods
  %% theory: see comments on DEB3 Section 6.1.1 
  %% p: 4-vector with parameters: g lT ha SG
  %% f: optional scalar with scaled functional response; default: f = 1
  %% t500: optional scalar with starting value for t50
  %% t50: scalar with scaled median life span
  %% info: scalar with indicator for success (1) or failure (0)
 
  global tG

  if exist('f','var') == 0
    f = 1;
  elseif isempty(f)
    f = 1;
  end


  %% unpack pars
  g   = p(1); % energy investment ratio
  lT  = p(2); % scaled heating length {p_T}/[p_M]Lm
  ha  = p(3); % h_a/ k_M^2, scaled Weibull aging acceleration
  sG  = p(4); % Gompertz stress coefficient

  if abs(sG) < 1e-10
    sG = 1e-10;
  end
  
  li = f - lT;
  hW3 = ha * f * g/ 6/ li; hW = hW3^(1/3); % scaled Weibull aging rate
  hG = sG * f * g * li^2;  hG3 = hG^3;     % scaled Gompertz aging rate
  tG = hG/ hW; tG3 = hG3/ hW3;             % scaled Gompertz aging rate

  if exist('t500','var') == 0
    t500 = .889/ hW;
  elseif isempty(f)
    t500 = .889/ hW;
  end

  % options = optimset('Display','off');
  % [t50 info] = nmregr('fnget_t50_s', t500 * hW, [0 0]);
  [t50 fvec info] = fzero('fnget_t50_s', t500 * hW);
  t50 = t50/ hW; % S(t50)=.5