function displayOptions(allOpts)
    fn = fieldnames(allOpts);
    
    maxL = max(cellfun(@length, fn));
    for i = 1:length(fn)
        fn_i = fn{i};
        
        fn_i_disp = strrep(fn_i, 'tbl_', '');
        
        isMultiple = strncmp(fn_i, 'tbl_', 4);
        opts_i = allOpts.(fn{i});

        if iscell(opts_i) && isempty(opts_i)
            continue;
        end

        if isMultiple && length(opts_i) == 1
            opts_i = opts_i{1};
            isMultiple = 0;
        end
        
        fprintf(['%' num2str(maxL) 's: '], fn_i_disp);

        if isMultiple
            
            subOpts = allOpts.(fn{i});
            fprintf(' (%d) %s \n', 1, tostring(subOpts(1))) 
            for j = 2:length(subOpts)
                fprintf('%s (%d) %s \n', repmat(' ', 1, maxL+2), j, tostring(subOpts(j))) 
            
            end
            
        else
            fprintf(' %s \n', tostring( opts_i ));
        
        end
    
    
    end
    
end

    
