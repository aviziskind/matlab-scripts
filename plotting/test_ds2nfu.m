%%

figure(97); clf; 
h = axes;
% axis([1 10, 1 10]); 

doLog = 0;
if doLog
    xlims = [.3, 300];
    ylims = [.1, 100];

    x1 = 2; x2 = 17.7;
    y1 = .2; y2 = 50;
    
else
    xlims = [1, 10];
    ylims = [1, 10];
    x1 = 2; x2 = 4;
    y1 = 3; y2 = 5;
end


plot([x1, x2], [y1, y2], 'ko-');
xlim(xlims);
ylim(ylims);
if doLog

    set(gca, 'xscale', 'log', 'yscale', 'log')
end

pos = [x1, y1, x2-x1, y2-y1];


[x1_nfu, y1_nfu] = ds2nfu(x1,  y1);
[x2_nfu, y2_nfu] = ds2nfu(x2,  y2);

pos_nfu = ds2nfu(pos);


pos_nfu2 = [x1_nfu, y1_nfu, x2_nfu-x1_nfu, y2_nfu-y1_nfu];

annotation('rectangle', pos_nfu, 'linewidth', 2);

annotation('rectangle', pos_nfu2, 'linestyle', ':', 'linewidth', 2, 'color', 'g');

