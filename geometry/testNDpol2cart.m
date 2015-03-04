function testNDpol2cart

    figure(1); clf;
    h = plot3([0 0], [0 0], [0 0], 'b-o'); hold on;
    hxy = plot3([0 0], [0 0], [0 0], 'b:o');
    hz = plot3([0 0], [0 0], [0 0], 'g:o');
    xlabel('x'); ylabel('y'); zlabel('z');
    axis([-1 1, -1 1, -1 1]);
    axis equal;
    zeroaxes;

    function doPlot(r, theta, phi)
        X = NDpol2cart([r, theta, phi]); % note switching of order
        X = X([1,2,3]);                  % note switching of order
        set(h, 'xdata', [0, X(1)], 'ydata', [0, X(2)], 'zdata', [0, X(3)]);
        set(hxy, 'xdata', [0 X(1)], 'ydata', [0, X(2)]);
        set(hz, 'xdata', [X(1) X(1)], 'ydata', [X(2), X(2)], 'zdata', [0 X(3)]);
    end

    args = {{'r', [0 2]}, {'theta', [0 2*pi]}, {'phi', [0 pi]}};
    manipulate(@doPlot, args, 'FigId', 2);

end
