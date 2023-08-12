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

% This main.m file is an example for using the MPBPSO code. The ideal point
% method is not use for selecting the final solution. Users can use the 
% "perfectpoint.m"  function to select the final solution.

clc;
%clear all;
close;
%% add weka path
addwekapath;
%% run setting
seed=46;        
infold=5;
segnum=5;
%% classifier
classifier=weka.classifiers.bayes.NaiveBayes();
classifier.setUseKernelEstimator(0); % 1 or 0
%% read and normalize data
datapath='wdbc.arff';
data=readArffData(datapath);
data=dataNorm(data); 
fprintf('attribute num is %d\nnum of instances is %d\n',data.numAttributes()-1,data.numInstances());
numAttri=data.numAttributes()-1;
data.randomize(java.util.Random(seed));
data.stratify(segnum);
%% parameters for MPBPSO
setup.SearchAgents_no = 100;
setup.Max_iter = 100;
setup.lb = -1;
setup.ub = 1;
setup.dim = numAttri;
setup.infold = 5;
setup.mutationtype = 1; % 1 one point, -1 change position , 0 hybrid 
setup.pnoe = 0.15; % for new mutation method tuned 2022.3.6
%  imS = 1 / dim;
%  imE = 0;
setup.im = 0.4; % tuned 2022.3.6
setup.tau = 5;


%%
Start=tic;
Startcpu=cputime;
randseed = 1;


segfold = 0;
%for segfold=8:8
RandStream.setGlobalStream(RandStream('mt19937ar','seed',randseed));
Startin=tic;
Startincpu=cputime;
disp(['Running fold ',num2str(segfold)]);


trainset=data.trainCV(segnum,segfold);

testset=data.testCV(segnum,segfold);

                                    
[Solution,Trainfunc, iter_result]= MPBPSO(classifier,trainset,setup);

%% get the prediction accuracy for each solution in the final solution set

numsolution=size(Solution,1);
Conf_matrix=cell(numsolution,1);
pAcc=zeros(numsolution,1);
Sensitivity=zeros(numsolution,1);
Specificity=zeros(numsolution,1);
f1=zeros(numsolution,1);
for i=1:numsolution   
    trainsetr=FeatureSelect(trainset,Solution(i,:));
    testsetr=FeatureSelect(testset,Solution(i,:));
    [~,pAcc(i),Conf_matrix{i,1}]=trainclassify(classifier,trainsetr,testsetr);
     Sensitivity(i)=Conf_matrix{i,1}(1,1)/sum(Conf_matrix{i,1}(1,:));
    Specificity(i)=Conf_matrix{i,1}(2,2)/sum(Conf_matrix{i,1}(2,:));
    preci = Conf_matrix{i,1}(1,1)/sum(Conf_matrix{i,1}(:, 1));
    if (preci + Sensitivity(i)) ==0 || isnan(preci)
        f1(i) = 0;
    else
        f1(i) = ( 2* preci * Sensitivity(i))/ (preci + Sensitivity(i));      
    end
  
end

Performance=[Sensitivity,Specificity,pAcc, f1];



%% summarize
