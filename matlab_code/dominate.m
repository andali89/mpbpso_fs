% Copyright (c) 2023, An-Da Li. All rights reserved. 
% Please read LICENCE for license terms.
% Coded by An-Da Li
% Email: andali1989@163.com

% This is a Matlab implementation of the MPBPSO algorithm, a 
% multi-objective particle swarm optimization algorithm, proposed
% for key quality feature selection in complex manufacturing processes.
% Please refer to the following paper for detail information of  this
% algorithm:

% Li, A.-D., Xue, B., & Zhang, M. (2023). Multi-objective particle swarm 
% optimization for key quality feature selection in complex manufacturing 
% processes. Information Sciences, 641, 119062.
% https://doi.org/10.1016/j.ins.2023.119062

function sign = dominate(a, b)
     % if a dominate or equals b sign = 1
     % if a do not dominate B and B do not dominate a sign =-1
     % else sign = 0
     
     sumSmaller = sum(a <= b);
     numObj = size(a, 2);
      if sumSmaller == numObj
        
          sign = 1;
%       elseif a(2) < b(2)
%           % if the number of features of a is less than  b, then we think
%           % a better
%           %sign = 1;
%           sign = 0;
      elseif sum(a < b) > 0
          sign = -1;
          % a do not dominate B and B do not dominate a
      else
          sign = 0;
      end



end