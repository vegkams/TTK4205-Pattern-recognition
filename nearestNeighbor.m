function [ class ] = nearestNeighbor( x, Training_set )
%NEARESTNEIGHBOR Tildeler klasse basert på nærmeste nabo i treningssettet
% Initialize distance as infinity
distance = inf;
index = 0;
for i = 1:size(Training_set)
    if norm(x - Training_set(i,2:end)) < distance
        distance = norm(x - Training_set(i,2:end));
        %fprintf('Distance iteration %d \n', i);
        %disp(distance);
        index = i;
    end
end
class = Training_set(index,1);
end

