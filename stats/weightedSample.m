function i = weightedSample(weights, nSamples)
    
    if nargin < 2
        nSamples = 1;
    end 

    
    weights = weights/sum(weights);
    cumsumWeights = [cumsum(weights)];    
    
    x_rnd = rand(1, nSamples);
    
    i = binarySearch(cumsumWeights, x_rnd, -1, 1);    
    
end