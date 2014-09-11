function [rssEmpty abnormalLink] = Read_Vacant_Data(vacantFile_string, settings)

% This funcion is for vacant network data pre-processing use only.  It
% returns a rssEmpty matrix which will be used as the standard matrix when
% sensing the vacant network.   It also returns abnormalLink which identify
% those links with a higher strange variance, they may be affected by the
% environment. 


threshold  = settings.vacantThreshold;
numNodes = settings.numNodes;
vacantSensingTime = settings.vacantSensingTime;
ignoreLine = settings.ignoreLine;


% read data for vacant network
vacantNetworkFileName = vacantFile_string;
vacantNetworkMeasurementData = csvread(vacantNetworkFileName);

nodeIDoffset = 0;


% Ignore the first and last 30 lines of the vacant data
vacantNetworkMeasurementData(:,1) = vacantNetworkMeasurementData(:,1) - nodeIDoffset;
vacantNetworkDataAfterIgnore = vacantNetworkMeasurementData(ignoreLine+1:end-ignoreLine,:);

% Process the time columns to get a time with 'second' scale
vacnatNetworkTimeStamps = vacantNetworkDataAfterIgnore(:,2+numNodes) * 3600 + vacantNetworkDataAfterIgnore(:,2+numNodes+1) * 60 ...
+ vacantNetworkDataAfterIgnore(:,2+numNodes+2) + vacantNetworkDataAfterIgnore(:,2+numNodes+3)*10^(-3);

% Define the first and last time stamps with 'second' scale
vacantNetworkInitialSecond = vacnatNetworkTimeStamps(1);
vacantNetworkLastSecond = vacnatNetworkTimeStamps(1) + vacantSensingTime;


% Define the first and last indice of the start line and the end line in the data matrix
vacantNetworkStartIndice = find(vacnatNetworkTimeStamps >= vacantNetworkInitialSecond, 1, 'first');
if vacantNetworkLastSecond > vacnatNetworkTimeStamps(end)     % If the vacnt data is too short, shorter than the pre-defined  'vacantNetworkSeconds', then set the end of the file as the last index
    vacantNetworkLastSecond = vacnatNetworkTimeStamps(end);
end
vacantNetworkEndIndice  = find(vacnatNetworkTimeStamps >= vacantNetworkLastSecond, 1, 'first');


% Define the data matrix we finally use for vacant network sensing 
%vacantNetworkDataForUse = vacantNetworkDataAfterIgnore(vacantNetworkStartIndice : vacantNetworkEndIndice,:);
vacantNetworkDataForUse = vacantNetworkMeasurementData;

% Process the vacant sensing data and get an averaged matrix: dimension is  numNodes * numNodes
rssEmpty = SubFunc_Compute_Vacant_Data(vacantNetworkDataForUse, numNodes);

% get high-variance link, identify those links with high variance (higher than 'threshold' ), which
% means these links may be affected by other stuffs, may need to take more
% care.
abnormalLink = SubFunc_Identify_Risky_Links(vacantNetworkDataAfterIgnore,numNodes,threshold);

end