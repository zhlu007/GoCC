
clc; close all; clear;

for times = 1:1  %runing times

A=importdata('Gowalla_edges.txt','\t'); %input the original dataset

B=A.data;

[m,n]=size(B);

max(B);

min(B);

C1 = unique(B(:,2));

C2 = unique(B(:,1));

C=unique([C1 ;C2]);

max(C);
min(C);
[mm,nn]=size(C);
network=zeros(max(C),max(C));
temp1=0;
temp2=0;
for i=1:m
    temp1=B(i,1);
    temp2=B(i,2);
    network(temp1,temp2)=1;    
end 

fname = cellstr(ls('nodes_*.csv')); % randomly select users from the original dataset

iname={'Task Coverage', 'Number of Recruited Users', 'Total Social Cost','Average Pairwise Communication Cost','Running Times (s)'};

impact_name={'Connected Components', 'Number of users','Number of cooperative tasks','Task Threshold'};

task_scale={'5','10','15','20','25'};

user_scale={'300','400','500','600','700','800','900'};

cooperative_scale={'[3,5]','[3,10]','[3,15]','[3,20]','[3,25]'};

connected_users={'[5,10]','[5,20]','[5,30]','[5,40]','[5,50]'};

XLabel_number={connected_users user_scale task_scale cooperative_scale};

num_edge=[length(connected_users) 1 1 1];

num_user=[1 length(fname) 1 1];

num_task=[1 1 length(task_scale) 1];

num_cooperation=[1 1 1 length(cooperative_scale)];

for impact_index=1:length(impact_name)
    
    MCT_M=[];
    
    MCT_S=[];
    
    C_C=[];
    
    GoCS_G=[];
    
    GoCS_U=[];
    
%%%%%%%%%%%%%%%%%%%%%%%% user scale setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for name_index=1:num_user(impact_index)

         f_name=name_index;
        
        if impact_index ~= 2
            
            f_name=4; % the number of users : 600 
            
        end
        
        M = csvread(fname{f_name});

        temp=network(:,M);%obtain users' relationship 

        A=temp(M,:);%obtain users' relationship 
        
         graph_network= A;
%         
         graph_network=(graph_network~=0);
         
         graph_network(sum(graph_network,1)<5,:)=0;

        [users,n]=size(graph_network); 
        
        Rgraph_network=graph_network;
        
 %%%%%%%%%%%%%%%%%%%%%%%% community size setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        for d=1:num_edge(impact_index)
            
            if impact_index ~=1
                
                d=3; % community size:[5, 30]
                
            end
            
            node_low=0;
            
            node_up=0;
            
            nodes=0;
            
            all_node=users;
            
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% breaking social ties and generating them randomly %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            node_range = str2num(connected_users{d});
            
            rank_user = randperm(users, users);
            
            random_graph = Rgraph_network .* 0;
            
            while (node_up < all_node)
                
                range = all_node - node_up;
                
                if range - max(node_range) > 0 | range - max(node_range) == 0
                    
                    node_low = node_up + 1;

                    nodes = randi(node_range,1,1);

                    node_up = nodes + node_low - 1;
                    
                    for k = node_low : node_up
                        
                        for v = node_low : node_up
                        
                            random_graph(k,v) = Rgraph_network(rank_user(k),rank_user(v));
                        
                        end
                    end            
                    
                else 
                    
                    node_low = node_up + 1;
                    
                    node_up = all_node;    
                    
                    for k = node_low : node_up
                        
                        for v = node_low : node_up
                        
                            random_graph(k,v) = Rgraph_network(rank_user(k),rank_user(v));
                        
                        end
                    end
                    
                end
            
            end
            
           graph_network = random_graph + random_graph';
           
            graph_network = (graph_network~=0);
   
            max(sum(graph_network,2));

            min(sum(graph_network,2));

            min(sum(graph_network,1));

            length(find(sum(graph_network~=0)~=0));

            sum(sum(graph_network~=0));

            Graph = graph_network;

            neighbor = (graph_network~=0);

            G = graph(graph_network);
    %  
            bins = conncomp(G);

            connected_components = max(bins);

            num_bins = zeros(1,max(bins));

            for t = 1 : max(bins)

                num_bins(t) = length(find(bins==t));

            end

            num_bins;
            
%%%%%%%%%%%%%%%%%%%%%%%% task scale setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            for t = 1 : num_task(impact_index)
                
                if impact_index ~= 3
                    
                    t = 2; %the number of tasks : 10
                    
                end

                tasks = str2num(task_scale{t});

                users = users;

                sensing_tasks = sort(randperm(tasks,tasks));%the total number of sensing tasks varies from 10 to 50

                uncovered_sensing_tasks = (sensing_tasks~=0);

                user_single_bid = unifrnd (5, 10, 1, users);% the cost of each bid is uniformly distributed in [5,10]

                 user_multi_bid = unifrnd (5, 10, users, tasks);

                user_task_set = zeros(users,tasks);%the user-task pairs matrix

                num = randi([3,5],1,users);%the number of biding tasks of each user are uniformly distributed in [3,5]

                for i = 1 : users 

                    index = randperm(tasks,num(i));

                    user_task_set(i,index) = 1;

                end

                user_multi_bid = user_multi_bid .* user_task_set;

                communication_cost = unifrnd (5, 10, users, users);

                communication_cost = (communication_cost+communication_cost')./2;

                communication_cost = communication_cost-diag(diag(communication_cost));

                communication_cost = communication_cost .* neighbor;

                 % for test
                % DG=sparse(communication_cost);
                % [dist,~,~] = graphshortestpath(DG,1,6,'Directed',false);
                
%%%%%%%%%%%%%%%%%%%%%%%% task threshold setting %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                for cindex = 1 : num_cooperation(impact_index)
                    
                    if impact_index ~= 4
                        
                        cindex = 2; %task threshold: [3, 10]
                        
                    end

                    required_cooperative_index = randi(str2num(cooperative_scale{cindex}),1,tasks);%the default value of cooperative index is uniformly distributed in [2,5]
              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GoCC Algorithm %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
                    beta = 0.5;
                    
                    gamma = 0.5;
                    
                    K = 100 ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% initial leader selection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    t1 = clock;
                    
                    seed = Leader_Selector(neighbor,neighbor,K);% initial leader selection 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% candidate group formation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    group = Group_Formation(seed,tasks,users,neighbor,required_cooperative_index,user_task_set,user_single_bid,communication_cost,beta); 
                    
                    t2 = clock;
                    
                    GOCC2_running_time = etime(t2,t1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% primary group selelction and cooperative group selection %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    GoCS_result = Group_based_Cooperator_Selection(group,seed,tasks,required_cooperative_index,user_task_set,user_single_bid,communication_cost,gamma,beta);

                    GoCS_result(:,end) = GoCS_result(:,end) + GOCC2_running_time;           
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                    MCT_M=[MCT_M; TMC_result(1,:)];

                    MCT_S=[MCT_S; TMC_result(2,:)];

                    C_C= [C_C; C2_result];

                    GoCS_G=[GoCS_G; GoCS_result(1,:)];

                    GoCS_U=[GoCS_U; GoCS_result(2,:)];

                end

            end

        end
        
    end

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% output results %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

MCT_M 

MCT_S

C_C

GoCS_G

GoCS_U 
      
end
times
end

