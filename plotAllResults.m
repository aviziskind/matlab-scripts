function plotAllResults(data, valueSets, valueLabels, plotTypes)
    % Plots the data accumulated in the n-dimensional matrix/cell data.
    % (Currently implemented up to 4 dimensions).
    % the values of the 'axes' of data should be provided in the cell array
    % 'valueSets', and names of the axes in 'valueLabels'. plotTypes
    % indicates how the data are to be plotted. 
    % First, decide whether you want one or two dimensions per axis. (If
    % data is an ND cell array (with multiple values for each 'element'),
    % then you would typically want only 1D, so that all the data in each element
    % will be plotted on its own axis.)
    % Second, decide how you want to arrange the plots, in terms of
    % multiple figures, or multiple subplots within single/multiple
    % figures.
    % Options for plotTypes that are currently implemented include:
    %   {plot1, [plot2]}                  (1-2D)
    %   {plot1, [plot2], 'fig'}           (2-3D)
    %   {plot1, [plot2], 'subfigm,n'}     (2-3D)  [m x n subplots on 1 figure.]
    %   {plot1, [plot2], 'subx', 'suby'}  (3-4D)  [subplots on 1 figure.]
    %   {plot1, [plot2], 'subm,n', 'fig'} (3-4D)  [m x n subplots on multiple figures.]
    %   {plot1, [plot2], 'subx', 'suby', 'fig'} (4-5D)  [2d subplot on multiple figures]
    % where plot1/2 is the function that plots the first 1 or2 dimensions.
    % which can be
    %    'surf', 'mesh', 'bar3' (for 2D graphs)
    %    'plot', 'bar'          (for plotting multiple line graphs on the same axes)
    % if more than one trial was done, provide the number of trials in
    % nTrials, and error bars will be plotted with your data.
    % for examples, see "testIterateAndPlotAll.m"
    
    % determine whether multiple trials were performed.
    nSets = length(valueSets);
    sizeData = size(data);
    nDimsData = length(sizeData);
    if (nDimsData == 2) && (size(data, 2) == 1), 
        nDimsData = 1;
    end
    if nDimsData == nSets+1
        nTrials = sizeData(end);
    elseif nSets == nDimsData
        nTrials = 1;
    else
        error('number of dimensions of data must be equal to number of input axes');
    end
    legendLocation = {'Location', 'NorthWest'};
    
    % determine whether are doing 1 or 2 dimensions per axis.
    VECTOR_INPUT = iscell(data);
    SINGLE = 1;
    DOUBLE = 2;
    if (length(plotTypes) < 2) || any(strncmp( plotTypes{2}, {'fig', 'sub'}, 3));
        mode = SINGLE;
    else % if any (strncmp( plotTypes{3}, {'fig', 'sub'}, 3));        
        mode = DOUBLE;
    end    
    if (mode == DOUBLE) && VECTOR_INPUT;
        error('For vector outputs, you must have only one plot per axis')
    end

    setFigureName = @(s) set(gcf, 'Name', s, 'NumberTitle', 'off');
