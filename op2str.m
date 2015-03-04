function s = op2str(op, flag)
    if nargin == 1
        outputFormat = 'Matlab';  % for Matlab usage
    elseif nargin > 1 && strcmpi(flag, 'SQL')
        outputFormat = 'SQL';    % for use with SQL queries
    end

    str = func2str(op);
    switch str
        case 'gt'
            s = '>';
        case 'lt'
            s = '<';
        case 'ge'
            s = '>=';
        case 'le'
            s = '<=';
        case 'eq'
            if strcmp(outputFormat, 'Matlab');
                s = '==';
            elseif strcmp(outputFormat, 'SQL');
                s = '=';
            end
        case 'ne'
            if strcmp(outputFormat, 'Matlab');
                s = '~=';
            elseif strcmp(outputFormat, 'SQL');
                s = '<>';  %  (or  '!=')
            end
        otherwise
            error('Unknown operation to convert to string');
    end
            
end