function varargout = varBreakdown(X, fieldnm)
    
%     prevFormat = get(0, 'format');
%     format('long');

    addPct = 1;

    if isempty(X);
        return;
    end

    if isstruct(X)
        if nargin < 2
            error('Need a field name to view breakdown of a struct');
        end
%         try 
%             X = [X.(fieldnm)];
%         catch
            X = {X.(fieldnm)};
%         end
    end
%     if ischar(X)
%         error('varBreakdown is not defined for strings');
%     end
        
    if isnumeric(X) || islogical(X) || ischar(X)
        [uniqueVals, ns] = uniqueCount(X);
        
        ns_num = ns;
        ns = num2cell(ns(:));        
        vals = num2cell(uniqueVals(:));
                
    elseif iscell(X)  % must be a cell array of strings. 
        X = cellfun(@num2str, X, 'un', 0); % just in case some of them not strings, or empty.            
        [uniqueVals, ns] = uniqueCount(X);
        ns_num = ns;
        ns = num2cell(ns(:));
        vals = uniqueVals(:);
        
    end
    
    maxLengthN = ceil( max(log10(ns_num) ) );
    breakdown = [ns, vals];
    fprintf('       N              Values\n');
    fprintf('  ------------    ----------------\n')
    for i = 1:length(ns)
        if ~addPct
            fprintf(' %*d  :  %s \n', maxLengthN, ns{i}, num2str(vals{i})); 
        else
            fprintf(' %*d (%4.1f%%) :  %s \n', maxLengthN, ns{i}, ns{i}/sum(ns_num)*100, num2str(vals{i})); 
        end
    end
  
    error(nargoutchk(0,2,nargout));
    if nargout == 1
        varargout{1} = breakdown;
    elseif nargout == 2
        varargout{1} = [ns{:}]';
        varargout{2} = vals;
    end
%     format(prevFormat);
    
end

%{
candidates:
2272, 5 (could be cleaned up)
2288, 4 (good)
2352, 0 (clean)


%}