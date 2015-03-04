function testManipulate2
    close all;
    x1 = [-3:.05:3];
    x2 = [0:.05:5];
    
    sigmoid =  @(x, M, x50, w)   M./(1+exp( - (x-x50)/w) );    
    dsigmoid = @(x, M, x50, w)  (M/w)* exp(-(x-x50)/w) ./ (1+exp(-(x-x50)/w)).^2;
    
    
    gaussian = @(x, mu, sigma)  1./(sqrt(2*pi*sigma^2)) .* exp( -((x-mu).^2)./(2*sigma^2));
    dgaussian = @(x, mu, sigma)  gaussian(x, mu, sigma) * (1./(2*sigma^2)) .* (x-mu);
    
    figure(2);

    subplot(10,1,1:3); 
    hMain = plot(0,0);  
    hMainTitle = title(' ');
    
    subplot(10,1,5:7); 
    hDeriv = plot(0,0);
    hDerivTitle = title(' ');
    
    line([-3 3], [0 0], 'Color', 'k', 'LineStyle', ':');
%     line([0 0],  [-100 100], 'Color', 'k', 'LineStyle', ':');
    
    function plotMain(a, b, c, d, M, x50, w, mu, sigma, polyType)
        switch polyType
            case 'linear',    x = x1; y = a * x + b;
            case 'quadratic', x = x1; y = a * x.^2 + b*x + c;
            case 'cubic',     x = x1; y = a * x.^3 + b*x.^2 + c * x + d;
            case 'sigmoid',   x = x2; y = sigmoid(x, M, x50, w);
            case 'gaussian',  x = x1; y = gaussian(x, mu, sigma);
        end            
        set(hMain, 'xdata', x, 'ydata', y);
        set(get(hMain, 'Parent'), 'xlim', [x(1), x(end)]);
        set(hMainTitle, 'String', polyType);
    end
    
    function plotDeriv(a, b, c, M, x50, w, mu, sigma, polyType)
        switch polyType
            case 'linear',    x = x1; y = a * ones(size(x));
            case 'quadratic', x = x1; y = 2*a * x + b;
            case 'cubic',     x = x1; y = 3*a*x.^2 + 2*b*x + c;
            case 'sigmoid',   x = x2; y = dsigmoid(x, M, x50, w);
            case 'gaussian',  x = x1; y = dgaussian(x, mu, sigma);
        end            
        set(hDeriv, 'xdata', x, 'ydata', y);
        set(get(hDeriv, 'Parent'), 'xlim', [x(1), x(end)]);
        set(hDerivTitle, 'String', ['d/dx ' polyType]);
    end
    
%     plot1(h1, x, 1,2,3);
%     plot2(h2, x, 1,2,3, 'asx');

    polyTypes =    {'linear',    'quadratic',     'cubic',              'sigmoid',         'gaussian'};
    polyTypeVars = { {'a', 'b'}, {'a', 'b', 'c'}, {'a', 'b', 'c', 'd'}, {'M', 'x50', 'w'}, {'mu', 'sigma'}};

    subplot(10,1,9:10);
    hText = text(.5, .5, ' ', 'HorizontalAlignment', 'Center');
    function text1(a, b, c, d, M, x50, w, mu, sigma, polyType)
        switch polyType
            case 'linear',    s = sprintf('y = %3.3gx + %3.3g', a, b);
            case 'quadratic', s = sprintf('y = %3.3gx^2 + %3.3gx + %3.3g', a, b, c);
            case 'cubic',     s = sprintf('y = %3.3gx^3 + %3.3gx^3 + %3.3gx + %3.3g', a, b, c, d);
            case 'sigmoid',   s = sprintf('y = %3.3g / (1 + exp( -(x - %3.3g)/%3.3g) )', M, x50, w);
            case 'gaussian',  s = sprintf('y = 1/sqrt(2*pi*(%3.3g)^2) * exp( -(x - %3.3g)^2/2(%3.3g))', sigma, mu, sigma);
        end                    
        set(hText, 'String', s);
    end

    funcHandles = {@(a, b, c, d, M, x50, w, mu, sigma, polyType) plotMain( a, b, c, d, M, x50, w, mu, sigma, polyType), ...
                   @(a, b, c,    M, x50, w, mu, sigma, polyType) plotDeriv(a, b, c,    M, x50, w, mu, sigma, polyType), ...
                   @(a, b, c, d, M, x50, w, mu, sigma, polyType) text1(    a, b, c, d, M, x50, w, mu, sigma, polyType) };
    args = {{'polyType', polyTypes, polyTypes{1}, polyTypeVars}, ...
                   {'a', [-5, 5], 1}, {'b', [-5, 5], 1}, {'c', [-5, 5], 1}, {'d', [-5, 5]}, ...
                   {'M', [-5, 5], 1}, {'x50', [0, 3], 1}, {'w', [.1:.1:5], 1}, {'mu', [-5, 5], 2}, {'sigma', [.1:.1:4], 1}};

    manipulate(1, funcHandles, args{:});


end