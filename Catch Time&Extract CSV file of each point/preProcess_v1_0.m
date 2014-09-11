clear;close;clc;
%step one:read obstacled time of each ponit
catchTime = csvread('catchTime.csv');
obstacleTime = catchTime(:,2) * 3600 + catchTime(:,3) * 60 ...
+ catchTime(:,4) + catchTime(:,5)*10^(-3);
pointNum = length(obstacleTime) - 2;
%step two:get the time stamp of gathered data
numNodes = 24;
fileName = 'data.csv';
wholeData = csvread(fileName);
%TimeStamps is the time when UART received data of node 1
TimeStamps = wholeData(wholeData(:,1)==1,2+numNodes) * 3600 + wholeData(wholeData(:,1)==1,2+numNodes+1) * 60 ...
+ wholeData(wholeData(:,1)==1,2+numNodes+2) + wholeData(wholeData(:,1)==1,2+numNodes+3)*10^(-3);

%step three:generate csv file of each point
for i = 1:pointNum
Startstamp = find(TimeStamps >= (obstacleTime(i) + obstacleTime(i+1))/2, 1, 'first');
Endstamp = find(TimeStamps >= (obstacleTime(i+1) + obstacleTime(i+2))/2, 1, 'first');
temp = [];
temp = num2str(i);
temp = [temp,'.csv'];
csvwrite(temp,wholeData(((Startstamp - 1)*numNodes + 1):((Endstamp - 1)*numNodes),:));
end