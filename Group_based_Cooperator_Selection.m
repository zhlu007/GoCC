function result = Group_based_Cooperator_Selection(group,seed,tasks,required_cooperative_index,user_task_set,user_single_bid,communication_cost,gamma,beta)

G = communication_cost;

for i = 1:length(seed)-1
    
    for j = i+1:length(seed)
        
        G(seed(i),seed(j)) = randi([10,20], 1,1);
    
    end
end

DG = sparse(G);

% [dist,~,~] = graphshortestpath(DG,1,6,'Directed',false);

%%%%%%%%%%%%%%%%%%%%%%%%%%%% group based task allocation ----- GoCC-G %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t1 = clock;
 
[r, users] = size(group);

group_bid_set = zeros(1,r);

group_communication_cost = zeros(1,r);

group_cooperative_index = zeros(r,tasks);


for i = 1 : r %computing each group

    member = find(group(i,:)~=0);

    temp = user_task_set(member,:);

    group_cooperative_index(i,:) = sum(temp,1); 

    group_bid_set(i) = sum(user_single_bid(member));

    group_communication_cost(i) = sum(communication_cost(seed(i),member));

end

group_cost = group_bid_set + group_communication_cost;%group's cost

temp_group_cost = group_cost;

temp_group_communication_cost = group_communication_cost;

temp_group_cooperative_index = group_cooperative_index;%

current_cooperative_index = zeros(1,tasks);

covering_uncovered_flag = zeros(1,tasks);

group_winner = [];

GCI = sum(group_cooperative_index,2);

effective_unit_cost = (beta*temp_group_cost+(1-beta)*temp_group_communication_cost)./GCI';

[~,rank_effunitcost] = sort(effective_unit_cost);%finding the cost-effective group

ranking_groups = rank_effunitcost;

group_winner = [group_winner ranking_groups(1)];%obtain the primary group

seed_winner = seed(ranking_groups(1));%the leader of the parmary group

seeds_c_cost = []; %%for the communication cost between groups

for i = 1 : r

 [dist,~,~] = graphshortestpath(DG,seed_winner,seed(i),'Directed',false);

 seeds_c_cost = [seeds_c_cost dist];

end    

user_winner = zeros(1,size(group,2));

user_winner = user_winner | group(group_winner(1),:);   %

x = find(user_winner~=0);

current_cooperative_index = sum(user_task_set(x,:),1);

uncovered_cooperative_index = required_cooperative_index-current_cooperative_index;

covering_uncovered_flag(uncovered_cooperative_index<0) = 1;

covering_uncovered_flag(uncovered_cooperative_index==0) = 1;

covering_uncovered_flag(uncovered_cooperative_index>0) = 0;

winner_cover_tasks = covering_uncovered_flag;

covering = find(covering_uncovered_flag==0, 1);

ranking_groups(1) = [];

temp_group = group(ranking_groups,:);  

temp_group_cost = group_cost(ranking_groups);

temp_group_communication_cost = group_communication_cost(ranking_groups);

temp_group_cooperative_index = group_cooperative_index(ranking_groups,:);%

temp_seeds_c_cost = seeds_c_cost(ranking_groups);

