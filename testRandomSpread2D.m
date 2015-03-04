function testRandomSpread2D

    testReallocation = true;
    r = 0;

    xrange1 = [2 12];
    yrange1 = [30 60];

    xrange2 = [0  15];
    yrange2 = [20 70];
    
    Nx1 = 20;
    Ny1 = 20;
  
    figure(1); clf(1);
	xlim(xrange2);
    ylim(yrange2);
    dx = (xrange1(2)-xrange1(1))/Nx1;
    dy = (yrange1(2)-yrange1(1))/Ny1;
    drawHorizontalLine( yrange1(1) + (0:Ny1)*dy);
    drawVerticalLine(   xrange1(1) + (0:Nx1)*dx);
    hold on;
    Xs = randomSpread([xrange1; yrange1], [Nx1, Ny1], r);
    plot(Xs(:,1), Xs(:,2), 'b.');
    hold off
    
    if testReallocation
        xrange2 = [0  20];
        yrange2 = [20 80];
        Nx2 = 20;
        Ny2 = 20;

        figure(2); clf(2);
        xlim(xrange2);
        ylim(yrange2);
        
        dx = (xrange2(2)-xrange2(1))/Nx2;
        dy = (yrange2(2)-yrange2(1))/Ny2;
        drawHorizontalLine( yrange2(1) + (0:Ny2)*dy);
        drawVerticalLine(   xrange2(1) + (0:Nx2)*dx);
        
        hold on;
        plot(Xs(:,1), Xs(:,2), 'b.');
        Xs_new = reAllocateRandomDivisions(Xs, [xrange2; yrange2], [Nx2, Ny2], r);
        plot(Xs_new(:,1), Xs_new(:,2), 'g.');
        plot(Xs(:,1), Xs(:,2), 'b.');
        hold off
        
    end

end