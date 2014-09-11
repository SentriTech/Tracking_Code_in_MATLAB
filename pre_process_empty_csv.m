%you should change the file name that you want to be processed each time.@wudan
%the aim of this script was to eliminate rss value that is 0
clear;close;clc;
nodenum = 24;
filedata = csvread('empty.csv');
nodeID = filedata(:,1);
standardID = 1:24;
IdGroup = find(nodeID==1);
N = length(IdGroup);
nodeRssi = filedata(:,2:nodenum+1);

for i=1:N
	StartRow = IdGroup(i);
	if i<N
	EndRow = IdGroup(i+1)-1;
	else EndRow = length(nodeID);
	end
	
	if (EndRow-StartRow == nodenum-1)
		block = nodeRssi(StartRow:EndRow,:);
		[row,column] = find(block == 0);
		temp = (row==column);
		row(temp) = [];
		column(temp) = [];
		zero_num = length(row);
		for j=1:zero_num
		block(row(j),column(j)) = block(column(j),row(j));
		end
		nodeRssi(StartRow:EndRow,:) = block;
	else continue;
	end
end
filedata(:,2:nodenum+1) = nodeRssi;
csvwrite('empty.csv',filedata);
