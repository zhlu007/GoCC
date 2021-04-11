function group = Group_Formation(seed,tasks,users,neighbor,required_cooperative_index,user_task_set,user_bid_set,communication_cost,beta)

temp_group = zeros(length(seed),users);

for i = 1 : length(seed)%length(seed)
    
    winner = [];
    
    current_cooperative_index = zeros(1,tasks);
    
    winner_cover_tasks = zeros(1,tasks);
    
    temp_user_task_set = user_task_set;
        
    winner = [winner seed(i)];
    
    winner_cover_tasks = winner_cover_tasks | temp_user_task_set(seed(i),:);
    
    current_cooperative_index = current_cooperative_index + winner_cover_tasks;     
    
    uncovered_cooperative_index = required_cooperative_index-current_cooperative_index;
        
    covering_uncovered_flag(uncovered_cooperative_index<0) = 1;     %1 indicates covered£¬0 indicating uncovered
    
    covering_uncovered_flag(uncovered_cooperative_index==0) = 1;
    
    covering_uncovered_flag(uncovered_cooperative_index>0) = 0;
    
    winner_cover_tasks = winner_cover_tasks .* covering_uncovered_flag;
    
    x = find(covering_uncovered_flag==0,1);   
          
    connected_users = find(neighbor(seed(i),:)~=0);%obtian the seed's neighbors
    
    currently_connected_users = connected_users;%[seed(i) seed_neighbor];

    connected_user_flag = (connected_users~=0);
    
    index = find(connected_user_flag==1,1);%obtain the unfound users
           
    while (~isempty(index))       
                                        
        temp_winner = repmat(winner_cover_tasks,length(currently_connected_users),1);
        
        users_submit_tasks = user_task_set(currently_connected_users,:);
        
        can_do_task = users_submit_tasks .* (1-temp_winner); % finding the uncovered tasks 
        
        cover_index = find((sum(can_do_task,2))==0);
        
        can_do_task(cover_index,:) = [];  %delete the repetitive users      
        
        currently_connected_users(cover_index) = [];   
                
       if isempty(currently_connected_users)%
           
           if  ~isempty(x) 
                           
                if ~isempty(index)
                    
                    currently_connected_users = connected_users(connected_users~=0);

                    winner_cover_tasks = winner_cover_tasks .* covering_uncovered_flag;
                    
                    temp_winner = repmat(winner_cover_tasks,length(currently_connected_users),1);

                    users_submit_tasks = user_task_set(currently_connected_users,:);

                    can_do_task = users_submit_tasks .* (1-temp_winner); % finding the uncovered tasks 
                    
                    cover_index = find((sum(can_do_task,2))==0);

                    can_do_task(cover_index,:) = [];%delete the unqualified users

                    currently_connected_users(cover_index) = [];
                    
                    if isempty(currently_connected_users)

                        break;
                        
                    end
                    
                else
                    
                    break;
                    
                end
                
           else
               
               break;
           
           end                  
        
       end
       
        currently_connected_user_bid = user_bid_set(currently_connected_users);%neighbors' cost
    
        current_communication_cost = communication_cost(seed(i),currently_connected_users);%the communication cost between users and the leader
                      
        q = sum(can_do_task,2);

        P = (beta.*currently_connected_user_bid+(1-beta).*current_communication_cost)./q';  
        
        [~,rank_P] = sort(P);%

        %add a bid into the set of winning bids
        winner = [winner currently_connected_users(rank_P(1))];
        
        connected_user_flag(connected_users==currently_connected_users(rank_P(1))) = 0;
        
        index = find(connected_user_flag==1,1);
        
        connected_users(connected_users==currently_connected_users(rank_P(1))) = 0;

        winner_cover_tasks = winner_cover_tasks | user_task_set(currently_connected_users(rank_P(1)),:);
        
        current_cooperative_index = current_cooperative_index + winner_cover_tasks;
                       
        currently_connected_users(rank_P(1)) = [];
              
        uncovered_cooperative_index = required_cooperative_index-current_cooperative_index;
        
    %1 indicates covered£¬0 indicating uncovered
        covering_uncovered_flag(uncovered_cooperative_index<0) = 1; 
        
        covering_uncovered_flag(uncovered_cooperative_index==0) = 1;
        
        covering_uncovered_flag(uncovered_cooperative_index>0) = 0;

        winner_cover_tasks = winner_cover_tasks .* covering_uncovered_flag;

        covering_uncovered_flag;
        
        x = find(covering_uncovered_flag==0,1);      
       
        if isempty(currently_connected_users)%
           
           if  ~isempty(x) 
                           
                if ~isempty(index)
                    
                    currently_connected_users = connected_users(connected_users~=0);

                     winner_cover_tasks = winner_cover_tasks .* covering_uncovered_flag;

                else
                    
                    break;
                    
                end
                
           else
               
               break;
           
           end                  
        
        end       
 
    end
    
    temp_group(i,winner) = 1;
end

group = temp_group;

end



  
     