function [allContours, allLevels] = contourMtx2Cell(C)
%{
    Converts a Contour matrix (output by Matlab's contourc function) into a more usable format: 
    a cell array of cell arrays of matrices (the first output argument, "allContours"):
    Each matrix corresponds to a single contour (each matrix is 2xn: it has the x-coordinates 
    (1st row) and y-coordinates (2nd row) of n points for each contour. All the contours for a
    single "level" are stored together in a cell array, and so the output variable is a cell array 
    with an entry (=a cell array of matrices) for each level.
    Thus, for example
      allContours{1}{2}(:,3)
    would give the position vector (x & y coordinate) of the 3rd point in the 2nd contour of the
    1st level.
    
    The second output argument ("allLevels") is a list of all the Levels found in the contour matrix C
    
    Use with Matlab's contourc function, eg:
        C_mtx = contourc(Z);
        [allContours, allLevels] = contourMtx2Cell(C_mtx)

    Written by Avi Ziskind
    Please send bug reports / comments to :
    avi.ziskind@gmail.com
  
    last updated: May 2012.
%}

    
    Nc = size(C,2);
        
    % (Step 1) Find # of Levels
    i = 1;    
    cur_level = nan;
    nLevels = 0;
    while i < Nc
        c_level = C(1,i);
        Ni = C(2,i);        
        if c_level ~= cur_level
            cur_level = c_level;
            nLevels = nLevels+1;            
        end                 
        i = i+Ni+1;
    end

    % (Step 2) Find actual levels and # of contours for each level
    allLevels = zeros(1,nLevels);
    nContoursPerLevel = ones(1,nLevels);
    
    i = 1;    
    cur_level_idx = 0;
    cur_level = nan;
    while i < Nc
        c_level = C(1,i);
        Ni = C(2,i);                
        if c_level ~= cur_level
            cur_level_idx = cur_level_idx+1;
            cur_level = c_level;
            allLevels(cur_level_idx) = cur_level;
        else
            nContoursPerLevel(cur_level_idx) =  nContoursPerLevel(cur_level_idx)+1;
        end
        i = i+Ni+1;
    end
        
    % (Step 3) Put in the contours in to the cellarray    
    allContours = arrayfun(@(n) cell(1, n), nContoursPerLevel, 'un', 0);
    
    i = 1;    
    cur_level_idx = 0;
    cur_level = nan;
    cur_contour_idx = 0;
    while i < Nc
        c_level = C(1,i);
        Ni = C(2,i);        
        XY = C(:,i+1:i+Ni);
        
        if c_level ~= cur_level
            cur_level_idx = cur_level_idx+1;
            cur_level = c_level;
            cur_contour_idx = 1;
            allContours{cur_level_idx}{cur_contour_idx} = XY;            
            
        else
            cur_contour_idx = cur_contour_idx+1;
            allContours{cur_level_idx}{cur_contour_idx} = XY;
        end
        i = i+Ni+1;
    end   


end