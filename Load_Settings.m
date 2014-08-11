function [settings] = Load_Settings()

% monitoring area and sensor network
%settings.L = 9; %length of square
settings.Lx = 4.7;
settings.Ly = 2.4;

settings.numNodes = 24;
settings.sensor_pos = [0 0; 1 0; 1.76 0; 2.66 0; 3.26 0; 4.01 0; 4.66 0; 4.66 0.88; 4.66 1.28; 4.66 1.68; 4.66 2.03; 4.66 2.38; 4.01 2.38; 3.36 2.38; 2.81 2.38; 2.36 2.38; 1.91 2.38; 1.41 2.38; 0.96 2.38; 0 2.38; 0 1.9; 0 1.3; 0 0.8; 0 0.4];



% Vacant network data processing 
settings.vacantThreshold = 1;    % Threshold to detect those links with high variance, higher than most of other links
settings.vacantSensingTime = 30; % The empty.csv may store more than 1 minutes, but we only use the first 30 seconds of the vacant network sensing data
settings.ignoreLine = 30;                                                                     % exclude the first & last 30 lines



% measurement model
settings.sigma_lambda = 0.2; %measurement model sigma lambda
settings.sigma_z = 2; %measurement noise
settings.PHI = 4;     %keep in the range 3 to 5
settings.K = 350;      % Set the time step the algorithm runs,  the algorithm will run for K times 

% object dynamics
settings.Nobj = 2; %number of objects predefined
settings.sigmax = 0.1; %variance on x-axis
settings.sigmay = 0.1; %variance on y-axis
settings.sigma_theta = sqrt(0.001);
settings.sigma_theta_init = 0.1;
settings.sigma_prior = 1;
settings.P = [0.75 0.65 0.65; 0.125 0.3 0.05; 0.125 0.05 0.3];
settings.C = [0 0.1 -0.1];
settings.m = 0.05;

settings.propagation_type = 'RW';
%settings.propagation_type = 'JSMM';

% particle filter settings
settings.Np_obj = 500; %number of particles per object
settings.N_resample = 7; %threshold for resampling

% MCMC filter settings
settings.N_burn = 1000;
settings.N_thin = 3;

% simulation settings
settings.TRACKING_PLOT = 0; % display plot at every iteration

% error settings
settings.p = 2;

end
