function scsurv_options (key, val)
  if exist('key', 'var') == 0
    nrregr_options
  elseif exist('val', 'var') == 0
    nrregr_options(key)
  else
    nrregr_options(key, val);
  end
