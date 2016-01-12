function addTick(xory, addvalues, addlabels)
	ax = gca;
    tol = 1e-10;
    if (nargin < 3)
        addlabels = cellfun(@num2str, m2cell(addvalues), 'UniformOutput', false);
    end
    if ischar(addlabels)
        addlabels = {addlabels};
    end
    ticks =  get(ax, [xory 'Tick']);
	labels =  cellstr(get(ax, [xory 'TickLabel']));

    for i = 1:length(addvalues)
        [tmp, ind] = min(abs(ticks - addvalues(i)));
        if (tmp < tol)
            if (nargin < 3) % if didn't supply new labels, then this function doesn't do anything.
                warning('addTick:valueAlreadyPresent',[ xory ' axis already contains value ' num2str(addvalues(i)) ]);
            end
            labels{ind} = addlabels{i};
        else
            ticks = sort([ticks addvalues(i)]);
            ind = find(ticks == addvalues(i), 1);
            labels = {labels{1:ind-1}, addlabels{i}, labels{ind:end}};
        end
    end

    set(ax, [xory 'Tick'], ticks);
    set(ax, [xory 'TickLabel'], labels);        
end
