function result = probabilityDist5(X, Y, hY, hZ, stim)
%Compute probability distribution among all
%combinations of pastX(i), pastZ(i), Y(i), pastY(i), stimulus(i)

assert(min(X) > 0, 'The pastX has invalid values');
assert(min(Y) > 0, 'The Y has invalid values');
assert(min(hY) > 0, 'The pastY has invalid values');
assert(min(hZ) > 0, 'The pastY has invalid values');
assert(min(stim) > 0, 'The stimulus has invalid values');

count = length(X);

pxyhyhzs = accumarray([X; Y; hY; hZ; stim]', 1, [max(X) max(Y) max(hY) max(hZ) max(stim)]) / count;

result = pxyhyhzs;
end

