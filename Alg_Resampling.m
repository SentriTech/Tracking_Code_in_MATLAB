function [indx] = Alg_Resampling(n, w, type)

% This function is to do the particle resampling for particle filter 
% resample n particles from a weighted set with weights w
% type = 'multinomial', 'stratified'
switch type

   case 'multinomial'

       % multinomial resampling using the histc function
       w = w(:)';

       edges = min([0 cumsum(w)],1); % protect against accumulated round-off
       edges(end) = 1; % get the upper edge exact
       [~, indx] = histc(rand(n,1),edges);

   case 'systematic'

       disp('Not implemented yet');

   case 'stratified'

       w = w(:)';

       v = (rand + (0:n-1))/n;

       edges = min([0 cumsum(w)],1); % protect against accumulated round-off
       edges(end) = 1; % get the upper edge exact
       [~, indx] = histc(v,edges);

   case 'residual'

       disp('Not implemented yet');

   otherwise

       disp('Unknown resampling method');

end;