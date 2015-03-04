function y = vectorFuncHandle(func, varargin)
    % for use with a scalar function of multiple variables that needs to accept 
    % input in vector form: F([x1,x2,...; y1, y2, ...; z1, z2, ...]);
    % but some matlab functions may want to call it as F(x, [y1, y2, y3])
    % this function replicates the inputs so the dimensions match, and then
    % gives them to the function in the required vector format
    
    args = varargin;
    L = cellfun(@length, args);
    nVars = length(L);
    maxL = max(L);
    if (maxL > 1)
        for vi = 1:nVars
            if L(vi) == 1
                args{vi} = args{vi}*ones(1,maxL);
            elseif L(vi) ~= maxL
                error('each variable must either have 1 or max(L) elements');
            end        
        end
    end
    X = vertcat(args{:});
    y = func(X);
end
