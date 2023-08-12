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

function output=perfectpoint(chromosome,Trainfunc,Performance,w)
    [~,M]=size(Trainfunc);
    V=size(chromosome,2);
    
    F_chromosome=[chromosome,Trainfunc,Performance];
   
    [uobj,p_in_f]=unique(F_chromosome(:,(V+1:M+V)),'rows');
    N = size(uobj,1);
    W = repmat(w, N,1);
     upoints=zscore(uobj).* W;
    
    per_point=min(upoints);
   % per_point=(zeros(1,M)-mean(uobj))./std(uobj);
    uPointNum=size(upoints,1);
    dist_norm=zeros(uPointNum,1);
    for i=1:  uPointNum
       dist_norm(i)=norm(upoints(i,:)-per_point);
    end
    [V_dist,I_dist]=min(dist_norm);
    obj_set=F_chromosome(p_in_f(I_dist),(V+1:M+V));

    Per_result=F_chromosome(ifinclude(F_chromosome(:,(V+1:M+V)),obj_set) ,:);

    output.Solution=Per_result(:,1:V);
    output.Trainfunc=Per_result(:,[V+1:V+M]);
    output.Performance=Per_result(:,[V+M+1:end]);
    for i = 1:size(output.Solution,1)
       output.Solution2(i,:) = find(output.Solution(i,:) == 1); 
    end
    output.maxQC = max(output.Solution2, [], 2);
    output.meanQC = mean(output.Solution2, 2);
end