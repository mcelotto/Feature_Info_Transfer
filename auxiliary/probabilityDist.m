function result = probabilityDist(pastX, Y, pastY, stimulus)
%Computes probability distribution among all
%combinations of pastX(i), Y(i), pastY(i), stimulus(i)

% input:
% stim = discrete stimulus (1 x trials)
% X = discrete X_past (1 x trials)
% Y = discrete Y_pres (1 x trials)
% hY = discrete Y_past (1 x trials)

assert(min(pastX) > 0, 'The pastX has invalid values');
assert(min(Y) > 0, 'The Y has invalid values');
assert(min(pastY) > 0, 'The pastY has invalid values');
assert(min(stimulus) > 0, 'The stimulus has invalid values');

count = length(pastX);

result = accumarray([pastX; Y; pastY; stimulus]', 1, [max(pastX) max(Y) max(pastY) max(stimulus)]) / count;

end



