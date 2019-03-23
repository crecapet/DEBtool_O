function [b,ndx,pos] = unique(a,flag)
  %% [b,ndx,pos] = unique(a,flag)
  %% a: array or cell array of strings
  %% flag: 'rows' (optional)
  %% b: as sorted a but repetitions removed
  %% ndx: indices such that b = a(ndx) or b = a(ndx,:)
  %% pos: indices such that a = b(pos) or a = b(pos,:)
  %% modified from Matlab

  if nargin==1 || isempty(flag),
    % Convert matrices and rectangular empties into columns
    if length(a) ~= prod(size(a)) | (isempty(a) && any(size(a)))
       a = a(:);
    end
    [b, ndx] = sort(a); nb = length(b);
    % Convert cell array of strings to character array
    if iscellstr(b),
      b = strvcat(b);
    end
    % d indicates the location of matching entries
    d = b((1:nb - 1)') == b((2:nb)');
    b(find(d)) = [];
    if nargout == 3, % Create position mapping vector
      pos = zeros(size(a));
      pos(ndx) = cumsum([1; ~d(:)]);
    end
  else
    if ~isstr(flag) | ~strcmp(flag,'rows'), error('Unknown flag.'); end
    [b, ndx] = sort(a); nb = size(b,1);
    [m, n] = size(a);
    % Convert cell array of strings to character array
    if iscellstr(b),
      b = strvcat(b);
    end
    if m > 1 && n ~= 0
      % d indicates the location of matching entries
      d = b(1:nb - 1,:)==b(2:nb,:);
    else
      d = zeros(m - 1,n);
    end
    d = all(d,2);
    b(find(d),:) = [];
    if nargout == 3, % Create position mapping vector
      pos(ndx) = cumsum([1;~d]);
      pos = pos';
    end
  end

  ndx(find(d)) = [];
