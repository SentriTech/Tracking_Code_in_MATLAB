function abnormalLink=SubFunc_Identify_Risky_Links(Data,numNodes,threshold)

% Function to identify the links that doesn't work in a normal way.  To
% identify those links that with a high variance (higher than the
% threshold), which means the link may be affected when sensing the vacant
% network.  


temp=zeros(numNodes,numNodes); %to save one full-block data
NumOfLink=(numNodes*(numNodes-1))/2;
LinkValue=cell(1,NumOfLink); %to save each link's 'all' value over time
LinkIndex = find(tril(ones(numNodes), -1));

BlockIndex=find(Data(:,1)==1); % use ID=1 to divide the data into several blocks
N=length(BlockIndex)-1; % number of block(data package)

for i=1:N
    startLine=BlockIndex(i);
    endLine=BlockIndex(i+1)-1;
    block=Data(startLine:endLine,1:numNodes+1);
    NumOfLine=endLine-startLine+1; % number of line in a block
    
    % if number of line in a block is larger than numNodes, then discard
    % this block data
    if NumOfLine>numNodes 
        continue;%pass the control into next iteration-(n+1)th interation.@wudan
    end
      
    % if NumOfLine<=numNodes, then reorganize the RSS data into the 'temp'
    % Matrix, let the lost line to be 'zero'.
     for ID=1:numNodes
          group=find(block(:,1)==ID);
          if isempty(group)
              continue;%when it hasn't particular node data.@wudan
          end
          if length(group)>1
              continue;%when it has one more node data.@wudan
          end
          temp(ID,:)=block(group,2:numNodes+1);
     end
     
     % if any temp(i,j) or temp(j,i)=0. then symmetrical value set to be
     % zero
     for row=1:numNodes;
         for col=row+1:numNodes
              if temp(row,col)==0
                  temp(col,row)=0;
                  continue;
              end
              if temp(col,row)==0
                  temp(row,col)=0;
              end
         end
     end
     
     temp=(temp+temp')/2;
     
     % if linkvalue=0, then discard this value
     LinkValueTemp=temp(LinkIndex);
     for l=1:NumOfLink
         value=LinkValueTemp(l);
         if value~=0
            LinkValue{1,l}=[LinkValue{1,l},value];
         end
     end  
end 

% calculate variance for each link
VData=zeros(1,NumOfLink);
for i=1:NumOfLink
    VData(1,i)=var(LinkValue{1,i});%unbiased variance estimation.@wudan
end

abnormalLink=find(VData>threshold);%obtain the index of abnormal links

end