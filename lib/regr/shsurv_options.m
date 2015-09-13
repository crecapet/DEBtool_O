function shsurv_options (key, nr, val)
  %% shsurv_options (key, nr, val)
  %% created at 2001/09/13 by Bas Kooijman; 2005/02/18
  %% sets options for function 'shsurv' one by one
  %% run 'shsurv' first to initiate option settings

  global dataset Range all_in_one xlabel ylabel;

    if exist('key', 'var') == 0
      key = 'unkown';
    end

    options = ['default'; 'dataset'; 'Range'; 'xlabel'; 'ylabel'; ...
	       'all_in_one'; 'unkown'; key];
    [r k] = size(options); 
    for i = 1:(r-2) % determine the option number
      if 1 == prod(options(r,:) == options(i,:))
	    opt_nr = i;
	    break;   
      end
    end
    if exist('opt_nr', 'var') == 0 % option is 'other'
      opt_nr = r-1;
    end

    switch opt_nr

      case 1 % option 'default'
	Range = [];
	dataset = [];
	all_in_one = [];
	xlabel = [];
	ylabel = [];
    
      case 2 % option 'dataset'
	dataset = nr;

      case 3 % option 'Range'
	Range(nr, :) = val;

      case 4 % option 'xlabel'
        eval(['global xlabel', num2str(nr), ';']);
	eval(['xlabel', num2str(nr), ' = val;']);

      case 5 % option 'ylabel'
        eval(['global ylabel', num2str(nr),';']);
	eval(['ylabel', num2str(nr), ' = val;']);

      case 6 % option 'all_in_one'
	all_in_one = nr;

      otherwise % option 'other'
        fprintf('unkown option \n');
	
    end
