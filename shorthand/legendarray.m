function s = legendarray(varargin)

%     s = legendarray(values)
%     s = legendarray(prestring, values)
%     s = legendarray(prestring, values, poststring)
%     s = legendarray(prestring, values, fmt, poststring)
    error(nargchk(1,4,nargin));
    switch nargin
        case 1, [prestring, values, fmt, poststring] = deal('', varargin{1}, [], '');
        case 2, [prestring, values, fmt, poststring] = deal(varargin{1:2},   [], '');  
        case 3, [prestring, values, fmt, poststring] = deal(varargin{1:2},   [], varargin{3});  
        case 4, [prestring, values, fmt, poststring] = deal(varargin{1:4});  
    end
            
    n = length(values);
    if ~iscell(values)
        values_cell = num2cell(values);
    else
        values_cell = values;
    end
    convertToString = isnumeric(values_cell{1});
    
    if convertToString
        if (nargin < 3) || isempty(fmt)
            if all(values == round(values))
                fmt = '%d';
            elseif all(10*values == round(10*values))
                fmt = '%.1f';               
            else
                fmt = '%.2f';                               
            end
            
        end
    
        values_cell = cellfun(@(v) num2str(v, fmt), values_cell(:), 'un', 0);
    else
        values_cell = values_cell(:);
    end
    
    prestrings_c  = repmat({prestring},  n, 1);
    poststrings_c = repmat({poststring}, n, 1);
    s = cellfun(@(pre, v, post) [pre v post], prestrings_c, values_cell, poststrings_c, 'un', 0);
    
%     s = mat2cell(s, ones(1,n), size(s,2));
end



