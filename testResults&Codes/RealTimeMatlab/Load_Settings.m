function [settings] = Load_Settings()

% monitoring area and sensor network
%settings.L = 9; %length of square
settings.Lx = 4;
settings.Ly = 4;

settings.numNodes = 24;
settings.sensor_pos = [0.57,0;1.14,0;1.71,0;2.28,0;2.85,0;3.42,0;4,0.57;4,1.14;4,1.71;4,2.28;4,2.85;4,3.42;3.42,4;2.85,4;2.28,4;1.71,4;1.14,4;0.57,4;0,3.42;0,2.85;0,2.28;0,1.71;0,1.14;0,0.57];%rooftop test position 

settings.human_pos = [1.1,0.5;1.7,0.5;2.3,0.5;2.9,0.5;3.5,1.1;3.5,1.7;3.5,2.3;3.5,2.9;2.9,3.5;2.3,3.5;1.7,3.5;1.1,3.5;0.5,2.9;0.5,2.3;0.5,1.7;0.5,1.1];
% Vacant network data processing 
settings.vacantThreshold = 1; % Threshold to detect those links with high variance, higher than most of other links
settings.vacantSensingTime = 600;%(changed into)10 minutes vacant sensing time.@wudan     % The empty.csv may store more than 1 minutes, but we only use the first 30 seconds of the vacant network sensing data
settings.ignoreLine = 24;   % exclude the first & last (changed into)24 lines.@wudan



% measurement model
settings.sigma_lambda = 0.5;%measurement model sigma lambda
settings.sigma_z = 4; 		%measurement noise
settings.PHI = 2;     		%keep in the range 3 to 5
settings.K = 600;%600     		% Set the time step the algorithm runs,  the algorithm will run for K times 

% object dynamics
settings.Nobj = 1; 			%number of objects predefined
settings.sigmax = 0.2; 		%variance on x-axis
settings.sigmay = 0.2; 		%variance on y-axis
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