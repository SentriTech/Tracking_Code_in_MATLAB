function [observation n_count fileName startRow] = Read_New_Data(data_file_string,settings)

% This function is to read and process new coming data from wireless sensor network, in
% real time.  

n_count = settings.n_count;%counting data block.@wudan
fileName = settings.fileName;
startRow = settings.startRow;
numNodes = settings.numNodes;%24 nodes

if n_count == 0
    Allname=struct2cell(dir); 
    [~,n]=size(Allname); 
    csvFilesNameIndex = [];
    for i=3:n
        name=Allname{1,i}; 

        if isempty(strfind(name,data_file_string))
            continue;
        end

        if ~isempty(strfind(name,'csv'))
            csvFilesNameIndex(end+1) = i;
        end
    end
    fileName = Allname{1,csvFilesNameIndex(1)};
end

%dataFile = csvread(fileName);
%[z ~] = extract_data(dataFile,settings.numNodes,settings.rssEmpty);

blockLength = numNodes;

linkIndex = find(tril(ones(numNodes), -1));%obtain the index of lower left quarter element.@wudan
linkAverage = settings.rssEmpty(linkIndex);
linkAverage(linkAverage > 127) = linkAverage(linkAverage > 127) - 2^8;

endRow = startRow + blockLength - 1;
wait_for_data = 1;
while(wait_for_data)
    try 
        %dataFile = csvread(fileName,startRow,0,[startRow 0 endRow 28]);
        %dataFile = csvread(fileName,0,0,[0 0 blockLength blockLength+4]);
        dataFile = csvread(fileName);
        dataFile(sum(dataFile,2)==0,:) = [];%sum along row,and then ???.@wudan
        if size(dataFile,1) < blockLength%total number of row.@wudan
            wait_for_data = 1;
        else
            dataFile = dataFile(startRow:endRow,:);%changed '2:blockLength+1' into 'startRow:endRow'.@wudan
            wait_for_data = 0;
        end
    catch exception
        wait_for_data = 1;
    end
    pause(max(0,(3-settings.Nobj)*0.02));
end
dataCurrentMeasurement = dataFile;
%dataCurrentMeasurement = dataFile(startRow:endRow,:);
startRow = endRow + 1;

rssMeasured = SubFunc_Compute_New_Data(dataCurrentMeasurement, numNodes, settings.rssEmpty);
linkMeasured = rssMeasured(linkIndex);
linkMeasured(linkMeasured > 127) = linkMeasured(linkMeasured > 127) - 2^8;
%deltaY = linkAverage - linkMeasured;
deltaY = abs(linkAverage - linkMeasured);
%???.@wudan
%if rssi changes too much , then set it to be unchanged.@wudan
deltaY(deltaY>20) = 0;
deltaY(deltaY<-5) = 0;
observation = deltaY;

n_count = n_count+1;

% if size(z,2) > n_count
%     n_count = n_count+1;
%     disp(n_count);
%     observation = z(:,n_count);
%     break;
% end

end

