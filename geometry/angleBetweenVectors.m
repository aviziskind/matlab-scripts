function angles = angleBetweenVectors(A, B)
    % for 2 inputs: A and B represent (the end points of) two vectors (or columns of vectors).
    % This function returns the angle(s) between the lines drawn from the *origin* to
    % the (sets of) vectors.

    if size(A) ~= size(B)
		angles = bsxfun(@angleBetweenVectors, A, B);
        return;
%         sa = size(A,2); sb = size(B,2);
%         if sa < sb
%             A = repmat(A, 1, sb/sa);
%         else
%             B = repmat(B, 1, sa/sb);
%         end
    end

    aLen = normV(A,1); 
    bLen = normV(B,1);
    ab = aLen .* bLen + (aLen .* bLen ==0)*1;

    cosAngles = dot(A,B, 1) ./ (ab);
    
    cosAngles(cosAngles < -1) = -1;
    cosAngles(cosAngles > 1)  = 1;

    angles = acos(cosAngles);
    
    
end
