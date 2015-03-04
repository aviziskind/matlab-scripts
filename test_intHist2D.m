function test_intHist2D

    rand('state', 0);
    nX = 3;
    nY = 5;
    n = 20;
    x_bins0 = randi(nX, 1, n);
    y_bins0 = randi(nX, 1, n);
    
    Cs = {'double', 'single', 'int32', 'int16'};
    for ci = 1:length(Cs)
        x_bins = cast(x_bins0, Cs{ci});
        y_bins = cast(y_bins0, Cs{ci});
        
        M1 = intHist2D_mtlb(x_bins, y_bins, nX, nY);
        M2 = intHist2D(x_bins, y_bins, nX, nY);

        assert(isequal(M1, M2));
    end


end

function M = intHist2D_mtlb(x_bins, y_bins, nX, nY)

    M = zeros(nX, nY);
    for i = 1:length(x_bins)
        M(x_bins(i), y_bins(i)) = M(x_bins(i), y_bins(i)) + 1;        
    end

end