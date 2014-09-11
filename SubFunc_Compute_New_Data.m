function rssAverage = SubFunc_Compute_New_Data(dataForUse, numNodes, rssEmpty)
%% Description: get the average rss of the network
%  In a time interval specified by measurementTimePerSample, each link
%  average its collected RSS. If no RSS measurements for a link in that time interval,
%  set it to be the RSS of vacant network
%  Notes:
%  Only one node transmits at a time. The first value of each line in the
%  data files indicates the node that is reporting its data. The 2nd column
%  to the 29th (since there are 28 total nodes) are the received signal
%  strength (RSS) values from each of the nodes to the reporting node.
%  For example, if the first column is 3, then the 2nd column would represent
%  the RSS from node 0 to node 3. Remember that the nodes' ID start from 0
%%
    rssAverageAcrossTime = zeros(numNodes, numNodes);
    transmitterId = dataForUse(:,1);
    rssData = dataForUse(:,2:1+numNodes);
    for nodeIndex = 1:numNodes
        sameNodeGroup = find(transmitterId == nodeIndex);
        if length(sameNodeGroup)            
            rssAverageAcrossTime(nodeIndex, :) = sum(rssData(sameNodeGroup, :),1) / length(sameNodeGroup);
        end
    end
    
	%the following code are added to eliminate 0 
	%@wudan.
	[syme_row,syme_column] = find(rssAverageAcrossTime == 0);
	syme_temp = (syme_row==syme_column);
	syme_row(syme_temp) = [];
	syme_column(syme_temp) = [];
	syme_zero_num = length(syme_row);
	for j=1:syme_zero_num
		rssAverageAcrossTime(syme_row(j),syme_column(j)) = rssAverageAcrossTime(syme_column(j),syme_row(j));
	end
	
    %if the transmitted data of one node is missing for two consecutive times, we use the data of the node as the receiving end, to measure
    %each link, which can't be missing since every row has 28 columns of data.
    for nodeIndex = 1:numNodes
        if rssAverageAcrossTime(nodeIndex,1) == 0
            rssAverageAcrossTime(nodeIndex, :) = rssAverageAcrossTime(:, nodeIndex);
        end
    end
    
    noMeasurementIndex = find(rssAverageAcrossTime == 0);
    
    rssAverageAcrossTime(noMeasurementIndex) = rssEmpty(noMeasurementIndex);
    
    rssAverage = (rssAverageAcrossTime + rssAverageAcrossTime') / 2;