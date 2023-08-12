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

function [swarm] = getNextGen(union, swarm_size)
%GETNEXTGEN Summary of this function goes here
%   Detailed explanation goes here
    M = size(union.pos, 1);
    newIndex = (1:M)';
    rank_crowd = union.rank_crowd;
    frontNum = rank_crowd(swarm_size, 1);
    index = find(rank_crowd(:, 1) == frontNum);
    
    if(index(end) ~= swarm_size)
        indexStrength = [rank_crowd(index, 2),index];
        sortedIS = sortrows(indexStrength, -1); % the larger the better for crowd distance
        newIndex(index) = sortedIS(:, 2);
    end
    addIndex = newIndex(1 : swarm_size);
    
    swarm.pos = union.pos(addIndex, :);
    swarm.fitness = union.fitness(addIndex, :);
    swarm.pbpos = union.pbpos(addIndex, :);
    swarm.pbfitness = union.pbfitness(addIndex, :);
    swarm.count = union.count(addIndex, :);
    swarm.rank_crowd = union.rank_crowd(addIndex, :);
end

