function removeTick(xory, remvalues)
	ax = gca;
    tol = 1e-10;
    ticks  = get(ax, [xory 'Tick']);
 	labels = cellstr(get(ax, [xory 'TickLabel']));

    indsToRemove = [];
    for i = 1:length(remvalues)
        [tmp, ind] = min(abs(ticks - remvalues(i)));
        if tmp < tol
            indsToRemove = [indsToRemove ind]; %#ok<AGROW>
        else
            warning('remTick:valueAlreadyGone',[ xory ' axis does not contain value ' num2str(remvalues(i)) ]);
        end
    end
    ticks(indsToRemove) = [];
    labels(indsToRemove) = [];
    
    set(ax, [xory 'Tick'], ticks);
    set(ax, [xory 'TickLabel'], labels);        
end
