function nrregr_options (key, val)
  %% nrregr_options (key, val)
  %% created at 2002/02/10 by Bas Kooijman; updated 2005/02/18
  %% sets options for function 'nrregr' one by one
  %% type 'nrregr_options' to see values or
  %% type 'nrregr_options('default') to set options at default values

    global max_step_number max_step_size max_norm report;

    if exist('key', 'var') == 0
      key = 'unkown';
    end

    options = ['default'; 'max_step_number'; 'max_step_size'; ...
	       'max_norm'; 'report'; 'unkown'; key];
    [nr nc] = size(options); 
    for i = 1:(nr-2) % determine the option number
      if nc == sum(options(nr,:) == options(i,:))
	opt_nr = i;
	break;   
      end		   
    end
    if exist('opt_nr', 'var') == 0 % option is 'other'
      opt_nr = nc-1;
    end
    
    switch opt_nr
	
      case 1 % option 'default'
	max_step_number = 10;
	max_step_size = 1e20;
	max_norm = 1e-8;
	report = 1;
	nrregr_options;

      case 2 % option 'max_step_number'
	if exist('val', 'var') == 0
	  if prod(size(max_step_number)) == 1
	    printf(['max_step_number = ', num2str(max_step_number),' \n']);  
	  else
            printf('max_step_number = unknown \n');
	  end	      
	else
	  max_step_number = val;
	end

      case 3 % option 'max_step_size'
	if exist('val', 'var') == 0
	  if prod(size(max_step_size)) == 1
	    printf(['max_step_size = ', num2str(max_step_size),' \n']);
	  else
	    printf('max_step_size = unkown \n');
	  end
	else
	  max_step_size = val;
	end

      case 4 % option 'max_norm'
	if exist('val', 'var') == 0
	  if prod(size(max_norm)) == 1
	    fprintf(['max_norm = ', num2str(max_norm),' \n']);
	  else
	    fprintf('max_norm = unknown \n');
	  end
	else
	  max_norm = val;
	end
	    
      case 5 % option 'report'
	if exist('val', 'var') == 0
	  if prod(size(report)) == 1
	    fprintf(['report = ', num2str(report),' \n']);
	  else
	    fprintf('report = unknown \n');
	  end
	else
	  report = val;
	end
	    
      otherwise % option 'other'
	if prod(size(max_step_number)) == 1
          fprintf(['max_step_number = ', num2str(max_step_number),' \n']);
	else
	  fprintf('max_step_number = unknown \n');
	end	      
	if prod(size(max_step_size)) == 1
	  fprintf(['max_step_size = ', num2str(max_step_size),' \n']);
	else
	  printf('max_step_size = unkown \n');
	end
	if prod(size(max_norm)) == 1
	  fprintf(['max_norm = ', num2str(max_norm),' \n']);
	else
	  fprintf('max_norm = unknown \n');
	end
	if prod(size(report)) == 1
	  printf(['report = ', num2str(report),' \n']);
	else
	  fprintf('report = unknown \n');
	end
     end	
