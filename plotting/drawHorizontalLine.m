function h = drawHorizontalLine(yvalues, varargin)
%     origXlim = xlim;

    hnd = line(repmat(xlim, length(yvalues),1)', repmat(yvalues(:)', 2,1) );
    set(hnd, 'Color', 'k', varargin{:});
    if nargout == 1
        h = hnd;
    end
    
%     xlim(origXlim); % in case line is out of bounds of original axes;
end

% line( [-100 100], [y y] );
