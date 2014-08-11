function [particle_s] = Alg_Initialize_Particles(settings)


% Initialize particles with uniform distribution 


nParticles = settings.nParticles;
n_max_targets = settings.Nobj;
xLength = settings.Lx;   %sensor network dimensions
yLength = settings.Ly;

if strcmp(settings.propagation_type,'JSMM')
    particle_s.previousTheta = settings.sigma_theta_init*randn(n_max_targets,nParticles);
    particle_s.previousU = zeros(3*n_max_targets,nParticles);
    particle_s.previousU(3*(0:n_max_targets-1)+1,:) = 1;
end

particles = zeros(nParticles,2*n_max_targets);
for i = 1:n_max_targets
    particles(:,2*i-1) = xLength*rand(nParticles,1);
    particles(:,2*i) = yLength*rand(nParticles,1);
end

particle_s.prev_time_particles = particles;
particle_s.curr_time_particles = particles;

end