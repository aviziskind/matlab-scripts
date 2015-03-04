function [idx_x, idx_y, polarity, vals] = findLocalExtrema2D_Matlab(mnmxtype, Z, w, reqCorners, circFlag)

    dbug = 0;

    if (nargin < 3) || isempty(w)
        w = 1;
    end

    [nx, ny] = size(Z);
    
    switch mnmxtype 
        case 'min', findMinima = 1; findMaxima = 0;
        case 'max', findMinima = 0; findMaxima = 1;
        case {'', 'minmax', 'maxmin'}, findMinima = 1; findMaxima = 1;
        otherwise, error('unknown')
    end
        
    if dbug
        figure(14); clf;
        imagesc(Z'); axis equal tight xy; hold on;
    end
    
    isExtremum = false(nx,ny);                    
    extremumState = zeros(nx, ny);    
    checkCorners = 0;
    
    % bottom row:
            
    for xi = 1:nx

        atLeftEdge =  xi == 1;
        atRightEdge = xi == nx;
        
        xi_lo = max(xi-w, 1);
        xi_hi = min(xi+w, nx);

        for yi = 1:ny

            dx_lo = sign(diff( Z(xi_lo:xi, yi) ));
            dx_hi = sign(diff( Z(xi:xi_hi, yi) ));

            is_local_max_x = (all( dx_lo ==  1) || atLeftEdge)  ...
                          && (all( dx_hi == -1) || atRightEdge);

            is_local_min_x = (all( dx_lo == -1) || atLeftEdge)  ...
                          && (all( dx_hi ==  1) || atRightEdge);                           
        
            
            atBottomEdge = yi == 1;
            atTopEdge    = yi == ny;
                        
            yi_lo = max(yi-w, 1);
            yi_hi = min(yi+w, ny);

            dy_lo = sign(diff( Z(xi, yi_lo:yi) ));
            dy_hi = sign(diff( Z(xi, yi:yi_hi) ));
                        
            is_local_max_y = (all( dy_lo ==  1) || atBottomEdge)  ...
                          && (all( dy_hi == -1) || atTopEdge);

            is_local_min_y = (all( dy_lo == -1) || atBottomEdge)  ...
                          && (all( dy_hi ==  1) || atTopEdge);                           
            
            is_local_min_xy = is_local_min_x && is_local_min_y;
            is_local_max_xy = is_local_max_x && is_local_max_y;
                      
                        
            if xi == 5 && yi == 11;
%                 A = Z(xi+[-1, 0, 1], yi+[-1, 0, 1])
%                 3;
            end
            
            if findMinima && is_local_min_xy
                if checkCorners                    
                    Z_val = Z(xi, yi);
                    vals = Z(xi_lo:xi_hi, yi_lo:yi_hi);
                    isMin = nnz( (vals(:) <= Z_val) == 1); % just the point itself;                    
                else
                    isMin = true;
                end
                
                if isMin
                    isExtremum(xi, yi) = true;
                    extremumState(xi, yi) = -1;                                
                    if dbug
                        plot(xi, yi, 'wo')
                    end
                end
            end
            if findMaxima && is_local_max_xy
                if checkCorners
                    Z_val = Z(xi, yi);
                    vals = Z(xi_lo:xi_hi, yi_lo:yi_hi);
                    isMax = nnz( (vals(:) >= Z_val) == 1); % just the point itself;                    
                else
                    isMax = true;
                end

                if isMax
                    isExtremum(xi, yi) = true;
                    extremumState(xi, yi) = 1;                                
                    if dbug
                        plot(xi, yi, 'w*')
                    end
                end
            end
            
        end
    end    
               
    [idx_x, idx_y] = find(isExtremum);    
    idx = sub2indV(size(Z), [idx_x(:), idx_y(:)]);
    polarity = extremumState(idx);
    vals = Z(idx);
    
end

% findLocalMaximaOrMinima



%{


    for yi = 1:ny
        for xi = 1:nx

            if xi < nx
                state_x = sign(Z(xi+1, yi)-Z(xi, yi));
            else
                state_x = nan;
            end
                
    %         else        
    %             state_x = sign(Z(i-di)-Z(i));        
    %         end

            if state_x == prevState_x
                count = count + 1;
            else
    %             if state_x == +1
    %             end                
                prevCount = count;
                count = 1;
                locSwitch_x = xi;            
            end
            
            atLeftEdge =  xi == 1;
            atRightEdge = xi == nx;
            closeToLeftEdge = xi < w;
            closeToRightEdge = xi > nx-w+1;
            
            if (xi == 1) && (yi == 11);
                3;
            end

            if ((state_x == searchState) || findMaxAndMin) ...
                    && ((prevCount >= w) || atLeftEdge) ...
                    && ((count == w) || atRightEdge);
                % found a local min in the x-direction - check whether have a local min in y
                % direction.
                
                atBottomEdge = yi == 1;
                atTopEdge = yi == ny;
                yi_lo = max(yi-w, 1);
                yi_hi = min(yi+w, ny);
                
                dy_lo = sign(diff( Z(xi, yi_lo:yi) ));
                dy_hi = sign(diff( Z(xi, yi:yi_hi) ));
                
%                 is_loc_min_y = all( dy_lo == 1) && all( dy_hi == -1);
%                 is_loc_max_y = all( dy_lo == -1) && all( dy_hi == 1);
                                



                if all( all(dy_lo == prevState_x) && all( dy_hi == state_x) ) % have min/max of same polarity as in x direction.
                    isExtremum(locSwitch_x, yi) = true;
                    extremumState(locSwitch_x, yi) = state_x;                                        
                    
                    if state_x == -1
                        plot(locSwitch_x, yi, 'w*')
                    else
                        plot(locSwitch_x, yi, 'wo')
                    end
                end                                
                
            end                    

            prevState_x = state_x;
        end    
    end

%}