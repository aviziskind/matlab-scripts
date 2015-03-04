function se = jackknifeStdErr(x_jacks, x_mean, varargin)
    M = length(x_jacks);
    
    isCircDist = 0;
    isLogRatio = 0;
    
    if nargin >= 3 
        switch varargin{1}
            case 'log', 
                isLogRatio = true;
            case 'circ', 
                isCircDist = true;
                circDistMax = varargin{2};
        end
    end
    
%     if isLogRatio
%         x_jacks_orig = x_jacks;
%         x_mean_orig = x_mean;
%         x_jacks = log2(x_jacks);
%         x_mean = log2(x_mean);
%     end
    
    if isCircDist
        allDifferences = circDist(x_jacks, x_mean, circDistMax);
    elseif isLogRatio
        allDifferences = abs(log2(x_jacks / x_mean));
    else
        allDifferences = x_jacks - x_mean;
    end
    
        
    se = sqrt( ((M-1)/M) * sum( (allDifferences).^2 ) );
    
%     if isLogRatio
%         se = 2.^(se);
%     end
    
end
