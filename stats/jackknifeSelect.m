function X_jack = jackknifeSelect(X)
    persistent jackSelectIdxs

    if isempty(jackSelectIdxs)
        jackSelectIdxs = {};
    end

    assert(isvector(X));
    
    if nargin < 2
        dimSelect = find(size(X)>1, 1);
    end
    
    n = size(X, dimSelect);
        
    if length(jackSelectIdxs) < n || isempty(jackSelectIdxs{n})
        %%
        idxs_n = [1:n]';
        idxs_n = idxs_n(:, ones(1,n));
        idxs_n = reshape( idxs_n(eye(n) == 0), [n-1, n]); % remove diagonal.
        jackSelectIdxs{n} = idxs_n;
%         idxs_n
        
    end    
    idxsSelect = jackSelectIdxs{n};
    
%     sz = size(X);
%     
%     
%     if dimSelect == 1
    X_jack = X(idxsSelect);

%     elseif dimSelect == 2
%         X_jack = X(idxsSelect);
%     
%     
%     end

    3;
end