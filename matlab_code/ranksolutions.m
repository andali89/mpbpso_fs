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

function swarm = ranksolutions(swarm)
% rank and resort the solutions accroding the rank
   dim = size(swarm.pos, 2);
   x = [swarm.pos, swarm.fitness];
   [f,index] = non_domination_sort_mod(x,dim, size(swarm.fitness, 2));
   swarm.pos = f(:, 1 : dim);
   swarm.fitness = f(:, dim + 1 : dim + 2);
   swarm.rank_crowd = f(:, dim + 3 : dim + 4); % Store the rank and crowd distance of swarm
   swarm.pbpos = swarm.pbpos(index, :);
   swarm.pbfitness = swarm.pbfitness(index, :);
   swarm.count = swarm.count(index, :);
end