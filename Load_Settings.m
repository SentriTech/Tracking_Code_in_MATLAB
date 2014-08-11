function [settings] = Load_Settings()

% monitoring area and sensor network
%settings.L = 9; %length of square
settings.Lx = 3.24;
settings.Ly = 4.14;

settings.numNodes = 24;
settings.sensor_pos = [0 0.16;0 0.69;0 1.22;0 2.15;0 2.68;0 3.21;0 3.74;0 4.14;0.6 4.14;1.19 4.14;1.79 4.14;2.39 4.14;2.94 4.14;3.24 3.52;3.24 2.97;3.24 2.42;3.24 1.88;3.24 1.34;3.24 0.79;3.24 0.24;2.41 0;1.81 0;1.21 0;0.6 0];


% Vacant network data processing 
settings.vacantThreshold = 1; % Threshold to detect those links with high variance, higher than most of other links
settings.vacantSensingTime = 600;%(changed into)10 minutes vacant sensing time.@wudan     % The empty.csv may store more than 1 minutes, but we only use the first 30 seconds of the vacant network sensing data
settings.ignoreLine = 24;   % exclude the first & last (changed into)24 lines.@wudan



% measurement model
settings.sigma_lambda = 0.2;%measurement model sigma lambda
settings.sigma_z = 2; 		%measurement noise('increasing' noise into 4 seems to make the result better)
settings.PHI = 4;     		%keep in the range 3 to 5
settings.K = 350;     		% Set the time step the algorithm runs,  the algorithm will run for K times 

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
settings.Np_obj = 500; %number of particles per 'object'
settings.N_resample = 7; %threshold for resampling

% MCMC filter settings
settings.N_burn = 500;
settings.N_thin = 3;

% simulation settings
settings.TRACKING_PLOT = 0; % display plot at every iteration

% error settings
settings.p = 2;

end