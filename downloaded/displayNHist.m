%% This function displays the histogram of a vector.
% This function will hopefully replace all earlier version of display hist
% including displayNHist_i and displayNormalHist
% 
% It can also be made so that the same axis are used
% 
% Backup versions will be made as copies.
% 
% [n, x, roundedMode] = displayNHist(cellValues, varargin)
% 
% Summary of what function does:
%  1) Autamatically sets the number and range of the bins to be appropriate 
%     for the data.
%  2) Compares multiple sets of data elegantly on one or more plots
%  3) Insert the number of points into the legend for each line
%  
% Pass a single array to obtain a regular looking histogram plot.
% Pass a cell array, which includes at least one number array to obtain a normalized 
% graph with line plots for each of the arrays of data
% 
% Syntax:
%   displayHist(Values, 'PropertyName', PropertyValue ...)
% 
% cellValues    : Vector of values, or cell array with arrays of values
% 
% Properties: Optional properties
%             'legend'  : A cell array with strings to put in the legend
%             'stdtimes': Number of times the standard deviation to set the upper (higher value) end of the axis to be.
%             'xlabel'  : Label of the X axis
%             'ylabel'  : Label of the Y axis
%             'eps'     : EPS file name of the generated plot to save
%             'title'   : Title of the figure
%             'fsize'   : Font size, default 22
%            'linewidth': Sets the width of the lines for all the graphs
%             'color'  : Sets the color of the bar graphs for regular
%                         mode, set to 'multicolor' for different colors.
%                         Note for the regular case this will just change
%                         the colormap for the linspecer function
%             'sub'     : Do not create a new figure for the graph
%             'minx'    : This is a hack to set the minimum bin to 0.
%             'mode'    : This will plot a stem plot of the mode
%             'median'  : same as above, but plotting the median instead
%             'noerror' : Will remove the mean and standard deviation error bars above the plot
%             'serror'  : Will put the mean and 'standard error' bars above the plot rather than the std
%            'binfactor': if 'same' then it makes all bins identical to
%                         the mean of the recomended bin sizes
%                         if a number then all bins will be some multiple
%                         of the largest bin. The larger the number the
%                         closer they will be to the largest bin.
%             'samebins': this will make all the bins align with each other
%           'normalhist': Use one or more normal histograms instead of a stair graph
%             'minbins' : The minimum number of bins allowed for each graph
%             'maxbins' : The maximum number of bins allowed for each graph
%        'separateplots': Plot each histogram separately, also use normal
%                         bar plots for the histograms rather than the
%                         stairs function...
%             'npoints' : this will add (number of points) to the legend or
%                         title automatically for each plot.
% 
% Note: if you pass it a solitary array rather than a cell, then it will
% plot with the regular looking bar graphs (instead of with a stairs
% fuction), but if you pass it a cell array then it will just plot it with
% a stairs function like the other cases.
%               
% 
% It returns the following values: 
%    n      : Normalized frequency counts for the bins
%    x      : Bin locations
%    roundedMode : the x location of the highest peak in 'n'
% 
% Pass this function an array, and it will display the normal histogram,
% but with special bin sizes. If you pass this function a cell, even with
% only one array inside, then it will plot a line plot as usual.
% 

%% The bin width is defined in the following way
% I did a little research and found that the theoretically best (unbiased)
% choice for histogram bin size was shown to be  , by Freedman-Diaconis
% (1981), where IQR is the interquartile range. Of course the theory is
% general and so not rigorous, but I feel it does a good job.
% 
% I did not follow it exactly though, restricting smaller bin sizes to be
% divisible by the larger bin sizes. In this way the three conditions can
% be accurately compared, unlike before.
% Note: this function is specialized to compare data with comparable
% standard deviations and means, but greatly varying numbers of points.

% 'serror' will plot the standard error = std/sqrt(N) otherwise the
% standard deviation will be plotted as a default
%% to test the function run this:
% 
% A={randn(1,10^4),randn(10^2,1)+1};
% displayNHist(A,'legend',{'u=0','u=1'})
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jonathan C. Lansey Aug 2009,     questions to Lansey at gmail.com       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [n, x, roundedMode] = displayNHist(cellValues, varargin)
%% Check if data is an array, not a cell
valueInfo=whos('cellValues');
valueType=valueInfo.class;
if strcmp(valueType,'cell')
    normalHist=0;
%   There are a few cells there, it will run as usual.
else % data needs to be changed to a cel array, for what follows.
    cellValues={cellValues};
    normalHist=1;
