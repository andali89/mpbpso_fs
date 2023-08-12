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

function [predictedclass,rate,conf_matrix]=classify(classifier,testData)
        num_c=testData.numClasses();
        class_set=zeros(num_c,1);
        testnum=testData.numInstances();
        classProbs=zeros(testnum,testData.numClasses());
        actual = testData.attributeToDoubleArray(testData.classIndex());   
        for t=0:testnum -1  
            classProbs(t+1,:) = classifier.distributionForInstance(testData.instance(t))';
        end
         [~,predictedclass] = max(classProbs,[],2);
        predictedclass=predictedclass-1;
       
        rate = sum(actual == predictedclass)/testnum; 
        
        if nargout >=3
            act_pre=[actual,predictedclass];
            conf_matrix=zeros(num_c,num_c);
            for i=1:num_c
                ins_now=act_pre(act_pre(:,1)==i-1,:);
                for j=1:num_c
                conf_matrix(i,j)=sum(ins_now(:,2)==j-1);    
                end
            end
                     
        end

      
                     
end