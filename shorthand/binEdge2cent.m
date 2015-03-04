function binCenters = binEdge2cent(binEdges)
    nBins = length(binEdges)-1;
    binEdges = binEdges(:);
    binCenters = mean( [ binEdges(1:nBins), binEdges(2:nBins+1) ],2);    
end