end


%% INITIALIZE PARAMETERS
% Default initialization of the parameters,
    
stdTimes=4; % the number of times the standard deviation to set the upper end of the axis to be.
binFactor=1;
sameBinsFlag=0; % if 1 then all bins will be the same size

minX=[]; % for the axis in case users don't enter anything
maxX=[];
minBins=10;
maxBins=100;
SXLabel = '';
SYLabel = '';
EPSFileName = '';
Title = '';
AxisFontSize = 12;
npointsFlag=0;

% lineColor = [.49 .49 .49];
lineColor = [0 0 0];
faceColor = [.7 .7 .7];

multicolorFlag=0;
brightnessExponent=1/2;

plotStdFlag = 1;
serrorFlag = 0;
medianFlag = 0;
modeFlag   = 0;
legendExists=0;
Sub = false;
linewidth=2;


% cropped_right=0;
% cropped_left=0;

%% Interpret the user parameters
  k = 1;
  while k <= length(varargin) && ischar(varargin{k})
    switch (lower(varargin{k}))
      case 'legend'
        cellLegend=varargin{k+1};
        legendExists=1;
        k = k + 1;
      case 'xlabel'
        SXLabel = varargin{k + 1};
        k = k + 1;
      case 'ylabel'
        SYLabel = varargin{k + 1};
        k = k + 1;
      case 'minx'
        minX = varargin{k + 1};
        k = k + 1;
      case 'maxx'
        maxX = varargin{k + 1};
        k = k + 1;
      case 'minbins'
        minBins = varargin{k + 1};
        k = k + 1;
      case 'maxbins'
        maxBins = varargin{k + 1};
        k = k + 1;
      case 'stdtimes' % the number of times the standard deviation to set the upper end of the axis to be.
        stdTimes = varargin{k + 1};
        k = k + 1;
        if ischar(stdTimes)
            error('stdTimes must be a number')
        end
      case 'binfactor'
        binFactor = varargin{k + 1};
        k = k + 1;
        if ischar(binFactor)
            error('binFactor must be a number')
        end
      case 'samebins'
        sameBinsFlag=1;        
      case 'eps'
        EPSFileName = varargin{k + 1};
        k = k + 1;
      case 'title'
        Title = varargin{k + 1};
        k = k + 1;
      case 'fsize'
        AxisFontSize = varargin{k + 1};
        k = k + 1;
      case 'linewidth'
        linewidth = varargin{k + 1};
        k = k + 1;
      case 'color'
        lineColor=varargin{k+1};
        if ischar(lineColor)
            if strcmp(lineColor,'multicolor')
                multicolorFlag = 1;
            end %then lineColor will be redone later
        else
            faceColor = lineColor;%.^(brightnessExponent);
%             lineColor = lineColor;
        end
        k = k + 1;
      case 'npoints'
            npointsFlag=1;
      case 'sub'
        Sub = true;
      case 'noerror'
          plotStdFlag = 0;
      case 'serror'
        serrorFlag = 1;
      case 'median'
          medianFlag=1;
      case 'separateplots'
          normalHist=1;
      case 'mode'
        modeFlag = 1;
      otherwise
        warning('user entered parameter is not recognized')
        disp('unrecognized term is:'); disp(varargin{k});
%         p_ematError(3, 'displayHist');
    end
    k = k + 1;
  end

  
%% Warn the User about some things:

