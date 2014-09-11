clear;close;clc;
%%%%%%=== following code are trying to extract rssi data when each point(totally 16) were walked through by a person  ===%%%%%%
%%%%%% this will finaly generate pointNum csv file in the directory
%step one:read obstacled time of each ponit
catchTime = csvread('catchTime.csv');
numNodes = 24;
pointNum = 16;%human obstacle point number
if(mod(length(catchTime),pointNum) == 2)
circleNum = floor(length(catchTime)/pointNum);%number of circle people walk through 16 obstacle points
obstacleTime = catchTime(:,2) * 3600 + catchTime(:,3) * 60 ...
+ catchTime(:,4) + catchTime(:,5)*10^(-3);
%step two:get the time stamp of gathered data
fileName = 'data.csv';
wholeData = csvread(fileName);
%TimeStamps is the time when UART received data of node 1
TimeStamps = wholeData(wholeData(:,1)==1,2+numNodes) * 3600 + wholeData(wholeData(:,1)==1,2+numNodes+1) * 60 ...
+ wholeData(wholeData(:,1)==1,2+numNodes+2) + wholeData(wholeData(:,1)==1,2+numNodes+3)*10^(-3);

%step three:generate csv file of each point
for i = 1:pointNum
    dataTemp = [];
    for j = 0:(circleNum-1)
        Startstamp = find(TimeStamps >= (obstacleTime(i+j*pointNum) + obstacleTime(i+1+j*pointNum))/2, 1, 'first');
        Endstamp = find(TimeStamps >= (obstacleTime(i+1+j*pointNum) + obstacleTime(i+2+j*pointNum))/2, 1, 'first');
        dataTemp = [dataTemp;wholeData(((Startstamp - 1)*numNodes + 1):((Endstamp - 1)*numNodes),:)];
    end
        temp = [];
        temp = num2str(i);
        temp = [temp,'.csv'];
        csvwrite(temp,dataTemp);
end

else
    
end
