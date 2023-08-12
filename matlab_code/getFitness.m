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

function [ fitness, cache, hits] = getFitness(trainset, classifier, pos, infold, cache)
%GETFITNESS Summary of this function goes here
%   Detailed explanation goes here
       matched = match(pos, cache);
       %matched = -1; % do not use cache for a fair comparison.
       tempHits = zeros(1, 2);
       if matched~= -1
           fitness = matched;
           tempHits(1) = 1;
       else
           fitness = runclassifier(classifier,trainset,pos,infold);
           cache.pos = [cache.pos; pos];
           cache.fitness = [cache.fitness; fitness];
            tempHits(2) = 1;
       end
       
       if nargout == 3
           hits = tempHits;
       end

end

