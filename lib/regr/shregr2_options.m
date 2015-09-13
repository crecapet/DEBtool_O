function shregr2_options (key, nr, val)
  %% shregr2_options (key, nr, val)
  %% created at 2002/01/12 by Bas Kooijman; 2005/02/18
  %% sets options for function 'shregr2' one by one

  global plotnr Range all_in_one xlabel ylabel zlabel

    options = ['default'; 'plotnr'; 'Range'; 'xlabel'; 'ylabel'; 'zlabel'; ...
	       'all_in_one'; 'unkown'];
    [r k] = size(options); 

    if exist('key', 'var') == 0
      for i = 2:(r-1)
	txt = options(i,:);
	txt = txt(txt~=' ');
        if eval(['exist(''',txt,''') != 1;'])
	  printf([options(i,:), ' : unkown \n']);
	else
	  if i == 2
	    n = max(size(plotnr));
	    plnr = ' ';
	    for j = 1:n
	      plnr = [plnr, ' ', num2str(plotnr(j))];
	    end
	    fprintf(['plotnr :', plnr, '\n']);
	  elseif i == 3
	    fprintf('Range : \n');
	    for kr = 1:2
	      for rr= 1:2 
	        fprintf([num2str(Range(kr,rr)), ' ']);
	      end
	      fprintf('\n');
	    end		       
	  else	    
	    fprintf([options(i,:), ' : ',num2str(eval(options(i,:))), '\n']);
	  end	  
	end
      end
      return;
    end

    options = [options; key];
    
    for i = 1:(r-1) % determine the option number
      if k == sum(options(r+1,:) == options(i,:))
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
	xtext = [];
	ytext = [];
	ztext = [];

      case 2 % option 'plotnr'
	plotnr = nr;

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
        eval(['global ylabel', num2str(nr), ';']);
	eval(['ylabel', num2str(nr), ' = val;']);


      case 6 % option 'zlabel'
	if exist('val', 'var') == 0
	    nr = 1; val = '';
	end	    
        eval(['global zlabel', num2str(nr), ';']);
	eval(['zlabel', num2str(nr), ' = val;']);


      case 7 % option 'all_in_one'
	all_in_one = nr;

      otherwise % option 'other'
        fprintf('unkown option \n');
	
    end