%     setFigureName = @(s) suptitle_2(s);
    

    function adjustAxes(ax, str)
        switch str
            case 'semilogx', set(ax, 'Xscale', 'log');
            case 'semilogy', set(ax, 'YScale', 'log');
            case 'loglog', set(ax, 'XScale', 'log', 'YScale', 'log');
        end
    end
    
    
    
    function h = plot1D(idxes)  % plot 1 dimension [or 2 dimensions for cell array] on the current axis;
        plotFuncStr = plotTypes{1};
        plotFunc = str2func(plotFuncStr);
        switch plotFuncStr                
            case {'plot', 'semilogx', 'semilogy', 'loglog'}
                if nTrials == 1
                    ydata = squeeze(data(:,idxes{:}));
                    if VECTOR_INPUT
                        ydata = cell2mat(ydata);
                    end
                    h = plotFunc(valueSets{1}, ydata, 'o-');
                    xlabel(valueLabels{1});   
                    if VECTOR_INPUT
                        legend ( valueLabels{2}, legendLocation{:} );
                    end                    
                
                elseif nTrials > 1   %% more than 1 trial
                    ydata = squeeze(data(:, idxes{:}, :));
                    if VECTOR_INPUT
                        dims = size(ydata);
                        ydata = reshape(ydata, [dims(1), 1, dims(2)]); % put trials on 3rd dimension so can unpack cells in dimension 2.
                        ydata = cell2mat(ydata);
                    end
                    d = ndims(ydata);
                    ydata_mean = mean(ydata, d);
                    ydata_std  = std(ydata, 0, d);
                    xdata = repmat(valueSets{1}(:), 1, size(ydata_mean, 2));                    
                    
                    h = errorbar(xdata, ydata_mean, ydata_std, 'o-');
                    adjustAxes(gca, plotFuncStr);
                    xlabel(valueLabels{1});           
                    if VECTOR_INPUT
                        legend ( valueLabels{2}, legendLocation{:} );
                    end
                end
                
        end
    end
    
    
    function h = plot2D(idxes) % plot 2 dimensions on the current axis;
        plotFuncStr = plotTypes{1};
        plotFunc = str2func(plotFuncStr);
        switch plotFuncStr
            case {'surf', 'mesh', 'bar3'}                
                h = plotFunc(valueSets{1}, valueSets{2}, squeeze(data(:,:,idxes{:})) );        
                xlabel(valueLabels{1});
                ylabel(valueLabels{2});
                
            case {'plot', 'bar', 'semilogx', 'semilogy'}
                hold on;
                for j = 1:length(valueSets{2})
                    if nTrials == 1
                        ydata = data(:,j,idxes{:});
                        h = plotFunc(valueSets{1}, ydata, [color(j) 'o-']);
                    elseif nTrials > 1
                        ydata = squeeze(data(:,j, idxes{:}, :));
                        d = ndims(ydata);
                        ydata_mean = mean(ydata, d);
                        ydata_std  = std(ydata, 0, d);
                        xdata = valueSets{1}(:);
                    
                        h = errorbar(xdata, ydata_mean, ydata_std, [color(j) 'o-']);
                        adjustAxes(gca, plotFuncStr)
                    end                        
                end   
                xlabel(valueLabels{1});
                legend ( legendarray([valueLabels{2} '='], valueSets{2}), legendLocation{:}  );
        end
    end
        

    function plotFigs1D(ind, plotfunc)
        % typically     ind      = 2       (SINGLE) or  3      (DOUBLE)
        % and           plotfunc = @plot2D (SINGLE) or @plot1D (DOUBLE)
        n = length(valueSets{ind});
        hs = zeros(1,n);
        plotType = plotTypes{ind};
        if strcmp(plotType, 'fig')            
            for fig_i = 1:length(valueSets{ind})
                figure(fig_i);
                h = plotfunc( {fig_i} ); hs(fig_i) = h(1);
                title([ valueLabels{ind+VECTOR_INPUT} ' = ' num2str( valueSets{ind}(fig_i)) ]);
            end

        elseif strncmp(plotType, 'subfig', 3)
            if length(plotType) > 6
                args = str2num(plotType(7:end)); %#ok<ST2NM>
            else
                if n <= 12
                    nrows = floor(sqrt(n));
                    ncols = ceil(n / nrows);                    
                else
                    nrows = 3;
                    ncols = 4;
                end
                args = {nrows, ncols, 1};
            end
            gridSubPlot(args{:});
            for subfig_i = 1:length(valueSets{ind});
                gridSubPlot;
                h = plotfunc( {subfig_i}); hs(subfig_i) = h(1);
                title([ valueLabels{ind+VECTOR_INPUT} ' = ' num2str( valueSets{ind}(subfig_i)) ]);
            end
        else
            error(['Unknown plotType option: ' plotType ]);
        end
        matchAxes('Y', hs(:));
    end


    function plotFigs2D(inds, plotfunc)
        % typically   inds  = [2,3]   (SINGLE) or  [3,4]  (DOUBLE)
        % and      plotfunc = @plot1D (SINGLE) or @plot2D (DOUBLE)
        n1 = length(valueSets{inds(1)});
        n2 = length(valueSets{inds(2)});
        hs = zeros(n1,n2);
        plotTypes12 = plotTypes(inds);
        if all( strncmp(plotTypes12, {'sub', 'sub'}, 3) )
            figure;
            for i2 = 1:n2  % rows
                for i1 = 1:n1  % cols
                    subplot(n2, n1, i1 +(i2-1)*n1);
                    h = plotfunc( {i1, i2} ); hs(i1, i2) = h(1);
                    title([ valueLabels{inds(1)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(1)}(i1)) ', ' ...
                            valueLabels{inds(2)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(2)}(i2)) ]);
                end
            end

        elseif all ( strcmp(plotTypes12, {'sub', 'fig'} ) )
            
            for i2 = 1:n2               
                nrows = floor(sqrt(n1));
                ncols = ceil(n1 / nrows);
                gridSubPlot(nrows, ncols, i2);

                for i1 = 1:n1
                    gridSubPlot;
                    h = plotfunc( {i1, i2}); hs(i1, i2) = h(1);
                    title([ valueLabels{inds(1)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(1)}(i1))]);
                end
                setFigureName( [valueLabels{inds(2)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(2)}(i2)) ]);
            end
        else
            error(['Unknown plotType options set: [' plotTypes12{1}, ', ' plotTypes12{2} ']' ]);    
        end
        matchAxes('Y', hs(:));
    end


