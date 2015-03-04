function testManipulate3
    close all;
    Xpn = [-3:.05:3];
    Xp  = [0:.05:5];
    
    sigmoid =  @(x, M, x50, w)   M./(1+exp( - (x-x50)/w) );    
    dsigmoid = @(x, M, x50, w)  (M/w)* exp(-(x-x50)/w) ./ (1+exp(-(x-x50)/w)).^2;    
    
    gaussian = @(x, mu, sigma)  1./(sqrt(2*pi*sigma^2)) .* exp( -((x-mu).^2)./(2*sigma^2));
    dgaussian = @(x, mu, sigma)  gaussian(x, mu, sigma) * (1./(2*sigma^2)) .* (x-mu);
    
    figure(2);

    hAx1 = subplot(10,1,1:3); 
    hMain = plot(0,0);  
    hMainTitle = title(' ');
    
    hAx2 = subplot(10,1,5:7); 
    hDeriv = plot(0,0);
    hDerivTitle = title(' ');    
    
    hLine = line([-3 3], [0 0], 'Color', 'k', 'LineStyle', ':');
    
    hAx3 = subplot(10,1,9:10);
    hText = text(.5, .5, ' ', 'HorizontalAlignment', 'Center');
    
    
    function plotFigures(funcType, a, b, c, d, M, x50, w, mu, sigma, lStyle, lWidth, fsize, hor_align, vert_align, col, showAxes, nXticklabels)

        switch funcType
            case 'linear', x = Xpn; 
                y       = a * x + b;
                y_deriv = a * ones(size(x));
                s = sprintf('y = %3.3gx + %3.3g', a, b);
            case 'quadratic', x = Xpn; 
                y = a * x.^2 + b*x + c;
                y_deriv = 2*a * x + b;
                s = sprintf('y = %3.3gx^2 + %3.3gx + %3.3g', a, b, c);
            case 'cubic',     x = Xpn; 
                y = a * x.^3 + b*x.^2 + c * x + d;
                y_deriv = 3*a*x.^2 + 2*b*x + c;
                s = sprintf('y = %3.3gx^3 + %3.3gx^3 + %3.3gx + %3.3g', a, b, c, d);
            case 'sigmoid',   x = Xp;  
                y = sigmoid(x, M, x50, w);
                y_deriv = dsigmoid(x, M, x50, w);
                s = sprintf('y = %3.3g / (1 + exp( -(x - %3.3g)/%3.3g) )', M, x50, w);
            case 'gaussian',  x = Xpn;
                y = gaussian(x, mu, sigma);
                y_deriv = dgaussian(x, mu, sigma);
                s = sprintf('y = 1/sqrt(2*pi*(%3.3g)^2) * exp( -(x - %3.3g)^2/2(%3.3g))', sigma, mu, sigma);
        end            
        set(hMain, 'xdata', x, 'ydata', y);
        set(get(hMain, 'Parent'), 'xlim', [x(1), x(end)]);
        set(hMainTitle, 'String', funcType);

        set(hDeriv, 'xdata', x, 'ydata', y_deriv);
        set(get(hDeriv, 'Parent'), 'xlim', [x(1), x(end)]);
        set(hDerivTitle, 'String', ['d/dx ' funcType]);
        
        set([hMain, hDeriv], 'lineStyle', lStyle, 'lineWidth', lWidth)

        set(hText, 'String', s, 'fontsize', fsize, 'hor', hor_align, 'vert', vert_align, 'color', col);
        onOff = {'off', 'off', 'off'};
        onOff(showAxes) = {'on'};        
        set([hAx1, hMain], 'visible', onOff{1});
        set([hAx2, hDeriv, hLine], 'visible', onOff{2});
        set([hAx3, hText], 'visible', onOff{3});
        
        set(hAx1, 'xtick', linspace(x(1), x(end), nXticklabels(1)));
        set(hAx2, 'xtick', linspace(x(1), x(end), nXticklabels(2)));
        set(hAx3, 'xtick', linspace(0, 1, nXticklabels(3)));
        
        
    end
        
    polyTypes =    {'linear',    'quadratic',     'cubic',              'sigmoid',         'gaussian'};
    polyTypeVars = { {'a', 'b'}, {'a', 'b', 'c'}, {'a', 'b', 'c', 'd'}, {'M', 'x50', 'w'}, {'mu', 'sigma'}};

    hor_alignVars = {'left', 'center', 'right'};
    vert_alignVars = {'top', 'middle', 'baseline'};
    font_colors = {'black', 'blue', 'red', 'green'};
    lineStyle_vars = {'--', ':', '-.'};
    
    tf = [false, true];
    showOptions = {tf; tf; tf};
    show0 = true(3,1);
    
    showLabels = {'Plot', 'Deriv', 'Text'};
    showPlotVars =  { {}, {'lineStyle', 'lineWidth'}}; % show none if false, show depVars if true; 
    showDerivVars = { {}, {'lineStyle', 'lineWidth'}};
    showTxtVars =   { {}, {'fontsize', 'horizontal', 'vertical', 'color'} };
    showDepVars = {showPlotVars, showDerivVars, showTxtVars};
    
