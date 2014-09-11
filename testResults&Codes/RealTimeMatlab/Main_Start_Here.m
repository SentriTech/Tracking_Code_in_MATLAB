clearvars;
close all;

% read data for vacant network

% load parameter settings(structure )    
settings = Load_Settings();                                                

% Pre-processing of the data of sensing the vacant network
vacantFile_string =  'empty.csv';
[rssEmpty abnormalLink] = Read_Vacant_Data(vacantFile_string, settings);

%'rssEmpty' is a matrix describe the vacant network, 
%'abnormalLink' is to identify unreliable links  
% Here is to add these two terms to the 'setting' structure
settings.rssEmpty = rssEmpty;
settings.abnormalLink = abnormalLink;
  
% create network layout setting
sensor_network = Create_Network(settings);

% process  data, first find the .csv data files with name 'round xxxx.csv'
dataFile_string = 'round';
[output_PF,centerVector] = Alg_Main(sensor_network,dataFile_string,settings);


