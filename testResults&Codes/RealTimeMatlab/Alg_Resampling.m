function [indx] = Alg_Resampling(n, w, type)

% This function is to do the particle re-sampling for particle filter 
% re-sample n particles from a weighted set with weights w
% type = 'multinomial', 'stratified'
switch type      %type of resampling.@wudan

   case 'multinomial'

       % multinomial resampling using the histc function
       w = w(:)';

       edges = min([0 cumsum(w)],1); % protect against accumulated round-off
       edges(end) = 1; % get the upper edge exact
       [~, indx] = histc(rand(n,1),edges);

   case 'systematic'

       disp('Not implemented yet');

   case 'stratified'   %current using resampling type

       w = w(:)';

       v = (rand + (0:n-1))/n;
	   
	   %the following statement changed elements that larger than '1' into 1.@wudan
       edges = min([0 cumsum(w)],1); % protect against accumulated round-off(cumulative summary.@wudan)
       edges(end) = 1; % get the upper edge exact
       [~, indx] = histc(v,edges);%counting elements in 'v' within each 'edges' interval.@wudan 

   case 'residual'

       disp('Not implemented yet');

   otherwise

       disp('Unknown resampling method');

end;