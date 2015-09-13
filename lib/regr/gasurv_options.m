function gasurv_options (key, val)
  if exist('key', 'var') == 0
    garegr_options
  elseif exist('val', 'var') == 0
    garegr_options(key)
  else
    garegr_options(key, val);
  end
