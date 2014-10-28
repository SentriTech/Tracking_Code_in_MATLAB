clear;close;clc;
%the following code are trying to extract each rssi data when
% a people walk through each reference point(totally 16) from 
% whole received dat！！！！data.csv .
% this will finaly generate pointNum.csv file in this directory,
%file number equal to reference point number.

%Step one:Read time when people walked through each ponit
catchTime = csvread('catchTime.csv');
numNodes = 24;%CC2530 Node number
pointNum = 16;%human obstacle point number(reference point number)
%valid catchTime file??
if(mod(length(catchTime),pointNum) == 2)
%caculate time into 'second'
circleNum = floor(length(catchTime)/pointNum);%number of circle people walk through 16 obstacle points
obstacleTime = catchTime(:,2) * 3600 + catchTime(:,3) * 60 ...
+ catchTime(:,4) + catchTime(:,5)*10^(-3);

%Step two:Get the time stamp of gathered data！！！！data.csv
fileName = 'data.csv';
wholeData = csvread(fileName);
%TimeStamps is the time when PC received data of node 25(center node)
TimeStamps = wholeData(wholeData(:,1)==1,2+numNodes) * 3600 + wholeData(wholeData(:,1)==1,2+numNodes+1) * 60 ...
+ wholeData(wholeData(:,1)==1,2+numNodes+2) + wholeData(wholeData(:,1)==1,2+numNodes+3)*10^(-3);

%Step three:Generate csv file of each point
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
