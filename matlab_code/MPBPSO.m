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

function [nonPos,nonFit, iter_result]=MPBPSO(classifier,trainset,setup)
% the main procedure for the MPBPSO algorithm
% Input:  classifier  - a classifier in Weka
%         trainset    - the trainset input to the algorithm
%         setup       - setup for MPBPSO
% Output: nonPos      - set of nondominated solutions
%         nonFit      - the objective function values of the nondominated solutions
%         iter_result - the information during the iterations of the algorithm




swarm_size = setup.SearchAgents_no;
Max_iter = setup.Max_iter;
dim = setup.dim;
infold = setup.infold;

pnone = setup.pnoe; % for new mutation method
%  imS = 1 / dim;
%  imE = 0;
tau = setup.tau;
im = setup.im;
ip = (1 - im) / 3;
ig = 2 * (1 - im) / 3;



%Initialize the positions of search agents

pos_temp =initialization(swarm_size,dim, 1, 0);
swarm.pos = double(pos_temp > 0.5);
swarm.pbpos = swarm.pos;



%%
t=0;% Loop counter
cache = [];
%% Evaluate the initial solutions

% Calculate objective function for each search agent

swarm.fitness = runclassifier(classifier,trainset,swarm.pos,infold);
swarm.pbfitness = swarm.fitness;
swarm.count = zeros(swarm_size , 1);
cache.pos = swarm.pos;
cache.fitness = swarm.fitness;
cacheHits = zeros(1, 2); % the first is the hits, the second is the miss

%% get the ranking results
 swarm = ranksolutions(swarm);
 nonSetIndex = find(swarm.rank_crowd(:, 1) == 1);
 %% iter re
 searchNum = swarm_size;
 iter_result = [[t, searchNum],{swarm.fitness(nonSetIndex, :)}];
%%
% Main loop
while t < Max_iter
    %update im ip ig
%        tc = -0.5 + t /(Max_iter -1);
%        im = imS - (imS - imE) / (1 + exp(- 10 * tc));
% %      im = imS + (imE - imS) * t /(Max_iter -1);
%        ig = (1 - im) * 2 / 3;
%        ip = 1 - im - ig;

    
     fprintf('iteration: %d, nondominated set size: %d \r\n', t, length(nonSetIndex));
    
    % select the gbests in swarm
     [gbest_pos, swarm] = select_gbestRoulette(swarm, nonSetIndex, tau);
     % copy the swarm to parent swarm
      swarm_parent = swarm;
      swarm.count = swarm.count * 0;
     % update the probability vector
     for i = 1 : swarm_size
         %added for test
%          im_base = repmat(im, 1, dim);
%          num_one = sum(swarm.pos(i, :)1)
%          im_base(swarm.pos(i, :) == 0) = im * num_one / (dim - num_one);
%          p = im_base  + ip * abs(swarm.pos(i, :) - swarm.pbpos(i, :)) + ...
%              ig * abs(gbest_pos - swarm.pos(i, :));
         
         p = ip * abs(swarm.pos(i, :) - swarm.pbpos(i, :)) + ...
             ig * abs(gbest_pos - swarm.pos(i, :));
         rand_num = rand(1, dim);
         change_index = rand_num < p;
         swarm.pos(i, change_index) = 1 - swarm.pos(i, change_index);  
       
         % mutation to be added
        
         swarm.pos(i, :) = mutation(swarm.pos(i, :), pnone); % new mutation type used
         % mutation end
         [ swarm.fitness(i, :), cache, hits ] = getFitness(trainset, classifier, ...
             swarm.pos(i, :), infold, cache);
         cacheHits = cacheHits + hits;
     end     
     
     
     % rank the solutions and update the swarm
     [union] = combineSwarm(swarm, swarm_parent);
     union = ranksolutions(union);
     swarm = getNextGen(union, swarm_size);
     nonSetIndex = find(swarm.rank_crowd(:, 1) == 1);   
     
     
     % update the pbest revised 2022.3.3
     frontFit = swarm.fitness(nonSetIndex, :);
     maxFit  = max(frontFit);
     minFit = min(frontFit);
     frontFit = fillfront(frontFit);
     frontFit = innernorm(frontFit, maxFit, minFit);
     for i = 1 : swarm_size
         domistate = dominate(swarm.fitness(i, :), swarm.pbfitness(i, :));
         if domistate ==1 && ...
                 ~isequal(swarm.fitness(i, :), swarm.pbfitness(i, :))
             swarm.pbfitness(i, :) = swarm.fitness(i, :);
             swarm.pbpos(i, :) = swarm.pos(i, :);
         elseif domistate == -1 
             % x and pbest do not domiate each other revised 2022.3.18
             pbdis = calGD(frontFit,swarm.pbfitness(i, :), maxFit, minFit);
             dis = calGD(frontFit,swarm.fitness(i, :), maxFit, minFit);
             if dis < pbdis
                 swarm.pbfitness(i, :) = swarm.fitness(i, :);
                 swarm.pbpos(i, :) = swarm.pos(i, :);
             end
         end         
     end
      
  
      t = t + 1;
      searchNum = searchNum + swarm_size;
      iter_this = [[t, searchNum],{swarm.fitness(nonSetIndex, :)}];
      if t ==0
          iter_result = iter_this;
      else
          iter_result = [iter_result;iter_this];
      end
      
      
      
    
end

nonPos = swarm.pos(nonSetIndex, :);
nonFit = swarm.fitness(nonSetIndex, :);


% write the information of cacheHits to file.
charName = char(trainset.relationName);
dataName = charName(1:5);
hitsfile = fopen([dataName, '_Hits.txt'], 'a+');
fprintf(hitsfile, 'Hits: %d, nonHits: %d \r\n', cacheHits);
fclose(hitsfile);
end




