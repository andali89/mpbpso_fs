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

function [obj]=runclassifier(classifier,Datain,population,infold)
    
    Data=weka.core.Instances(Datain);
    popsize=size(population,1);
    numInstan=zeros(infold,1);
    %fullFeature = Data.numAttributes()-1;%%
    sma=Data.numClasses();
    sensi_speciy=zeros(infold,sma);
    Avg_sensi=zeros(popsize,sma);
    FeatureNum=zeros(popsize,1);

    cAcc=zeros(infold,1);
    Avg_Acc=zeros(popsize,1);
    Data.stratify(infold);
  
    for p=1:popsize   
        if sum(population(p,:))~=0
            DataS=FeatureSelect(Data,population(p,:));
            for k=1:infold
                TrainDataS=DataS.trainCV(infold,k-1);
                TestDataS=DataS.testCV(infold,k-1);
                numInstan(k)=TestDataS.numInstances();
                [~,cAcc(k),matrix]=trainclassify(classifier,TrainDataS,TestDataS);             
                           
                for i=1:sma
                   sensi_speciy(k,i)= matrix(i,i)/sum(matrix(i,:));
                end
                
            end
            Avg_sensi(p,:)=sum(sensi_speciy.*repmat((numInstan),1,2))/sum(numInstan);
            Avg_Acc(p)=sum(cAcc.*numInstan)/sum(numInstan);
            FeatureNum(p)=sum(population(p,:));
            %maxQC(p) = find(population(p,:) == 1, 1, 'last' );
            %meanQC(p) = mean(find(population(p,:) == 1));
            %Inter_QC(p) = 1 - (((1 - (FeatureNum(p) / fullFeature)) * (1 - (maxQC(p) /fullFeature)))^0.5);
            %InterQC(p) = 0.9*FeatureNum(p) + 0.1*meanQC(p);
        else
            Avg_Acc(p)=0;
            Avg_sensi(p,:)=zeros(1,sma);
            %FeatureNum(p)=sum(population(p,:));
            FeatureNum(p) = 1000;
            %meanQC(p) = 1000;
            %maxQC(p) = 1000;
            %InterQC(p) = 1000;
        end
    end

  obj=[1-((Avg_sensi(:,1).*Avg_sensi(:,2)).^0.5),FeatureNum];

  
end