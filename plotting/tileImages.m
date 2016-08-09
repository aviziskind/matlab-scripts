function [tiled, imageStack] = tileImages(imageStack, m,n, nBlanks, blankScale, alignment)
    
    if nargin < 6 || isempty(alignment)
        alignment = {'Top', 'Center'}; % top-left
    end
    if iscell(imageStack)
        imageStack = expandImagesInStack(imageStack, alignment);
        imageStack = cat(3, imageStack{:});
    end
    
    nDims = ndims(imageStack);
    if nDims <= 3
        [h,w,nImages] = size(imageStack);
        nPlanes = 1;
        imageStack = reshape(imageStack, [h,w,nPlanes, nImages]);
    elseif nDims == 4
        [h,w,nPlanes,nImages] = size(imageStack);
    end
    
    
    
    if nargin < 2 || isempty(m)
        m = floor(sqrt(nImages));
    end
    if nargin < 3 || isempty(n)
        n = ceil(nImages/m);
    end
    if nargin < 4 || isempty(nBlanks)
        nBlanks = 1;
    end
    if nargin < 5 || isempty(blankScale)
        blankScale = 0.5;
    end
    
    doTranspose = m < 0 || n < 0;
    m = abs(m);
    n = abs(n);

    
    if iscell(blankScale)
        blankValue = blankScale{1};
    else
%%
        Mx = max((imageStack(:)));
        Mn = min((imageStack(:)));
        blankValue = double( Mn + blankScale*(Mx - Mn) );
    end
    
    H = (h+nBlanks)*m + nBlanks;
    W = (w+nBlanks)*n + nBlanks;
    
    if islogical( imageStack), 
        class_use = 'uint8';
    else
        class_use =class(imageStack);
    end
    tiled = zeros(H,W, nPlanes, class_use)+blankValue;
    cur_h = 1;
    cur_w = 1;
    
    fillBy = 'rows';
    if doTranspose
        fillBy = 'columns';
    end
    
    for i = 1:nImages
        if nImages == 26 && i == 25
            if m == 5 && n == 6
                cur_w = cur_w + 2;
            elseif m == 7 && n == 4
                cur_w = cur_w + 1;
            end
        end
        i_top = nBlanks + (cur_h-1)*(h+nBlanks)+1;
        i_left = nBlanks + (cur_w-1)*(w+nBlanks)+1;
        
        tiled( i_top + [0:h-1], i_left + [0:w-1], :) = imageStack(:,:,:,i);
        
        if strcmp(fillBy, 'rows')
        
            cur_w = cur_w + 1;
            if cur_w > n
                cur_w = 1;
                cur_h = cur_h + 1;
            end
        elseif strcmp(fillBy, 'columns')
            cur_h = cur_h + 1;
            if cur_h > m
                cur_h = 1;
                cur_w = cur_w + 1;
            end
            
            
        end
    end
    


end

function C_new = expandImagesInStack(C, alignment)

    allH = cellfun(@(x) size(x, 1), C);
    allW = cellfun(@(x) size(x, 2), C);
    allN = cellfun(@(x) size(x, 3), C);

    W = max(allW);
    
    vert_alignment = lower(alignment{1});
    horiz_alignment = lower(alignment{2});
    n = length(C);
    
    if isnumeric(vert_alignment)
        %%
        tb = bsxfun(@minus, [zeros(1, n); allH], vert_alignment);
        
        distToBottoms = allH - vert_alignment;
        distToTops     = vert_alignment;
        
        maxDistToTop = max(distToTops);
        maxDistToBottom = max(distToBottoms);
        H = max(distToTops) + max(distToBottoms);
        
        tb = tb + maxDistToTop;
        3;
    else
        H = max(allH);
    end
       
    C_new = cell( size(C));
    
    for i = 1:numel(C)
        
        h = allH(i);
        w = allW(i);

        if isnumeric(vert_alignment)
            v_offset = tb(1,i); %(i);
        else
            switch vert_alignment
                case 'top',     v_offset = 0;
                case 'middle',  v_offset = floor((H-h)/2);
                case 'bottom',  v_offset = (H-h);
            end
        end
        m_idxs = [1:h] + v_offset;            
        assert(all(m_idxs <= H))
        
        if isnumeric(horiz_alignment)
            h_offset = horiz_alignment(i);
        else
            switch horiz_alignment
                case 'left',   h_offset = 0;
                case 'center', h_offset = floor( (W-w)/2);
                case 'right',  h_offset = (W-w);

            end
        end            
        n_idxs = [1:w] + h_offset;
        
        C_new{i} = zeros( H, W, allN(i) );
        C_new{i}(m_idxs, n_idxs, :) = C{i};
        
    end
    3;

end