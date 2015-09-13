function sh_options_exist
  global dataset Range all_in_one xtext ytext ztext plotnr
  
  if exist('dataset', 'var') == 0 
    dataset = [];
  end
  if exist('Range', 'var') == 0 
     Range = [];
  end
  if exist('all_in_one', 'var') == 0
    all_in_one = [];
  end
  if exist('plotnr', 'var') == 0
    plotnr = [];
  end
  if exist('xtext', 'var') == 0
    xtext = [];
  end
  if exist('ytext', 'var') == 0
    ytext = [];
  end
  if exist('ztext', 'var') == 0
    ztext = [];
  end
