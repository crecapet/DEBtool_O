function shregr_options (key, nr, val)
  %% shregr_options (key, nr, val)
  %% created at 2002/01/20 by Bas Kooijman; 2009/10/28
  %% sets options for function 'shregr' one by one
  %% run 'shregr' first to initiate option settings

  global dataset Range all_in_one xlabel ylabel

    if exist('key', 'var') == 0
      key = 'unkown';
    end
    options = ['default'; 'dataset'; 'Range'; 'xlabel'; 'ylabel'; ...
	       'all_in_one'; 'unkown'; key];
    [r k] = size(options); 
    for i = 1:(k-2) % determine the option number
      if k == sum(options(r,:) == options(i,:))
	opt_nr = i;
	break;   
      end
    end
    
    if exist('opt_nr', 'var') == 0 % option is 'other'
      opt_nr = k-1;
    end

    switch opt_nr

      case 1 % option 'default'
	dataset = [];
	all_in_one = [];
	Range = [];
	xlabel = [];
	ylabel = [];
   
      case 2 % option 'dataset'
	dataset = nr;

      case 3 % option 'Range'
	if exist('val', 'var') == 0
	  nr = 1; val = [];
	end
	Range(nr, :) = val;

      case 4 % option 'xlabel'
	if exist('val', 'var') == 0
	    nr = 1; val = '';
	end	    
        eval(['global xlabel', num2str(nr), ';']);
	eval(['xlabel', num2str(nr), ' = val;']);

      case 5 % option 'ylabel'
	if exist('val', 'var') == 0
	    nr = 1; val = '';
	end	    
        eval(['global ylabel', num2str(nr),';']);
	eval(['ylabel', num2str(nr), ' = val;']);

      case 6 % option 'all_in_one'
	all_in_one = nr;

      otherwise % option 'other'
        printf('unkown option \n');
	
    end
