function Y = alias(X, n2, dim, dontRescaleFlag)
%     showWorking = false;    

    if isvector(X)
        n1 = length(X);
        Y = zeros(1,n2);
    else         
        if ~exist('dim', 'var') || isempty(dim)  
            dim = 1;        
        end    
        sizeX = size(X);
        n1 = size(X,dim);
        sizeY = size(X);
        sizeY(dim) = n2;

        Y = zeros(sizeY);
    end
    
    if exist('dontRescaleFlag', 'var') && ~isempty(dontRescaleFlag)
        rescaleFactor = 1;
    else
        rescaleFactor = n2/n1;
    end        
    
    [orig_idx, orig_idx_frac, nIdxs] = getAliasIdxs(n1, n2);
    
%     if showWorking
%         test1 = zeros(1,n1);
%         for i2 = 1:n2
%             idx = 1:nIdxs(i2);
%             test1(orig_idx{i2}(idx)) = test1(orig_idx{i2}(idx)) + orig_idx_frac{i2}(idx);
%         end
%         assert(abs( sum(test1)-n1) < 1e-10 );
%     end
  
    if isvector(X)
        for i2 = 1:n2
            idx = 1:nIdxs(i2);
            x1_vals = X( orig_idx{i2}(idx)      );
            x1_wgts =    orig_idx_frac{i2}(idx);
            Y(i2) = sum( x1_vals(:) .* x1_wgts(:) ) * rescaleFactor;
        end        
    else
        X_idx = arrayfun(@(n) 1:n, sizeX, 'un', 0);
        Y_idx = arrayfun(@(n) 1:n, sizeY, 'un', 0);
        reshapeDims = ones(1,length(sizeY)); 
        for i2 = 1:n2            
            x2_idx = 1:nIdxs(i2);
            reshapeDims(dim) = nIdxs(i2);
            X_idx{dim} = orig_idx{i2}(x2_idx);
            Y_idx{dim} = i2;
            
            x1_vals = X( X_idx{:} );
            x1_wgts = reshape( orig_idx_frac{i2}(x2_idx), reshapeDims);
            Y( Y_idx{:} ) = sum( bsxfun(@times, x1_vals, x1_wgts), dim) * rescaleFactor;
        end
    end
    
    
end





function [orig_idx, orig_idx_frac, nIdxs] = getAliasIdxs(n1, n2)
    
    orig_idx = cell(1,n2);      orig_idx(:)      = {zeros(1,ceil(n1/n2))};
    orig_idx_frac = cell(1,n2); orig_idx_frac(:) = {zeros(1,ceil(n1/n2))};
    nIdxs = zeros(1,n2);
    
    v1pos = linspace(0,1,n1+1);
    v2pos = linspace(0,1,n2+1);
     
    curId1 = 1;
    curId2 = 1;
    fracOf1Remaining = 1;
    
%     if showWorking 
%         figure(99);  clf; axis([0 1 0 2]);
%         line( [v1pos; v1pos], [ones(1, n1+1)*1;ones(1, n1+1)*2], 'color', 'k');
%         for i = 1:n1
%             h1(i) = text( mean(v1pos(i:i+1)), 1.5, num2str(i), 'hor', 'cent', 'vert', 'mid'); %#ok<*AGROW>
%         end
%         line( [v2pos; v2pos], [ones(1, n2+1)*0;ones(1, n2+1)*1], 'color', 'k');
%         for i = 1:n2
%             h2(i) = text( mean(v2pos(i:i+1)), .5, num2str(i), 'hor', 'cent', 'vert', 'mid');
%         end            
%     end
        
    while (curId1 <= n1) || (curId2 <= n2)
        p1 = v1pos(curId1+1);
        p2 = v2pos(curId2+1);

%         if showWorking 
%             set([h1, h2], 'color', 'k');
%             set([h1(curId1), h2(curId2)], 'color', 'r');
%         end                    

        nIdxs(curId2) = nIdxs(curId2)+1;
        if p1 <= p2
            orig_idx{curId2}(nIdxs(curId2)) = curId1;
            
            orig_idx_frac{curId2}(nIdxs(curId2)) = fracOf1Remaining;
            fracOf1Remaining = 1;
            curId1 = curId1 + 1;            
            
            if p1 == p2
                curId2 = curId2 + 1;
            end
                   
       elseif p2 < p1
           fracOf1AllocatedTo2 = (v2pos(curId2+1)-v1pos(curId1))/(1/n1);
           assert(fracOf1AllocatedTo2 <= 1);
           orig_idx{curId2}(nIdxs(curId2)) = curId1;
           orig_idx_frac{curId2}(nIdxs(curId2)) = fracOf1AllocatedTo2;
           fracOf1Remaining = fracOf1Remaining-fracOf1AllocatedTo2;
           curId2 = curId2 + 1;
        end
       
    end

end

% testAlias
%{

    n1 = randi(100);
    n2 = randi(100);
    x1 = linspace(0,1,n1);
    x2 = linspace(0,1,n2);
    y1 = rand(1,n1);
    y2 = alias(y1, n2, 1);
    figure(1); clf; plot(x1, y1, 'b.-', x2, y2, 'g.-')
    assert( abs( sum(y1)-sum(y2) )  < 1e-10 );

%}