%     show2Lab = {'A', 'B', 'C', 'DEFEF'};
%     show3Lab = {'Animal', 'Penetration', 'Location'};
%     show4Lab = {'F1/DC_cmp', 'sumPhs', 'minFrac'};
%     show5Lab = 'a';
% %     
% %     pairFilters2_labels = ;   nPf2 = length(pairFilters2_labels);        
% %     pairFilters2_depVars = { {{}, {'animalCmp'}} , {{}, {'penetrCmp'}}, {{}, {'locCmp'} } };
% %     locCmpStrs = {'same', 'diff'};
% %     
% %     locFilters_labels = ;  nLf = length(locFilters_labels);
% %     locFilters_depVars ={ {{}, {'minF1oDCs_cmp'}}, {{}, {'minSumPhs'}}, {{}, {'minFracR'}} };
% %     
% %     
    nXticksRange = {[3:10]; 5; [3:8]};
    nXticks0 = [5 5 5];

    
    funcHandle = @plotFigures;
    
    args = {{'funcType', polyTypes, polyTypes{4}, polyTypeVars}, ...
                   {'a', [-5, 5], 1}, {'b', [-5, -3:5], 1}, {'c', [-5, 5], 1}, {'d', [-5, 5]}, ...
                   {'M', [-5, 5], 1}, {'x50', [0, 3], 1}, {'w', [.1:.1:5], 1}, {'mu', [-5, 5], 2}, {'sigma', [.1:.1:4], 1}, ...
                   {'lineStyle', lineStyle_vars}, {'lineWidth', [1:5]}, ...
                   {'fontsize', [8:15], 10}, {'horizontal', hor_alignVars, hor_alignVars{2}}, {'vertical', vert_alignVars, vert_alignVars{2}}, ...
                   {'color', font_colors, font_colors{1}}, ...
                   {'show', showOptions, show0, showDepVars, showLabels}, ...
...                  {'show2', {tf; tf; tf; tf}, [], [], show2Lab}, ...
...                   {'show3', {tf; tf; tf}, [], [], show3Lab}, ...
...                   {'show4', {tf; tf; tf}, [], [], show4Lab}, ...
...                   {'show5', tf, [], [], show5Lab}, ...
                   {'nXTicksRange', nXticksRange, nXticks0 } };
    grps = {':Groups', {'a', 'b', 'c', 'd'}, {'M', 'x50', 'w', 'mu', 'sigma'}, {'fontsize', 'horizontal', 'vertical', 'color'}, {'lineStyle', 'lineWidth'}};
               
    
%     plotFigures(polyTypes{4}, 1, 1, 1, 0, 1, 1, 1, 2, 1, 10, ');

    manipulate(1, funcHandle, args{:}, grps);


end