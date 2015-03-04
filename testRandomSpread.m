function testRandomSpread

    testReallocation = true;

    xrange1 = [6 12.2];
    xrange2 = [3 20.1];
    r = 0;

    Nx1 = 10;
    Nx2 = 20;

    figure(1); clf(1);
	xlim(xrange2);
    ylim([-1 1]);
    dx = (xrange1(2)-xrange1(1))/Nx1;
    drawVerticalLine(   xrange1(1) + (0:Nx1)*dx);
    hold on;
    xs = randomSpread(xrange1, Nx1, r);
    disp(num2str(length(xs)));
    plot(xs, zeros(size(xs)), 'b.');
    hold off

    
    %%%%%%%%%%%%%%%%%%%%% re-allocation
    if testReallocation
        figure(2); clf(2);
        xlim(xrange2);
        ylim([-1 1]);
        dx = (xrange2(2)-xrange2(1))/Nx2;    
        drawVerticalLine(   xrange2(1) + (0:Nx2)*dx);

        hold on;
        plot(xs, zeros(size(xs)), 'b.');

        x_new = reAllocateRandomDivisions(xs, xrange2, Nx2, r);
        disp(num2str(length(x_new)));
        plot(x_new, zeros(size(x_new)), 'g.');

        plot(xs, zeros(size(xs)), 'b.');
        hold off
    end


end