function X_jack_C = jackknifeAverageTrials(X, dimTrials)
    persistent jackSelectIdxs_C

    if isempty(jackSelectIdxs_C)
        jackSelectIdxs_C = {};
    end

    if nargin < 2
        dimTrials = 1;
    end
    
    nTrials = size(X, dimTrials);
%     assert(isvector(X));
    
%     if nargin < 2
%         dimSelect = find(size(X)>1, 1);
%     end
%             
    if length(jackSelectIdxs_C) < nTrials || isempty(jackSelectIdxs_C{nTrials})
        %%
        idxs_n = [1:nTrials]';
        idxs_n = idxs_n(:, ones(1,nTrials));
        idxs_n = reshape( idxs_n(eye(nTrials) == 0), [nTrials-1, nTrials]); % remove diagonal.
%         jackSelectIdxs{nTrials} = idxs_n;
        
        jackSelectIdxs_C{nTrials} = mat2cell(idxs_n, nTrials-1, ones(1, nTrials));
        
%         idxs_n
        
    end    
%     idxsSelect = jackSelectIdxs{nTrials};
    idxsSelect_C = jackSelectIdxs_C{nTrials};
    assert(dimTrials <= 3);
    
    if dimTrials == 1
        X_jack_C = cellfun(@(trial_idxs) mean(X(trial_idxs, :, :),1), idxsSelect_C, 'un', 0);
    elseif dimTrials == 2
        X_jack_C = cellfun(@(trial_idxs) mean(X(:, trial_idxs, :),2), idxsSelect_C, 'un', 0);
    elseif dimTrials == 3
        3;
        X_jack_C = cellfun(@(trial_idxs) mean(X(:, :, trial_idxs),3), idxsSelect_C, 'un', 0);
        
    end
    

    3;
end