function S = tryLoad(filename, max_nTries, fieldNamesShouldHave)
 
    if nargin < 2 || isempty(max_nTries)
        max_nTries = 3;
    end
    checkFields = nargin >= 3;
    
    try_i = 1;
    S = struct;
    MErr = struct;
    while try_i <= max_nTries  && isempty(fieldnames(S))
        try
            S = load(filename);
            if checkFields
                for fi = 1:length(fieldNamesShouldHave)
                    if ~isfield(S, fieldNamesShouldHave{fi})
                        error( 'MATLAB:load:badLoad', 'Didnt have this field: %s. Tying to load again.', fieldNamesShouldHave{fi});
                    end
                end
                
            end
            
        catch MErr
%             Errs_to_allow = {'MATLAB:load:notBinaryFile', 'MATLAB:load:couldNotReadFile'};
            Errs_to_allow = {'MATLAB:load:notBinaryFile', 'MATLAB:load:badLoad'};
            if any(strcmp(MErr.identifier, Errs_to_allow))
                fprintf('[When loading %s, Got error : %s, trying again in 5 seconds ', filename, MErr.identifier);
                try_i = try_i + 1;
                for i = 1:5
                    pause(1); fprintf('.');
                end
                fprintf(']\n');
                continue;
            else
                rethrow(MErr);
            end
            
        end
         
    end
    
    % couldn't load after NMAX attempts:
    if isempty(fieldnames(S)) &&  isprop(MErr, 'identifier')
        throw(Merr);
    end
    
    
         
end