if ~legendExists && npointsFlag
    warning(['you must submit a legend for numpoints to plot, '...
             'you can use an empty list like {'''','''',''''}']);
end
  
  
%% Collect the Data
num2Plot=length(cellValues);
for k=1:num2Plot
% transpose if need be
% if the vector was facing the wrong way then it is fixed here
% This also makes it so you can pass it a full matrix, just for fun.
% It is done for each one individually so you can even pass a cell array
% where the individual vectors are differently angled.
    cellValues{k}=cellValues{k}(:); 
% Store a few other useful values
    Values=cellValues{k};
    stdV{k}=std(Values); % standard dev of values
    meanV{k}=mean(Values);
    medianV{k}=median(Values);
    numPoints{k}=length(Values); % number of values
end


%% FIND THE AXIS BOUNDS
% on each side, left and right

% error the user if they choose retarded bounds (pardon my politically uncorrectness)
if ~isempty(minX) && ~isempty(maxX)
    if maxX<minX
        error(['your max bound: ' num2str(maxX) ' is bigger than your min bound: ' num2str(minX) ' you can''t do that silly']);
    end
end

for k=1:num2Plot
  Values=cellValues{k};
% warn the user if they chose a dumb bounds (but not retarded ones)
  if ~isempty(minX)
    if minX>meanV{k}
        warning(['the mean of your data set#' num2str(k) ' is off the chart to the left, '...
                'choose larger bounds or quit messing with the program and let it do '...
                'its job the way it was designed.']);
    end
  end
  if ~isempty(maxX)
    if maxX<meanV{k}
        warning(['the mean of your data set#' num2str(k) ' is off the chart to the right, '...
                'choose larger bounds or quit messing with the program and let it do '...
                'its job the way it was designed.']);
    end
  end
  
%   Note the check stdV{k}>0, just in case the std is zero, we need to set
%   boundaries so that it doesn't crash with 0 bins used
%       The range of (+1,-1) is totally arbitrary

% set x MIN values
    if isempty(minX) % user did not specify - then we need to find the minimum x value to use
        if stdV{k}>0 % just checking there are more than two different points to the data
            leftEdge = meanV{k}-stdV{k}*stdTimes;
            if leftEdge<min(Values) % if the std is larger than the largest value
                minS(k)=min(Values);
            else % cropp it now on the bottom.
%             cropped!
                minS(k) = leftEdge;
            end
        else % stdV==0, wow,
            minS(k)=min(Values)-1;
        end 
    else % minX is specified so minS is just set stupidly here
        minS(k)=minX;
    end
      
% set x MAX values  
    if isempty(maxX)
        if stdV{k}>0 % just checking there are more than two different points to the data
            rightEdge = meanV{k}+stdV{k}*stdTimes;
            if rightEdge>max(Values) % if the suggested border is larger than the largest value
                maxS(k)=max(Values);
            else % crop the graph to cutoff values
                maxS(k)=rightEdge;
            end
        else % stdV==0, wow,
%           Note that minX no longer works in this case.
            maxS(k)=max(Values)+1;
        end
    else % maxX is specified so minS is just set stupidly here
        maxS(k)=maxX;    
    end

% 
end % look over k finished
% This is the range that the x axis will plot at for each one.
SXRange = [min(minS) max(maxS)];
totalRange=diff(SXRange);

%% FIND OUT IF THERE WERE CROPS DONE

for k=1:num2Plot
    % Set the crop flag      
    if min(cellValues{k})<SXRange(1)
        cropped_left{k}=1;  % flag to plot the star later
    else
        cropped_left{k}=0;
    end
    % Set the crop flag
    if max(cellValues{k})>SXRange(2)
        cropped_right{k}=1; % flag to plot the star later
    else
        cropped_right{k}=0;
    end
end

%% DEAL WITH BIN SIZES
% Reccomend a bin width
binWidth=zeros(1,num2Plot);

% Warn users for dumb max/min bin size choices.
if minBins<3,  error('No I refuse to plot this you abuser of functions, the minimum number of bins must be at least 3'); end;
if minBins<10, warning('you are using a very small minimum number of bins, do you even know what a histogram is?'); end;
if minBins>20, warning('you are using a very large minimum number of bins, are you sure you *always need this much precision?'); end;
if maxBins>150,warning('you are using a very high maximum for the number of bins, unless your monitor is in times square you probably won''t need that many bins'); end;
if maxBins<50, warning('you are using a low maximum for the number of bins, are you sure it makes sense to do this?'); end;

% Choose estimate bin widths
for k=1:num2Plot
%* This formula here to determine bin width is from Freedman-Diaconis'
% choiceFreedman, David; Diaconis, P. (1981). "On the histogram as a
% density estimator: L2 theory". Zeitschrift für Wahrscheinlichkeitstheorie
% und verwandte Gebiete 57 (4): 453–476
%       binWidth(k)=2*iqr(Values)/(numPoints{k})^(1/3)  *  2.0 ;% the 2.0 was added even though I disagree with it.- Jonathan
% this  formula uses Scotts choice to reccomend a bin width
% Then it is adulterated by user parameter 'binFactor'
%        binFactor is a number to allow the user to make the bins larger or
%        smaller to their tastes. Larger binFactor means more bins. 1 is default
    binWidth(k)=3.5*stdV{k}/(binFactor*(numPoints{k})^(1/3));% the 2.0 was added even though I disagree with it.- Jonathan

  % Instate a mininum and maximum number of bins
    numBins = totalRange/binWidth(k); % Approx number of bins
    if numBins<minBins % if this will imply less than 10 bins
        binWidth(k)=totalRange/(minBins-1); % set so there are ten bins
    end
    if numBins>maxBins % if there would be more than 75 bins (way too many)
        binWidth(k)=totalRange/maxBins;
    end
    
end    
% find the maximum bin width    
bigBinWidth=max(binWidth);
%      minBins=10;       maxBins=50;

%%  resize bins to be multiples of each other - or not
% sameBinsFlag will make all bin sizes the same.

% Note that in all these conditions the largest histogram bin width
% divides evenly into the smaller bins. This way the data will line up and
% you can easily visually compare the values in different bins

if sameBinsFlag % if 'same' is passed then make them all equal to the average reccomended size
    binWidth=0*binWidth+mean(binWidth); %
else % the bins will be different if neccesary
    for k=1:num2Plot
%       here I do a round, where its round(x/2)*2. this is similar to
%       rounding away an entire digit, like round(x/10)*10 but less
%       information is lost this way. The 'ceil' rather than 'round' is
%       supposed to make sure that the ratio is at lease 1 (divisor at least 2)
%       default: binFactor=1;
        binWidth(k)=bigBinWidth/ceil(bigBinWidth/binWidth(k));
    end
end


%% CALCULATE THE HISTOGRAM
% 
maxN=0; %for setting they ylim(maxN) command later, find the largest height of a column
for k=1:num2Plot
    Values=cellValues{k};
%  Set the bins
     SBins{k}=SXRange(1):binWidth(k):SXRange(2);
%  Set it to count all those outside as well.
     binsForHist{k}=SBins{k};
     binsForHist{k}(1)=-inf; binsForHist{k}(end)=inf;
%  Calculate the histograms
     n{k} = histc(Values, binsForHist{k});
     n{k}=n{k}';
%  This here is to complete the right-most value of the histogram.
%      x{k}=[SBins{k} SXRange(2)+binWidth(k)];
       x{k} = SBins{k};
%      n{k}=[n{k} 0];
%  Later we will need to plot a line to complete the left start.

%% Add the number of points used to the legend
    if npointsFlag
        if legendExists
            cellLegend{k}=[cellLegend{k} ' (' num2str(numPoints{k}) ')'];
        end
    end

%% Normalize all the data
% only do this if they will be plotted together, otherwise leave it be.
  % = (each value)*(1/width of a bin)/total number of points, or the sum(n)
  if ~normalHist
      n{k}=n{k}/(binWidth(k)*numPoints{k});
  end
%         n{k}=n{k}*(nBins{k}/(maxS(k)-minS(k)))/numPoints{k};
%         n{k}=n{k}/trapz(SBins{k},n{k}); % height/area(data) via trapezoidal method

    maxN=max([n{k} maxN]);

%   this calculates the approximate mode, the highest peak here.
%   you need to add the binWidth/2 to get to the center of the bar for
%   the histogram.
    roundedMode{k}=mean(x{k}(n{k}==max(n{k})))+binWidth(k)/2;

end

%% PREPARE THE COLORS
if normalHist %
   if multicolorFlag
%         lineStyleOrder=linspecer(num2Plot,'jet');
        faceStyleOrder=linspecer(num2Plot,'jet');
        for k=1:num2Plot % make the face colors brighter a bit
            lineStyleOrder{k}=[0 0 0];
            faceStyleOrder{k}=(faceStyleOrder{k}).^(brightnessExponent); % this will make it brighter than the line           
        end
   else % then we need to make all the graphs the same color, gray or not
        for k=1:num2Plot
            lineStyleOrder{k}=[0 0 0];
            faceStyleOrder{k}=faceColor;
        end
   end
else % they will all be in one plot, its simple. there is no faceStyleOrder
    if ischar(lineColor) % then the user must have inputted it! 
%       That means we should use the colormap they gave
        lineStyleOrder=linspecer(num2Plot,lineColor);
    else % just use the default 'jet' colormap.
        lineStyleOrder=linspecer(num2Plot,'jet');
    end    
end

%% create the figure
if ~Sub
%     figure('Name', Title);
%     Hx = axes('Box', 'off', 'FontSize', AxisFontSize);
    title(Title)
end

hold on;
  
%% PLOT THE HISTOGRAM
% reason for this loop:
% Each histogram plot has 2 parts drawn, the legend will look at these
% colors, this just seems like an easy way to make sure that is all plotted
% in the right order - not the most effient but its fast enough as it is.
if normalHist % plot this for legend purposes only!
    for k=1:num2Plot
        subplot(num2Plot,1,k);
        hold on;
        plot([x{k}(1) x{k}(1)],[0 n{k}(1)],'color',lineStyleOrder{k},'linewidth',linewidth);
    end
else % do the same thing, but on different subplots
    for k=1:num2Plot
        plot([x{k}(1) x{k}(1)],[0 n{k}(1)],'color',lineStyleOrder{k},'linewidth',linewidth);
    end
end

if normalHist
    for k=1:num2Plot
        subplot(num2Plot,1,k);
        hold on;
        set(gca,'fontsize',AxisFontSize);
%         axes('Box', 'off', 'FontSize', AxisFontSize);

%       Note this is basically doing what the 'histc' version of bar does,
%       but with more functionality (there must be some matlab bug which
%       doesn't allow chaning the lineColor property of a histc bar graph.       
        bar(x{k}+binWidth(k)/2,n{k}/1,'FaceColor',faceStyleOrder{k},'barwidth',1,'EdgeColor','none')
        stairs(x{k},n{k},'k','linewidth',linewidth);
        plot([x{k}(1) x{k}(1)],[0 n{k}(1)],'color','k','linewidth',linewidth);
    end
else
    for k=1:num2Plot
        stairs(x{k},n{k},'color',lineStyleOrder{k},'linewidth',linewidth);
        plot([x{k}(1) x{k}(1)],[0 n{k}(1)],'color',lineStyleOrder{k},'linewidth',linewidth);
    end
end
%% PLOT THE STARS IF CROPPED
%    ADD A STAR IF CROPPED
% plot a star on the last bin in case the ends are cropped
% you will want to also include the following text in the caption:
% 'The starred column on the far right represents the bin for all values that lie off the edge of the graph.'
%     Note that the star is placed +maxN/20 above the column, this
%     is so that its the same for all data, and relative to the y
%     axis range, not the individual plots. The text starts at the
%     top, so it only needs a very small push to get above it.
if normalHist
    for k=1:num2Plot
        subplot(num2Plot,1,k);
        if cropped_right{k} % if some of the data points lie outside the bins.
            text(x{k}(end-1)+binWidth(k)/10,n{k}(end-1)+max(n{k})/50,'*','fontsize',AxisFontSize,'color',lineStyleOrder{k});
        end
        if cropped_left{k} % if some of the data points lie outside the bins.
            text(x{k}(1)+binWidth(k)/10,n{k}(1)+max(n{k})/30-max(n{k})/50,'*','fontsize',AxisFontSize,'color',lineStyleOrder{k});
        end
    end
else
%     lineStyleOrder=linspecer(num2Plot,'jet');
    for k=1:num2Plot
        stairs(x{k},n{k},'color',lineStyleOrder{k},'linewidth',linewidth);
        plot([x{k}(1) x{k}(1)],[0 n{k}(1)],'color',lineStyleOrder{k},'linewidth',linewidth);
        
  %    ADD A STAR IF CROPPED 
        if cropped_right{k} % if some of the data points lie outside the bins.
            text(x{k}(end-1)+binWidth(k)/10,n{k}(end-1)+maxN/50,'*','fontsize',AxisFontSize,'color',lineStyleOrder{k});
        end
        if cropped_left{k} % if some of the data points lie outside the bins.
            text(x{k}(1)+binWidth(k)/10,n{k}(1)+maxN/30-maxN/50,'*','fontsize',AxisFontSize,'color',lineStyleOrder{k});
        end
    end
end



%% PLOT the ERROR BARS and MODE
% but only if it was requested
if modeFlag && medianFlag % just a warning here
  warning(['This will make a very messy plot, didn''t your mother '...
           'warn you not to do silly things like this '...
           'Next time please choose either to have mode or the median plotted.']);
    fprintf('The mode is plotted as a dashed line\n');
end

for k=1:num2Plot
%     Note the following varables that were defined much earlier in the code.
%       numPoints
%       stdV{k}=std(Values); % standard dev of values
%       meanV{k}=mean(Values);
%       medianV{k}=median(Values);
%       roundedMode{k}=mean(x{k}(n{k}==max(n{k}))); % finds the maximum of the plot
    if normalHist
        subplot(num2Plot,1,k);
        tempMax = max(n{k});
        
        
        
    else
        tempMax = maxN;
               
    end
    
    
    if medianFlag
        if normalHist % plot with 'MarkerFaceColor'
            stem(medianV{k},(1.1)*tempMax,'color',lineStyleOrder{k},'linewidth',linewidth,'MarkerFaceColor',faceStyleOrder{k});
        else % plot hollow
            stem(medianV{k},(1.1)*tempMax,'color',lineStyleOrder{k},'linewidth',linewidth)
        end
        
    end
    if modeFlag % then plot the median in the center as a stem plot
%               Note that this mode is rounded . . .
        if medianFlag % plot the mode in a different way
            if normalHist
                stem(roundedMode{k},(1.1)*tempMax,'--','color',lineStyleOrder{k},'linewidth',linewidth,'MarkerFaceColor',faceStyleOrder{k});
            else
                stem(roundedMode{k},(1.1)*tempMax,'--','color',lineStyleOrder{k},'linewidth',linewidth)
            end
            
        else % plot the regular way and there will be no confusion
            if normalHist
                stem(roundedMode{k},(1.1)*tempMax,'color',lineStyleOrder{k},'linewidth',linewidth,'MarkerFaceColor',faceStyleOrder{k})
            else
                stem(roundedMode{k},(1.1)*tempMax,'color',lineStyleOrder{k},'linewidth',linewidth);
            end
        end

    end

    if plotStdFlag==0 && serrorFlag==1 % just a warning here
        warning('You have can''t have ''noerror'' and eat your ''serror'' too!')
        fprintf('Next time please choose either to have error bars or not have them!\n');
    end
    if plotStdFlag
        if normalHist
            tempY=tempMax.*1.4;
        else
            tempY=tempMax*(1.1+.1*(num2Plot-k+1));
        end
        
        if serrorFlag%==1 % if standard error will be plotted
%           note: that it is plotting it from the top to the bottom! just like the legend is
            errorb(meanV{k},tempY,stdV{k}/sqrt(numPoints{k}),'horizontal','color',lineStyleOrder{k},'barwidth',tempMax/20,'linewidth',linewidth);
        else % just plot the standard deviation as error
            errorb(meanV{k},tempY,stdV{k},                   'horizontal','color',lineStyleOrder{k},'barwidth',tempMax/20,'linewidth',linewidth);
        end
        
        if normalHist % plot only the dot in color
            plot(meanV{k},tempY,'.','markersize',25,'color',faceStyleOrder{k});
            plot(meanV{k},tempY,'o','markersize',8,'color',[0 0 0],'linewidth',linewidth);
        else % plot everything in color, this dot and the bars before it
            plot(meanV{k},tempY,'.','markersize',25,'color',lineStyleOrder{k});
        end
    end 
end

  
%% DEAL WITH FANCY GRAPH THINGS
% note that the legend is already added in the 'plotting' section

% padd the edges of the graphs so the histograms have room to sit in.
axisRange(1)=SXRange(1)-totalRange/30;
axisRange(2)=SXRange(2)+totalRange/30;

if normalHist
    for k=1:num2Plot
        subplot(num2Plot,1,k);
%       add a title to each plot, from the legend
        if legendExists
            title(cellLegend{k});
        end
%      set axis
        xlim(axisRange);
        if plotStdFlag
            ylim([0 max(n{k})*(1.2+.1*num2Plot)]);
        else
            ylim([0 max(n{k})*(1.1)]);
        end
  % label y
        ylabel(SYLabel, 'FontSize', AxisFontSize);

    end
%   label x axis only at the end, the bottom subplot
    xlabel(SXLabel, 'FontSize', AxisFontSize);
    
else % all in one plot:
%  set y limits
    if plotStdFlag
      ylim([0 maxN*(1.2+.1*num2Plot)]);
    else
        ylim([0 maxN*(1.1)]);
    end
    % set x limits
    xlim(axisRange);
    % label y and x axis
    ylabel(SYLabel, 'FontSize', AxisFontSize);
    xlabel(SXLabel, 'FontSize', AxisFontSize);

 % Add legend
    if legendExists
        if num2Plot~=length(cellLegend)
            warning('legend is not appropriately sized for the data');
        end
        legend(cellLegend,'location','best');%,'location','SouthOutside');

    end
end

  
%% print figure    
  % Save the figure to a EPS file
  if ~strcmp(EPSFileName, ''), print('-depsc', EPSFileName); end
%%
end








%% function errorb(x,y,varargin) to plot nice healthy error bars
% It is possible to plot nice error bars on top of a bar plot with Matlab's
% built in errorbar function by setting tons of different parameters to be
% various things.
% This function plots what I would consider to be nice error bars as the
% default, with no modifications necessary.
% It also plots, only the error bars, and in black. There are some very
% useful abilities that this function has over the matlab one, see below:
% 
% horizontal: will plot the error bars horizontally rather than vertically
% top: plot only the top half of the error bars (or right half for horizontal)
% barwidth: the width of the little hats on the bars (default scales with the data!)
% linewidth: the width of the lines the bars are made of (default is 2)
% color: specify a particular color for all the bars to be (default is black, this can be anything like 'blue' or [.5 .5 .5])
% multicolor: will plot all the bars a different color (thanks to my linespecer function)
% 
%% Basics (same as matlab's errobar)
% ERRORBAR(Y,E) plots Y and
% draws an error bar at each element of Y. The error bar
% is a distance of E(i) above and below the curve so that
% each bar is symmetric and 2*E(i) long.
% ERRORBAR(X,Y,E) plots Y versus X with
% symmetric error bars 2*E(i) long. X, Y, E must
% be the same size. When they are vectors, each error bar is a distance of E(i) above
% and below the point defined by (X(i),Y(i)).
% 
%% future developments 
% How to deal with matlab's grouped bar plots . . . very difficult. I don't
% know what they use to determine their spacing. If you know the answer,
% let me know and I'll develop this section.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Jonathan Lansey March 2009,     questions to Lansey at gmail.com        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 

function errorb(x,y,varargin)
%% first things first

num2Plot=size(x,2);
numGroups=size(x,1);
if numGroups>1 && num2Plot>1 % if you need to do a group plot
% Plot bars
    e=y; y=x;
	handles.bars = bar(x, 'edgecolor','k', 'linewidth', 2);
	hold on
%     colormap(jet);
% 	if ~isempty(bw_legend) && ~strcmp(legend_type, 'axis')
% 		handles.legend = legend(bw_legend, 'location', 'best', 'fontsize',12);
% 		legend boxoff;
% 	else
% 		handles.legend = [];
% 	end
	
	% Plot erros
	for i = 1:num2Plot
		x =get(get(handles.bars(i),'children'), 'xdata');
		x = mean(x([1 3],:));
		errorb(x,y(:,i), e(:,i),'barwidth',1/(4*num2Plot),varargin{:});
%       handles.errors(i) =  errorbar(x, y(:,i), e(:,i), 'k', 'linestyle', 'none', 'linewidth', 2);
% 		ymax = max([ymax; y(:,i)+e(:,i)]);
    end
    
    return

end
%% Check if X and Y were passed or just X

if length(varargin)>0
    if ischar(varargin{1})
        justOneInputFlag=1;
        e=y; y=x; x=1:num2Plot;
    else
        justOneInputFlag=0;
        e=varargin{1};
    end
else % not text arguments, not even separate 'x' argument
    e=y; y=x; x=1:length(e);
    justOneInputFlag=0;
end

if numGroups>num2Plot % if its transposed the wrong way
%     x=x'; % This is set to begin with so we don't need to change it.
    num2Plot=numGroups; numGroups=num2Plot; % yes it is unused
    y=y';
    e=e';
end


% x,y,e,

hold on

%% Check that your vectors are the proper length
if num2Plot~=length(e) || num2Plot~=length(y)
    error('your data must be vectors of all the same length')
end

%% Check that the errors are all positive
signCheck=min(0,min(e(:)));
if signCheck<0
    error('your error values must be greater than zero')
end

%% In case you don't specify color:
color2Plot = [ 0 0 0];
% set all the colors for each plot to be the same one. if you like black
for kk=1:num2Plot
    lineStyleOrder{kk}=color2Plot;
end

%% Initialize some things before switches

signFlag=sign(y);

horizontalFlag=0;
topFlag=0;
barWidthFlag=0;
barFlag=0;
linewidth=2;




% Run switches
k = 1 + 1 - justOneInputFlag; %
%  if there is just one input, then start at 1,
%  but if X and Y were passed then we need to start at 2
while k <= length(varargin) && ischar(varargin{k})
    switch (lower(varargin{k}))
      case 'horizontal'
        horizontalFlag=1;
        
        if justOneInputFlag % need to switch x and y now
            x=y; y=1:num2Plot; % e is the same
        end
        
%       case 'color' % this is the number of bins you want between - and 2pi
%         col =linspace(0,2*pi, varargin{k + 1}); % 0 to 2pi, with 'bins' bins
      case 'color' %  '': can be 'ampOnly', 'heat'
        color2Plot = varargin{k + 1};
%       set all the colors for each plot to be the same one
        for kk=1:num2Plot
            lineStyleOrder{kk}=color2Plot;
        end
        
        k = k + 1;
        
      case 'linewidth' %  '': can be 'ampOnly', 'heat'
        linewidth = varargin{k + 1};
        k = k + 1;
        
      case 'barwidth' %  '': can be 'ampOnly', 'heat'
        barWidth = varargin{k + 1};
        barWidthFlag=1;
        k = k + 1;
      case 'multicolor'
        lineStyleOrder=linspecer(num2Plot,'jet');
      case 'top'
          topFlag=1;
      case 'barthem'
          barFlag=1;
            
      otherwise
        warning('Dude, you put in the wrong argument');
%         p_ematError(3, 'displayRose: Error, your parameter was not recognized');
    end
    k = k + 1;
end


%% Set the bar's width if not set earlier
if ~barWidthFlag %if the bars width hasn't already been set.
    if num2Plot==1
        barWidth=0.25;
    else % is more than one datum
        if horizontalFlag
            barWidth=(y(2)-y(1))/4;
        else
            barWidth=(x(2)-x(1))/4;
        end
    end
end


%%
for k=1:num2Plot
    
    if horizontalFlag
        ex=e(k);
        esy=barWidth/2;
%       the main line

        if ~topFlag || x(k)>=0  %also plot the bottom half.
            plot([x(k)+ex x(k)],[y(k) y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
    %       the hat     
            plot([x(k)+ex x(k)+ex],[y(k)+esy y(k)-esy],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
        
        
        if ~topFlag || x(k)<0  %also plot the bottom half.
            plot([x(k) x(k)-ex],[y(k) y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
            plot([x(k)-ex x(k)-ex],[y(k)+esy y(k)-esy],'color',lineStyleOrder{k},'linewidth',linewidth);
            %rest?
        end
        
    else %plot then vertically
        ey=e(k);
%         ex2=barWidth/2;
        esx=barWidth/2;
%         the main line
        if ~topFlag || y(k)>=0 %also plot the bottom half.
            plot([x(k) x(k)],[y(k)+ey y(k)],'color',lineStyleOrder{k},'linewidth',linewidth);
    %       the hat
            plot([x(k)+esx x(k)-esx],[y(k)+ey y(k)+ey],'color',lineStyleOrder{k},'linewidth',linewidth);
        end
        if ~topFlag || y(k)<0 %also plot the bottom half.
            plot([x(k) x(k)],[y(k) y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
            
            plot([x(k)+esx x(k)-esx],[y(k)-ey y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
        %rest?
        end

 
    end

%     plot(x(k),y(k),'.')
    

%     plot([x(k)+ex x(k)-ex],[y(k)+ey y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);

%     plot(x(k),y(k),'.')
%     plot([x(k)+esx x(k)-esx],[y(k)+ey y(k)+ey],'color',lineStyleOrder{k},'linewidth',linewidth);
%     plot([x(k)+esx x(k)-esx],[y(k)-ey y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);


% hold on
% 
%         plot([x(k)+ex x(k)-ex],[y(k)+ey y(k)-ey],'color',lineStyleOrder{k},'linewidth',linewidth);
% 

end

%% expand axis if neccesary, really? do I need this?
% this is  really matlabs problem not mine

% in positive or negative direction
% for horizontal and vertical bars
% axisValues=axis;
% axis auto

% if horizontalFlag
%     do this
% else
%     a1=max(max(abs([y+e] [y-e])));
%     if abs(p(4))<abs(max(max([y+e] [y-e]))*1.1)
%         axis([axisValues(1:3) 
        

%%


drawnow;
    
end





%% lineStyleOrder=linspecer(N)
% creates a list of 3 element arrays which contain colors to be used for
% plotting lines of varying colors. It will return 'N' of these evenly
% spaced.
% 
% The darkest color is black, and the lightest color is
% [   1.0000 1.0000    0.1250]
% 
% 
%%

function lineStyleOrder=linspecer(N,varargin)

% default colormap
colormap hot; A=colormap;

%% interperet varagin
if ~isempty(varargin)>0
    colormap (varargin{1}); A=colormap;
end      
      
%%      
values=round(linspace(1,50,N));
for n=1:N
    lineStyleOrder(n) = {A(values(n),:)};
end

end





