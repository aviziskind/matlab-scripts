function h = drawVerticalLine(xvalues, varargin)
%     origYlim = ylim;

    hnd = line(repmat(xvalues(:)', 2,1), repmat(ylim, length(xvalues),1)' );
    set(hnd, 'Color', 'k', varargin{:});
    if nargout == 1
        h = hnd;
    end

%     ylim(origYlim);
end

% line( [-x x], [0 0] );