while(~isempty(covering))

    [A,~] = size(temp_group);

    temp_group_user = repmat(user_winner,A,1);

    g_u = temp_group - temp_group_user .* temp_group;%%Delete duplicate users

    temp_group_c_index = zeros(A,tasks);

    temp_group_c_cost = zeros(1,A);

    for i = 1 : A

        member = find(g_u(i,:)~=0);

        temp = user_task_set(member,:);

        temp_group_c_index(i,:) = sum(temp,1);  

        temp_group_c_cost(i) = sum(communication_cost(seed(i),member));

    end

    temp_group_communication_cost = temp_group_c_cost;

    temp_group_cooperative_index = temp_group_c_index;

    temp_uncovered_cooperative_index = repmat(covering_uncovered_flag,A,1);

    can_do_tasks = temp_group_cooperative_index .* (1-temp_uncovered_cooperative_index);   

    CDT = sum(can_do_tasks,2);

    inde = find(CDT==0);

    CDT(inde) = [];

    ranking_groups(inde) = [];

    temp_group(inde,:) = [];

    temp_group_cost(inde) = [];

    temp_group_communication_cost(inde) = [];

    temp_group_cooperative_index(inde,:) = [];

    temp_seeds_c_cost(inde) = [];   

    if isempty(temp_group)

        break;

    end  

    effective_unit_cost = (beta*temp_group_cost+(1-beta)*temp_group_communication_cost) ./ CDT';%computing each candidate group

    %% normalization
    effective_unit_cost = effective_unit_cost./ max(effective_unit_cost);

    temp_seeds_c_cost = temp_seeds_c_cost./max(temp_seeds_c_cost);

    %%
    P = gamma .* effective_unit_cost + (1-gamma) .* temp_seeds_c_cost; %

    [~,ranking_P] = sort(P);

    group_winner = [group_winner ranking_groups(ranking_P(1))];    %

    user_winner = user_winner | group(ranking_groups(ranking_P(1)),:);%

    x = find(user_winner~=0);

    current_cooperative_index = sum(user_task_set(x,:),1);

    uncovered_cooperative_index = required_cooperative_index - current_cooperative_index;

    covering_uncovered_flag(uncovered_cooperative_index<0) = 1;  %0 represents tasks are covered, 1 indicates uncovered

    covering_uncovered_flag(uncovered_cooperative_index==0) = 1;

    covering_uncovered_flag(uncovered_cooperative_index>0) = 0;

    winner_cover_tasks = covering_uncovered_flag;

    covering = find(covering_uncovered_flag==0, 1);

    if ~isempty(covering) 
     
        temp_group_cost(ranking_P(1)) = [];

        temp_group_cooperative_index(ranking_P(1),:) = [];         

        temp_group_communication_cost(ranking_P(1)) = [];

        temp_seeds_c_cost(ranking_P(1)) = [];  

        temp_group(ranking_P(1),:) = [];

        ranking_groups(ranking_P(1)) = [];             

         if isempty(temp_group)
             
            break;
            
         end
    else
           break;
    end   

end

%% user based cost 

x = find(user_winner~=0);

cooperative_index = sum(user_task_set(x,:),1);

current_cooperative_index;

required_cooperative_index;

social_cost = user_single_bid(x);

length(x)

total_social_cost = sum(social_cost);

average_social_cost1 = total_social_cost/length(x);

average_group_social_cost = total_social_cost/sum(cooperative_index);

total_group_communication_cost = 0;

k=0;

conflict_value_users = 0;

G = communication_cost;

for i = 1 : length(group_winner)
    
    u = find(group(group_winner(i),:)~=0);
    
    s = seed(group_winner(i));
    
    for j = 1 : length(u)
        
        total_group_communication_cost = total_group_communication_cost + G(s,u(j));
        
        k = k + 1;
    end
    
end

average_group_communication_cost = (total_group_communication_cost + 20 * (length(group_winner) - 1))/(k+length(group_winner)-1);

%% TASK COVERAGE
winner_cover_tasks;

Task_Completion_Rates = sum(winner_cover_tasks)/tasks;

t2 = clock;

GoCC_G_running_time = etime(t2,t1);

%% OUTPUT

winning_group_group = [Task_Completion_Rates length(x) total_social_cost average_group_communication_cost GoCC_G_running_time];

%% user based task allocation--GoCC-U

