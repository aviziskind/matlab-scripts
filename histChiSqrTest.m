function [p, cstat] = histChiSqrTest(varargin)
    % syntax #1: histChiSqrTest(obsN, expN)
    % syntax #2: histChiSqrTest(allObsVals, expVals, expN)

    testMode = 'chisqr';
%     testMode = 'g-test';
    
    error(nargchk(2,3,nargin));
    switch nargin
        case 2, [obsN, expN] = deal(varargin{:});
            if length(obsN) ~= length(expN)
                error('Observed vector & expected vector must be the same length');
            end
            idx_both0 = obsN == 0 & expN == 0;
            obsN(idx_both0) = [];
            expN(idx_both0) = [];
            
        case 3, [allObsVals, expVals, expN] = deal(varargin{:});
            idx_exp0 = find(expN == 0);
            expVals(idx_exp0) = [];
            expN(idx_exp0) = [];
            
            allObsVals = allObsVals(~isnan(allObsVals));
            [obsVals, obsN_tmp] = uniqueCount(allObsVals);
            [extraObsVals, idx_extra] = setdiff(obsVals, expVals);
            if ~isempty(extraObsVals)
                for i = 1:length(extraObsVals)
                    [discrep, idx_orig] = min( abs( extraObsVals(i) - expVals));
                    if discrep < 1e-3
                        obsVals(idx_extra(i)) = expVals(idx_orig);
                    end
                end
                extraObsVals = setdiff(obsVals, expVals);
                if ~isempty(extraObsVals)                
                    error(['the following observed values were not expected: ' num2str(extraObsVals(:)') ]);
                end
            end

            idx = arrayfun(@(y) find(expVals == y, 1), obsVals);
            obsN = zeros(size(expN));
            obsN(idx) = obsN_tmp;
            assert(length(obsN) == length(expN));
    end


    nbins = length(expN);

    emin = 5;
    if any(expN<emin)
       [expN,obsN] = poolbins(expN,obsN,emin);
       nbins = length(expN);
    end    
    
    
    df = nbins - 1;
    
    % Compute test statistic
    if strcmp(testMode, 'chisqr')
        cstat = sum((obsN-expN).^2 ./ expN);
    elseif strcmp(testMode, 'g-test')
        cstat = 2 * sum( obsN .* log( obsN./expN) );
    end
        
    % Figure out degrees of freedom    

    if df>0
       p = gammainc(cstat/2, df/2, 'upper');  % p = 1 - chi2cdf(cstat,df);
    else
       p = NaN(class(cstat));
    end
    
end



    % -------------------------
    function [expN,obsN,edges] = poolbins(expN,obsN,emin)  %%% copied from chi2gof algorithm from Stats toolbox.
    %POOLBINS Check that expected bin counts are not too small

    % Pool the smallest bin each time, working from the end, but
    % avoid pooling everything into one bin.  We will never pool bins
    % except at either edge (no two internal bins will get pooled together).
    i = 1;
    j = length(expN);
    while(i<j-1 && ...
          (   expN(i)<emin || expN(i+1)<emin ...
           || expN(j)<emin || expN(j-1)<emin))
       if expN(i)<expN(j)
          expN(i+1) = expN(i+1) + expN(i);
          obsN(i+1) = obsN(i+1) + obsN(i);
          i = i+1;
       else
          expN(j-1) = expN(j-1) + expN(j);
          obsN(j-1) = obsN(j-1) + obsN(j);
          j = j-1;
       end
    end      

    % Retain only the pooled bins
    expN = expN(i:j);
    obsN = obsN(i:j);
    % edges(j+1:end-1) = [];  % note j is a bin number, not an edge number
    % edges(2:i) = [];        % same for i

    % Warn if some remaining bins have expected counts too low
    if any(expN<emin)
%        warning('stats:chi2gof:LowCounts',...
%                ['After pooling, some bins still have low expected counts.\n'...
%                 'The chi-square approximation may not be accurate']);
    end
end