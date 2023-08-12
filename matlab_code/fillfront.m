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

function frontFit = fillfront(frontFit)
% interpolation the objective function values

fits = unique([frontFit(:,2),frontFit(:,1)], 'rows');
fitsadd = [];
for i = 1 : size(fits, 1) - 1
    a = fits(i,1);
    b = fits(i+1,1);
    ya = fits(i,2);
    yb = fits(i+1,2);
    n = b - a - 1;  % the number of elements to interpolate
    if n >= 1
       step = (yb - ya) / (b -a); 
       for j = 1 : n 
            fitsadd = [fitsadd; [a + j, ya + j*step]];
       end
    end
end
fits = [fits; fitsadd];
frontFit = [fits(:,2),fits(:,1)];


end