function plotFigs3D(inds, plotfunc)
        % typically   inds  = [2,3,4]   (SINGLE) or  [3,4,5]  (DOUBLE)
        % and      plotfunc = @plot1D   (SINGLE)  or @plot2D (DOUBLE)
        n1 = length(valueSets{inds(1)});
        n2 = length(valueSets{inds(2)});
        n3 = length(valueSets{inds(3)});
        hs = zeros(n1, n2, n3);
        plotTypes123 = plotTypes(inds);
        if all( strncmp(plotTypes123, {'sub', 'sub', 'fig'}, 3) )
            for i3 = 1:n3;
                figure(i3);
                for i2 = 1:n2  % rows
                    for i1 = 1:n1  % cols
                        subplot(n2, n1, i1 +(i2-1)*n1);
                        h = plotfunc( {i1, i2, i3} ); hs(i1, i2, i3) = h(1);
                        title([ valueLabels{inds(1)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(1)}(i1)) ', ' ...
                                valueLabels{inds(2)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(2)}(i2)) ]);
                    end
                end
                setFigureName( [valueLabels{inds(3)+VECTOR_INPUT} ' = ' num2str( valueSets{inds(3)}(i3)) ]);
            end
        else
            error(['Unknown plotType options set: [' plotTypes123{1}, ', ' plotTypes123{2} ']' ]);    
        end
        matchAxes('Y', hs(:))
    end



    switch length(valueSets)
        case 1,
            plot1D({});
            
        case 2,
            if mode == SINGLE  % plotting 1 dim per axes
                plotFigs1D(2, @plot1D) 
            elseif mode == DOUBLE  % plotting 2 dims per axes
                plot2D({});
            end
            
        case 3
            if mode == SINGLE
                plotFigs2D([2,3], @plot1D)
            elseif mode == DOUBLE
                plotFigs1D(3, @plot2D)
            end
                        
        case 4
            if mode == SINGLE
                plotFigs3D([2,3,4], @plot1D);
            elseif mode == DOUBLE
                plotFigs2D([3,4], @plot2D)
            end;

        case 5
            if mode == DOUBLE
                plotFigs3D([3,4,5], @plot2D);
            else
                error('For 5 inputs, you must put the first 2 on the same axes');
            end
                
        otherwise
            error('Currently only 5 dimensions of data supported');
    end
    
    drawnow;
end


% {noiseStds, nsToIgnore, eigThresholds}, {'noise', 'ns', 'th'}, {'line', 'color', 'subfig'})

%                         unpack cell data perpendicular to direction of data, to prevent concatenation of data series.
%                         if (iscolumn(ydata) && iscolumn(ydata{1})) || (isrow(ydata) && isrow(ydata{1}))
%                             ydata = cell2mat(ydata');
%                         else
%                             ydata = cell2mat(ydata);
%                         end
