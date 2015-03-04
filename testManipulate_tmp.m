function testManipulate
    % This is a basic demonstration of how "manipulate" works.
    % This example demonstrates:
    %  (1) illustrates how to pass arguments to the manipulate function.
    %  (2) demonstrates how to use string-lists, and scalar variables
    %  (3) shows how to use context-dependent variables
    %  (3) how to define plot/axes handles first, which the updateFunction
    %       (here, "updatePlot") uses.
    
    close all;
    x = [-5:.1:5];
    
    % First define all the variables and figure handles.
    figure(1);
    hAx(1) = axes;
    hMain = plot(0,0);  % make an empty plot so we can get a handle to the plot (which we can update later).
    hMainTitle = title(' ');
            
%     hLine(1) = line([-3 3], [0 0], 'Color', 'k', 'LineStyle', ':');
%     line([0 0],  [-100 100], 'Color', 'k', 'LineStyle', ':');
    
    function updatePlot(a, b, c, d)
        y =  exp( -(((x-a).^2)./(2*b^2)+((x-c).^4)./(2*d^4)));  
        
        set(hMain, 'xdata', x, 'ydata', y);
%         set(hMainTitle, 'String', [polyType ' function']);
    end
    

    polyTypes = {'Gaussian'};

    args = { {'a', [-5:.2:5], 0}, {'b', [.01:.1:20], 1}, {'c', [-5:.2:5], 0}, {'d', [.01:.1: 20], 5}, };
    
    manipulate(@updatePlot, args, 'FigId', 2);

end