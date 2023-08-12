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

function [gbest_pos, swarm] = select_gbestRoulette(swarm, nonSetIndex, tau)
%SELECT_GBEST from the swarm
%   swarm compased of .pos .gbpos .count .fitness .rank_crowd
%   the gbest is the one with minimum count number
%   the selected one with .count + 1
%   the swarm is updated 
    count =  swarm.count(nonSetIndex, :);
    cump = cumsum(exp(-tau * count)); % modified 2022.02.27
    cump = cump / cump(end);    
    % ntour = 2;
    ntour = 2;
    p = rand(1, ntour);
    sel = zeros(1, ntour);
    for i = 1: ntour
       sel(i) = find(cump >= p(i), 1);
    end
    [~, ind] = max(swarm.rank_crowd(nonSetIndex(sel), 2));
    selIndex = nonSetIndex(sel(ind));
    gbest_pos = swarm.pos(selIndex, :);
    swarm.count(selIndex, :) = swarm.count(selIndex, :) + 1; 
end

