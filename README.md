# GoCC
Multiple Cooperative Task Allocation on Group-oriented Cooperative Crowdsensing
# GoCC Algorithm
It is an open-source MATLAB code that can be used to handle Group-oriented Cooperative Crowdsensing for Multiple Cooperative Task Allocation, which contains four MATLAB files, namely main.m, Leader_Selector.m, Group_Formation.m and Group_based_Cooperator_Selection.m respectively, and one dataset file, i.e., Gowalla_edges.txt, for test.
# GoCC Overview
We consider the problem of Multiple Cooperative Task Allocation (MCTA) in social mobile crowdsensing, in which each task requires a specific amount of users to cooperatively accomplish. GoCC (Group-oriented Cooperative Crowdsensing) approach is proposed to solve the MCTA problem. The general framework of GoCC consists of three main phases:

Phase 1 Leader Initialization —> Phase 2 Group Formation —> Phase 3 Task Allocation, where these phases correspond to the Matlab files Leader_Selector.m, Group_Formation.m and Group_based_Cooperator_Selection.m, respectively.

GoCC first selects top-K influential nodes on the social network as initial leaders via the function of Leader_Selector in Leader_Selector.m file. 

Then, GoCC makes the top-K leaders as leaders searching for their neighbors (from the perspective of social cost and communication cost) in the social network to form candidate groups for the tasks. It can be achieved by using the Group_Formation function in Group_Formation.m file.

Finally, GoCC first allocates a primary group from the perspective of social cost and communication cost to take charge of the tasks. Subsequently, the cooperative groups are needed if the primary group cannot complete the tasks independently. Its MATLAB code can be found in Group_based_Cooperator_Selection.m file.

# Test
We also provide the experiment setup, including performance metrics, parameter settings, etc. All of them can be found in main.m file. For example, the performance metrics includes Task Coverage, Total Cost, Average Pairwise Communication Cost and Running Time. Besides, four parameters are varied in the tests to simulate different MCTA scenarios, including community size, user scale, task scale, and task threshold. 

<!-- community_size = {'[5,10]','[5,20]','[5,30]','[5,40]','[5,50]'}; 
user_scale = {'300','400','500','600','700','800','900'}; 
task_scale = {'5','10','15','20','25'}; 
task_threshold = {'[3,5]','[3,10]','[3,15]','[3,20]','[3,25]'};
 -->

# Dataset
The used dataset is a copy of the Gowalla dataset, i.e., Gowalla_edges.txt, published in http://snap.stanford.edu/data/loc-Gowalla.html

# Development
To setup the development environment, you can directly open GoCC algorithm in MATLAB R2016a. If you have further questions, please contact us.
