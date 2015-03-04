function ind = sub2indV(siz, V)
    % same as sub2ind, except that this function takes a vector input "V"
    % which contains all the subscripts.
    % V can also be a matrix, in which case each *row* is considered a
    % separate set of subscripts
    if isvector(V)
        V = V(:)'; % make row vector
    elseif isamatrix(V)
        sizeV = size(V);
        if ~any(sizeV == length(siz))
            error('incorrect dimensions provided');
        end
        if sizeV(2) ~= length(siz)
            V = V';
        end
        nV = sizeV(1);
    end
        
    % out of bounds checking:
    if any( bsxfun(@gt, V, siz(:)') )        
        error('out of bounds error');        
    end        
    
    D = length(siz);    
    
    if (D == 2) && any(siz == 1)
        ind = prod(double(V), 2);  % ie. since one of them is 1, can just take product to get other one.

    else
        ind = V(:,1);
        for d = 2:D
            ind = ind + (V(:,d)-1) * prod( siz(1:d-1) );
        end
    end
        
end

%     D = length(siz);
%     
%     if (D == 2) && any(siz == 1)
%         ind = prod(V);  % ie. assume that one of them is 1.
% 
%     else
%         ind = V(1);
%         for d = 2:D
%             ind = ind + (V(d)-1) * prod( siz(1:d-1) );
%         end
%     end
