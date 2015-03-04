function x = randFromDistrib(xEdges, P, sizeVec)
    if nargin < 2
        sizeVec = [1 1];
    end
    
    n = prod(sizeVec);
%     x = zeros(n,1);
    x = zeros(sizeVec);
    
    if length(xEdges) ~= length(P)+1
        error('length(edges) must = length(P) + 1');
    end
    P = P(:)/sum(P);
    cumP = [0; cumsum(P)];
    binWidths = diff(xEdges);
    

    U = rand(n,1);
    
    for i = 1:n
        binId = find(U(i) < cumP, 1)-1;    
        posInBin = (U(i)-cumP(binId)) / P(binId);
        x(i) = xEdges(binId) + binWidths(binId) * posInBin;
    end    
    
%     U = rand(sizeVec);
%     binIds = arrayfun(@(u) find(u < cumP, 1)-1, U);    
%     posInBins = arrayfun(@(u, binId) (u-cumP(binId)) / P(binId), U, binIds);
%     x = arrayfun(@(u,binId,posInBin) xEdges(binId) + binWidths(binId) * posInBin, U, binIds, posInBins);    
    
%     idx = arrayfun(@(u) find(cumP > u, 1), U);    
%     posInBin = arrayfun (@(i, u) cumP(i)-u / P(i), idx, U);
    
%     x = reshape(x, sizeVec);
    
end