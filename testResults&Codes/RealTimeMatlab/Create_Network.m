function [sensor_network] = Create_Network(settings)

% Use the defined setting to establish the structure 'sensor_network',
% which defines the sensor level setting


% Constants
N = settings.numNodes;
M = (N*(N-1))/2; %num_links()

% sensor locations
sensor_pos = settings.sensor_pos;

% Links
links = [];
for ii = 1 : N
    for jj = ii+1:N
        links = [links;ii,jj];
    end;
end;

d = zeros(M,1);
for ii = 1 : M
    s1_pos = sensor_pos(links(ii,1),:);
    s2_pos = sensor_pos(links(ii,2),:);
    d(ii) = norm(s1_pos - s2_pos);%distance of each link.@wudan
end;

% output structure
sensor_network.N = N; %number of sensors
sensor_network.M = M; %number of links between sensors
sensor_network.sensor_pos = sensor_pos; %position of sensors
sensor_network.links = links; %ID of links between sensors
sensor_network.d = d; %distances between links
