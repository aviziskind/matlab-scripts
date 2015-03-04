function S = tryLoad(filename, max_nTries)
 
    if nargin < 2
      max_nTries = 3;
    end
    
    try_i = 1;
    S = struct;
    MErr = struct;
    while try_i <= max_nTries  && isempty(fieldnames(S))
        try
            S = load(filename);
        catch MErr
%             Errs_to_allow = {'MATLAB:load:notBinaryFile', 'MATLAB:load:couldNotReadFile'};
            Errs_to_allow = {'MATLAB:load:notBinaryFile'};
            if any(strcmp(MErr.identifier, Errs_to_allow))
                fprintf('[When loading %s, Got error : %s, trying again...]\n', filename, MErr.identifier);
                try_i = try_i + 1;
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
