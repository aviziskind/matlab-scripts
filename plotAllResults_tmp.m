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
    % where plot1/2 is the function that plots the first 1 or2 dimensions.
    % which can be
    %    'surf', 'mesh', 'bar3' (for 2D graphs)
    %    'plot', 'bar'          (for plotting multiple line graphs on the same axes)

    % determine whether are doing single/double plots
    SINGLE = 1;
    DOUBLE = 2;
    if any (strncmp( plotTypes{2}, {'fig', 'sub'}, 3))
        mode = SINGLE;
    elseif any (strncmp( plotTypes{3}, {'fig', 'sub'}, 3))
        mode = DOUBLE;
    end
    
    
    function plot1(idxes)
        plotFuncStr = plotTypes{1};
        plotFunc = str2func(plotFuncStr);
        switch plotFuncStr                
            case {'plot'}
                ydata = squeeze(data(:,idxes{:}));
                if iscell(ydata)
                    ydata = cell2mat(ydata);
                end
                plotFunc(valueSets{1}, ydata);
                xlabel(valueLabels{1});                
        end
    end
    
    
    function plot1vs2(idxes)
        plotFuncStr = plotTypes{1};
        plotFunc = str2func(plotFuncStr);
        switch plotFuncStr
            case {'surf', 'mesh', 'bar3'}                
                plotFunc(valueSets{1}, valueSets{2}, squeeze(data(:,:,idxes{:})) );        
                xlabel(valueLabels{1});
                ylabel(valueLabels{2});
                
            case {'plot', 'bar'}
                hold on;
                for j = 1:length(valueSets{2})
                    plotFunc(valueSets{1}, squeeze(data(:,j,idxes{:})), [color(j) 'o-']);
                end   
                xlabel(valueLabels{1});
                legend ( legendarray([valueLabels{2} '='], valueSets{2}) )
%                 legend( cellfun(@num2str, m2cell(valueSets{2}), 'Un', false) );        
        end
    end
        

    function plotFigs1D(ind)
        n3 = length(valueSets{3});
        plotType3 = plotTypes{2};
        if strcmp(plotType3, 'fig')
            for i3 = 1:length(valueSets{3})
                figure(i3);
                plot1vs2( {i3} );
                title([ valueLabels{3} ' = ' num2str( valueSets{3}(i3)) ]);
            end

        elseif strncmp(plotType3, 'subfig', 6)
            if length(plotType3) > 6
                args = str2num(plotType3(7:end)); %#ok<ST2NM>
            else
                if n3 <= 12
                    nrows = floor(sqrt(n3));
                    ncols = ceil(n3 / nrows);                    
                else
                    nrows = 3;
                    ncols = 4;
                end
                args = {nrows, ncols, 1};
            end
            gridSubPlot(args{:});
            for i3 = 1:length(valueSets{3});
                gridSubPlot;
                plot1vs2( {i3});
                title([ valueLabels{3} ' = ' num2str( valueSets{3}(i3)) ]);
            end
        end        
    end


    function plotFigs2D
        n3 = length(valueSets{3});
        n4 = length(valueSets{4});
        plotTypes34 = plotTypes([2,3]);
        if all( strncmp(plotTypes34, {'subx', 'suby'}, 3) )
            figure;
            for i4 = 1:n4  % rows
                for i3 = 1:n3  % cols
                    subplot(n4, n3, i3 +(i4-1)*n3);
                    plot1vs2( {i3, i4});
                    title([ valueLabels{3} ' = ' num2str( valueSets{3}(i3)) ', ' ...
                            valueLabels{4} ' = ' num2str( valueSets{4}(i4)) ]);
                end
            end

        elseif ( strcmp(plotTypes34, {'sub', 'fig'} ) )
            
            for i4 = 1:n4               
                nrows = floor(sqrt(n3));
                ncols = ceil(n3 / nrows);
                gridSubPlot(nrows, ncols, i4);

                for i3 = 1:n3
                    gridSubPlot;
                    plot1vs2( {i3, i4});
                    title([ valueLabels{3} ' = ' num2str( valueSets{3}(i3))]);
                end
                suptitle_2( [valueLabels{4} ' = ' num2str( valueSets{4}(i4)) ]);
            end
        end
    end

    nSets = length(valueSets);
    if nSets ~= length( size(data) )
        error('number of dimensions of data must be equal to number of axes');
    end

        
    switch length(valueSets)
        case 1,
            plot1({});
            
        case 2,
            if mode == SINGLE
                
            elseif mode == DOUBLE
                plot1vs2({});
            end
            
        case 3
            plot3vars;
            
        case 4
            plot4vars;
       
        otherwise
            error('Currently only 4 dimensions of data supported');
    end
    
    
end


% {noiseStds, nsToIgnore, eigThresholds}, {'noise', 'ns', 'th'}, {'line', 'color', 'subfig'})