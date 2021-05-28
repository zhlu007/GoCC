# GoCC
Multiple Cooperative Task Allocation on Group-oriented Cooperative Crowdsensing
# GoCC Algorithm
It is an open-source MATLAB code that can be used to handle Group-oriented Cooperative Crowdsensing for Multiple Cooperative Task Allocation, which contains four files, namely main.m, Leader_Selector.m, Group_Formation.m and Group_based_Cooperator_Selection.m respectively.
# GoCC Overview
We consider the problem of Multiple Cooperative Task Allocation (MCTA) in social mobile crowdsensing.  GoCC (Group-oriented Cooperative Crowdsensing) approach is proposed to solve the MCTA problem. The general framework of GoCC consists of three main phases:

Phase 1 Leader Initialization. This phase selects top-K influential nodes on the social network as initial leaders via the function of Leader_Selector in Leader_Selector.m file. 

Phase 2 Group Formation. This phase makes the top-K leaders as leaders searching for their neighbors in the social network to form candidate groups for multiple Cooperative Tasks. It can be achieved by using the Group_Formation function in Group_Formation.m file.

Phase 3 Task Allocation: This phase first considers a primary group. Subsequently, the cooperative groups are assigned if the primary group cannot complete the tasks independently. Its MATLAB code can be found in Group_based_Cooperator_Selection.m file.

# Development
To setup the development environment, you can directly open GoCC algorithm in MATLAB R2016a. If you have further questions, please contact us.

# Test
We also provide the experiment setup, including performance metrics, parameter settings, etc. All of them can be found in main.m file. For example, the performance metrics includes Task Coverage, Total Cost, Average Pairwise Communication Cost and Running Time.

# Dataset
The used dataset is a copy of the Gowalla dataset, i.e., Gowalla_edges.txt, published in http://snap.stanford.edu/data/loc-Gowalla.html
