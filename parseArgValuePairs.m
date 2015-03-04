function varargout=parseArgValuePairs(allParamNames,defaultVals,varargin)

    varargout = defaultVals;   

    % Initialize some variables
    % nparams = length(allParamNames);

    nArgs = length(varargin);

    % Must have name/value pairs
    if mod(nArgs,2)~=0
        error('Wrong number of arguments.');
    end
        
    % Process name/value pairs
    for arg_idx=1:2:nArgs
        paramName = varargin{arg_idx};
        if ~ischar(paramName)
            error('Parameter name must be text.');
        end
        param_idx = find(strcmpi(paramName,allParamNames));
        if isempty(param_idx)
            error('Invalid parameter name:  %s.',paramName);
        elseif length(param_idx)>1
            error('Parameter %s is defined multiple times', paramName);
        else
            varargout{param_idx} = varargin{arg_idx+1};
        end
    end
end
