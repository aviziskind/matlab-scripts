function h = updateHGFunction(plotFunc, h, syntaxes, varargin)
%     h_out = updatePlotFunction(plotFunc, h, syntaxes, {args / argPairs})
%     h_out = updatePlotFunction(plotFunc, h, )
%     h_out = updatePlotFunction(plotFunc, h, {everyTimeArgs}, {firstTimeArgs})

    firstTime = isempty(h) || all(h == 0) || all(~ishandle(h));

    % syntaxes allows 
    if firstTime
        h = plotFunc(varargin{:});
        
    else
        if nargin > 3 && ~isempty(syntaxes)
            args = parseCompactArgsToExplicit(varargin, syntaxes);
        else
            args = varargin;
        end
        set(h, args{:})
    end
        
end


function varginExpl = parseCompactArgsToExplicit(vargin, syntaxes)
    % eg: {x,y,'Txt'} --> {'x', x, 'y', y, 'String', 'Txt};
    varginExpl = vargin;
    
    nSyntaxes = size(syntaxes, 1);

    for syn_i = 1:nSyntaxes
        isSyntaxI = 1;
        nSyntaxArgs = length(syntaxes{syn_i,1});
        for arg_j = 1:nSyntaxArgs
            if checkIfIs(syntaxes{syn_i}{arg_j}, vargin{arg_j})
                continue;
            else
                isSyntaxI = 0;
                break;
            end
        end        
        isSyntaxI = isSyntaxI && (arg_j == nSyntaxArgs); % managed to compare all syntax arg types with actual args, and all checked out
                
        if isSyntaxI
            break;
        end
    end
    
    if isSyntaxI
        syntaxFmt = syntaxes{syn_i,2};
        if iscell(syntaxFmt)  % eg : {'x', 'y', 'String'}
        
            varginExpl = [cell(1,nSyntaxArgs*2), vargin(nSyntaxArgs+1:end)];
            for arg_j = 1:nSyntaxArgs
                varginExpl{2*arg_j-1} = syntaxFmt{arg_j};
                varginExpl{2*arg_j}   = vargin{arg_j};
            end
            
        elseif strcmp(class(syntaxFmt), 'function_handle');  % eg : @(x,y,str) ...
            varginExpl = [syntaxFmt(vargin{1:nSyntaxArgs}), vargin(nSyntaxArgs+1:end)];
            
        end
            
    end
    
            
    
end



function tf = checkIfIs(argTypeStr, arg)
    switch argTypeStr
        case 'numeric', tf = isnumeric(arg);
        case 'integer', tf = isinteger(arg);
        case 'char', tf = ischar(arg);
        case 'cellstr', tf = iscellstr(arg);
        otherwise, error('Unknown arg type check');
    end
    %             f = str2func( ['is' syntaxes(syn_i,arg_j)])
    
end
    


%     firstTimeArgs = {};
%     if iscell(varargin{1}) 
%         everyTimeArgs = varargin{1};
%         if (length(varargin) > 1) && firstTime
%             firstTimeArgs = varargin{2};
%         end
%     else
%         everyTimeArgs = varargin;
%     end
%     
%     if firstTime
%         h = plotFunc(firstTimeArgs{:}, everyTimeArgs{:});        
%     else
%         set(h, everyTimeArgs{:})
%     end
%     if nargout > 0
%         h_out = h;
%     end        

