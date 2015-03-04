function zeroaxes

    is3d = (length(axis) == 6);

    xlims = xlim;
    ylims = ylim;
    zlims = zlim;
    Lmin = 1000;
    L = max(abs([xlims ylims zlims Lmin]));
    if is3d
        line( [-L 0 0; L, 0 0], [0, -L, 0; 0 L, 0], [0 0 -L; 0 0 L], 'LineStyle', ':', 'Color', 'k'  );
    else
        line( [-L 0; L, 0], [0, -L; 0 L], 'LineStyle', ':', 'Color', 'k'  );
    end    
    xlim(xlims);
    ylim(ylims);
    zlim(zlims);

end