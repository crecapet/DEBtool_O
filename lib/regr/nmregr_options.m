function nmregr_options (key, val)
  %% nmregr_options (key, val)
  %% created at 2002/02/10 by Bas Kooijman, modified 2005/05/23
  %% sets options for function 'nmregr' one by one
  %% type 'nmregr_options' to see values or
  %% type 'nmregr_options('default') to set options at default values

  global report max_step_number max_fun_evals tol_simplex tol_fun;

  if exist('key', 'var') == 0
    key = 'unkown';
  end

  options = ['default'; 'report'; 'max_step_number'; ...
	     'max_fun_evals'; 'tol_simplex'; 'tol_fun'; 'unkown'; key];
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
     max_step_number = 800;
     max_fun_evals = 2000;
     tol_simplex = 1e-4;
     tol_fun = 1e-4;
     nmregr_options

   case 2 % option 'report'
     if exist('val', 'var') == 0
       if prod(size(report)) == 1
	     fprintf(['report = ', num2str(report),' \n']);  
       else
         fprintf('report = unknown \n');
       end	      
     else
       report = val;
     end

   case 3 % option 'max_step_number'
     if exist('val', 'var') == 0
       if prod(size(max_step_number)) == 1
	     fprintf(['max_step_number = ', num2str(max_step_number),' \n']);  
       else
         fprintf('max_step_number = unknown \n');
       end	      
     else
       max_step_number = val;
     end

   case 4 % option 'max_fun_evals'
     if exist('val', 'var') == 0
       if prod(size(max_fun_evals)) == 1
	     fprintf(['max_fun_evals = ', num2str(max_fun_evals),' \n']);
       else
	     fprintf('max_fun_evals = unkown \n');
       end
     else
       max_fun_evals = val;
     end

   case 5 % option 'tol_simplex'
     if exist('val', 'var') == 0
       if prod(size(tol_simplex)) == 1
	     fprintf(['tol_simplex = ', num2str(tol_simplex),' \n']);
       else
	     fprintf('tol_simplex = unknown \n');
       end
     else
       tol_simplex = val;
     end
	    
   case 6 % option 'tol_fun'
     if exist('val', 'var') == 0
       if prod(size(tol_fun)) == 1
	     fprintf(['tol_fun = ', num2str(tol_fun),' \n']);
       else
	     fprintf('tol_fun = unknown \n');
       end
     else
       tol_fun = val;
     end
	    
   otherwise % option 'other'
     if prod(size(report)) == 1
       fprintf(['report = ', num2str(report),' \n']);
     else
       printf('report = unknown \n');
     end	      
     if prod(size(max_step_number)) == 1
        fprintf(['max_step_number = ', num2str(max_step_number),' \n']);
     else
        fprintf('max_step_number = unkown \n');
     end
     if prod(size(max_fun_evals)) == 1
        fprintf(['max_fun_evals = ', num2str(max_fun_evals),' \n']);
     else
        fprintf('max_fun_evals = unkown \n');
     end
     if prod(size(tol_simplex)) == 1
        fprintf(['tol_simplex = ', num2str(tol_simplex),' \n']);
     else
        fprintf('tol_simplex = unknown \n');
     end
     if prod(size(tol_fun)) == 1
        fprintf(['tol_fun = ', num2str(tol_fun),' \n']);
     else
       fprintf('tol_fun = unknown \n');
     end
   end
