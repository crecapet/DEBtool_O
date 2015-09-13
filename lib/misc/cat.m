function y = cat(dim, varargin)
  %% y = cat(dim, varargin)
  %% created by Bas Kooijman 2005/01/31, modified 2008/02/21
  %% catenate variable number of matrices
  %% dim is either 1 or 2
  y = [];
  if (dim ~= 1) && (dim ~= 2)
    fprintf('dimension number is not 1 or 2\n');
    return
  end
  nvars = nargin - 1;
  if nvars > 0
    y = varargin{1};
  end
  if (dim == 1) && (1 == prod(size(dim))) && (nvars > 1)
    for i = 2:nvars
      y = [y; varargin{i}];
    end
  elseif (dim == 2) && (1 == prod(size(dim))) && (nvars > 1)
    for i = 2:nvars
      y = [y, varargin{i}];
    end
  end