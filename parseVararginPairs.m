% script: parseVararginPairs
% This routine must be called from within a function in which there are variable input arguments.
% It will then assign the values (in a pairwise fashion) to their
% corresponding variables
% eg. if varargin = {'name1', val1, 'name2', val2}
% this script will create a variable 'name1', with value val1, etc.
% you can detect whether a particular variable name was assigned using
% exist(..., 'var')

    n = length(varargin); %#ok<USENS>
    if (mod(n,2) ~= 0)
        error('must be an even number of variable arguments');
    end
    
    checkPropertyNames = exist('validPropertyNames', 'var');
    for i = 1:2:n
        propertyName  = varargin{i};
        propertyValue = varargin{i+1};
        if checkPropertyNames
            if ~any(strcmp(propertyName, validPropertyNames))
                error(['Invalid property name: ' propertyName]);
            end
        end
        eval([propertyName ' = ' var2str(propertyValue) ';']);
    end
    