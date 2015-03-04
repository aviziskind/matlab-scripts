function ylimAutoLog(h_ax)

    if nargin < 1
        h_ax = gca;
    end
    %%
    ch = get(h_ax, 'children');
    L = []; 
    for i = 1:length(ch)
        yi = get(ch(i), 'yData');
        L = lims( [L; yi(:)]);

    end
    Lr(1) = 10.^( floor( log10(L(1)) ));
    Lr(2) = 10.^( ceil( log10(L(2)) ));

    set(gca, 'ylim', Lr);

end