if length(group_winner) > 1 


    current_cooperative_index = group_cooperative_index(group_winner(1),:);

    uncovered_cooperative_index = required_cooperative_index-current_cooperative_index;

    covering_uncovered_flag(uncovered_cooperative_index<0) = 1;%1 represents tasks are covered, 0 indicates uncovered

    covering_uncovered_flag(uncovered_cooperative_index==0) = 1;

    covering_uncovered_flag(uncovered_cooperative_index>0) = 0;

    covering = find(covering_uncovered_flag==0, 1);

    winner_cover_tasks = covering_uncovered_flag;

    user_winner = zeros(1,size(group,2));

    user_winner = user_winner | group(group_winner(1),:);%the selected users

    t1 = clock;

    commcost = 0;
    
    comm = 0;

    for i = 2 : length(group_winner)

        selected_seed = i;

        if isempty(covering)

            break;
            
        end

        group_u = group(group_winner(i),:) - (group(group_winner(i),:) .* user_winner);

        group_user = find(group_u~=0) ;

        current_group_user = group_user;

        while (~isempty(current_group_user))       

            temp_winner = repmat(winner_cover_tasks,length(current_group_user),1);

            users_submit_tasks = user_task_set(current_group_user,:);

            can_do_task = users_submit_tasks .* (1-temp_winner); % uncompleted tasks

            cover_index = find((sum(can_do_task,2))==0); 

            can_do_task(cover_index,:) = [];  %Delete duplicate users      

            current_group_user(cover_index) = [];  

           if isempty(current_group_user)%

             break;

           end

            currently_connected_user_bid = user_single_bid(current_group_user);%neighbors' cost

        %% the communication cost between the leader and its neighbors

            current_communication_cost = [];

            for j = 1 : length(current_group_user)

                [dist,~,~] = graphshortestpath(DG,seed_winner,current_group_user(j),'Directed',false);

                current_communication_cost = [current_communication_cost dist];

            end

            q = sum(can_do_task,2);
            
            %% normalization

            currently_connected_user_bid = currently_connected_user_bid./max(currently_connected_user_bid);

            current_communication_cost = current_communication_cost./max(current_communication_cost);

            q = q./max(q);

            P = (beta.*currently_connected_user_bid+(1-beta).*current_communication_cost)./q';  

            [~,rank_P] = sort(P);%

            user_winner(current_group_user(rank_P(1))) = 1;

            required_cooperative_index;

            current_cooperative_index = current_cooperative_index + user_task_set(current_group_user(rank_P(1)),:);

            current_group_user(rank_P(1)) = [];

            uncovered_cooperative_index = required_cooperative_index - current_cooperative_index;

            covering_uncovered_flag(uncovered_cooperative_index<0) = 1;

            covering_uncovered_flag(uncovered_cooperative_index==0) = 1;

            covering_uncovered_flag(uncovered_cooperative_index>0) = 0;

            winner_cover_tasks = covering_uncovered_flag;

            covering = find(covering_uncovered_flag==0,1);

            if isempty(covering)

                break;
            end

            if isempty(current_group_user)%
                
                break;
                
            end

        end

    end

    current_cooperative_index;

    sum(user_task_set(user_winner~=0,:),1);

    required_cooperative_index;

    x = find(user_winner~=0);

    length(x)

    cooperative_index = sum(user_task_set(x,:),1);

    social_cost = user_single_bid(x);

    total_social_cost = sum(social_cost);

    average_social_cost1 = total_social_cost/length(x);

    average_group_social_cost = total_social_cost/sum(cooperative_index);

    total_communication_cost = 0;

    k = 0;

    conflict_value_users = 0;
    
   for i = 1 : selected_seed
               
        s = seed(group_winner(i));

        user = group(group_winner(i),:) .* user_winner;

        u = find(user ~= 0);

        for j = 1 : length(u)

            total_communication_cost = total_communication_cost + G(s,u(j));

            k = k + 1;

        end

    end

    average_communication_cost = (total_communication_cost + 20*(selected_seed - 1))/(k+selected_seed-1);   

    %% task coverage
    
    Task_Completion_Rates = sum(winner_cover_tasks)/tasks;

      %% output

    t2 = clock;

    GoCC_U_running_time = etime(t2,t1) + GoCC_G_running_time;

    winning_user = [Task_Completion_Rates length(x) total_social_cost average_communication_cost GoCC_U_running_time];

else
    
    winning_user = winning_group_group;
    
end

result = [winning_group_group; winning_user];

end





