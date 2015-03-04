function results = iterateOverValues(coreFunction, valueSets, nTrials)
    % the results can be plotted using plotAllResults

    if nargin < 3
        nTrials = 1;
    end

    nSets = length(valueSets);
    nsInEachSet = cellfun(@length, valueSets);    
    nIterationsPerTrial = prod(nsInEachSet);
    
    if (length(nsInEachSet) == 1) && (nTrials == 1)
        dimInit = [nsInEachSet(:)', 1];
    else
        dimInit = [nsInEachSet(:)', nTrials];
    end
    
    progressBar('init-', nTrials * nIterationsPerTrial, 100);
    % find out what kind of output the function gives:
    args = cell(1,nSets);
    inds1 = ind2subV(nsInEachSet, 1);        
    for j = 1:nSets
        args{j} = valueSets{j}(inds1(j));
    end
    ans1 = coreFunction( args{:} );
    progressBar;
    
    if isscalar(ans1)
        results = zeros(dimInit);
        results(1) = ans1;
    elseif isvector(ans1)
        results = cell(dimInit);
        results{1} = ans1(:)'; % put in data as a row vector;
    elseif isamatrix(ans1)
        error('Matrix outputs not supported yet');
    end
%     startAt = 2; % for the first trial, start at 2, because already have the first result.    
    startAt = 9063940;
    % Do the rest of the iterations
    for trial_i = 1:nTrials
        for iteration_i = startAt:nIterationsPerTrial
            argInds = ind2subV(nsInEachSet, iteration_i);        
            for j = 1:nSets
                args{j} = valueSets{j}(argInds(j));
            end
            r = coreFunction( args{:} );
            progressBar( (trial_i-1)*nIterationsPerTrial + iteration_i );
            idx = (trial_i-1)*nIterationsPerTrial + iteration_i;
            if (iscell(results))
                results{idx} = r(:)'; % row vector
            else
                results(idx) = r;
            end
        end
        startAt = 1;         
    end

end


% args2 = cellfun(@(x,y) x(y), valueSets, m2cell( inds' ), 'Un', false);