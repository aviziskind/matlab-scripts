function testManipulate
    % This is a basic demonstration of how "manipulate" works.
    % This example demonstrates:
    %  (1) illustrates how to pass arguments to the manipulate function.
    %  (2) demonstrates how to use string-lists, and scalar variables
    %  (3) shows how to use context-dependent variables
    %  (3) how to define plot/axes handles first, which the updateFunction
    %       (here, "updatePlot") uses.
    
    close all;
    x = [-3:.1:3];
    
    % First define all the variables and figure handles.
    figure(1);
    hAx(1) = subplot(10,1,1:3); 
    hMain = plot(0,0);  % make an empty plot so we can get a handle to the plot (which we can update later).
    hMainTitle = title(' ');
    
    hAx(2) = subplot(10,1,5:7); 
    hDeriv = plot(0,0);  
    hDerivTitle = title(' ');

    hAx(3) = subplot(10,1,9:10);    
    hText = text(.5, .5, ' ', 'horiz', 'center', 'vert', 'middle');    
    axis([0 1 0 1]);
        
%     hLine(1) = line([-3 3], [0 0], 'Color', 'k', 'LineStyle', ':');
%     line([0 0],  [-100 100], 'Color', 'k', 'LineStyle', ':');
    
    function updatePlot(polyType, a, b, c, d, showTicks, color )
        switch polyType
            case 'Linear',    
                y = a * x + b;
                y_deriv = a * ones(size(x));
                str = sprintf('y = %.2f x + %.2f', a, b);
            case 'Quadratic', 
                y = a * x.^2 + b*x + c;
                y_deriv = 2*a * x + b;
                str = sprintf('y = %.2f x^2 + %.2f x + %.2f', a, b, c);
            case 'Cubic',     
                y = a * x.^3 + b*x.^2 + c * x + d;
                y_deriv = 3*a*x.^2 + 2*b*x + c;
                str = sprintf('y = %.2f x^3 + %.2f x^2 + %.2f x + %.2f', a, b, c, d);
        end            
        if ~showTicks
            set(hAx, 'xtick', [], 'ytick', [])            
        else
            set(hAx, 'xtickmode', 'auto', 'ytickmode', 'auto')            
        end
        
        set(hMain, 'xdata', x, 'ydata', y, 'color', color(1));
        set(hMainTitle, 'String', [polyType ' function']);
        set(hDeriv, 'xdata', x, 'ydata', y_deriv, 'color', color(1));        
        set(hDerivTitle, 'String', ['Derivative of ' polyType ' function']);    
        set(hText, 'String', str, 'color', color(1));
    end
    

    polyTypes = {'Linear', 'Quadratic', 'Cubic'};
    polyTypeVars = { {'a', 'b'}, {'a', 'b', 'c'}, {'a', 'b', 'c', 'd'}};
    colorOptions = {'blue', 'green', 'red', 'magenta'};

    args = { {'polyType', polyTypes, polyTypes{1}, polyTypeVars}, ...
             {'a', [-5:.1:5], 1}, {'b', [-5:.1:5], 1}, {'c', [-5:.1:5], 1}, {'d', [-5 :.1: 5]}, ...
             {'showTicks', [true, false]}, ...
             {'color', colorOptions} };
    
    manipulate(@updatePlot, args, 'FigId', 2);

end