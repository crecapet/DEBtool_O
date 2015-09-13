function printpar(nm,p,varargin)
  %% by Bas Kooijman, modified 2009/02/18, 2010/03/28
  %% print parameter name, value and standard deviation
  %% nm: n-vector with text for parameter values (cells)
  %% p: n-vector with parameter values
  %% optional n-vector with standard deviations
  %% optional text for header

  if nargin == 2
    txt = 'Parameter values';
    sd = [];
  elseif nargin == 3
    sd = varargin{1};
    if isempty(sd)
      txt = 'Parameter values';
    else
      txt = 'Parameter values and standard deviations';
    end
  else
    sd = varargin{1};
    txt = varargin{2};
  end
  [r,c] = size(nm);
  fprintf([txt, ' \n']);
  if nargin == 2 || isempty(sd)
    for i = 1:r
      fprintf('%s %8.4g \n', nm{i,:}, p(i,1));
    end
  else
    for i = 1:r
      fprintf('%s %8.4g %8.4g \n', nm{i,:}, p(i,1), sd(i));
    end
  end
