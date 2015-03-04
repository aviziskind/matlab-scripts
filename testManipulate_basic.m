function testManipulate_basic
    close all;
    xs = [-3:.1:3];
    
    figure(2);
    hMain = plot(0,0);  
    hMainTitle = title(' ');
    
    
    line([-3 3], [0 0], 'Color', 'k', 'LineStyle', ':');
%     line([0 0],  [-100 100], 'Color', 'k', 'LineStyle', ':');
    
%     function plotMain(inputs)
%         [polyType, a, b, c, d] = inputs{:};

    function plotMain(polyType, a, b, c, d, e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z)
        switch polyType
            case 'linear',    ys = a * xs + b;
            case 'quadratic', ys = a * xs.^2 + b*xs + c;
            case 'cubic',     ys = a * xs.^3 + b*xs.^2 + c * xs + d;
        end            
        set(hMain, 'xdata', xs, 'ydata', ys);
        set(hMainTitle, 'String', polyType);
    end
    
    polyTypes = {'linear', 'quadratic', 'cubic'};
     polyTypeVars = { {'a', 'b'}, {'a', 'b', 'c'}, {'a', 'b', 'c', 'd'}};
    grps = {':Groups', {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'}, {'i', 'j', 'k', 'l', 'm', 'n'}, {'o', 'p', 'q', 'r', 's', 't', 'u'}, {'v', 'w', 'x', 'y', 'z'}};
    vars = arrayfun(@(i) {char(96+i), [-1, 1], 0}, 1:26, 'un', 0);
    func_handle = @plotMain;

    manipulate(1, {func_handle}, ...                   
                   {'polyType', polyTypes, polyTypes{1}, polyTypeVars},...
                   vars{:}, grps);
%                    {'a', [-2, 2], 1}, {'b', [-2, 2], 1}, {'c', [-5, 5], 1}, {'d', [-5, 5]});


end