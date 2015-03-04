function [ep] = findEQpointFromFxFy(f1x, f2y)
    x = 0; y = 0;
    dr = .1; 
    xrange = [-60:dr:60];
    yrange = [-60:dr:60];

    for iterations = 1:5
        f1 = [xrange; f1x(xrange)];
        f2 = [f2y(yrange); yrange];

%             figure(9);
%             plot(f1(1,:), f1(2,:), 'ob'); hold on
%             plot(f2(1,:), f2(2,:), 'og'); hold off

        distsqr = zeros(length(xrange)); 

        for i = 1:length(xrange)
            distsqr(i,:) = (f1(1,:)-f2(1,i)).^2 + (f1(2,:)-f2(2,i)).^2;
        end
        [i,j] = minij(distsqr);

        x = xrange(i); y = yrange(j);
        xrange = [x-dr:dr/10:x+dr];
        yrange = [y-dr:dr/10:y+dr];
        dr = dr/10;
    end

    ep = [x,y];
end
