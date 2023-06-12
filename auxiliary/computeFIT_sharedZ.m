function sharedFIThZ = computeFIT_sharedZ( pxyhyhzs )
% Here we compute the PID atom that is subtracted from FIT to obtain cFIT

% Input:
%  joint probability distribution pxyhyhzs where X is past of sender X, Y
%  repressents current values of receiver Y, hY represents past of receiver
%  Y, hZ represents the past of the third region Z and S represents stimulus.
%
% The probability distribution has to have following dimensions in the
% particular order:
% 1: past of X
% 2: present of Y
% 3: past of Y
% 4: past of Z
% 5: stimulus

% In the coming code abbreviations in the names of variables are as
% follows:

% r -> stands for the bracket notation {} 
% X -> past of the sender
% Y -> current of the receiver
% hY -> past of the receiver
% hZ -> past of the third region
% ps -> probability of S - P(S)
% psa -> P(S|A)
% pas -> P(A|S)
% PiR -> denotes information atoms, the Pi notation is used in the Williams and Beer paper (i.e. PiR indicates information atoms)

%% Compute specific surprises from all source variables

specSurpriseX = zeros(size(pxyhyhzs, 5), 1);
specSurpriseY = zeros(size(pxyhyhzs, 5), 1);
specSurprisehY = zeros(size(pxyhyhzs, 5), 1);
specSurprisehZ = zeros(size(pxyhyhzs, 5), 1);

% Compute specific information provided by each source variable about the
% target (William and Beers, 2010 eq. 2)
for s = 1:size(pxyhyhzs, 5)
    
    ps(s) = sum(sum(sum(sum(pxyhyhzs(:, :, :, :, s))))); % probability of S
            
    % {x}
    for x = 1:size(pxyhyhzs, 1)
        psa = sum(sum(sum(sum(pxyhyhzs(x, :, :, :, s))))) / (sum(sum(sum(sum(pxyhyhzs(x, :, :, :, :))))) + eps);
        pas = sum(sum(sum(sum(pxyhyhzs(x, :, :, :, s))))) / (sum(sum(sum(sum(pxyhyhzs(:, :, :, :, s))))) + eps);
        specSurpriseX(s) = specSurpriseX(s) + pas * (log2(1/(ps(s) + eps)) - log2(1/(psa + eps)));
    end
            
    % {y}
    for y = 1:size(pxyhyhzs, 2)
        psa = sum(sum(sum(sum(sum(pxyhyhzs(:, y, :, :, s)))))) / (sum(sum(sum(sum(sum(pxyhyhzs(:, y, :, :, :)))))) + eps);
        pas = sum(sum(sum(sum(sum(pxyhyhzs(:, y, :, :, s)))))) / (sum(sum(sum(sum(sum(pxyhyhzs(:, :, :, :, s)))))) + eps);
        specSurpriseY(s) = specSurpriseY(s) + pas * (log2(1/(ps(s) + eps)) - log2(1/(psa + eps)));
    end
    
    % {hy}
    for hy = 1:size(pxyhyhzs, 3)
        psa = sum(sum(sum(sum(sum(pxyhyhzs(:, :, hy, :, s)))))) / (sum(sum(sum(sum(sum(pxyhyhzs(:, :, hy, :, :)))))) + eps);
        pas = sum(sum(sum(sum(sum(pxyhyhzs(:, :, hy, :, s)))))) / (sum(sum(sum(sum(sum(pxyhyhzs(:, :, :, :, s)))))) + eps);
        specSurprisehY(s) = specSurprisehY(s) + pas * (log2(1/(ps(s) + eps)) - log2(1/(psa + eps)));
    end
    
    % {hz}
    for hz = 1:size(pxyhyhzs, 4)
        psa = sum(sum(sum(sum(sum(pxyhyhzs(:, :, :, hz, s)))))) / (sum(sum(sum(sum(sum(pxyhyhzs(:, :, :, hz, :)))))) + eps);
        pas = sum(sum(sum(sum(sum(pxyhyhzs(:, :, :, hz, s)))))) / (sum(sum(sum(sum(sum(pxyhyhzs(:, :, :, :, s)))))) + eps);
        specSurprisehZ(s) = specSurprisehZ(s) + pas * (log2(1/(ps(s) + eps)) - log2(1/(psa + eps)));
    end
    

end

% Computation of iMin as defined in the WB paper for all nodes in the lattice
iMinrXrYrhYrhZ = 0;
iMinrXrYrhZ = 0;


for s = 1:size(pxyhyhzs, 5)
    % {X}{Y}{hY}{hZ}
    iMinrXrYrhYrhZ = iMinrXrYrhYrhZ + ps(s) * min([specSurpriseX(s) specSurpriseY(s) specSurprisehY(s) specSurprisehZ(s)]);
    
    % {X}{Y}
    iMinrXrYrhZ = iMinrXrYrhZ + ps(s) * min([specSurpriseX(s) specSurpriseY(s) specSurprisehZ(s)]);
end

% PiR term for {X}{Y}{hY} is just its iMin
% The next PiR terms are computed as iMin - sum of all preceding PiR terms
% in the lattice. It has to be computed from below up, of course.

sharedFIThZ = iMinrXrYrhZ - iMinrXrYrhYrhZ;