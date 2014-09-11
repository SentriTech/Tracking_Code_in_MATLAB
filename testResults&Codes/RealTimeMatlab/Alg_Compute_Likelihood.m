function sum_log_likelihood = Alg_Compute_Likelihood(x,z,settings,sensor_network)


% compute the log likelihood of the observation, it is from the measurement
% model,  which compares the predicted data computed by algorithm and the
% observation data from wireless sensor networks, and get the likelihood
% for every particle points, assign weights to each particle points, those
% with higher weights will contributes more to the final estimated locations

nParticles = size(x,1);
sigma_measurement = settings.sigma_z;%measurement noise.@wudan
phi_true = settings.PHI;%???.@wudan
sigma_lambda = settings.sigma_lambda;
n_max_targets = settings.Nobj;
linkNum = sensor_network.M;
linksDistances = sensor_network.d;

attenuation = zeros(linkNum,nParticles,n_max_targets);
s1_location = sensor_network.sensor_pos(sensor_network.links(:,1),:);%one node of every link
s2_location = sensor_network.sensor_pos(sensor_network.links(:,2),:);%another node of every link.@wudan

for i = 1:n_max_targets
    x_location = x(:,2*(i-1)+1:2*(i-1)+2);

    %diff1 = s1_location(:,1) - x_location(1);
    %diff2 = s1_location(:,2) - x_location(2);
    diff1 = bsxfun(@minus,s1_location(:,1),x_location(:,1)');
    diff2 = bsxfun(@minus,s1_location(:,2),x_location(:,2)');
    distance1 = sqrt(diff1.^2 + diff2.^2);

    %diff1 = s2_location(:,1) - x_location(1);
    %diff2 = s2_location(:,2) - x_location(2);
    diff1 = bsxfun(@minus,s2_location(:,1),x_location(:,1)');
    diff2 = bsxfun(@minus,s2_location(:,2),x_location(:,2)');
    distance2 = sqrt(diff1.^2 + diff2.^2);

    %lambdaVector = distance1 + distance2 - linksDistances;
    lambdaVector = bsxfun(@minus,distance1+distance2,linksDistances);
    % sigma lambda and phi term change
    attenuation(:,:,i) = phi_true*exp(-lambdaVector./(2*sigma_lambda));
end
z_calculated = sum(attenuation,3);%???.@wudan

sigma_const = -0.5*linkNum*log(2*pi*sigma_measurement^2);
%log_likelihood = -((z-z_calculated).^2)/(2*sigma_measurement^2);
%sum_log_likelihood = sigma_const + sum(log_likelihood);
log_likelihood = -(bsxfun(@minus,z,z_calculated).^2)/(2*sigma_measurement^2);
sum_log_likelihood = sigma_const + sum(log_likelihood,1)';

end