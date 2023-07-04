function output_vector = eqpop_binning(input_vector, num_bins)
% EQPOP_BINNING Discretizes data into bins of equal population.
%
%   output_vector = EQPOP_BINNING(input_vector, num_bins) returns a vector
%   of bin indices that correspond to each value in input_vector. The bins 
%   are created such that they each contain approximately the same number 
%   of data points.
%
%   input_vector: A vector or array of data to be binned.
%   num_bins:     An integer specifying the number of bins.
%
%   output_vector: A vector indicating which bin each value in input_vector 
%                  belongs to.
%
%   Example:
%       x = randn(1000,1);
%       discrete_x = eqpop_binning(x, 5);
%

probabilities = linspace(0, 1, num_bins + 1);
bin_limits = quantile(input_vector(:), probabilities);
[~,output_vector] = histc(input_vector(:), bin_limits);

end
