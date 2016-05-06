function x_lims = lims(X, extend_frac, dim, log_flag)
%{
shorthand for finding the limits (min & max) of a certain set of values.

% example 1: 
>>lims([2 3 4 5 nan 6])
ans =
     2
     6  

Optionally, you can "extend" the range on both sides by supplying a non-empty (and 
non-zero) second argument (eg: to extend by 10%, give a second argument of
0.1. You can also contract the range by supplying a negative 

% example 1: 
>>lims([2 3 4 5 nan 6])
ans =
     2
     6  


% If you extend (or contract) the range, you can extend/contract it on a logarithmic scale instead
of a linear scale (the default), by supplying a non-empty 4th argument

%}
    if isempty(X)
%         x_lims = [0, 1];
        x_lims = [];
        return;
    end

    if (nargin >= 3) && ~isempty(dim)
        x_min = min(X, [], dim);
        x_max = max(X, [], dim);        
    else
        x_min = min(X(~isinf(X))); 
        x_max = max(X(~isinf(X)));
        dim = 1;
    end
    x_lims = cat(dim, x_min, x_max);    
    
    if exist('extend_frac', 'var') && ~isempty(extend_frac)
        if (min(extend_frac) < -.5)
            error('fractional extension must be greater than -0.5 (-50%), otherwise the length becomes negative');
        end
        
        logScale = exist('log_flag', 'var') && (isequal(log_flag, 1) || isequal(log_flag, 'log'));
        
        if length(extend_frac) == 1
            extend_frac = extend_frac * [-1, 1];
        elseif length(extend_frac) == 2
            extend_frac = [-extend_frac(1), extend_frac(2)];
        else
            error('Length of extend_frac must be 1 or 2');
        end
        extend_frac_vec = cat(dim, extend_frac(1), extend_frac(2));

        if ~logScale  % linear scaling
            x_lims = x_lims + bsxfun(@times, diff(x_lims, [], dim), extend_frac_vec); %cat(dim, -1, 1)*(extend_frac));        
        
        else % logarithmic scaling
            if x_lims(1) <= 0 
                error('lower limit must be positive for logarithmic scaling');
            end
            
            x_lims_log = log(x_lims);
            x_lims_log = x_lims_log + bsxfun(@times, diff(x_lims_log, [], dim), extend_frac_vec); %cat(dim, -1, 1)*(extend_frac));                    
            x_lims = exp(x_lims_log);            
            
        end
            
            
    end
    
    if diff(x_lims) == 0 && exist('extend_frac', 'var') && ~isequal(extend_frac, [0, 0])
        x_lims = x_lims + 1e-3*[-1; 1];
    end

end