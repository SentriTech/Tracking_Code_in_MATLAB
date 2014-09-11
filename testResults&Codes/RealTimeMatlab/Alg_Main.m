function [output_x,centerVector] = Alg_Main(sensor_network,data_file_string,settings)


% Multiple Particle Filtering,this is the main tracking algorithm 

try 
tic;
stream = RandStream('mt19937ar','seed',1);
RandStream.setGlobalStream(stream);

% some constants
Nobj = settings.Nobj;%number of object.@wudan
nParticles = settings.Np_obj;%number of particle.@wudan
settings.nParticles = nParticles;
x_dim = 2*Nobj;
nTime = settings.K;
x = zeros(nTime,nParticles,x_dim);
x_weight = zeros(nTime,nParticles,Nobj);

% particle structure 
%particle_s = initial_particles(object_pos,settings);
particle_s = Alg_Initialize_Particles(settings);
particle_s.prev_particle_weights = (1/nParticles)*ones(nParticles,Nobj);

% remove abnormal links
sensor_network.M = sensor_network.M - length(settings.abnormalLink);
sensor_network.links(settings.abnormalLink,:) = [];
sensor_network.d(settings.abnormalLink) = [];

count_time = 0;
settings.n_count = 0;
settings.startRow = 1;
settings.fileName = '';
figure; grid on; hold on;
plot(sensor_network.sensor_pos(:,1),sensor_network.sensor_pos(:,2),'kx','MarkerSize',15);%plot 24 node in the graph.@wudan

%plot(settings.human_pos(:,1),settings.human_pos(:,2),'k+','MarkerSize',15);%plot 16 human position in the graph.@wudan
%hold on
% propagate the posterior
centerVector = [];%added by wudan September 11th
for iTime = 1:nTime
    count_time = count_time+1;
    disp(iTime);
    [observation settings.n_count settings.fileName settings.startRow] = Read_New_Data(data_file_string,settings);
    observation(settings.abnormalLink,:) = [];

    %particle propagation
    particle_s = Alg_Compute_Dynamic(particle_s,settings);

    % predictive estimates
    yp = ones(1,x_dim);%a_dim equal to 2*N_obj
    for i = 1:Nobj
        yp(2*(i-1)+1:2*(i-1)+2) = particle_s.prev_particle_weights(:,i)'*particle_s.curr_time_particles(:,2*(i-1)+1:2*(i-1)+2);
    end
    % update weights
    for i = 1:Nobj
        y = repmat(yp,nParticles,1);
        y(:,2*(i-1)+1:2*(i-1)+2) = particle_s.curr_time_particles(:,2*(i-1)+1:2*(i-1)+2);
        particle_s.curr_particle_weights(:,i) = Alg_Compute_Likelihood(y,observation,settings,sensor_network); % log likelihoods
    end

    % normalize the weights to sum to one
    particle_s.curr_particle_weights = bsxfun(@minus,particle_s.curr_particle_weights,(max(max(particle_s.curr_particle_weights))));
    particle_s.curr_particle_weights = exp(particle_s.curr_particle_weights);
    particle_s.curr_particle_weights = bsxfun(@rdivide,particle_s.curr_particle_weights,sum(particle_s.curr_particle_weights,1));
	%/\
	%|| @rdivide refers to right array divide.@wudan
	
    % resample particles
    for i = 1:Nobj
        [outIndex] = Alg_Resampling(nParticles,particle_s.curr_particle_weights(:,i),'stratified');
        particle_s.curr_particle_weights(:,i) = (1/nParticles)*ones(nParticles,1);
        particle_s.curr_time_particles(:,2*(i-1)+1:2*(i-1)+2) = particle_s.curr_time_particles(outIndex,2*(i-1)+1:2*(i-1)+2);
        if strcmp(settings.propagation_type,'JSMM')
            particle_s.previousTheta(i,:) = particle_s.thetaThisRound(i,outIndex);
            particle_s.previousU(3*i-2:3*i,:) = particle_s.UThisRound(3*i-2:3*i,outIndex);
        end
    end

    particle_s.prev_time_particles = particle_s.curr_time_particles;
    particle_s.prev_particle_weights = particle_s.curr_particle_weights;

    x(count_time,:,:) = particle_s.curr_time_particles;
    x_weight(count_time,:,:) = particle_s.curr_particle_weights;
    
    % plot target location(the center of praticle.@wudan)
    particle_center = particle_s.curr_particle_weights'*particle_s.curr_time_particles;
    color = ['r' 'b' 'k'];%3 colour to identify 3 object(person).@wudan
    clf; hold on; grid on;
    plot(sensor_network.sensor_pos(:,1),sensor_network.sensor_pos(:,2),'kx','MarkerSize',15);
	hold on
	plot(settings.human_pos(:,1),settings.human_pos(:,2),'b+','MarkerSize',15);%plot 16 human position in the graph.@wudan

	centertemp = [];
    for i = 1:Nobj
        plot(particle_center(2*i-1),particle_center(2*i),'o','color',color(i));
		centertemp = [centertemp,particle_center];
    end
	centerVector = [centerVector;centertemp];
    axis([0 settings.Lx 0 settings.Ly]);
    %pause(0.05);%changed.@wudan
	%pause(0.8);%changed @wudan
    
end % end the for loop of time
%plot(centerVector(:,1),centerVector(:,2),'b+--','MarkerSize',10)
fclose all;
output_x = [];

catch exception
    output_x.exception =  getReport(exception);
    disp(exception.message);
end

end