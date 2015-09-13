function nmsurv_options (key, val)
  if exist('key', 'var') == 0
    nmregr_options
  elseif exist('val', 'var') == 0
    nmregr_options(key)
  else
    nmregr_options(key, val);
  end
