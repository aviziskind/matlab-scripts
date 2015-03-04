function tf = between(x, varargin)    
    %{
      call syntax:
        tf = between(X, a, b)   % where x is a vector
        tf = between(x, A, B)   % where a and b are vectors
        tf = between(..., AB)    % where AB = [a, b]
        tf = between(..., boundaryStr)  
                boundaryStr defines whether the boundaries are included in 
                the interval (default: not included) the lower (upper) bound 
                is incluced in the interval if boundaryStr contains a "[" ("]")
    %}    
    error(nargchk(2,4,nargin));
    
    if ischar( varargin{end} )
        boundaryStr = varargin{end};
        varargin = varargin(1:end-1);
        includeLower = ~isempty(strfind(boundaryStr, '['));
        includeUpper = ~isempty(strfind(boundaryStr, ']'));        
    else
        [includeLower, includeUpper] = deal(false);
    end
    lowerOp = iff(includeLower, @le, @lt);
    upperOp = iff(includeUpper, @le, @lt);
    
    switch length(varargin)
        case 1
            a = varargin{1}(:,1);
            b = varargin{1}(:,2);
        case 2
            a = varargin{1};
            b = varargin{2};
    end

    tf = (lowerOp(a, x) & upperOp(x, b));
end
