function [equim, p1, p2] = varpar2 (fn, Xi, par1, start1, stop1, np1, ...
				   par2, start2, stop2, np2)
  %% [equim, p1, p2] = varpar2 (fn, Xi, par1, start1, stop1, np1, ...
  %% 				    par2, start2, stop2, np2)
  %% Copyright (C) 2000 Bas Kooijman
  %% Author: Bas Kooijman <bas@bio.vu.nl>
  %% Created: 1 aug 2000
  %% Keywords: equilibrium of a set of ode's as a function of two parameters
  %%
  %% This program is distributed in the hope that it will be useful, but
  %% WITHOUT ANY WARRANTY; without even the implied warranty of
  %% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  %%
  %% This program is written in Octave
  %%   (free software: http://www.che.wisc.edu/octave/)
  %% This script can be obtained from http://www.bio.vu.nl/thb/deb/deblab/
  %%   new versions are indicated by the date of creation

  %% Usage: [par1, par2, equi] =
  %%   varpar2 ('fn_name', initial_values, 'par1_name', start1, stop1, n1,
  %%            'par2_name', start2, stop2, n2)
  %%   fn_name: name of function that defines a set of ode's (see lsode)
  %%   initial_values: row-matrix of values of variables for which ode's
  %%     are given; used to obtain equilibrium value by integration 
  %%   par1_name: name of first parameter that is changed
  %%   start1: first value of first parameter that is changed
  %%   stop1: last value of first parameter that is changed
  %%   n1: number of first-parameter values for which equilibrium is evaluated
  %%   par2_name: name of second parameter that is changed
  %%   start2: first value of second parameter that is changed
  %%   stop2: last value of second parameter that is changed
  %%   n2: number of second-parameter values for which equilibrium is evaluated
  %%   par1: (n1, 1)-matrix of parameter values
  %%   par2: (n2, 1)-matrix of parameter values
  %%   equi: (k, n1, n2)-array of equilibrium values
  %%     organized in a data-structure:
  %%     equi._4 is a (n1, n2) matrix that relates to variable number 4
  %%     (assuming that there are at least 4 variables defined in 'fn_name').
  %%     This silly construct is necessary because Octave does not support
  %%     (yet?) multidimensional arrays
  %%
  %% The ode's are first integrated to obtain an initial guess for the
  %% equilibrium values, given parameter value equals `start'.
  %% The equilibrium values serve as initial guesses for the next parameter
  %% value. This assumes that the system has a point attractor at
  %% parameter value `start'. The used-defined function fn_name should
  %% define the parameter as global.
  %%
  %% Requires: wrap
  %%           user-defined function 'fn_name' for ode's, see lsode
  %%           global parameters 'par1_name', 'par2_name'
  %%           int2equi
  %% See also: varpar


  eval(['global ', par1, ' ', par2,';'])

  %% grab current values of parameters, to be restored on return
  eval(['value1 = ', par1,'; value2 = ', par2, ';']);

  %% fill output for p1 and p2, and initiate equim, later converted to equi  
  p1 = linspace (start1, stop1, np1); p1 = p1.';
  p2 = linspace (start2, stop2, np2); p2 = p2.';
  [nr, nc] = size(Xi);         % the assumption is that nr = 1
  equim = zeros (np1*np2, nc); % first make a matrix,
			       % later wrap it into a data structure

  eval([par1, ' = start1; ', par2, ' = start2;']); % set par values


  Xj = Xi;    % the start value is contained in Xi
  for i = 1:np1    
    eval([par1, ' = p1(i);']);   
    for j = 1:np2
      eval([par2,' = p2(j);']);
      if (i == 1)  % start new row in mesh
        [Xj, info] = int2equi (fn, Xj);	% use last new-row value as start
        Xi = Xj;   % copy result in start value for the rest of new row 
      else	
        [Xi, info] = int2equi (fn, Xi);	% use last new-column value as start
      end
      equim(j + (i-1)*np2,:) = Xi.'; % fill result matrix
      
      if (info ~= 1)
        fprint('no convergence \n');	
      end      
    end
  end

  %% wrap result matrix equim into output data-structure equi 
  for i = 1:nc
    eval(['equi._',num2str(i),' = wrap (equim(:,i), np1, np2);' ]);
  end
  
  %% restore values of parameters
  eval([par1, ' = value1; ', par2, ' = value2;']);
  