function garegr_options (key, val)
  %% garegr_options (key, val)
  %% created at 2006/05/28 by Bas Kooijman
  %% sets options for function 'garegr' one by one
  %% type 'garegr_options' to see values or
  %% type 'garegr_options('default') to set options at default values

  global popSize startPop tol_fun report max_step_number max_evol

  if exist('key', 'var') == 0
    key = 'unkown';
  end

  options = ['default'; 'report'; 'max_step_number'; ...
	     'max_evol'; 'tol_fun'; 'popSize'; 'startPop'; 'unkown'; key];
  [nr nc ] = size(options); 
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
     report = 1;
     max_step_number = 500;
     max_evol = 50;
     tol_fun = 1e-6;
     popSize = 50;
     startPop = [];
     garegr_options

   case 2 % option 'report'
     if exist('val', 'var') == 0
       if prod(size(report)) == 1
	 fprintf(['report = ', num2str(report),' \n']);  
       else
         printf('report = unknown \n');
       end	      
     else
       report = val;
     end

   case 3 % option 'max_step_number'
     if exist('val', 'var') == 0
       if prod(size(max_step_number)) == 1
	 fprintf(['max_step_number = ', num2str(max_step_number),' \n']);  
       else
         printf('max_step_number = unknown \n');
       end	      
     else
       max_step_number = val;
     end

   case 4 % option 'max_evol'
     if exist('val', 'var') == 0
       if prod(size(max_evol)) == 1
	 fprintf(['max_evol = ', num2str(max_evol),' \n']);
       else
	 fprintf('max_evol = unkown \n');
       end
     else
       max_evol = val;
     end

   case 5 % option 'tol_fun'
     if exist('val', 'var') == 0
       if prod(size(tol_fun)) == 1
	 fprintf(['tol_fun = ', num2str(tol_fun),' \n']);
       else
	 fprintf('tol_fun = unknown \n');
       end
     else
       tol_fun = val;
     end
     
   case 6 % option 'popSize'
     if exist('val', 'var') == 0
       if prod(size(popSize)) == 1
	 fprintf(['popSize = ', num2str(popSize),' \n']);
       else
	 fprintf('popSize = unknown \n');
       end
     else
       popSize = val;
     end

   case 7 % option 'startPop'
     if exist('val', 'var') == 0
       if prod(size(startPop)) == 1
	 fprintf(['startPop = ', num2str(startPop),' \n']);
       else
	 fprintf('startPop = unknown \n');
       end
     else
       popSize = val;
     end

	    
   otherwise % option 'other'
     if prod(size(report)) == 1
       fprintf(['report = ', num2str(report),' \n']);
     else
       fprintf('report = unknown \n');
     end	      
     if prod(size(max_step_number)) == 1
       fprintf(['max_step_number = ', num2str(max_step_number),' \n']);
     else
       fprintf('max_step_number = unkown \n');
     end
     if prod(size(max_evol)) == 1
       fprintf(['max_evol = ', num2str(max_evol),' \n']);
     else
       fprintf('max_evol = unkown \n');
     end
     if prod(size(tol_fun)) == 1
       fprintf(['tol_fun = ', num2str(tol_fun),' \n']);
     else
       fprintf('tol_fun = unknown \n');
     end
     if prod(size(popSize)) == 1
       printf(['popSize = ', num2str(popSize),' \n']);
     else
       printf('popSize = unknown \n');
     end
     if prod(size(startPop)) == 1
       fprintf(['startPop = ', num2str(startPop),' \n']);
     else
       fprintf('startPop = unknown \n');
     end
   end
      
