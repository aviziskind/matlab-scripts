function [xs, ys, zs] = fmesh(func, xlim, ylim, varargin)
% same as fplot, but for 2D functions, taking in input matrices of xs and ys;

    
    if nargin > 3        
        dfltValues = {[], [], [], []};
        argNames = {'col', 'spacing', 'plotFunc', 'calc'};
        [col, spacing, plotFunc, calc] = parseArgValuePairs(argNames, dfltValues, varargin{:} );        
    end

    if (~exist('plotFunc', 'var') || isempty(plotFunc))
        plotFunc = @mesh; %@surf
    end

    if (length(xlim) > 2) && (length(ylim) > 2)
        xs = xlim;
        ys = ylim;

    else
        if (~exist('spacing', 'var') || isempty(spacing))
            numPointsX = 35;
            numPointsY = 40;
            spacing = [(xlim(2)-xlim(1))/(numPointsX-1), (ylim(2)-ylim(1))/(numPointsY-1)];
        elseif length(spacing) == 1    
            spacing = [spacing spacing];
        end

        xspacing = spacing(1);
        yspacing = spacing(2);

        xs = xlim(1):xspacing:xlim(2);
        ys = ylim(1):yspacing:ylim(2);

    end

    
    zs = zeros(length(xs), length(ys));

    if (~exist('calc', 'var') || isempty(calc))

        str = func2str(func);
        id1 = strfind(str, '('); id2 = strfind(str, ')');
        str = str(id1:id2);
        str = strrep(str, ' ', '');

        switch str
            case '(x,y)', calc = 'single';
            case '(X)',   calc = 'vector';
            case '(X,Y)', calc = 'group';
        end
    end            
    
    nArgs = numArgsInAnonFunction(func);
    switch calc
        case 'single',  % calculate each z value individually
            for xi = 1:length(xs)
                for yi = 1:length(ys)

                    if nArgs == 1
                        zs(xi,yi) = func([xs(xi); ys(yi)]);
                    elseif nArgs == 2
                        zs(xi,yi) = func(xs(xi),ys(yi));
                    end

                    if imag(zs(xi,yi)) ~= 0
                        disp(['imaginary value of f found at (' num2str(xs(xi)) ', ' num2str(ys(yi))  ')'  ] );
                    end
                end
            end
            
        case 'group', % faster calculation, if f is designed to handle it (default)
            [xs_grid, ys_grid] = meshgrid(xs, ys);
            zs = func({xs_grid, ys_grid});
        case 'vector',
            [xs_grid, ys_grid] = meshgrid(xs, ys);
            zs = func([xs_grid(:)'; ys_grid(:)']);
            zs = reshape(zs, [length(xs), length(ys)]);            
            
        

    end

    zs = zs';
    [xs, ys] = meshgrid(xs, ys);        
    if nargout <= 1  

        hnd = plotFunc(xs,ys,zs);  % flip z because  size(Z) = [length(y), length(x)];
        xs = hnd;
        
        if exist('col', 'var') && ~isempty(col)
            set(hnd, 'Color', col);
        end
    elseif nargout == 3  % output instead of plotting
        
        
        
    end        
%     xlabel('x');
%     ylabel('y');
%     zlabel('z');




end




function n = numArgsInAnonFunction(f)

    funcString = func2str(f);
    
    a = strfind(funcString, '('); a = a(1);
    b = strfind(funcString, ')'); b = b(1);
    
    argString = funcString([a:b]);
    commas = length( strfind(argString, ',') );
    
    n = commas + 1;

end

