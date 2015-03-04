function inds = subplotInds(m,n,UL, LR)
    
    [r1, c1] = deal(UL(1), UL(2));
    [r2, c2] = deal(LR(1), LR(2));
    
    allI = reshape([1:m*n], n,m)';
    inds = allI([r1:r2], [c1:c2]);
    inds = inds(:);
    
    
%     nRows = r2-r1+1;
%     nCols = c2-c1+1;
%     
%     inds = zeros(nCols, nRows);
%     for ri = 1:nRows
%         inds(ri,:) = 
%         
%         
%     end
    
    
    
    
end