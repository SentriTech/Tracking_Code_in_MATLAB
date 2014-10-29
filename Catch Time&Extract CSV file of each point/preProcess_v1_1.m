clear;close;clc;
%the following code are trying to extract each rssi data when
% a people walk through each reference point(totally 16) from 
% whole received data！！！！data.csv .
% this will finaly generate pointNum.csv file in this directory,
%file number equal to reference point number.

%Step one:Read time when people walked through each ponit
catchTime = csvread('catchTime.csv');
numNodes = 24;%CC2530 Node number
pointNum = 16;%human obstacle point number(reference point number)
if(mod(length(catchTime),pointNum) == 2)%Validity catchTime file Determination
%caculate time into 'second'
circleNum = floor(length(catchTime)/pointNum);%number of circle that people walked through 16 obstacle(reference) points
obstacleTime = catchTime(:,2) * 3600 + catchTime(:,3) * 60 ...
+ catchTime(:,4) + catchTime(:,5)*10^(-3);%normalized to seconds

%Step two:Get the time stamp of gathered data！！！！data.csv
fileName = 'data.csv';
wholeData = csvread(fileName);%data to be tear apart
%TimeStamps is the time when PC received data from node 25(central node)
TimeStamps = wholeData(wholeData(:,1)==1,2+numNodes) * 3600 + wholeData(wholeData(:,1)==1,2+numNodes+1) * 60 ...
+ wholeData(wholeData(:,1)==1,2+numNodes+2) + wholeData(wholeData(:,1)==1,2+numNodes+3)*10^(-3);%normalized to seconds

%Step three:Generate n csv file of each point
for i = 1:pointNum
    dataTemp = [];%temporary data variable
    for j = 0:(circleNum-1)
        Startstamp = find(TimeStamps >= (obstacleTime(i+j*pointNum) + obstacleTime(i+1+j*pointNum))/2, 1, 'first');%start index
        Endstamp = find(TimeStamps >= (obstacleTime(i+1+j*pointNum) + obstacleTime(i+2+j*pointNum))/2, 1, 'first');%end index
        dataTemp = [dataTemp;wholeData(((Startstamp - 1)*numNodes + 1):((Endstamp - 1)*numNodes),:)];%extracted data
    end
        temp = [];%temporary file name variable
        temp = num2str(i);%transfer number into string
        temp = [temp,'.csv'];%concatenant it with a file type suffix
        csvwrite(temp,dataTemp);%writing data to csv file
end

else%another part of if condition
    
end%end of if condition
