function ticksOff(ax)
    if nargin < 1
        ax = gca;
    end
    set(ax, 'xtick', [], 'ytick', [], 'ztick', []);
end