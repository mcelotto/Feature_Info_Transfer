function SUI = compute_SUI( pxyhys )
% This function compute the SUI Partial Information atom using the I_min 
% redundancy measure (see Williams and Beer (2010) arXiv)
%
% Input:
%  joint probability distribution pxyhys where X is past of sender X, Y
%  repressents current values of receiver Y, hY represents past of receiver
%  Y and S represents stimulus.
%
% The probability distribution has to have following dimensions in the
% particular order:
% 1: past of X
% 2: present of Y
% 3: past of Y
% 4: stimulus

% In the coming code abbreviations in the names of variables are as
% follows:

% r -> stands for the bracket notation {} 
% X -> past of the sender
% Y -> present of the receiver
% hY -> past of the receiver
% ps -> probability of S - P(S)
% psa -> P(S|A)
% pas -> P(A|S)
% PiR -> denotes information atoms, the Pi notation is used in the Williams and Beer paper (i.e. PiR indicates information atoms)

%%
specSurpriseX = zeros(size(pxyhys, 4), 1);
specSurpriseY = zeros(size(pxyhys, 4), 1);
specSurprisehY = zeros(size(pxyhys, 4), 1);

% Compute specific information provided by each source variable about the
% target (William and Beers, 2010 eq. 2)
for s = 1:size(pxyhys, 4)
    ps = sum(sum(sum(pxyhys(:, :, :, s)))); % probability of S
            
    % {x}
    for x = 1:size(pxyhys, 1)
        psa = sum(sum(sum(sum(pxyhys(x, :, :, s))))) / (sum(sum(sum(sum(pxyhys(x, :, :, :))))) + eps);
        pas = sum(sum(sum(sum(pxyhys(x, :, :, s))))) / (sum(sum(sum(sum(pxyhys(:, :, :, s))))) + eps);
        specSurpriseX(s) = specSurpriseX(s) + pas * (log2(1/(ps + eps)) - log2(1/(psa + eps)));
    end
            
    % {y}
    for y = 1:size(pxyhys, 2)
        psa = sum(sum(sum(sum(pxyhys(:, y, :, s))))) / (sum(sum(sum(sum(pxyhys(:, y, :, :))))) + eps);
        pas = sum(sum(sum(sum(pxyhys(:, y, :, s))))) / (sum(sum(sum(sum(pxyhys(:, :, :, s))))) + eps);
        specSurpriseY(s) = specSurpriseY(s) + pas * (log2(1/(ps + eps)) - log2(1/(psa + eps)));
    end
            
    % {hy}
    for hy = 1:size(pxyhys, 3)
        psa = sum(sum(sum(sum(pxyhys(:, :, hy, s))))) / (sum(sum(sum(sum(pxyhys(:, :, hy, :))))) + eps);
        pas = sum(sum(sum(sum(pxyhys(:, :, hy, s))))) / (sum(sum(sum(sum(pxyhys(:, :, :, s))))) + eps);
        specSurprisehY(s) = specSurprisehY(s) + pas * (log2(1/(ps + eps)) - log2(1/(psa + eps)));
    end
end

% Computation of iMin as defined in the Wialliams and Beer paper for the
% two collections of interest
iMinrXrYrhY = 0;
iMinrXrY = 0;

for s = 1:size(pxyhys, 4)
    % {X}{Y}{hY}
    iMinrXrYrhY = iMinrXrYrhY + sum(sum(sum(pxyhys(:, :, :, s)))) * min([specSurpriseX(s) specSurpriseY(s) specSurprisehY(s)]);
    
    % {X}{Y}
    iMinrXrY = iMinrXrY + sum(sum(sum(pxyhys(:, :, :, s)))) * min([specSurpriseX(s) specSurpriseY(s)]);
end

% PiR term for {X}{Y}{hY} is just its iMin
% The next PiR term is computed as iMin - sum of all preceding PiR terms
% in the lattice. It has to be computed from below up, of course.

PiRrXrYrhY = iMinrXrYrhY;
SUI = iMinrXrY - PiRrXrYrhY;

end