function options_exist
  global max_step_number max_step_size max_norm max_evol report ...
      tol_fun max_fun_evals tol_simplex popSize startPop
  
  if exist('popSize', 'var') == 0 % ga**
    popSize = [];
  end
  if exist('startPop', 'var') == 0 % ga**
    startPop = [];
  end
  if exist('max_step_number', 'var') == 0 % ga**, nm**, nr**
    max_step_number = [];
  end
  if exist('max_step_size', 'var') == 0 % nr**
    max_step_size = [];
  end
  if exist('max_norm', 'var') == 0 % nr**
    max_norm = [];
  end
  if exist('max_evol', 'var') == 0 % ga**
    max_evol = [];
  end
  if exist('report', 'var') == 0 % ga**, nm**, nr**
    report = [];
  end
  if exist('tol_fun', 'var') == 0 % ga**, nm**
    tol_fun = [];
  end
  if exist('max_fun_evals', 'var') == 0 % nm**
    max_fun_evals = [];
  end
  if exist('tol_simplex', 'var') == 0  % nm**
    tol_simplex = [];
  end

