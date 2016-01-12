function lastOne = gridSubPlot(varargin)
    % Initialize for easy sequential subplotting by calling
    %    gridSubPlot(nrows, ncols, [startFigId {maxPages}], {nSubRows})
    % This is for subplotting across one or more figures, with nrows rows and
    % ncols columns, starting at figure startFigId.
    % Then, just call
    %    {lastOne} = gridSubPlot;
    % before plotting each figure.
    %
    % If a maxPages parameter is provided (as the second element of the 3rd argument)
    %   'lastOne' will return true after the last subplot is reached.
    %
    % If nSubRows has been provided (nRows should be a multiple of nSubRows)
    % then you can call 
    %    gridSubPlot(1); plot(...)
    %    gridSubPlot(2); plot(...)
    %    ...
    %    gridSubPlot(nSubRows); plot(...)
    % to plot different series of plots on different rows (even across
    % multiple figures).

    persistent figId  subFigId  nrows  ncols  startFigId  maxPages nSubRows subFigsPlotted;
    lastOne = false;
    
    switch nargin
        case {2,3,4}  % initialize
            [nrows, ncols] = elements(varargin);
            if nargin > 2
                startFigId = varargin{3};
            else
                startFigId = gcf;
            end
                
            if length(startFigId) > 1
                [startFigId, maxPages] = elements(startFigId);
            else
                maxPages = 20;
            end
            
            if (nargin == 4)
                nSubRows = varargin{4};
            else
                nSubRows = 1;
            end
            
            if mod(nrows, nSubRows) ~= 0
                error('nrows must be divisible by nSubRows');
            end
            
%             plottedOnThisFig = false(ncols, nrows, maxPages);
            subFigsPlotted = false(nSubRows, (nrows/nSubRows)*ncols*maxPages);
            subFigId = 0;
            figId = startFigId;
            
        case 0,   % advance simply along the rows.
            subFigId = subFigId + 1;
            if (subFigId > nrows*ncols)
                subFigId = 1;
                figId = figId +1;                
            end                
            lastOne = (figId-startFigId > maxPages) || (figId-startFigId+1 == maxPages) && (subFigId == nrows*ncols);
            
            curFig = gcf;
            if curFig ~= figId                
                figure(figId);
            end
            subplot(nrows,ncols,subFigId);
%             plottedOnThisFig(subFigId)=true;
            
        case 1,  % advance along nSubRows independent rows. (assumes nrows is even)

            r = varargin{1};
            if ~ibetween(r, 1, nSubRows)
                error('input must be between 1 and nSubRows');
            end
            ind = find(~subFigsPlotted(r, :), 1);
            lastOne = (ind == size(subFigsPlotted,2));

            if isempty(ind) % double the size for more plots
                subFigsPlotted(r, end*2) = false;
                ind = find(~subFigsPlotted(r, :), 1);
            end
                
            
            
%             [figId, subColId] = divrem(ind, nSubRows*ncols);
            [subColId, figId] = ind2sub([(nrows/nSubRows)*ncols, nrows], ind);
            
%             [m_sub, n] = divrem(subColId, ncols);            
            [n, m_sub] = ind2sub([ncols, nrows], subColId);            
                        
            m = (m_sub-1)*nSubRows+1  +  r-1;            

%             figure(200);
%             imagesc(subFigsPlotted);
            
            figure(startFigId + figId-1);
            subplot(nrows, ncols, (m-1) * ncols + n);
%                                    
%             if isempty(subFigId)
%                 figId = figId +1;                
% %                 plottedOnThisFig = false(ncols, nrows);
%                 if r == 1
%                     subFigId = 1;                                        
%                 elseif r == 2
%                     subFigId = ncols+1;                                                            
%                 end
%             end                
            
            
            subFigsPlotted(r, ind) = true;
                       
    end
end
            
   