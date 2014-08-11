function rssEmpty = SubFunc_Compute_Vacant_Data(dataForUse, numNodes)
%% Descrition: get the average rss of the vacant network
%   Only one node transmits at a time. The first value of each line in the
%   data files indicates the node that is reporting its data. The 2nd column
%   to the 29th (since there are 28 total nodes) are the received signal
%   strength (RSS) values from each of the nodes to the reporting node.
%   For example, if the first column is 3, then the 2nd column would represent
%   the RSS from node 0 to node 3. Remember that the nodes' ID start from 0.
%   The nodes to transmit to themselves will always report "-45".
%%
    transmitterId = dataForUse(:,1);
    rssData = dataForUse(:,2:1+numNodes);
    for nodeIndex = 1:numNodes
        sameNodeGroup = find(transmitterId == nodeIndex);
       for i=1:numNodes
            a=rssData(sameNodeGroup,i);
            n=length(find(a~=0));
            if n==0
                rssEmpty(nodeIndex,i)=0;
            else
                rssEmpty(nodeIndex,i)=sum(a)/n;
            end
        end
    end
    
    rssEmpty = (rssEmpty + rssEmpty') / 2;
end