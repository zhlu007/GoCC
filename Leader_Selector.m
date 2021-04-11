function seed = Leader_Selector(Graph, neighbor, K)

[m, ~]=size(neighbor);

degree=sum(neighbor,2);

Seed_set=[];

Seed_neighbor_set=zeros(1,m);

DD_utility=[];

seed_Neighbors=[];

degree_index=1:1:m;

iteration=0;

while (~isempty(degree_index) && K~=0)

    copy_winner=repmat(Seed_neighbor_set,length(degree_index),1);
    
    temp_ne= neighbor(degree_index,:) | copy_winner;
    
    temp_ne=temp_ne - copy_winner;
    
    increse_node=sum(temp_ne,2);
    
    [~,rank_increse_node]=sort(increse_node,'descend');
    
    Increase = increse_node(rank_increse_node(1)) / m;
    
    iteration=iteration+1;
       
     if Increase >2/m | Increase ==2/m
         
         if degree(rank_increse_node(1))>1 | degree(rank_increse_node(1))==1
             
             K = K-1;
             
             DD_utility = [DD_utility Increase];
         
            seed_Neighbors = [seed_Neighbors; neighbor(degree_index(rank_increse_node(1)),:)];

            Seed_set = [Seed_set degree_index(rank_increse_node(1))];%[Seed_set degree_index(DD_utility_index(1))];%adding new seed
            
            Seed_neighbor_set= Seed_neighbor_set | neighbor(degree_index(rank_increse_node(1)),:);%adding the new seed's neighbors

            degree_index(rank_increse_node(1))=[];
            
         else
             
               degree_index(rank_increse_node(1))=[];%
               
         end
         
     else
            break;
     end
     
end

seed = Seed_set;


