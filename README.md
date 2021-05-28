# GoCC
Multiple Cooperative Task Allocation on Group-oriented Cooperative Crowdsensing
# GoCC Algorithm
It is an open-source MATLAB code that can be used to handle Group-oriented Cooperative Crowdsensing for Multiple Cooperative Task Allocation, which contains four files, namely main.m, Leader_Selector.m, Group_Formation.m and Group_based_Cooperator_Selection.m respectively.
# Dataset
The used dataset is a copy of the Gowalla dataset, i.e., Gowalla_edges.txt, published in http://snap.stanford.edu/data/loc-Gowalla.html
# GoCC Overview
The general framework of GoCC consists of three main phases:

\textbf{Phase 1 Leader Initialization:} In this phase, we select K influential nodes on the social network as initial leaders by fusing influence degree and user diversity. 

\textbf{Phase 2 Group Formation:} In this phase, we make the top-$K$ leaders as leaders searching for their neighbors in the social network to form groups for MCTs. 

\textbf{Phase 3 Task Allocation:} To handle MCTs effectively, this phase first considers a primary group according to the social cost and communication cost of candidate groups. Subsequently, the cooperative groups are assigned if the primary group cannot complete the sensing tasks independently. 
