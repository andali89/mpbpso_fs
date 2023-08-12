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

function [trainset, testset] = divData(data, trainN, testN)
allfolds = trainN + testN;
data.stratify(allfolds);

testset = data.testCV(allfolds, 0);
for i = 1 : testN - 1
    testset.addAll(data.testCV(allfolds, i));    
end

trainset = data.testCV(allfolds, testN);
for i = 1 : trainN -1
   trainset.addAll(data.testCV(allfolds, i + testN));   
end

indexes = trainset.attributeToDoubleArray(trainset.numAttributes() - 1); 

% Number of classes
classNums = max(indexes) + 1;
% weight of instances in each class
classWeight = zeros(classNums, 1);
% numver of instances in the training set
InsNums = trainset.numInstances();
for i = 1 : classNums
   classWeight(i, 1) = InsNums / sum(indexes == (i - 1)) ;    
end
classWeight

% for each instances set weight
for i = 1: InsNums
   weight = classWeight(indexes(i) + 1);
   trainset.get(i - 1).setWeight(weight); 
   
end



end