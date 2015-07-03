function tf = strCcmp(cs1, cs2, fullFlag)
    % size(tf) = [1, length(cs1)];
    % is the result of asking: 'which strings in cs1 are present in cs2'?
    % if 'fullFlag' is provided, the full matrix of cs1 x cs2 is returned.

    returnFull = nargin > 2 && ~isempty(fullFlag);

    if ischar(cs1)
        cs1 = {cs1};
    end
    if ischar(cs2)
        cs2 = {cs2};
    end
    
    n1 = length(cs1);
    n2 = length(cs2);
    tf = zeros(n1, n2);    

    for i = 1:n1
        for j = 1:n2
            tf(i,j) = strcmp(cs1{i}, cs2{j});            
        end
    end
    
    if returnFull
        return;
    end
    
    tf = any(tf, 2);    
end


% for i = 1:n1
%     tf2(i,:) = strcmp(cs1{i}, cs2);
% end    
