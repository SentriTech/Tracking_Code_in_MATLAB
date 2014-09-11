function [settings] = Load_Settings()

% monitoring area and sensor network
%settings.L = 9; %length of square
%settings.Lx = 3.24;
%settings.Ly = 4.14;
settings.Lx = 4;
settings.Ly = 4;

settings.numNodes = 24;
%adjusted sensor position
settings.sensor_pos = [0.57,0;1.14,0;1.71,0;2.28,0;2.85,0;3.42,0;4,0.57;4,1.14;4,1.71;4,2.28;4,2.85;4,3.42;3.42,4;2.85,4;2.28,4;1.71,4;1.14,4;0.57,4;0,3.42;0,2.85;0,2.28;0,1.71;0,1.14;0,0.57];%rooftop test position 

settings.human_pos = [1.1,0.5;1.7,0.5;2.3,0.5;2.9,0.5;3.5,1.1;3.5,1.7;3.5,2.3;3.5,2.9;2.9,3.5;2.3,3.5;1.7,3.5;1.1,3.5;0.5,2.9;0.5,2.3;0.5,1.7;0.5,1.1];
%2,1;3,1;3,2;3,3;2,3;1,3;1,2];
%settings.human_pos = [1,1;2,1;3,1;3,2;3,3;2,3;1,3;1,2];

%settings.human_pos = [0.65,1.5;1.25,1.5;1.85,1.5;2.45,1.5;2.45,2.05;2.45,2.6;1.85,2.6;1.25,2.6;0.65,2.6;0.65,2.05];%here sets location of different human position point
%settings.human_pos = [2.45,2.6;1.85,2.6;1.25,2.6;0.65,2.6;0.65,2.05];%here sets location of different human position point

% Vacant network data processing 
settings.vacantThreshold = 0.8; % Threshold to detect those links with high variance, higher than most of other links
settings.vacantSensingTime = 300;%(changed into)5 minutes vacant sensing time.@wudan     % The empty.csv may store more than 1 minutes, but we only use the first 30 seconds of the vacant network sensing data
settings.ignoreLine = 0;   % exclude the first & last (changed into)24 lines.@wudan



% measurement model
settings.sigma_lambda = 0.2;%measurement model sigma lambda
settings.sigma_z = 2; 		%measurement noise('increasing' noise into 4 seems to make the result better)
settings.PHI = 4;     		%keep in the range ?
settings.K = 350;     		%Set the time step the algorithm runs,  the algorithm will run for K times 

% object dynamics
settings.Nobj = 1; 			%number of objects predefined
settings.sigmax = 0.5; 		%variance on x-axis.@wudan need to be changed
settings.sigmay = 0.5; 		%variance on y-axis.@wudan need to be changed
settings.sigma_theta = sqrt(0.001);
settings.sigma_theta_init = 0.1;
settings.sigma_prior = 1;
settings.P = [0.75 0.65 0.65; 0.125 0.3 0.05; 0.125 0.05 0.3];%summary along row equal to 1.@wudan
settings.C = [0 0.1 -0.1];
settings.m = 0.05;

settings.propagation_type = 'RW';
%settings.propagation_type = 'JSMM';

% particle filter settings
settings.Np_obj = 1000; %number of particles per 'object'
settings.N_resample = 7; %threshold for resampling

% MCMC filter settings
settings.N_burn = 500;
settings.N_thin = 3;

% simulation settings
settings.TRACKING_PLOT = 0; % display plot at every iteration

% error settings
settings.p = 2;

end