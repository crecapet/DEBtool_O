function [EMJHG info] = birth_pie_foetus(p, eb)
% [EMJHG info] = birth_pie_foetus(p, eb)
% created at 2011/01/19 by Bas Kooijman
%   shell around get_EMJHG_foetus to draw pies
% p: 4 or 5-vector with parameters
% eb: optional n-vector with scaled reserve densities at birth
%    default: 1
% EMJHG: (n,5 or 6)-matrix with in the columns fractions of initial reserve at birth
%  reserve left at birth, cumulatively allocated to som maint, mat maint, maturation, growth 
%  if p(5) is specified, growth if splitted in dissipated and fixed in structure
% info: n-vector with failure (0) of success (1) for uE0 and tau_b-computations

if exist('eb','var') == 0
    eb = 1; % maximum value as juvenile
end
n = length(eb);
[EMJHG info] = get_EMJHG_foetus(p, eb);

%close all
if length(p) == 4
  pie_txt = {'reserve', 'som maint', 'mat maint', 'maturity', 'growth'};
  pie_color = [1 1 .8; 1 0 0; 1 0 1; 0 0 1; 0 1 0];
  for i = 1:n
    figure
    colormap(pie_color);
    pie(EMJHG(i,:),[0 1 1 1 0], pie_txt);
    title(['foetus e_b = ', num2str(eb(i))])  
  end
else
  pie_txt = {'reserve', 'som maint', 'mat maint', 'maturity', 'growth overhead', 'structure'};
  pie_color = [1 1 .8; 1 0 0; 1 0 1; 0 0 1; 0 1 0; .8 1 .8];
  for i = 1:n
    figure
    colormap(pie_color);
    pie(EMJHG(i,:),[0 1 1 1 1 0], pie_txt);
    title(['foetus e_b = ', num2str(eb(i))])
  end
end