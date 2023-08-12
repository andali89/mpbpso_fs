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

function [ swarmC ] = combineSwarm( swarmA, swarmB )
%COMBINESWARM Summary of this function goes here
% swarmB is the swarm_Parent;
%   swarmC is the combine of swarmA and swarmB
    swarmC.pos = [swarmA.pos; swarmB.pos];
    swarmC.pbpos = [ swarmA.pbpos;  swarmB.pbpos];
    swarmC.fitness = [swarmA.fitness; swarmB.fitness];
    swarmC.pbfitness = [swarmA.pbfitness; swarmB.pbfitness];
    swarmC.count = [swarmA.count; swarmB.count];
end

