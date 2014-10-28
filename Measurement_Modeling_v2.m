clear;close;clc;
%unvalidated fully-2014.08.14 version
%unadjusted parament :step, 
%the aim of this script is to modeling measuerment model, or we can say to obtain 3 parameter:PHI, sigma_lamda and sigma_z
%Step 1:Load settings.
settings = Load_Settings();                                                

%Step 2:Read empty room rss data.
%Obtain rssEmpty
vacantFile_string = 'empty.csv';
[rssEmpty,abnormalLink] = Read_Vacant_Data(vacantFile_string, settings);%we didn't take abnormal links into account in this time

settings.rssEmpty = rssEmpty;
settings.abnormalLink = abnormalLink;
%Step 3:Read rss data with human stand in differant points.
%Obtain rssObstruct
Point_pos = settings.human_pos;
[Point_num,~] = size((settings.human_pos));
rssObstruct = zeros(settings.numNodes,settings.numNodes,Point_num);%Initialize rss data with a human stand in zigbee network

Allname=struct2cell(dir); 
[~,n] = size(Allname);

for j = 1:Point_num
	data_file_string = num2str(j);
	csvFilesNameIndex = [];
	for i = 3:n
		name=Allname{1,i}; 
		if isempty(strfind(name,data_file_string))
			continue;
		end
		if ~isempty(strfind(name,'csv'))
        csvFilesNameIndex(end+1) = i;
		end
	end
	fileName = Allname{1,csvFilesNameIndex(1)};%get file name of ith point - i.csv.
	[rssObstruct(:,:,j),~] = Read_Vacant_Data(fileName,settings);
end

%Step 4:caculate lamda and Z(attenuation).
lamda = [];
Z = [];
sensor_network = Create_Network(settings);
%remove abnormal links
sensor_network.M = sensor_network.M - length(settings.abnormalLink);
sensor_network.links(settings.abnormalLink,:) = [];
sensor_network.d(settings.abnormalLink) = [];

links = sensor_network.links;
linkNum = sensor_network.M;
linksDistances = sensor_network.d;

s1_location = sensor_network.sensor_pos(sensor_network.links(:,1),:);%transmitte node position of each link
s2_location = sensor_network.sensor_pos(sensor_network.links(:,2),:);%receive node position of each link.@wudan
for i = 1:Point_num
    diff1 = bsxfun(@minus,s1_location(:,1),Point_pos(i,1));
    diff2 = bsxfun(@minus,s1_location(:,2),Point_pos(i,2));
    distance1 = sqrt(diff1.^2 + diff2.^2);

    diff1 = bsxfun(@minus,s2_location(:,1),Point_pos(i,1));
    diff2 = bsxfun(@minus,s2_location(:,2),Point_pos(i,2));
    distance2 = sqrt(diff1.^2 + diff2.^2);

    %lambdaVector = distance1 + distance2 - linksDistances;
    temp = bsxfun(@minus,distance1+distance2,linksDistances);
	lamda =[lamda,temp'];
	
	temp = rssEmpty - rssObstruct(:,:,i);
	%be careful about the index of Z should consistent with that of lamda
	index = sub2ind(size(temp),links(:,1),links(:,2));
	Z =[Z,temp(index)'];
end
%clear index temp

%Step 5:Merge lamda vector into lamda_standard.
%Here we divide lamda evenly into L segments, because it makes the following caculation easier
% and it almost have no influence on final results. 
% step = (lamda_standard(L+1)-lamda_standard(L))/2
step = 0.03;%step size should be choose carefully, here we choose 10 cetimeter
lamda_standard = 0:step:1;
L = length(lamda_standard);
Z_standard = zeros(1,L);
for i=1:L
temp = (lamda < (lamda_standard(i)+step/2))&(lamda >= (lamda_standard(i)-step/2));
if sum(temp)~=0%avoid mean([])
%plot(lamda_standard(i),Z(temp),'.r','MarkerSize',11)
%hold on
Z_standard(i) = mean(Z(temp));%average attenuation level.
end
end
temp = find(Z_standard==0);%find zero part of Z_standard and eliminate it
lamda_standard(temp) = [];
Z_standard(temp) = [];
%Step 6:Fitting the exponential curve
plot(lamda_standard,Z_standard,'r-')
xlabel('Lamda')
ylabel('Attenuation')
phi = 1.8;sigma_lamda = 0.03;
hold on
plot(lamda_standard,phi*exp(-lamda_standard/(2*sigma_lamda)))
diff = Z_standard - phi*exp(-lamda_standard/(2*sigma_lamda));
sqrt(var(diff))