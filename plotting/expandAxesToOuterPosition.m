function expandAxesToOuterPosition(ax)

    op = get(ax, 'outerposition');
    p = get(ax, 'position');
    t_abs = get(ax, 'tightInset');
    M = [-1,0,0,0;
         0,-1,0,0;
         1,0,1,0;
         0,1,0,1];
    t_rel = (M*t_abs')';

    new_pos = op-t_rel;
    % annotation('rectangle', get(ax, 'outerPosition'), 'color', 'y')
    % annotation('rectangle', p, 'color', 'g')
    % annotation('rectangle', pt2, 'color', 'r')
    % annotation('rectangle', pt3, 'color', 'k')
    set(ax, 'position', new_pos)

end