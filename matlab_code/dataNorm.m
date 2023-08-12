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

function datao=dataNorm(data,scale,translation)
    if nargin<2
       % normlize to [-1, 1]
       scale=2;
       translation=-1;
    end
    normer=weka.filters.unsupervised.attribute.Normalize();
    normer.setOptions({'-S',num2str(scale),'-T',num2str(translation)});
    normer.setInputFormat(data);
    datao=weka.filters.Filter.useFilter(data,normer);
end

