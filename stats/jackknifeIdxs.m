function [jackknifeIdxs, segmentIdxs] = jackknifeIdxs(nTrials, nJackSegments)
                
    segmentIdxs   = arrayfun(@(i) find( (mod([1:nTrials]-1, nJackSegments)+1) == i),    1:nJackSegments, 'un', 0); % divide into nJackSegments "segments" 
    
    jackknifeIdxs = arrayfun(@(i) sort( [segmentIdxs{ setdiff(1:nJackSegments, i) }] ), 1:nJackSegments, 'un', 0); % for each jackknife idx group, leave out 1 segment.

end