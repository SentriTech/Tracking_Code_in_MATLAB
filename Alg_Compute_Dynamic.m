function [particle_s] = Alg_Compute_Dynamic(particle_s,settings)


% The dynamic model, or transition model, this function is to add a dynamic
% to the particle location, it is like adding a possible location according to the previous estimated location  


Nobj = settings.Nobj;


% Random Walk
if strcmp(settings.propagation_type,'RW')
    sigma_x = settings.sigmax;
    sigma_y = settings.sigmay;
    sigma_xyv = repmat([sigma_x sigma_y],1,Nobj);
    particle_s.curr_time_particles = particle_s.prev_time_particles + bsxfun(@times,sigma_xyv,randn(size(particle_s.prev_time_particles)));
end

particle_s.curr_time_particles(particle_s.curr_time_particles<0) = abs(particle_s.curr_time_particles(particle_s.curr_time_particles<0));
for i = 1:Nobj
    particle_s.curr_time_particles(particle_s.curr_time_particles(:,2*i-1)>settings.Lx,2*i-1) = 2*settings.Lx - particle_s.curr_time_particles(particle_s.curr_time_particles(:,2*i-1)>settings.Lx,2*i-1);
    particle_s.curr_time_particles(particle_s.curr_time_particles(:,2*i)>settings.Ly,2*i) = 2*settings.Ly - particle_s.curr_time_particles(particle_s.curr_time_particles(:,2*i)>settings.Ly,2*i);
end



% JSMM,   We don't use it right now
if strcmp(settings.propagation_type,'JSMM')

    previousParticles = particle_s.prev_time_particles';
    previousTheta = particle_s.previousTheta;
    previousU = particle_s.previousU;
    
    
    currentTheta = zeros(size(previousTheta));
    [Nobj nParticles] = size(previousTheta);
    sigma_v = settings.sigmax;
    currentU = zeros(3*Nobj,nParticles);

    for i = 1:Nobj
        %temp_currentU = mnrnd(1,(settings.P*previousU(3*i-2:3*i,:))');
        %currentU(3*i-2:3*i,:) = temp_currentU';

        edges = cumsum(settings.P*previousU(3*i-2:3*i,:)); % protect against accumulated round-off
        draw_sample = rand(1,nParticles);
        for j = 1:nParticles
            if draw_sample(j) < edges(1,j)
                indx = 1;
            else if draw_sample(j) > edges(2,j)
                    indx = 3;
                else
                    indx = 2;
                end
            end
            currentU(3*i-3+indx,j) = 1;
        end

        currentTheta(i,:) = previousTheta(i,:) + settings.C * currentU(3*i-2:3*i,:) + settings.sigma_theta * randn(size(previousTheta(i,:)));

        currentParticles(2*i-1:2*i,:) = previousParticles(2*i-1:2*i,:) + settings.m * [cos(currentTheta(i,:));sin(currentTheta(i,:))] + sigma_v*randn(size(previousParticles(2*i-1:2*i,:)));
    end

    
    particle_s.thetaThisRound = currentTheta;
    particle_s.UThisRound = currentU;
    particle_s.curr_time_particles = currentParticles';
end

end