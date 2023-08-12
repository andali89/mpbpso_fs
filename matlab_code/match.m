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

function matched = match(pos, cache)
    % find if binary position match one pos in cache
    % if matched assign the fitness function values to  matched
    % else let mathed = -1
    num = sum(pos);
    index = find(cache.fitness(:,end) == num);
    if isempty(index)
       matched = -1; 
       return;
    else
        matched = -1;
        for i = 1: size(index)
            if all(pos == cache.pos(index(i),:))
                matched = cache.fitness(index(i),:);
                return;
            end
        end
    end

end