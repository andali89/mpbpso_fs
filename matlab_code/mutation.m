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

%new mutation method
% 0.1 probability no mutation
% 0.3 probability for add 1 reduce 1 and exchange 1 and 0
function snnew=mutation(snew, pnone)
    if rand() < pnone
       % do not mutate
       snnew = snew;
       return;
    end
    num1 = length(find(snew ==1));
    if num1 ==1
       sel = randi(2);
    elseif num1 ==0
       sel =  1;
    else
       sel = randi(3);
    end
    if sel ==1 
       % add1
       ind0 = find(snew == 0);
       snew (ind0(randi(length(ind0)))) = 1;   
    elseif sel == 2
       ind0 = find(snew == 0);
       ind1 = find(snew == 1);
       snew (ind0(randi(length(ind0)))) = 1;        
       snew (ind1(randi(length(ind1)))) = 0;
    else
       % reduce 1
       ind1 = find(snew == 1);
       snew (ind1(randi(length(ind1)))) = 0;
    end
    snnew = snew;
end   
